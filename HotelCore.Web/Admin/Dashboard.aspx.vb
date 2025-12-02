Public Class Dashboard
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' Check admin access
        If Session("UserRoleName") Is Nothing OrElse Session("UserRoleName").ToString() <> "Admin" Then
            Response.Redirect("~/Account/Login.aspx")
            Return
        End If

        If Not IsPostBack Then
            LoadDashboardData()
        End If
    End Sub

    Private Sub LoadDashboardData()
        Try
            ' NOTE: These are placeholder values for demonstration purposes.
            ' In a production environment, replace these with actual BLL service calls:
            ' - BookingService.GetBookingStatistics()
            ' - RoomService.GetRoomStatusSummary()
            ' - PaymentService.GetRevenueReport()
            litTotalBookings.Text = "156"
            litActiveBookings.Text = "24"
            litOccupancy.Text = "72%"
            litRevenue.Text = "45,890"

            litTodayCheckIns.Text = "8"
            litTodayCheckOuts.Text = "5"
            litTodayNewBookings.Text = "3"
            litTodayCancellations.Text = "1"

            litRoomsAvailable.Text = "18"
            litRoomsOccupied.Text = "42"
            litRoomsCleaning.Text = "3"
            litRoomsMaintenance.Text = "2"

            ' Load recent bookings (placeholder data)
            ' In real implementation, call BookingService
            Dim recentBookings As New List(Of Object)
            recentBookings.Add(New With {
                .BookingID = 1,
                .BookingReference = "HC-2024-001",
                .RoomNumber = "101",
                .StartDateTime = DateTime.Now.AddDays(1),
                .Status = "Confirmed"
            })
            recentBookings.Add(New With {
                .BookingID = 2,
                .BookingReference = "HC-2024-002",
                .RoomNumber = "205",
                .StartDateTime = DateTime.Now.AddDays(2),
                .Status = "Pending"
            })
            recentBookings.Add(New With {
                .BookingID = 3,
                .BookingReference = "HC-2024-003",
                .RoomNumber = "302",
                .StartDateTime = DateTime.Now,
                .Status = "CheckedIn"
            })

            If recentBookings.Count > 0 Then
                rptRecentBookings.DataSource = recentBookings
                rptRecentBookings.DataBind()
            Else
                pnlNoBookings.Visible = True
            End If

        Catch ex As Exception
            ' Handle error
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

End Class
