'' Business Logic Service for Room Operations

Imports System.Data
Imports HotelCore.DAL


Public Class RoomService

    Private ReadOnly _roomRepo As IRoomRepository

    Public Sub New()
        _roomRepo = New RoomRepository()
    End Sub

    Public Sub New(roomRepo As IRoomRepository)
        _roomRepo = roomRepo
    End Sub

    '' Get all room types for selection
    Public Function GetAllRoomTypes() As OperationResult(Of List(Of RoomModel))
        Dim result As New OperationResult(Of List(Of RoomModel))

        Try
            Dim dt As DataTable = _roomRepo.GetAllRoomTypes()

            Dim roomTypes As New List(Of RoomModel)
            For Each row As DataRow In dt.Rows
                roomTypes.Add(New RoomModel With {
                    .RoomID = CInt(row("RoomTypeID")),
                    .TypeName = row("TypeName").ToString(),
                    .Description = row("Description").ToString(),
                    .BaseHourlyRate = CDec(row("BaseHourlyRate")),
                    .BaseDailyRate = CDec(row("BaseDailyRate")),
                    .MaxOccupancy = CInt(row("MaxOccupancy")),
                    .SquareFeet = If(IsDBNull(row("SquareFeet")), 0, CInt(row("SquareFeet"))),
                    .BedConfiguration = If(IsDBNull(row("BedConfiguration")), "", row("BedConfiguration").ToString())
                })
            Next

            result.Success = True
            result.Data = roomTypes
            result.Message = $"Retrieved {roomTypes.Count} room type(s)"

        Catch ex As Exception
            result.Success = False
            result.ErrorMessage = $"Error retrieving room types: {ex.Message}"
        End Try

        Return result
    End Function

    '' Get room details by ID
    Public Function GetRoomById(roomID As Integer) As OperationResult(Of RoomModel)
        Dim result As New OperationResult(Of RoomModel)

        Try
            Dim row As DataRow = _roomRepo.GetRoomById(roomID)

            If row IsNot Nothing Then
                result.Data = New RoomModel With {
                    .RoomID = CInt(row("RoomID")),
                    .RoomNumber = row("RoomNumber").ToString(),
                    .FloorNumber = CInt(row("FloorNumber")),
                    .Status = row("Status").ToString(),
                    .TypeName = row("TypeName").ToString(),
                    .Description = row("Description").ToString(),
                    .BaseHourlyRate = CDec(row("BaseHourlyRate")),
                    .BaseDailyRate = CDec(row("BaseDailyRate")),
                    .MaxOccupancy = CInt(row("MaxOccupancy")),
                    .SquareFeet = If(IsDBNull(row("SquareFeet")), 0, CInt(row("SquareFeet"))),
                    .BedConfiguration = If(IsDBNull(row("BedConfiguration")), "", row("BedConfiguration").ToString()),
                    .LastCleanedDate = If(IsDBNull(row("LastCleanedDate")), Nothing, CDate(row("LastCleanedDate"))),
                    .Notes = If(IsDBNull(row("Notes")), "", row("Notes").ToString())
                }

                result.Success = True
                result.Message = "Room retrieved successfully"
            Else
                result.Success = False
                result.ErrorMessage = "Room not found"
            End If

        Catch ex As Exception
            result.Success = False
            result.ErrorMessage = $"Error retrieving room: {ex.Message}"
        End Try

        Return result
    End Function

    '' Update room status
    Public Function UpdateRoomStatus(roomID As Integer, status As String, notes As String, currentUserID As Integer) As OperationResult
        Dim result As New OperationResult

        Try
            ' BUSINESS RULE VALIDATION
            Dim validStatuses As String() = {"Available", "Occupied", "Cleaning", "Maintenance", "OutOfOrder"}
            If Not validStatuses.Contains(status) Then
                result.Success = False
                result.ErrorMessage = "Invalid room status"
                Return result
            End If

            ' Call DAL
            Dim errorCode As Integer = 0
            Dim errorMessage As String = ""

            Dim success As Boolean = _roomRepo.UpdateRoomStatus(
                roomID,
                status,
                notes,
                currentUserID,
                errorCode,
                errorMessage
            )

            If success AndAlso errorCode = 0 Then
                result.Success = True
                result.Message = "Room status updated successfully"
            Else
                result.Success = False
                result.ErrorCode = errorCode
                result.ErrorMessage = errorMessage
            End If

        Catch ex As Exception
            result.Success = False
            result.ErrorMessage = $"Error updating room status: {ex.Message}"
        End Try

        Return result
    End Function

End Class