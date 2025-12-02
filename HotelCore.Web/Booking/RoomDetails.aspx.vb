Imports HotelCore.BLL

Public Class RoomDetails
    Inherits System.Web.UI.Page

    Private _roomID As Integer = 0

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Integer.TryParse(Request.QueryString("id"), _roomID) Then
            ShowError("Invalid room ID.")
            Return
        End If

        If Not IsPostBack Then
            LoadRoomDetails()
        End If
    End Sub

    Private Sub LoadRoomDetails()
        Try
            Dim roomService As New RoomService()
            Dim result = roomService.GetRoomById(_roomID)

            If result.Success AndAlso result.Data IsNot Nothing Then
                Dim room = result.Data

                ' Update page title
                litRoomType.Text = room.TypeName
                Page.Title = room.TypeName & " - HotelCore"

                ' Populate room details
                litRoomTypeName.Text = room.TypeName
                litRoomNumber.Text = room.RoomNumber
                litFloor.Text = room.FloorNumber.ToString()
                litSize.Text = room.SquareFeet.ToString()
                litCapacity.Text = room.MaxOccupancy.ToString()
                litBedConfig.Text = If(String.IsNullOrEmpty(room.BedConfiguration), "Standard", room.BedConfiguration)
                litDailyRate.Text = room.BaseDailyRate.ToString("N2")
                litEstDailyRate.Text = room.BaseDailyRate.ToString("N2")
                litStatus.Text = room.Status
                litDescription.Text = If(String.IsNullOrEmpty(room.Description), "Experience comfort and luxury in our well-appointed room.", room.Description)

                ' Store room info in ViewState for later use
                ViewState("RoomID") = room.RoomID
                ViewState("DailyRate") = room.BaseDailyRate
                ViewState("MaxOccupancy") = room.MaxOccupancy

                ' Limit guest dropdown based on room capacity
                For Each item As ListItem In ddlGuests.Items
                    Dim guestCount As Integer = CInt(item.Value)
                    item.Enabled = guestCount <= room.MaxOccupancy
                Next
            Else
                ShowError(If(String.IsNullOrEmpty(result.ErrorMessage), "Room not found.", result.ErrorMessage))
            End If

        Catch ex As Exception
            ShowError("An error occurred while loading room details.")
        End Try
    End Sub

    Protected Sub btnCalculate_Click(sender As Object, e As EventArgs)
        CalculatePrice()
    End Sub

    Protected Sub ddlGuests_SelectedIndexChanged(sender As Object, e As EventArgs)
        CalculatePrice()
    End Sub

    Private Sub CalculatePrice()
        Try
            ' Validate dates
            Dim checkIn As DateTime
            Dim checkOut As DateTime

            If Not DateTime.TryParse(txtCheckIn.Text, checkIn) OrElse Not DateTime.TryParse(txtCheckOut.Text, checkOut) Then
                litNights.Text = "0"
                litTotalPrice.Text = "0.00"
                Return
            End If

            If checkIn >= checkOut Then
                litNights.Text = "0"
                litTotalPrice.Text = "0.00"
                Return
            End If

            ' Get room ID from ViewState or QueryString
            Dim roomID As Integer = 0
            If ViewState("RoomID") IsNot Nothing Then
                roomID = CInt(ViewState("RoomID"))
            ElseIf Integer.TryParse(Request.QueryString("id"), roomID) Then
                ' Use query string
            Else
                Return
            End If

            ' Call BLL to estimate price
            Dim bookingService As New BookingService()
            Dim result = bookingService.EstimatePrice(roomID, checkIn, checkOut)

            If result.Success Then
                Dim nights As Integer = CInt(Math.Ceiling((checkOut - checkIn).TotalDays))
                litNights.Text = nights.ToString()
                litTotalPrice.Text = result.Data.ToString("N2")
            Else
                ' Fall back to simple calculation
                If ViewState("DailyRate") IsNot Nothing Then
                    Dim dailyRate As Decimal = CDec(ViewState("DailyRate"))
                    Dim nights As Integer = CInt(Math.Ceiling((checkOut - checkIn).TotalDays))
                    litNights.Text = nights.ToString()
                    litTotalPrice.Text = (dailyRate * nights).ToString("N2")
                End If
            End If

        Catch ex As Exception
            ' Silently handle errors in price calculation
        End Try
    End Sub

    Protected Sub btnBookNow_Click(sender As Object, e As EventArgs)
        ' Validate dates
        Dim checkIn As DateTime
        Dim checkOut As DateTime

        If Not DateTime.TryParse(txtCheckIn.Text, checkIn) Then
            ShowError("Please select a valid check-in date.")
            Return
        End If

        If Not DateTime.TryParse(txtCheckOut.Text, checkOut) Then
            ShowError("Please select a valid check-out date.")
            Return
        End If

        If checkIn >= checkOut Then
            ShowError("Check-out date must be after check-in date.")
            Return
        End If

        If checkIn < DateTime.Today Then
            ShowError("Check-in date cannot be in the past.")
            Return
        End If

        ' Check if user is logged in
        If Session("UserID") Is Nothing Then
            ' Store booking info in session and redirect to login
            Session("PendingBooking_RoomID") = Request.QueryString("id")
            Session("PendingBooking_CheckIn") = checkIn
            Session("PendingBooking_CheckOut") = checkOut
            Session("PendingBooking_Guests") = ddlGuests.SelectedValue
            
            Response.Redirect("~/Account/Login.aspx?returnUrl=" & Server.UrlEncode("~/Booking/Checkout.aspx"))
            Return
        End If

        ' Redirect to checkout with parameters
        Response.Redirect(String.Format("~/Booking/Checkout.aspx?roomId={0}&checkIn={1}&checkOut={2}&guests={3}",
            Request.QueryString("id"),
            Server.UrlEncode(checkIn.ToShortDateString()),
            Server.UrlEncode(checkOut.ToShortDateString()),
            ddlGuests.SelectedValue))
    End Sub

    Private Sub ShowError(message As String)
        pnlError.Visible = True
        pnlRoomDetails.Visible = False
        litError.Text = "<i class='fa fa-exclamation-circle mr-2'></i> " & message
    End Sub

End Class
