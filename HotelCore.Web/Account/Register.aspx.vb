Imports HotelCore.BLL
Imports HotelCore.BLL.Models

Public Class Register
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' If already logged in, redirect to home
        If Session("UserID") IsNot Nothing Then
            Response.Redirect("~/Default.aspx")
        End If
    End Sub

    Protected Sub btnRegister_Click(sender As Object, e As EventArgs)
        Try
            pnlError.Visible = False

            ' Validate terms acceptance
            If Not chkTerms.Checked Then
                ShowError("Please accept the Terms of Service and Privacy Policy.")
                Return
            End If

            ' Validate password length
            If txtPassword.Text.Length < 8 Then
                ShowError("Password must be at least 8 characters long.")
                Return
            End If

            ' Create user model
            Dim user As New UserModel With {
                .Email = txtEmail.Text.Trim(),
                .FirstName = txtFirstName.Text.Trim(),
                .LastName = txtLastName.Text.Trim(),
                .PhoneNumber = txtPhone.Text.Trim(),
                .RoleID = 2 ' Default role for regular users (Guest)
            }

            ' Call BLL to register
            Dim userService As New UserService()
            Dim result = userService.RegisterUser(user, txtPassword.Text, Nothing)

            If result.Success AndAlso result.Data IsNot Nothing Then
                ' Registration successful - redirect to login
                Response.Redirect("~/Account/Login.aspx?registered=true")
            Else
                ShowError(If(String.IsNullOrEmpty(result.ErrorMessage), "Registration failed. Please try again.", result.ErrorMessage))
            End If

        Catch ex As Exception
            ShowError("An error occurred during registration. Please try again.")
        End Try
    End Sub

    Private Sub ShowError(message As String)
        pnlError.Visible = True
        litError.Text = "<i class='fa fa-exclamation-circle mr-2'></i> " & message
    End Sub

End Class
