Imports System.Data

Public Interface IRoomRepository
    Function GetRoomById(roomID As Integer) As DataRow
    Function GetAllRoomTypes() As DataTable
    Function UpdateRoomStatus(roomID As Integer, status As String, notes As String,
                             currentUserID As Integer, ByRef errorCode As Integer,
                             ByRef errorMessage As String) As Boolean
End Interface