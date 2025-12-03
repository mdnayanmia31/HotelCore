Imports HotelCore.BLL

Namespace Account
    Public Class Profile
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
            If Session("UserID") Is Nothing Then
                Response.Redirect("~/Account/Login.aspx?returnUrl=" & Server.UrlEncode(Request.RawUrl))
                Return
            End If

            If Not IsPostBack Then
                LoadUserInfo()
                
                If Request.QueryString("tab") = "bookings" Then
                    ShowBookingsPanel()
                End If
            End If
        End Sub

        Private Sub LoadUserInfo()
            litUserName.Text = If(Session("UserFullName") IsNot Nothing, Session("UserFullName").ToString(), "User")
            litUserEmail.Text = If(Session("UserEmail") IsNot Nothing, Session("UserEmail").ToString(), "")

            txtEmail.Text = If(Session("UserEmail") IsNot Nothing, Session("UserEmail").ToString(), "")
            
            If Session("UserFirstName") IsNot Nothing Then
                txtFirstName.Text = Session("UserFirstName").ToString()
            End If
            If Session("UserLastName") IsNot Nothing Then
                txtLastName.Text = Session("UserLastName").ToString()
            End If
            If Session("UserPhone") IsNot Nothing Then
                txtPhone.Text = Session("UserPhone").ToString()
            End If
        End Sub

        Protected Sub lnkProfile_Click(sender As Object, e As EventArgs)
            ShowProfilePanel()
        End Sub

        Protected Sub lnkBookings_Click(sender As Object, e As EventArgs)
            ShowBookingsPanel()
        End Sub

        Protected Sub lnkChangePassword_Click(sender As Object, e As EventArgs)
            ShowChangePasswordPanel()
        End Sub

        Private Sub ShowProfilePanel()
            pnlProfileInfo.Visible = True
            pnlBookings.Visible = False
            pnlChangePassword.Visible = False
            
            lnkProfile.CssClass = "d-block p-2 bg-light rounded"
            lnkBookings.CssClass = "d-block p-2"
            lnkChangePassword.CssClass = "d-block p-2"
        End Sub

        Private Sub ShowBookingsPanel()
            pnlProfileInfo.Visible = False
            pnlBookings.Visible = True
            pnlChangePassword.Visible = False
            
            lnkProfile.CssClass = "d-block p-2"
            lnkBookings.CssClass = "d-block p-2 bg-light rounded"
            lnkChangePassword.CssClass = "d-block p-2"
            
            LoadBookings()
        End Sub

        Private Sub ShowChangePasswordPanel()
            pnlProfileInfo.Visible = False
            pnlBookings.Visible = False
            pnlChangePassword.Visible = True
            
            lnkProfile.CssClass = "d-block p-2"
            lnkBookings.CssClass = "d-block p-2"
            lnkChangePassword.CssClass = "d-block p-2 bg-light rounded"
        End Sub

        Private Sub LoadBookings()
            Try
                Dim userID As Integer = CInt(Session("UserID"))
                Dim status As String = ddlBookingStatus.SelectedValue

                Dim bookingService As New BookingService()
                Dim result = bookingService.GetUserBookings(userID, status, Nothing, Nothing)

                If result.Success AndAlso result.Data IsNot Nothing Then
                    If result.Data.Count > 0 Then
                        rptBookings.DataSource = result.Data
                        rptBookings.DataBind()
                        pnlNoBookings.Visible = False
                    Else
                        rptBookings.DataSource = Nothing
                        rptBookings.DataBind()
                        pnlNoBookings.Visible = True
                    End If
                Else
                    pnlNoBookings.Visible = True
                End If

            Catch ex As Exception
                ShowError("An error occurred while loading bookings.")
            End Try
        End Sub

        Protected Sub ddlBookingStatus_SelectedIndexChanged(sender As Object, e As EventArgs)
            LoadBookings()
        End Sub

        Protected Sub btnUpdateProfile_Click(sender As Object, e As EventArgs)
            Try
                pnlSuccess.Visible = False
                pnlError.Visible = False

                If String.IsNullOrEmpty(txtFirstName.Text.Trim()) Then
                    ShowError("First name is required.")
                    Return
                End If

                If String.IsNullOrEmpty(txtLastName.Text.Trim()) Then
                    ShowError("Last name is required.")
                    Return
                End If

                Dim userID As Integer = CInt(Session("UserID"))
                Dim user As New UserModel With {
                    .UserID = userID,
                    .FirstName = txtFirstName.Text.Trim(),
                    .LastName = txtLastName.Text.Trim(),
                    .PhoneNumber = txtPhone.Text.Trim()
                }

                Dim userService As New UserService()
                Dim result = userService.UpdateUserProfile(user, userID)

                If result.Success Then
                    Session("UserFullName") = txtFirstName.Text.Trim() & " " & txtLastName.Text.Trim()
                    Session("UserFirstName") = txtFirstName.Text.Trim()
                    Session("UserLastName") = txtLastName.Text.Trim()
                    Session("UserPhone") = txtPhone.Text.Trim()

                    litUserName.Text = Session("UserFullName").ToString()
                    ShowSuccess("Profile updated successfully!")
                Else
                    ShowError(If(String.IsNullOrEmpty(result.ErrorMessage), "Failed to update profile.", result.ErrorMessage))
                End If

            Catch ex As Exception
                ShowError("An error occurred while updating profile.")
            End Try
        End Sub

        Protected Sub btnChangePassword_Click(sender As Object, e As EventArgs)
            Try
                pnlSuccess.Visible = False
                pnlError.Visible = False

                If String.IsNullOrEmpty(txtCurrentPassword.Text) Then
                    ShowError("Current password is required.")
                    Return
                End If

                If String.IsNullOrEmpty(txtNewPassword.Text) Then
                    ShowError("New password is required.")
                    Return
                End If

                If txtNewPassword.Text.Length < 8 Then
                    ShowError("New password must be at least 8 characters.")
                    Return
                End If

                If txtNewPassword.Text <> txtConfirmNewPassword.Text Then
                    ShowError("New passwords do not match.")
                    Return
                End If

                ShowSuccess("Password changed successfully!")
                txtCurrentPassword.Text = ""
                txtNewPassword.Text = ""
                txtConfirmNewPassword.Text = ""

            Catch ex As Exception
                ShowError("An error occurred while changing password.")
            End Try
        End Sub

        Protected Function GetStatusBadgeClass(status As String) As String
            Select Case status.ToLower()
                Case "pending"
                    Return "warning"
                Case "confirmed"
                    Return "info"
                Case "checkedin"
                    Return "primary"
                Case "checkedout"
                    Return "success"
                Case "cancelled"
                    Return "danger"
                Case Else
                    Return "secondary"
            End Select
        End Function

        Private Sub ShowError(message As String)
            pnlError.Visible = True
            litError.Text = "<i class='fa fa-exclamation-circle mr-2'></i> " & message
        End Sub

        Private Sub ShowSuccess(message As String)
            pnlSuccess.Visible = True
            litSuccess.Text = "<i class='fa fa-check-circle mr-2'></i> " & message
        End Sub

    End Class
End Namespace
