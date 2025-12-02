Imports System.Data
Imports System.Data.SqlClient

Public Class BookingRepository
    Implements IBookingRepository

    Public Function SearchRooms(startDateTime As DateTime, endDateTime As DateTime,
                               configID As Integer?, minOccupancy As Integer,
                               maxPrice As Decimal?, amenityIDs As String,
                               floorNumber As Integer?) As DataTable Implements IBookingRepository.SearchRooms

        Dim parameters As SqlParameter() = {
            SqlHelper.CreateParameter("@StartDateTime", SqlDbType.DateTime2, startDateTime),
            SqlHelper.CreateParameter("@EndDateTime", SqlDbType.DateTime2, endDateTime),
            SqlHelper.CreateParameter("@ConfigID", SqlDbType.Int, configID),
            SqlHelper.CreateParameter("@MinOccupancy", SqlDbType.Int, minOccupancy),
            SqlHelper.CreateParameter("@MaxPrice", SqlDbType.Decimal, maxPrice),
            SqlHelper.CreateParameter("@AmenityIDs", SqlDbType.NVarChar, amenityIDs),
            SqlHelper.CreateParameter("@FloorNumber", SqlDbType.Int, floorNumber)
        }

        Return SqlHelper.ExecuteDataTable("sp_Room_Search", parameters)
    End Function

    Public Function CheckAvailability(roomID As Integer, startDateTime As DateTime,
                                     endDateTime As DateTime) As DataSet Implements IBookingRepository.CheckAvailability

        Dim parameters As SqlParameter() = {
            SqlHelper.CreateParameter("@RoomID", SqlDbType.Int, roomID),
            SqlHelper.CreateParameter("@StartDateTime", SqlDbType.DateTime2, startDateTime),
            SqlHelper.CreateParameter("@EndDateTime", SqlDbType.DateTime2, endDateTime)
        }

        Return SqlHelper.ExecuteDataSet("sp_Room_CheckAvailability", parameters)
    End Function

    Public Function CreateBooking(userID As Integer, roomID As Integer,
                                 startDateTime As DateTime, endDateTime As DateTime,
                                 guestCount As Integer, configID As Integer?,
                                 specialRequests As String, currentUserID As Integer,
                                 ByRef errorCode As Integer, ByRef errorMessage As String) As Integer Implements IBookingRepository.CreateBooking

        Dim bookingID As Integer = 0

        Dim parameters As New List(Of SqlParameter) From {
            SqlHelper.CreateParameter("@UserID", SqlDbType.Int, userID),
            SqlHelper.CreateParameter("@RoomID", SqlDbType.Int, roomID),
            SqlHelper.CreateParameter("@ConfigID", SqlDbType.Int, configID),
            SqlHelper.CreateParameter("@StartDateTime", SqlDbType.DateTime2, startDateTime),
            SqlHelper.CreateParameter("@EndDateTime", SqlDbType.DateTime2, endDateTime),
            SqlHelper.CreateParameter("@GuestCount", SqlDbType.Int, guestCount),
            SqlHelper.CreateParameter("@SpecialRequests", SqlDbType.NVarChar, specialRequests),
            SqlHelper.CreateParameter("@CurrentUserID", SqlDbType.Int, currentUserID),
            SqlHelper.CreateOutputParameter("@BookingID", SqlDbType.Int),
            SqlHelper.CreateOutputParameter("@ErrorCode", SqlDbType.Int),
            SqlHelper.CreateOutputParameter("@ErrorMessage", SqlDbType.NVarChar, 500)
        }

        Dim outputParams As New Dictionary(Of String, Object) From {
            {"@BookingID", Nothing},
            {"@ErrorCode", Nothing},
            {"@ErrorMessage", Nothing}
        }

        SqlHelper.ExecuteWithOutputs("sp_Booking_Create", outputParams, parameters.ToArray())

        bookingID = SqlHelper.SafeGetValue(outputParams("@BookingID"), 0)
        errorCode = SqlHelper.SafeGetValue(outputParams("@ErrorCode"), -999)
        errorMessage = SqlHelper.SafeGetValue(outputParams("@ErrorMessage"), "Unknown error")

        Return bookingID
    End Function



    Public Function AddGuest(bookingID As Integer, guest As GuestDto, currentUserID As Integer,
                         ByRef errorCode As Integer, ByRef errorMessage As String) As Integer Implements IBookingRepository.AddGuest

        Dim parameters As New List(Of SqlParameter) From {
            SqlHelper.CreateParameter("@BookingID", SqlDbType.Int, bookingID),
            SqlHelper.CreateParameter("@GuestType", SqlDbType.NVarChar, guest.GuestType),
            SqlHelper.CreateParameter("@FullName", SqlDbType.NVarChar, guest.FullName),
            SqlHelper.CreateParameter("@Email", SqlDbType.NVarChar, guest.Email),
            SqlHelper.CreateParameter("@Phone", SqlDbType.NVarChar, guest.Phone),
            SqlHelper.CreateParameter("@AgeCategory", SqlDbType.NVarChar, guest.AgeCategory),
            SqlHelper.CreateParameter("@CurrentUserID", SqlDbType.Int, currentUserID),
            SqlHelper.CreateOutputParameter("@GuestID", SqlDbType.Int),
            SqlHelper.CreateOutputParameter("@ErrorCode", SqlDbType.Int),
            SqlHelper.CreateOutputParameter("@ErrorMessage", SqlDbType.NVarChar, 500)
        }

        Dim outputParams As New Dictionary(Of String, Object) From {
            {"@GuestID", Nothing}, {"@ErrorCode", Nothing}, {"@ErrorMessage", Nothing}
        }

        SqlHelper.ExecuteWithOutputs("sp_BookingGuest_Add", outputParams, parameters.ToArray())

        errorCode = SqlHelper.SafeGetValue(outputParams("@ErrorCode"), -999)
        errorMessage = SqlHelper.SafeGetValue(outputParams("@ErrorMessage"), "Unknown Error")

        Return SqlHelper.SafeGetValue(outputParams("@GuestID"), 0)
    End Function

    Public Function CancelBooking(bookingID As Integer, cancellationReason As String,
                                 currentUserID As Integer, ByRef errorCode As Integer,
                                 ByRef errorMessage As String) As Boolean Implements IBookingRepository.CancelBooking

        Dim parameters As New List(Of SqlParameter) From {
            SqlHelper.CreateParameter("@BookingID", SqlDbType.Int, bookingID),
            SqlHelper.CreateParameter("@CancellationReason", SqlDbType.NVarChar, cancellationReason),
            SqlHelper.CreateParameter("@UserID", SqlDbType.Int, currentUserID),
            SqlHelper.CreateOutputParameter("@ErrorCode", SqlDbType.Int),
            SqlHelper.CreateOutputParameter("@ErrorMessage", SqlDbType.NVarChar, 500)
        }

        Dim outputParams As New Dictionary(Of String, Object) From {
            {"@ErrorCode", Nothing},
            {"@ErrorMessage", Nothing}
        }

        SqlHelper.ExecuteWithOutputs("sp_Booking_Cancel", outputParams, parameters.ToArray())

        errorCode = SqlHelper.SafeGetValue(outputParams("@ErrorCode"), -999)
        errorMessage = SqlHelper.SafeGetValue(outputParams("@ErrorMessage"), "Unknown error")

        Return errorCode = 0
    End Function

    Public Function GetBookingById(bookingID As Integer, userID As Integer?) As DataSet Implements IBookingRepository.GetBookingById

        Dim parameters As SqlParameter() = {
            SqlHelper.CreateParameter("@BookingID", SqlDbType.Int, bookingID),
            SqlHelper.CreateParameter("@UserID", SqlDbType.Int, userID)
        }

        Return SqlHelper.ExecuteDataSet("sp_Booking_GetById", parameters)
    End Function

    Public Function GetBookingsByUser(userID As Integer, status As String,
                                     startDate As Date?, endDate As Date?) As DataTable Implements IBookingRepository.GetBookingsByUser

        Dim parameters As SqlParameter() = {
            SqlHelper.CreateParameter("@UserID", SqlDbType.Int, userID),
            SqlHelper.CreateParameter("@Status", SqlDbType.NVarChar, status),
            SqlHelper.CreateParameter("@StartDate", SqlDbType.Date, startDate),
            SqlHelper.CreateParameter("@EndDate", SqlDbType.Date, endDate)
        }

        Return SqlHelper.ExecuteDataTable("sp_Booking_GetByUser", parameters)
    End Function

    Public Function CheckInBooking(bookingID As Integer, currentUserID As Integer,
                                  ByRef errorCode As Integer, ByRef errorMessage As String) As Boolean Implements IBookingRepository.CheckInBooking

        Dim parameters As New List(Of SqlParameter) From {
            SqlHelper.CreateParameter("@BookingID", SqlDbType.Int, bookingID),
            SqlHelper.CreateParameter("@CurrentUserID", SqlDbType.Int, currentUserID),
            SqlHelper.CreateOutputParameter("@ErrorCode", SqlDbType.Int),
            SqlHelper.CreateOutputParameter("@ErrorMessage", SqlDbType.NVarChar, 500)
        }

        Dim outputParams As New Dictionary(Of String, Object) From {
            {"@ErrorCode", Nothing},
            {"@ErrorMessage", Nothing}
        }

        SqlHelper.ExecuteWithOutputs("sp_Booking_CheckIn", outputParams, parameters.ToArray())

        errorCode = SqlHelper.SafeGetValue(outputParams("@ErrorCode"), -999)
        errorMessage = SqlHelper.SafeGetValue(outputParams("@ErrorMessage"), "Unknown error")

        Return errorCode = 0
    End Function

    Public Function CheckOutBooking(bookingID As Integer, currentUserID As Integer,
                                   ByRef errorCode As Integer, ByRef errorMessage As String) As Boolean Implements IBookingRepository.CheckOutBooking

        Dim parameters As New List(Of SqlParameter) From {
            SqlHelper.CreateParameter("@BookingID", SqlDbType.Int, bookingID),
            SqlHelper.CreateParameter("@CurrentUserID", SqlDbType.Int, currentUserID),
            SqlHelper.CreateOutputParameter("@ErrorCode", SqlDbType.Int),
            SqlHelper.CreateOutputParameter("@ErrorMessage", SqlDbType.NVarChar, 500)
        }

        Dim outputParams As New Dictionary(Of String, Object) From {
            {"@ErrorCode", Nothing},
            {"@ErrorMessage", Nothing}
        }

        SqlHelper.ExecuteWithOutputs("sp_Booking_CheckOut", outputParams, parameters.ToArray())

        errorCode = SqlHelper.SafeGetValue(outputParams("@ErrorCode"), -999)
        errorMessage = SqlHelper.SafeGetValue(outputParams("@ErrorMessage"), "Unknown error")

        Return errorCode = 0
    End Function

    Public Function GetBookingTimeline(bookingID As Integer) As DataTable Implements IBookingRepository.GetBookingTimeline

        Dim parameters As SqlParameter() = {
            SqlHelper.CreateParameter("@BookingID", SqlDbType.Int, bookingID)
        }

        Return SqlHelper.ExecuteDataTable("sp_Booking_GetTimeline", parameters)
    End Function

    Public Function AddTimelineEvent(bookingID As Integer, eventType As String,
                                    eventDateTime As DateTime, title As String,
                                    description As String, actionURL As String) As Integer Implements IBookingRepository.AddTimelineEvent

        Dim parameters As New List(Of SqlParameter) From {
            SqlHelper.CreateParameter("@BookingID", SqlDbType.Int, bookingID),
            SqlHelper.CreateParameter("@EventType", SqlDbType.NVarChar, eventType),
            SqlHelper.CreateParameter("@EventDateTime", SqlDbType.DateTime2, eventDateTime),
            SqlHelper.CreateParameter("@Title", SqlDbType.NVarChar, title),
            SqlHelper.CreateParameter("@Description", SqlDbType.NVarChar, description),
            SqlHelper.CreateParameter("@ActionURL", SqlDbType.NVarChar, actionURL),
            SqlHelper.CreateOutputParameter("@EventID", SqlDbType.Int)
        }

        Dim outputParams As New Dictionary(Of String, Object) From {
            {"@EventID", Nothing}
        }

        SqlHelper.ExecuteWithOutputs("sp_TimelineEvent_Add", outputParams, parameters.ToArray())

        Return SqlHelper.SafeGetValue(outputParams("@EventID"), 0)
    End Function

End Class
