Imports HotelCore.BLL
Imports HotelCore.BLL.Models

Public Class Search
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ' Check for query string parameters from home page
            If Not String.IsNullOrEmpty(Request.QueryString("checkin")) Then
                txtCheckIn.Text = Server.UrlDecode(Request.QueryString("checkin"))
            End If
            If Not String.IsNullOrEmpty(Request.QueryString("checkout")) Then
                txtCheckOut.Text = Server.UrlDecode(Request.QueryString("checkout"))
            End If
            If Not String.IsNullOrEmpty(Request.QueryString("guests")) Then
                ddlGuests.SelectedValue = Request.QueryString("guests")
            End If
            
            ' If parameters were passed, perform search automatically
            If Not String.IsNullOrEmpty(txtCheckIn.Text) AndAlso Not String.IsNullOrEmpty(txtCheckOut.Text) Then
                PerformSearch()
            End If
        End If
    End Sub

    Protected Sub btnSearch_Click(sender As Object, e As EventArgs)
        PerformSearch()
    End Sub

    Private Sub PerformSearch()
        Try
            ' Hide default rooms panel
            pnlDefaultRooms.Visible = False
            pnlNoResults.Visible = False
            pnlError.Visible = False
            
            ' Validate dates
            Dim checkIn As DateTime
            Dim checkOut As DateTime
            
            If Not DateTime.TryParse(txtCheckIn.Text, checkIn) Then
                ShowError("Please enter a valid check-in date.")
                Return
            End If
            
            If Not DateTime.TryParse(txtCheckOut.Text, checkOut) Then
                ShowError("Please enter a valid check-out date.")
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
            
            ' Build search criteria
            Dim criteria As New RoomSearchCriteria With {
                .StartDateTime = checkIn,
                .EndDateTime = checkOut,
                .MinOccupancy = CInt(ddlGuests.SelectedValue)
            }
            
            ' Add room type filter if selected
            If Not String.IsNullOrEmpty(ddlRoomType.SelectedValue) Then
                criteria.ConfigID = CInt(ddlRoomType.SelectedValue)
            End If
            
            ' Add max price filter if selected
            If Not String.IsNullOrEmpty(ddlMaxPrice.SelectedValue) Then
                criteria.MaxPrice = CDec(ddlMaxPrice.SelectedValue)
            End If
            
            ' Get current user ID (0 for anonymous)
            Dim currentUserID As Integer = 0
            If Session("UserID") IsNot Nothing Then
                currentUserID = CInt(Session("UserID"))
            End If
            
            ' Call BLL to search rooms
            Dim bookingService As New BookingService()
            Dim result = bookingService.SearchAvailableRooms(criteria, currentUserID)
            
            If result.Success Then
                If result.Data IsNot Nothing AndAlso result.Data.Count > 0 Then
                    rptRooms.DataSource = result.Data
                    rptRooms.DataBind()
                Else
                    pnlNoResults.Visible = True
                End If
            Else
                ShowError(result.ErrorMessage)
            End If
            
        Catch ex As Exception
            ShowError("An error occurred while searching for rooms. Please try again.")
        End Try
    End Sub

    Private Sub ShowError(message As String)
        pnlError.Visible = True
        litError.Text = "<i class='fa fa-exclamation-circle mr-2'></i> " & message
    End Sub

End Class
