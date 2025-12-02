Imports HotelCore.BLL

Public Class BookingDetails
    Inherits System.Web.UI.Page

    Private _bookingID As Integer = 0
    Private _bookingStatus As String = ""

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' Ensure user is logged in
        If Session("UserID") Is Nothing Then
            Response.Redirect("~/Account/Login.aspx?returnUrl=" & Server.UrlEncode(Request.RawUrl))
            Return
        End If

        If Not Integer.TryParse(Request.QueryString("id"), _bookingID) Then
            ShowError("Invalid booking ID.")
            Return
        End If

        If Not IsPostBack Then
            LoadBookingDetails()
        End If
    End Sub

    Private Sub LoadBookingDetails()
        Try
            Dim currentUserID As Integer = CInt(Session("UserID"))

            Dim bookingService As New BookingService()
            Dim result = bookingService.GetBookingById(_bookingID, currentUserID)

            If result.Success AndAlso result.Data IsNot Nothing Then
                Dim booking = result.Data

                ' Store status for badge class
                _bookingStatus = booking.Status
                ViewState("BookingStatus") = booking.Status

                ' Populate details
                litBookingRef.Text = booking.BookingReference
                litRoomType.Text = booking.RoomType
                litRoomNumber.Text = booking.RoomNumber
                litCheckIn.Text = booking.StartDateTime.ToShortDateString()
                litCheckOut.Text = booking.EndDateTime.ToShortDateString()
                litGuests.Text = booking.GuestCount.ToString()
                litTotal.Text = booking.TotalAmount.ToString("N2")
                litStatus.Text = booking.Status
                litBookingDate.Text = booking.CreatedDate.ToShortDateString()

                ' Show guests if any
                If booking.Guests IsNot Nothing AndAlso booking.Guests.Count > 0 Then
                    pnlGuests.Visible = True
                    rptGuests.DataSource = booking.Guests
                    rptGuests.DataBind()
                End If

                ' Show payments if any
                If booking.Payments IsNot Nothing AndAlso booking.Payments.Count > 0 Then
                    pnlPayments.Visible = True
                    rptPayments.DataSource = booking.Payments
                    rptPayments.DataBind()
                End If

                ' Show cancellation info if cancelled
                If booking.Status = "Cancelled" Then
                    pnlCancellationInfo.Visible = True
                    pnlCanCancel.Visible = False
                    litCancelledDate.Text = If(booking.CancelledDate.HasValue, booking.CancelledDate.Value.ToShortDateString(), "N/A")
                    litCancellationReason.Text = If(String.IsNullOrEmpty(booking.CancellationReason), "No reason provided", booking.CancellationReason)
                Else
                    ' Check if can cancel (not already checked in and at least 24 hours before check-in)
                    Dim canCancel As Boolean = (booking.Status = "Pending" OrElse booking.Status = "Confirmed") AndAlso booking.StartDateTime > DateTime.Now.AddHours(24)
                    pnlCanCancel.Visible = canCancel
                End If
            Else
                ShowError(If(String.IsNullOrEmpty(result.ErrorMessage), "Booking not found.", result.ErrorMessage))
            End If

        Catch ex As Exception
            ShowError("An error occurred while loading booking details.")
        End Try
    End Sub

    Protected Sub btnCancelBooking_Click(sender As Object, e As EventArgs)
        pnlBookingDetails.Visible = False
        pnlCancelForm.Visible = True
    End Sub

    Protected Sub btnCancelCancelation_Click(sender As Object, e As EventArgs)
        pnlBookingDetails.Visible = True
        pnlCancelForm.Visible = False
    End Sub

    Protected Sub btnConfirmCancel_Click(sender As Object, e As EventArgs)
        Try
            Dim reason As String = txtCancellationReason.Text.Trim()

            If String.IsNullOrEmpty(reason) OrElse reason.Length < 10 Then
                ShowError("Cancellation reason must be at least 10 characters.")
                Return
            End If

            Dim currentUserID As Integer = CInt(Session("UserID"))

            Dim bookingService As New BookingService()
            Dim result = bookingService.CancelBooking(_bookingID, reason, currentUserID)

            If result.Success Then
                ShowSuccess("Booking cancelled successfully.")
                pnlCancelForm.Visible = False
                pnlBookingDetails.Visible = True
                LoadBookingDetails() ' Reload to show updated status
            Else
                ShowError(If(String.IsNullOrEmpty(result.ErrorMessage), "Failed to cancel booking.", result.ErrorMessage))
            End If

        Catch ex As Exception
            ShowError("An error occurred while cancelling the booking.")
        End Try
    End Sub

    Protected Function GetStatusBadgeClass() As String
        Dim status As String = If(ViewState("BookingStatus") IsNot Nothing, ViewState("BookingStatus").ToString(), "")
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
