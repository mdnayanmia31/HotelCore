Imports System.Web.Security

Public Class SiteMaster
    Inherits System.Web.UI.MasterPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub lnkLogout_Click(sender As Object, e As EventArgs)
        Session.Clear()
        Session.Abandon()
        FormsAuthentication.SignOut()
        Response.Redirect("~/Default.aspx")
    End Sub

    Protected Sub btnSubscribe_Click(sender As Object, e As EventArgs)
        Dim email As String = txtNewsletter.Text.Trim()
        
        If Not String.IsNullOrEmpty(email) Then
            Try
                Dim addr = New System.Net.Mail.MailAddress(email)
                If addr.Address <> email Then
                    ScriptManager.RegisterStartupScript(Me, Me.GetType(), "NewsletterError", "alert('Please enter a valid email address.');", True)
                    Return
                End If
            Catch
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "NewsletterError", "alert('Please enter a valid email address.');", True)
                Return
            End Try
            
            txtNewsletter.Text = ""
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "NewsletterSuccess", "alert('Thank you for subscribing!');", True)
        End If
    End Sub

End Class