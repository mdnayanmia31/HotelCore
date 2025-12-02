Namespace HotelCore.DAL
 ''' <summary>
 ''' Data transfer object used by DAL for guest operations.
 ''' Kept in DAL to avoid circular project references.
 ''' </summary>
 Public Class GuestDto
 Public Property GuestID As Integer
 Public Property FullName As String
 Public Property Email As String
 Public Property Phone As String
 Public Property GuestType As String
 Public Property AgeCategory As String
 End Class
End Namespace