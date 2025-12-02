Public Class _Default
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub btnCheckAvailability_Click(sender As Object, e As EventArgs)
        ' Get form values
        Dim checkIn As String = txtCheckIn.Text
        Dim checkOut As String = txtCheckOut.Text
        Dim guests As String = ddlGuests.SelectedValue
        
        ' Redirect to search page with parameters
        Response.Redirect(String.Format("~/Booking/Search.aspx?checkin={0}&checkout={1}&guests={2}", 
            Server.UrlEncode(checkIn), Server.UrlEncode(checkOut), guests))
    End Sub

End Class