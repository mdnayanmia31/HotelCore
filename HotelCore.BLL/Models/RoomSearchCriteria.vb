'' DTO for room search parameters
Public Class RoomSearchCriteria
    Public Property StartDateTime As DateTime
    Public Property EndDateTime As DateTime
    Public Property ConfigID As Integer?
    Public Property MinOccupancy As Integer = 1
    Public Property MaxPrice As Decimal?
    Public Property AmenityIDs As String
    Public Property FloorNumber As Integer?
End Class