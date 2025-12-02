Public Class _Default
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub btnCheckAvailability_Click(sender As Object, e As EventArgs)
        ' Get form values
        Dim checkIn As String = txtCheckIn.Text.Trim()
        Dim checkOut As String = txtCheckOut.Text.Trim()
        Dim guests As String = ddlGuests.SelectedValue
        
        ' Validate dates before redirecting
        Dim checkInDate As DateTime
        Dim checkOutDate As DateTime
        
        If Not DateTime.TryParse(checkIn, checkInDate) OrElse Not DateTime.TryParse(checkOut, checkOutDate) Then
            ' Invalid dates - just redirect to search page without parameters
            Response.Redirect("~/Booking/Search.aspx")
            Return
        End If
        
        If checkInDate >= checkOutDate Then
            ' Invalid date range - redirect without parameters
            Response.Redirect("~/Booking/Search.aspx")
            Return
        End If
        
        ' Redirect to search page with validated parameters
        Response.Redirect(String.Format("~/Booking/Search.aspx?checkin={0}&checkout={1}&guests={2}", 
            Server.UrlEncode(checkIn), Server.UrlEncode(checkOut), guests))
    End Sub

End Class