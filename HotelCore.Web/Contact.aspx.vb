Public Class Contact
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs)
        Try
            pnlError.Visible = False
            pnlSuccess.Visible = False

            ' Validate inputs
            If String.IsNullOrEmpty(txtName.Text.Trim()) Then
                ShowError("Please enter your name.")
                Return
            End If

            If String.IsNullOrEmpty(txtEmail.Text.Trim()) Then
                ShowError("Please enter your email.")
                Return
            End If

            If String.IsNullOrEmpty(txtMessage.Text.Trim()) Then
                ShowError("Please enter your message.")
                Return
            End If

            ' In a real implementation, you would:
            ' 1. Save to database
            ' 2. Send email notification
            ' 3. Log the inquiry

            ' For now, show success message
            pnlSuccess.Visible = True
            pnlForm.Visible = False

        Catch ex As Exception
            ShowError("An error occurred. Please try again.")
        End Try
    End Sub

    Private Sub ShowError(message As String)
        pnlError.Visible = True
        litError.Text = "<i class='fa fa-exclamation-circle mr-2'></i> " & message
    End Sub

End Class
