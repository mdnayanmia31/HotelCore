''Business Logic Service for Booking Operations

Imports System.Data
Imports System.Transactions
Imports HotelCore.DAL


Public Class BookingService

    Private ReadOnly _bookingRepo As IBookingRepository
    Private ReadOnly _roomRepo As IRoomRepository

    '' Constructor with Dependency Injection
    '' UI doesn't need to know about concrete implementations
    Public Sub New()
        _bookingRepo = New BookingRepository()
        _roomRepo = New RoomRepository()
    End Sub

    Public Sub New(bookingRepo As IBookingRepository, roomRepo As IRoomRepository)
        _bookingRepo = bookingRepo
        _roomRepo = roomRepo
    End Sub

    '' Search available rooms based on criteria
    Public Function SearchAvailableRooms(criteria As RoomSearchCriteria, currentUserID As Integer) As OperationResult(Of List(Of RoomModel))
        Dim result As New OperationResult(Of List(Of RoomModel))

        Try
            ' BUSINESS RULE VALIDATION
            Dim validationErrors As List(Of String) = ValidateSearchCriteria(criteria)
            If validationErrors.Count > 0 Then
                result.Success = False
                result.ErrorMessage = String.Join("; ", validationErrors)
                Return result
            End If

            ' Call DAL
            Dim dt As DataTable = _bookingRepo.SearchRooms(
                criteria.StartDateTime,
                criteria.EndDateTime,
                criteria.ConfigID,
                criteria.MinOccupancy,
                criteria.MaxPrice,
                criteria.AmenityIDs,
                criteria.FloorNumber
            )

            ' Map DataTable to DTOs
            Dim rooms As New List(Of RoomModel)
            For Each row As DataRow In dt.Rows
                rooms.Add(New RoomModel With {
                    .RoomID = CInt(row("RoomID")),
                    .RoomNumber = row("RoomNumber").ToString(),
                    .FloorNumber = CInt(row("FloorNumber")),
                    .TypeName = row("TypeName").ToString(),
                    .Description = row("Description").ToString(),
                    .MaxOccupancy = CInt(row("MaxOccupancy")),
                    .SquareFeet = If(IsDBNull(row("SquareFeet")), 0, CInt(row("SquareFeet"))),
                    .BedConfiguration = If(IsDBNull(row("BedConfiguration")), "", row("BedConfiguration").ToString()),
                    .BaseDailyRate = CDec(row("EstimatedPrice"))
                })
            Next

            result.Success = True
            result.Data = rooms
            result.Message = $"Found {rooms.Count} available room(s)"

        Catch ex As Exception
            result.Success = False
            result.ErrorMessage = $"Error searching rooms: {ex.Message}"
        End Try

        Return result
    End Function


    '' Create a new booking
    Public Function CreateBooking(model As BookingModel, currentUserID As Integer) As OperationResult(Of BookingModel)
        Dim result As New OperationResult(Of BookingModel)

        Try
            ' BUSINESS RULE VALIDATION
            Dim validationErrors As List(Of String) = ValidateBookingModel(model)
            If validationErrors.Count > 0 Then
                result.Success = False
                result.ErrorMessage = String.Join("; ", validationErrors)
                Return result
            End If

            ' Check room capacity
            Dim roomData As DataRow = _roomRepo.GetRoomById(model.RoomID)
            If roomData Is Nothing Then
                result.Success = False
                result.ErrorMessage = "Room not found"
                Return result
            End If

            Dim maxOccupancy As Integer = CInt(roomData("MaxOccupancy"))
            If model.GuestCount > maxOccupancy Then
                result.Success = False
                result.ErrorMessage = $"Guest count ({model.GuestCount}) exceeds room capacity ({maxOccupancy})"
                Return result
            End If

            ' Check booking duration
            Dim duration As TimeSpan = model.EndDateTime - model.StartDateTime
            If duration.TotalHours < 2 Then
                result.Success = False
                result.ErrorMessage = "Minimum booking duration is 2 hours"
                Return result
            End If

            If duration.TotalDays > 30 Then
                result.Success = False
                result.ErrorMessage = "Maximum booking duration is 30 days"
                Return result
            End If

            ' If the BLL crashes halfway through adding guests, the booking is rolled back.

            Using scope As New TransactionScope()
                Try
                    Dim errorCode As Integer = 0
                    Dim errorMessage As String = ""

                    ' Create the Main Booking Header
                    Dim bookingID As Integer = _bookingRepo.CreateBooking(
                        model.UserID, model.RoomID, model.StartDateTime, model.EndDateTime,
                        model.GuestCount, model.ConfigID, model.SpecialRequests,
                        currentUserID, errorCode, errorMessage)

                    If bookingID <= 0 Or errorCode <> 0 Then
                        result.Success = False
                        result.ErrorMessage = errorMessage
                        Return result ' Transaction automatically aborts (no Complete called)
                    End If

                    model.BookingID = bookingID

                    ' Add the Primary Guest
                    Dim primaryGuest As New GuestModel With {
                        .GuestType = "Primary",
                        .FullName = "Primary Guest",
                        .AgeCategory = "Adult"
                    }

                    _bookingRepo.AddGuest(bookingID, primaryGuest, currentUserID, errorCode, errorMessage)
                    If errorCode <> 0 Then Throw New Exception("Failed to add primary guest: " & errorMessage)

                    'Loop through additional guests
                    If model.Guests IsNot Nothing AndAlso model.Guests.Count > 0 Then
                        For Each guest As GuestModel In model.Guests
                            guest.GuestType = "Additional" ' Force type
                            _bookingRepo.AddGuest(bookingID, guest, currentUserID, errorCode, errorMessage)

                            If errorCode <> 0 Then
                                ' This Throw will trigger the Catch block, which exits the Using scope
                                Throw New Exception($"Failed to add guest {guest.FullName}: {errorMessage}")
                            End If
                        Next
                    End If

                    'Commit the Transaction
                    scope.Complete()

                    result.Success = True
                    result.Data = model
                    result.Message = "Booking and Guest List confirmed successfully"

                Catch ex As Exception
                    result.Success = False
                    result.ErrorMessage = $"Booking Process Failed: {ex.Message}"
                    ' Transaction implicitly rolls back here
                End Try
            End Using

            Return result
    End Function

    ''' Get booking details by ID
    Public Function GetBookingById(bookingID As Integer, currentUserID As Integer?) As OperationResult(Of BookingModel)
        Dim result As New OperationResult(Of BookingModel)

        Try
            Dim ds As DataSet = _bookingRepo.GetBookingById(bookingID, currentUserID)

            If ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                Dim row As DataRow = ds.Tables(0).Rows(0)

                ' Map Main Booking 
                Dim booking As New BookingModel With {
                    .BookingID = CInt(row("BookingID")),
                    .BookingReference = row("BookingReference").ToString(),
                    .TotalAmount = CDec(row("TotalAmount")),
                    .Status = row("Status").ToString(),
                .Guests = New List(Of GuestModel)(),
                .Payments = New List(Of PaymentModel)()
            }

                If ds.Tables.Count > 1 Then
                    For Each guestRow As DataRow In ds.Tables(1).Rows
                        booking.Guests.Add(New GuestModel With {
                            .GuestID = CInt(guestRow("GuestID")),
                            .FullName = guestRow("FullName").ToString(),
                            .GuestType = guestRow("GuestType").ToString(),
                            .Email = If(IsDBNull(guestRow("Email")), "", guestRow("Email").ToString()),
                            .AgeCategory = guestRow("AgeCategory").ToString()
                        })
                    Next
                End If

                If ds.Tables.Count > 2 Then
                    For Each payRow As DataRow In ds.Tables(2).Rows
                        booking.Payments.Add(New PaymentModel With {
                            .PaymentID = CInt(payRow("PaymentID")),
                            .Amount = CDec(payRow("Amount")),
                            .Status = payRow("Status").ToString(),
                            .PaymentDate = CDate(payRow("PaymentDate"))
                        })
                    Next
                End If

                result.Success = True
                result.Data = booking
            Else
                result.Success = False
                result.ErrorMessage = "Booking not found"
            End If

        Catch ex As Exception
            result.Success = False
            result.ErrorMessage = $"Error retrieving booking: {ex.Message}"
        End Try

        Return result
    End Function


    '' Get all bookings for a specific user
    Public Function GetUserBookings(userID As Integer, status As String, startDate As Date?, endDate As Date?) As OperationResult(Of List(Of BookingModel))
        Dim result As New OperationResult(Of List(Of BookingModel))

        Try
            Dim dt As DataTable = _bookingRepo.GetBookingsByUser(userID, status, startDate, endDate)

            Dim bookings As New List(Of BookingModel)
            For Each row As DataRow In dt.Rows
                bookings.Add(New BookingModel With {
                    .BookingID = CInt(row("BookingID")),
                    .BookingReference = row("BookingReference").ToString(),
                    .RoomNumber = row("RoomNumber").ToString(),
                    .RoomType = row("RoomType").ToString(),
                    .StartDateTime = CDate(row("StartDateTime")),
                    .EndDateTime = CDate(row("EndDateTime")),
                    .TotalAmount = CDec(row("TotalAmount")),
                    .Status = row("Status").ToString(),
                    .GuestCount = CInt(row("GuestCount")),
                    .CreatedDate = CDate(row("CreatedDate"))
                })
            Next

            result.Success = True
            result.Data = bookings
            result.Message = $"Retrieved {bookings.Count} booking(s)"

        Catch ex As Exception
            result.Success = False
            result.ErrorMessage = $"Error retrieving bookings: {ex.Message}"
        End Try

        Return result
    End Function


    '' Cancel a booking
    Public Function CancelBooking(bookingID As Integer, cancellationReason As String, currentUserID As Integer) As OperationResult
        Dim result As New OperationResult

        Try
            ' Cancellation reason required
            If String.IsNullOrWhiteSpace(cancellationReason) Then
                result.Success = False
                result.ErrorMessage = "Cancellation reason is required"
                Return result
            End If

            If cancellationReason.Length < 10 Then
                result.Success = False
                result.ErrorMessage = "Cancellation reason must be at least 10 characters"
                Return result
            End If

            ' Call DAL
            Dim errorCode As Integer = 0
            Dim errorMessage As String = ""

            Dim success As Boolean = _bookingRepo.CancelBooking(
                bookingID,
                cancellationReason,
                currentUserID,
                errorCode,
                errorMessage
            )

            If success AndAlso errorCode = 0 Then
                result.Success = True
                result.Message = "Booking cancelled successfully"
            Else
                result.Success = False
                result.ErrorCode = errorCode
                result.ErrorMessage = errorMessage
            End If

        Catch ex As Exception
            result.Success = False
            result.ErrorMessage = $"Error cancelling booking: {ex.Message}"
        End Try

        Return result
    End Function


    '' Check-in a booking
    Public Function CheckInBooking(bookingID As Integer, currentUserID As Integer) As OperationResult
        Dim result As New OperationResult

        Try
            Dim errorCode As Integer = 0
            Dim errorMessage As String = ""

            Dim success As Boolean = _bookingRepo.CheckInBooking(
                bookingID,
                currentUserID,
                errorCode,
                errorMessage
            )

            If success AndAlso errorCode = 0 Then
                result.Success = True
                result.Message = "Check-in successful"
            Else
                result.Success = False
                result.ErrorCode = errorCode
                result.ErrorMessage = errorMessage
            End If

        Catch ex As Exception
            result.Success = False
            result.ErrorMessage = $"Error during check-in: {ex.Message}"
        End Try

        Return result
    End Function


    '' Check-out a booking
    Public Function CheckOutBooking(bookingID As Integer, currentUserID As Integer) As OperationResult
        Dim result As New OperationResult

        Try
            Dim errorCode As Integer = 0
            Dim errorMessage As String = ""

            Dim success As Boolean = _bookingRepo.CheckOutBooking(
                bookingID,
                currentUserID,
                errorCode,
                errorMessage
            )

            If success AndAlso errorCode = 0 Then
                result.Success = True
                result.Message = "Check-out successful. Housekeeping has been notified."
            Else
                result.Success = False
                result.ErrorCode = errorCode
                result.ErrorMessage = errorMessage
            End If

        Catch ex As Exception
            result.Success = False
            result.ErrorMessage = $"Error during check-out: {ex.Message}"
        End Try

        Return result
    End Function

    Private Function ValidateSearchCriteria(criteria As RoomSearchCriteria) As List(Of String)
        Dim errors As New List(Of String)

        ' End date must be after start date
        If criteria.StartDateTime >= criteria.EndDateTime Then
            errors.Add("End date must be after start date")
        End If

        ' Cannot search for past dates
        If criteria.StartDateTime < DateTime.UtcNow.AddMinutes(-5) Then
            errors.Add("Cannot search for past dates")
        End If

        ' Minimum occupancy
        If criteria.MinOccupancy < 1 Then
            errors.Add("Minimum occupancy must be at least 1")
        End If

        'Maximum advance booking
        If criteria.StartDateTime > DateTime.UtcNow.AddDays(365) Then
            errors.Add("Cannot book more than 1 year in advance")
        End If

        'Reasonable search duration
        Dim duration As TimeSpan = criteria.EndDateTime - criteria.StartDateTime
        If duration.TotalDays > 30 Then
            errors.Add("Maximum search duration is 30 days")
        End If

        Return errors
    End Function


    '' Validate booking model before creation
    Private Function ValidateBookingModel(model As BookingModel) As List(Of String)
        Dim errors As New List(Of String)

        ' Valid user
        If model.UserID <= 0 Then
            errors.Add("Invalid user")
        End If

        ' Valid room
        If model.RoomID <= 0 Then
            errors.Add("Invalid room selection")
        End If

        ' Valid dates
        If model.StartDateTime >= model.EndDateTime Then
            errors.Add("Check-out date must be after check-in date")
        End If

        ' Cannot book in past
        If model.StartDateTime < DateTime.UtcNow.AddMinutes(-5) Then
            errors.Add("Cannot book in the past")
        End If

        ' Guest count
        If model.GuestCount < 1 Then
            errors.Add("At least one guest is required")
        End If

        If model.GuestCount > 10 Then
            errors.Add("Maximum 10 guests per booking")
        End If

        ' Guest breakdown
        If (model.AdultCount + model.ChildCount + model.InfantCount) <> model.GuestCount Then
            errors.Add("Guest count breakdown does not match total guest count")
        End If

        If model.AdultCount < 1 Then
            errors.Add("At least one adult guest is required")
        End If

        Return errors
    End Function

    Public Function EstimatePrice(roomID As Integer, startDateTime As DateTime, endDateTime As DateTime) As OperationResult(Of Decimal)
        Dim result As New OperationResult(Of Decimal)

        Try
            Dim room = _roomRepo.GetRoomById(roomID)
            If room Is Nothing Then Throw New Exception("Room not found")

            Dim durationHours As Double = (endDateTime - startDateTime).TotalHours
            Dim baseHourly As Decimal = CDec(room("BaseHourlyRate"))
            Dim baseDaily As Decimal = CDec(room("BaseDailyRate"))
            Dim total As Decimal = 0

            If durationHours < 24 Then
                total = baseHourly * CDec(durationHours)
            Else
                Dim days As Integer = CInt(Math.Ceiling(durationHours / 24))
                total = baseDaily * days
            End If

            ' Apply Weekend logic (Sat/Sun)
            If startDateTime.DayOfWeek = DayOfWeek.Saturday Or startDateTime.DayOfWeek = DayOfWeek.Sunday Then
                total *= 1.1D ' 10% surcharge
            End If

            result.Data = Math.Round(total, 2)
            result.Success = True

        Catch ex As Exception
            result.Success = False
            result.ErrorMessage = ex.Message
        End Try

        Return result
    End Function

End Class
