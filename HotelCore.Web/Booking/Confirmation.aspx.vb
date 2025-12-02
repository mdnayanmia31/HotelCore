Imports HotelCore.BLL

Public Class Confirmation
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            LoadBookingDetails()
        End If
    End Sub

    Private Sub LoadBookingDetails()
        Try
            Dim bookingID As Integer
            If Not Integer.TryParse(Request.QueryString("id"), bookingID) Then
                ShowError("Invalid booking ID.")
                Return
            End If

            ' Get current user ID (can be Nothing for viewing confirmation)
            Dim currentUserID As Integer? = Nothing
            If Session("UserID") IsNot Nothing Then
                currentUserID = CInt(Session("UserID"))
            End If

            ' Load booking
            Dim bookingService As New BookingService()
            Dim result = bookingService.GetBookingById(bookingID, currentUserID)

            If result.Success AndAlso result.Data IsNot Nothing Then
                Dim booking = result.Data

                litBookingRef.Text = booking.BookingReference
                litRoomType.Text = booking.RoomType
                litRoomNumber.Text = booking.RoomNumber
                litCheckIn.Text = booking.StartDateTime.ToShortDateString()
                litCheckOut.Text = booking.EndDateTime.ToShortDateString()
                litGuests.Text = booking.GuestCount.ToString()
                litStatus.Text = booking.Status
                litTotal.Text = booking.TotalAmount.ToString("N2")

                ' Show guests if any
                If booking.Guests IsNot Nothing AndAlso booking.Guests.Count > 0 Then
                    pnlGuests.Visible = True
                    rptGuests.DataSource = booking.Guests
                    rptGuests.DataBind()
                End If
            Else
                ShowError(If(String.IsNullOrEmpty(result.ErrorMessage), "Booking not found.", result.ErrorMessage))
            End If

        Catch ex As Exception
            ShowError("An error occurred while loading booking details.")
        End Try
    End Sub

    Private Sub ShowError(message As String)
        pnlError.Visible = True
        pnlConfirmation.Visible = False
        litError.Text = "<i class='fa fa-exclamation-circle mr-2'></i> " & message
    End Sub

End Class
