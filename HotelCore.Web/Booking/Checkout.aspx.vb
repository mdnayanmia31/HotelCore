Imports HotelCore.BLL

Public Class Checkout
    Inherits System.Web.UI.Page

    Private _roomID As Integer = 0
    Private _checkIn As DateTime
    Private _checkOut As DateTime
    Private _guestCount As Integer = 1

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' Ensure user is logged in
        If Session("UserID") Is Nothing Then
            Response.Redirect("~/Account/Login.aspx?returnUrl=" & Server.UrlEncode(Request.RawUrl))
            Return
        End If

        If Not IsPostBack Then
            LoadBookingDetails()
            PopulateExpiryYears()
            PopulateUserInfo()
        End If
    End Sub

    Private Sub LoadBookingDetails()
        Try
            ' Try to get from query string first
            If Not String.IsNullOrEmpty(Request.QueryString("roomId")) Then
                _roomID = CInt(Request.QueryString("roomId"))
                DateTime.TryParse(Server.UrlDecode(Request.QueryString("checkIn")), _checkIn)
                DateTime.TryParse(Server.UrlDecode(Request.QueryString("checkOut")), _checkOut)
                Integer.TryParse(Request.QueryString("guests"), _guestCount)
            ElseIf Session("PendingBooking_RoomID") IsNot Nothing Then
                ' Try session (from login redirect)
                _roomID = CInt(Session("PendingBooking_RoomID"))
                _checkIn = CDate(Session("PendingBooking_CheckIn"))
                _checkOut = CDate(Session("PendingBooking_CheckOut"))
                _guestCount = CInt(Session("PendingBooking_Guests"))
                
                ' Clear session after use
                Session.Remove("PendingBooking_RoomID")
                Session.Remove("PendingBooking_CheckIn")
                Session.Remove("PendingBooking_CheckOut")
                Session.Remove("PendingBooking_Guests")
            Else
                ShowError("No booking information found. Please start from room selection.")
                Return
            End If

            ' Validate dates
            If _checkIn = DateTime.MinValue OrElse _checkOut = DateTime.MinValue Then
                ShowError("Invalid booking dates.")
                Return
            End If

            ' Store in ViewState
            ViewState("RoomID") = _roomID
            ViewState("CheckIn") = _checkIn
            ViewState("CheckOut") = _checkOut
            ViewState("GuestCount") = _guestCount

            ' Load room details
            Dim roomService As New RoomService()
            Dim result = roomService.GetRoomById(_roomID)

            If result.Success AndAlso result.Data IsNot Nothing Then
                Dim room = result.Data
                
                litRoomType.Text = room.TypeName
                litRoomNumber.Text = room.RoomNumber
                litCheckIn.Text = _checkIn.ToShortDateString()
                litCheckOut.Text = _checkOut.ToShortDateString()
                litGuests.Text = _guestCount.ToString()

                Dim nights As Integer = CInt(Math.Ceiling((_checkOut - _checkIn).TotalDays))
                litNights.Text = nights.ToString()
                litDailyRate.Text = room.BaseDailyRate.ToString("N2")

                Dim subtotal As Decimal = room.BaseDailyRate * nights
                Dim tax As Decimal = subtotal * 0.1D
                Dim total As Decimal = subtotal + tax

                litSubtotal.Text = subtotal.ToString("N2")
                litTax.Text = tax.ToString("N2")
                litTotal.Text = total.ToString("N2")

                ViewState("DailyRate") = room.BaseDailyRate
                ViewState("Total") = total

                ' Setup additional guests
                If _guestCount > 1 Then
                    pnlAdditionalGuests.Visible = True
                    Dim additionalGuestCount As Integer = _guestCount - 1
                    Dim guestList As New List(Of Integer)
                    For i As Integer = 1 To additionalGuestCount
                        guestList.Add(i)
                    Next
                    rptAdditionalGuests.DataSource = guestList
                    rptAdditionalGuests.DataBind()
                End If
            Else
                ShowError("Room not found.")
            End If

        Catch ex As Exception
            ShowError("An error occurred while loading booking details.")
        End Try
    End Sub

    Private Sub PopulateExpiryYears()
        ddlExpiryYear.Items.Clear()
        Dim currentYear As Integer = DateTime.Now.Year
        For i As Integer = currentYear To currentYear + 10
            ddlExpiryYear.Items.Add(New ListItem(i.ToString(), i.ToString()))
        Next
    End Sub

    Private Sub PopulateUserInfo()
        ' Pre-fill with logged-in user info if available
        If Session("UserEmail") IsNot Nothing Then
            txtEmail.Text = Session("UserEmail").ToString()
        End If
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

    Protected Sub btnCompleteBooking_Click(sender As Object, e As EventArgs)
        Try
            ' Validate terms acceptance
            If Not chkTerms.Checked Then
                ShowError("Please accept the Terms and Conditions to continue.")
                Return
            End If

            ' Get values from ViewState
            Dim roomID As Integer = CInt(ViewState("RoomID"))
            Dim checkIn As DateTime = CDate(ViewState("CheckIn"))
            Dim checkOut As DateTime = CDate(ViewState("CheckOut"))
            Dim guestCount As Integer = CInt(ViewState("GuestCount"))
            Dim userID As Integer = CInt(Session("UserID"))

            ' Build booking model
            Dim booking As New BookingModel With {
                .UserID = userID,
                .RoomID = roomID,
                .StartDateTime = checkIn,
                .EndDateTime = checkOut,
                .GuestCount = guestCount,
                .AdultCount = guestCount, ' Simplified - assume all adults
                .ChildCount = 0,
                .InfantCount = 0,
                .SpecialRequests = txtSpecialRequests.Text.Trim()
            }

            ' Add additional guests
            If guestCount > 1 Then
                booking.Guests = New List(Of GuestModel)()
                For Each item As RepeaterItem In rptAdditionalGuests.Items
                    Dim txtName As TextBox = CType(item.FindControl("txtGuestName"), TextBox)
                    Dim ddlAge As DropDownList = CType(item.FindControl("ddlAgeCategory"), DropDownList)
                    Dim txtGuestEmail As TextBox = CType(item.FindControl("txtGuestEmail"), TextBox)

                    If txtName IsNot Nothing AndAlso Not String.IsNullOrEmpty(txtName.Text) Then
                        booking.Guests.Add(New GuestModel With {
                            .FullName = txtName.Text.Trim(),
                            .AgeCategory = ddlAge.SelectedValue,
                            .Email = If(txtGuestEmail IsNot Nothing, txtGuestEmail.Text.Trim(), ""),
                            .GuestType = "Additional"
                        })

                        ' Update counts based on age category
                        Select Case ddlAge.SelectedValue
                            Case "Child"
                                booking.ChildCount += 1
                                booking.AdultCount -= 1
                            Case "Infant"
                                booking.InfantCount += 1
                                booking.AdultCount -= 1
                        End Select
                    End If
                Next
            End If

            ' Create booking
            Dim bookingService As New BookingService()
            Dim result = bookingService.CreateBooking(booking, userID)

            If result.Success AndAlso result.Data IsNot Nothing Then
                ' Process payment if not Pay at Hotel
                If ddlPaymentMethod.SelectedValue <> "PayAtHotel" Then
                    Dim paymentService As New PaymentService()
                    Dim totalAmount As Decimal = CDec(ViewState("Total"))
                    
                    ' NOTE: This is a simulated payment for demonstration purposes.
                    ' In production, integrate with actual payment processors (Stripe, PayPal, etc.)
                    ' and implement proper payment validation, PCI compliance, and security measures.
                    Dim payment As New PaymentModel With {
                        .BookingID = result.Data.BookingID,
                        .PaymentMethod = ddlPaymentMethod.SelectedValue,
                        .Amount = totalAmount,
                        .ProcessorTransactionID = Guid.NewGuid().ToString() ' Simulated transaction ID for demo
                    }
                    
                    Dim paymentResult = paymentService.ProcessPayment(payment, userID)
                    ' In production: Handle payment failures, refunds, and provide appropriate user feedback
                End If

                ' Redirect to confirmation
                Response.Redirect("~/Booking/Confirmation.aspx?id=" & result.Data.BookingID)
            Else
                ShowError(If(String.IsNullOrEmpty(result.ErrorMessage), "An error occurred while creating the booking.", result.ErrorMessage))
            End If

        Catch ex As Exception
            ShowError("An error occurred while processing your booking. Please try again.")
        End Try
    End Sub

    Private Sub ShowError(message As String)
        pnlError.Visible = True
        litError.Text = "<i class='fa fa-exclamation-circle mr-2'></i> " & message
    End Sub

End Class
