'' Business Logic Service for User Operations

Imports HotelCore.DAL

Public Class UserService

    Private ReadOnly _userRepo As IUserRepository

    Public Sub New()
        _userRepo = New UserRepository()
    End Sub

    Public Sub New(userRepo As IUserRepository)
        _userRepo = userRepo
    End Sub

    '' Authenticate user login
    Public Function AuthenticateUser(email As String, password As String, ipAddress As String, userAgent As String) As OperationResult(Of UserModel)
        Dim result As New OperationResult(Of UserModel)

        Try
            ' BUSINESS RULE VALIDATION
            If String.IsNullOrWhiteSpace(email) Then
                result.Success = False
                result.ErrorMessage = "Email is required"
                Return result
            End If

            If String.IsNullOrWhiteSpace(password) Then
                result.Success = False
                result.ErrorMessage = "Password is required"
                Return result
            End If

            ' Hash password
            Dim passwordHash As String = HashPassword(password)

            ' Call DAL
            Dim userID As Integer = 0
            Dim roleID As Integer = 0
            Dim roleName As String = ""
            Dim fullName As String = ""
            Dim errorCode As Integer = 0
            Dim errorMessage As String = ""

            userID = _userRepo.Authenticate(
                email,
                passwordHash,
                ipAddress,
                userAgent,
                roleID,
                roleName,
                fullName,
                errorCode,
                errorMessage
            )

            If userID > 0 AndAlso errorCode = 0 Then
                result.Success = True
                result.Data = New UserModel With {
                    .UserID = userID,
                    .Email = email,
                    .FullName = fullName,
                    .RoleID = roleID,
                    .RoleName = roleName
                }
                result.Message = "Login successful"
            Else
                result.Success = False
                result.ErrorCode = errorCode
                result.ErrorMessage = errorMessage
            End If

        Catch ex As Exception
            result.Success = False
            result.ErrorMessage = $"Error during authentication: {ex.Message}"
        End Try

        Return result
    End Function

    ''Register new user
    Public Function RegisterUser(model As UserModel, password As String, currentUserID As Integer?) As OperationResult(Of UserModel)
        Dim result As New OperationResult(Of UserModel)

        Try
            ' BUSINESS RULE VALIDATION
            Dim validationErrors As List(Of String) = ValidateUserRegistration(model, password)
            If validationErrors.Count > 0 Then
                result.Success = False
                result.ErrorMessage = String.Join("; ", validationErrors)
                Return result
            End If

            ' Hash password
            Dim passwordHash As String = HashPassword(password)
            Dim passwordSalt As String = GenerateSalt()

            ' Call DAL
            Dim errorCode As Integer = 0
            Dim errorMessage As String = ""

            Dim userID As Integer = _userRepo.CreateUser(
                model.Email,
                passwordHash,
                passwordSalt,
                model.FirstName,
                model.LastName,
                model.PhoneNumber,
                model.RoleID,
                currentUserID,
                errorCode,
                errorMessage
            )

            If userID > 0 AndAlso errorCode = 0 Then
                model.UserID = userID
                result.Success = True
                result.Data = model
                result.Message = "User registered successfully"
            Else
                result.Success = False
                result.ErrorCode = errorCode
                result.ErrorMessage = errorMessage
            End If

        Catch ex As Exception
            result.Success = False
            result.ErrorMessage = $"Error during registration: {ex.Message}"
        End Try

        Return result
    End Function

    '' Update user profile
    Public Function UpdateUserProfile(model As UserModel, currentUserID As Integer) As OperationResult
        Dim result As New OperationResult

        Try
            ' BUSINESS RULE VALIDATION
            If String.IsNullOrWhiteSpace(model.FirstName) Then
                result.Success = False
                result.ErrorMessage = "First name is required"
                Return result
            End If

            If String.IsNullOrWhiteSpace(model.LastName) Then
                result.Success = False
                result.ErrorMessage = "Last name is required"
                Return result
            End If

            ' Call DAL
            Dim errorCode As Integer = 0
            Dim errorMessage As String = ""

            Dim success As Boolean = _userRepo.UpdateProfile(
                model.UserID,
                model.FirstName,
                model.LastName,
                model.PhoneNumber,
                currentUserID,
                errorCode,
                errorMessage
            )

            If success AndAlso errorCode = 0 Then
                result.Success = True
                result.Message = "Profile updated successfully"
            Else
                result.Success = False
                result.ErrorCode = errorCode
                result.ErrorMessage = errorMessage
            End If

        Catch ex As Exception
            result.Success = False
            result.ErrorMessage = $"Error updating profile: {ex.Message}"
        End Try

        Return result
    End Function

    ' Private validation methods
    Private Function ValidateUserRegistration(model As UserModel, password As String) As List(Of String)
        Dim errors As New List(Of String)

        ' Email validation
        If String.IsNullOrWhiteSpace(model.Email) Then
            errors.Add("Email is required")
        ElseIf Not IsValidEmail(model.Email) Then
            errors.Add("Invalid email format")
        End If

        ' Password validation
        If String.IsNullOrWhiteSpace(password) Then
            errors.Add("Password is required")
        ElseIf password.Length < 8 Then
            errors.Add("Password must be at least 8 characters")
        End If

        ' Name validation
        If String.IsNullOrWhiteSpace(model.FirstName) Then
            errors.Add("First name is required")
        End If

        If String.IsNullOrWhiteSpace(model.LastName) Then
            errors.Add("Last name is required")
        End If

        Return errors
    End Function

    Private Function IsValidEmail(email As String) As Boolean
        Try
            Dim addr = New System.Net.Mail.MailAddress(email)
            Return addr.Address = email
        Catch
            Return False
        End Try
    End Function

    Private Function HashPassword(password As String) As String

        Using sha256 As New System.Security.Cryptography.SHA256Managed()
            Dim bytes As Byte() = System.Text.Encoding.UTF8.GetBytes(password)
            Dim hash As Byte() = sha256.ComputeHash(bytes)
            Return Convert.ToBase64String(hash)
        End Using
    End Function

    Private Function GenerateSalt() As String
        Dim rng As New System.Security.Cryptography.RNGCryptoServiceProvider()
        Dim saltBytes(31) As Byte
        rng.GetBytes(saltBytes)
        Return Convert.ToBase64String(saltBytes)
    End Function

End Class