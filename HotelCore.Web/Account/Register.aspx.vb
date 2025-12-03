Imports HotelCore.BLL

Namespace Account
    Public Class Register
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
            If Session("UserID") IsNot Nothing Then
                Response.Redirect("~/Default.aspx")
            End If
        End Sub

        Protected Sub btnRegister_Click(sender As Object, e As EventArgs)
            Try
                pnlError.Visible = False

                If Not chkTerms.Checked Then
                    ShowError("Please accept the Terms of Service and Privacy Policy.")
                    Return
                End If

                If txtPassword.Text.Length < 8 Then
                    ShowError("Password must be at least 8 characters long.")
                    Return
                End If

                Dim user As New UserModel With {
                    .Email = txtEmail.Text.Trim(),
                    .FirstName = txtFirstName.Text.Trim(),
                    .LastName = txtLastName.Text.Trim(),
                    .PhoneNumber = txtPhone.Text.Trim(),
                    .RoleID = 2
                }

                Dim userService As New UserService()
                Dim result = userService.RegisterUser(user, txtPassword.Text, Nothing)

                If result.Success AndAlso result.Data IsNot Nothing Then
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
End Namespace
