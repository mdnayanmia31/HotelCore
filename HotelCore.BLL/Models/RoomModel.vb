''DTO for Room data
Public Class RoomModel
    Public Property RoomID As Integer
    Public Property RoomNumber As String
    Public Property FloorNumber As Integer
    Public Property Status As String
    Public Property TypeName As String
    Public Property Description As String
    Public Property BaseHourlyRate As Decimal
    Public Property BaseDailyRate As Decimal
    Public Property MaxOccupancy As Integer
    Public Property SquareFeet As Integer
    Public Property BedConfiguration As String
    Public Property LastCleanedDate As DateTime?
    Public Property Notes As String
    Public Property IsAvailable As Boolean
End Class