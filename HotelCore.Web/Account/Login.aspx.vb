Imports System.Web.Security
Imports HotelCore.BLL

Namespace Account
    Public Class Login
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
            If Session("UserID") IsNot Nothing Then
                RedirectAfterLogin()
            End If

            If Not IsPostBack Then
                If Request.QueryString("registered") = "true" Then
                    pnlSuccess.Visible = True
                    litSuccess.Text = "<i class='fa fa-check-circle mr-2'></i> Registration successful! Please sign in."
                End If
            End If
        End Sub

        Protected Sub btnLogin_Click(sender As Object, e As EventArgs)
            Try
                pnlError.Visible = False
                pnlSuccess.Visible = False

                Dim email As String = txtEmail.Text.Trim()
                Dim password As String = txtPassword.Text

                If String.IsNullOrEmpty(email) OrElse String.IsNullOrEmpty(password) Then
                    ShowError("Please enter both email and password.")
                    Return
                End If

                Dim userService As New UserService()
                Dim result = userService.AuthenticateUser(
                    email,
                    password,
                    Request.UserHostAddress,
                    Request.UserAgent
                )

                If result.Success AndAlso result.Data IsNot Nothing Then
                    Dim user = result.Data

                    Session("UserID") = user.UserID
                    Session("UserEmail") = user.Email
                    Session("UserFullName") = user.FullName
                    Session("UserRoleID") = user.RoleID
                    Session("UserRoleName") = user.RoleName

                    FormsAuthentication.SetAuthCookie(email, chkRememberMe.Checked)

                    RedirectAfterLogin()
                Else
                    ShowError(If(String.IsNullOrEmpty(result.ErrorMessage), "Invalid email or password.", result.ErrorMessage))
                End If

            Catch ex As Exception
                ShowError("An error occurred during login. Please try again.")
            End Try
        End Sub

        Private Sub RedirectAfterLogin()
            Dim returnUrl As String = Request.QueryString("returnUrl")
            If Not String.IsNullOrEmpty(returnUrl) Then
                Response.Redirect(Server.UrlDecode(returnUrl))
            Else
                If Session("UserRoleName") IsNot Nothing AndAlso Session("UserRoleName").ToString() = "Admin" Then
                    Response.Redirect("~/Admin/Dashboard.aspx")
                Else
                    Response.Redirect("~/Default.aspx")
                End If
            End If
        End Sub

        Private Sub ShowError(message As String)
            pnlError.Visible = True
            litError.Text = "<i class='fa fa-exclamation-circle mr-2'></i> " & message
        End Sub

    End Class
End Namespace
