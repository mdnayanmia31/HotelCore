''DTO for User data
Public Class UserModel
    Public Property UserID As Integer
    Public Property Email As String
    Public Property FirstName As String
    Public Property LastName As String
    Public Property FullName As String
    Public Property PhoneNumber As String
    Public Property RoleID As Integer
    Public Property RoleName As String
    Public Property IsActive As Boolean
    Public Property LastLoginDate As DateTime?
    Public Property CreatedDate As DateTime
End Class
