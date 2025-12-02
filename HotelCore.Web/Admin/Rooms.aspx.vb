Imports HotelCore.BLL
Imports HotelCore.BLL.Models

Public Class Rooms
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' Check admin access
        If Session("UserRoleName") Is Nothing OrElse Session("UserRoleName").ToString() <> "Admin" Then
            Response.Redirect("~/Account/Login.aspx")
            Return
        End If

        If Not IsPostBack Then
            LoadRooms()
        End If
    End Sub

    Protected Sub ddlStatus_SelectedIndexChanged(sender As Object, e As EventArgs)
        LoadRooms()
    End Sub

    Protected Sub ddlFloor_SelectedIndexChanged(sender As Object, e As EventArgs)
        LoadRooms()
    End Sub

    Protected Sub ddlRoomType_SelectedIndexChanged(sender As Object, e As EventArgs)
        LoadRooms()
    End Sub

    Private Sub LoadRooms()
        Try
            ' In a real implementation, these would come from the BLL
            ' For demo, use placeholder data
            Dim rooms As New List(Of Object)
            
            rooms.Add(New With {
                .RoomID = 1,
                .RoomNumber = "101",
                .FloorNumber = 1,
                .TypeName = "Standard Room",
                .Status = "Available",
                .MaxOccupancy = 2,
                .BedConfiguration = "1 Queen",
                .BaseDailyRate = 99.00D
            })
            
            rooms.Add(New With {
                .RoomID = 2,
                .RoomNumber = "102",
                .FloorNumber = 1,
                .TypeName = "Standard Room",
                .Status = "Occupied",
                .MaxOccupancy = 2,
                .BedConfiguration = "1 Queen",
                .BaseDailyRate = 99.00D
            })
            
            rooms.Add(New With {
                .RoomID = 3,
                .RoomNumber = "201",
                .FloorNumber = 2,
                .TypeName = "Deluxe Room",
                .Status = "Available",
                .MaxOccupancy = 3,
                .BedConfiguration = "1 King",
                .BaseDailyRate = 150.00D
            })
            
            rooms.Add(New With {
                .RoomID = 4,
                .RoomNumber = "202",
                .FloorNumber = 2,
                .TypeName = "Deluxe Room",
                .Status = "Cleaning",
                .MaxOccupancy = 3,
                .BedConfiguration = "1 King",
                .BaseDailyRate = 150.00D
            })
            
            rooms.Add(New With {
                .RoomID = 5,
                .RoomNumber = "301",
                .FloorNumber = 3,
                .TypeName = "Executive Suite",
                .Status = "Available",
                .MaxOccupancy = 4,
                .BedConfiguration = "2 Queens",
                .BaseDailyRate = 250.00D
            })
            
            rooms.Add(New With {
                .RoomID = 6,
                .RoomNumber = "401",
                .FloorNumber = 4,
                .TypeName = "Presidential Suite",
                .Status = "Maintenance",
                .MaxOccupancy = 6,
                .BedConfiguration = "3 Kings",
                .BaseDailyRate = 450.00D
            })

            ' Apply filters
            Dim filteredRooms = rooms

            If Not String.IsNullOrEmpty(ddlStatus.SelectedValue) Then
                filteredRooms = filteredRooms.Where(Function(r) r.Status = ddlStatus.SelectedValue).ToList()
            End If

            If Not String.IsNullOrEmpty(ddlFloor.SelectedValue) Then
                Dim floor As Integer = CInt(ddlFloor.SelectedValue)
                filteredRooms = filteredRooms.Where(Function(r) r.FloorNumber = floor).ToList()
            End If

            ' Update stats
            litAvailable.Text = rooms.Count(Function(r) r.Status = "Available").ToString()
            litOccupied.Text = rooms.Count(Function(r) r.Status = "Occupied").ToString()
            litCleaning.Text = rooms.Count(Function(r) r.Status = "Cleaning").ToString()
            litMaintenance.Text = rooms.Count(Function(r) r.Status = "Maintenance").ToString()

            If filteredRooms.Count > 0 Then
                rptRooms.DataSource = filteredRooms
                rptRooms.DataBind()
                pnlNoRooms.Visible = False
            Else
                rptRooms.DataSource = Nothing
                rptRooms.DataBind()
                pnlNoRooms.Visible = True
            End If

        Catch ex As Exception
            ShowError("An error occurred while loading rooms.")
        End Try
    End Sub

    Protected Sub StatusCommand(sender As Object, e As CommandEventArgs)
        Try
            Dim args() As String = e.CommandArgument.ToString().Split("|"c)
            Dim roomID As Integer = CInt(args(0))
            Dim newStatus As String = args(1)
            Dim currentUserID As Integer = CInt(Session("UserID"))

            Dim roomService As New RoomService()
            Dim result = roomService.UpdateRoomStatus(roomID, newStatus, "", currentUserID)

            If result.Success Then
                ShowSuccess("Room status updated successfully!")
            Else
                ShowError(result.ErrorMessage)
            End If

            LoadRooms()

        Catch ex As Exception
            ShowError("An error occurred while updating room status.")
        End Try
    End Sub

    Protected Function GetStatusBadgeClass(status As String) As String
        Select Case status.ToLower()
            Case "available"
                Return "success"
            Case "occupied"
                Return "danger"
            Case "cleaning"
                Return "warning"
            Case "maintenance"
                Return "secondary"
            Case "outoforder"
                Return "dark"
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
