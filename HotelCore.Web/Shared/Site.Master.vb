Imports System.Web.Security

Public Class Site1
    Inherits System.Web.UI.MasterPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub lnkLogout_Click(sender As Object, e As EventArgs)
        ' Clear session
        Session.Clear()
        Session.Abandon()
        
        ' Clear authentication cookie
        FormsAuthentication.SignOut()
        
        ' Redirect to home page
        Response.Redirect("~/Default.aspx")
    End Sub

    Protected Sub btnSubscribe_Click(sender As Object, e As EventArgs)
        ' Handle newsletter subscription
        Dim email As String = txtNewsletter.Text.Trim()
        
        If Not String.IsNullOrEmpty(email) Then
            ' In a real implementation, save to database or email service
            txtNewsletter.Text = ""
            ' Show success message via JavaScript
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "NewsletterSuccess", "alert('Thank you for subscribing!');", True)
        End If
    End Sub

End Class