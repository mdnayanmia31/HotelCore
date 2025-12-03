Imports HotelCore.BLL

Namespace Admin
    Public Class Bookings
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
            If Session("UserRoleName") Is Nothing OrElse Session("UserRoleName").ToString() <> "Admin" Then
                Response.Redirect("~/Account/Login.aspx")
                Return
            End If

            If Not IsPostBack Then
                LoadBookings()
            End If
        End Sub

        Protected Sub btnSearch_Click(sender As Object, e As EventArgs)
            LoadBookings()
        End Sub

        Private Sub LoadBookings()
            Try
                Dim bookings As New List(Of Object)
                
                bookings.Add(New With {
                    .BookingID = 1,
                    .BookingReference = "HC-2024-001",
                    .RoomNumber = "101",
                    .RoomType = "Deluxe Room",
                    .StartDateTime = DateTime.Now.AddDays(1),
                    .EndDateTime = DateTime.Now.AddDays(3),
                    .GuestCount = 2,
                    .TotalAmount = 450.00D,
                    .Status = "Confirmed"
                })
                
                bookings.Add(New With {
                    .BookingID = 2,
                    .BookingReference = "HC-2024-002",
                    .RoomNumber = "205",
                    .RoomType = "Executive Suite",
                    .StartDateTime = DateTime.Now.AddDays(2),
                    .EndDateTime = DateTime.Now.AddDays(5),
                    .GuestCount = 4,
                    .TotalAmount = 1200.00D,
                    .Status = "Pending"
                })
                
                bookings.Add(New With {
                    .BookingID = 3,
                    .BookingReference = "HC-2024-003",
                    .RoomNumber = "302",
                    .RoomType = "Standard Room",
                    .StartDateTime = DateTime.Now.AddDays(-1),
                    .EndDateTime = DateTime.Now.AddDays(2),
                    .GuestCount = 1,
                    .TotalAmount = 297.00D,
                    .Status = "CheckedIn"
                })
                
                bookings.Add(New With {
                    .BookingID = 4,
                    .BookingReference = "HC-2024-004",
                    .RoomNumber = "401",
                    .RoomType = "Presidential Suite",
                    .StartDateTime = DateTime.Now.AddDays(-5),
                    .EndDateTime = DateTime.Now.AddDays(-2),
                    .GuestCount = 3,
                    .TotalAmount = 1500.00D,
                    .Status = "CheckedOut"
                })

                Dim filteredBookings = bookings

                If Not String.IsNullOrEmpty(ddlStatus.SelectedValue) Then
                    filteredBookings = filteredBookings.Where(Function(b) b.Status = ddlStatus.SelectedValue).ToList()
                End If

                If filteredBookings.Count > 0 Then
                    rptBookings.DataSource = filteredBookings
                    rptBookings.DataBind()
                    pnlNoResults.Visible = False
                Else
                    rptBookings.DataSource = Nothing
                    rptBookings.DataBind()
                    pnlNoResults.Visible = True
                End If

            Catch ex As Exception
                ShowError("An error occurred while loading bookings.")
            End Try
        End Sub

        Protected Sub BookingCommand(sender As Object, e As CommandEventArgs)
            Try
                Dim bookingID As Integer = CInt(e.CommandArgument)
                Dim currentUserID As Integer = CInt(Session("UserID"))
                Dim bookingService As New BookingService()

                Select Case e.CommandName
                    Case "CheckIn"
                        Dim result = bookingService.CheckInBooking(bookingID, currentUserID)
                        If result.Success Then
                            ShowSuccess("Guest checked in successfully!")
                        Else
                            ShowError(result.ErrorMessage)
                        End If

                    Case "CheckOut"
                        Dim result = bookingService.CheckOutBooking(bookingID, currentUserID)
                        If result.Success Then
                            ShowSuccess("Guest checked out successfully!")
                        Else
                            ShowError(result.ErrorMessage)
                        End If
                End Select

                LoadBookings()

            Catch ex As Exception
                ShowError("An error occurred while processing the action.")
            End Try
        End Sub

        Protected Function GetStatusBadgeClass(status As String) As String
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
End Namespace
