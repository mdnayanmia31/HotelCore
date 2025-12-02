<%@ Page Title="Manage Rooms - HotelCore Admin" Language="vb" AutoEventWireup="false" MasterPageFile="~/Shared/Site.Master" CodeBehind="Rooms.aspx.vb" Inherits="HotelCore.Web.Admin.Rooms" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <!-- Breadcrumb Section -->
    <section class="hotelcore-breadcrumb">
        <div class="container">
            <h1>Manage Rooms</h1>
            <div class="hotelcore-breadcrumb-nav">
                <a href="<%= ResolveUrl("~/Default.aspx") %>">Home</a>
                <span>/</span>
                <a href="<%= ResolveUrl("~/Admin/Dashboard.aspx") %>">Admin</a>
                <span>/</span>
                <span>Rooms</span>
            </div>
        </div>
    </section>
    
    <!-- Rooms Section -->
    <section class="hotelcore-section">
        <div class="container">
            <asp:Panel ID="pnlSuccess" runat="server" CssClass="hotelcore-alert hotelcore-alert-success" Visible="false">
                <asp:Literal ID="litSuccess" runat="server"></asp:Literal>
            </asp:Panel>
            
            <asp:Panel ID="pnlError" runat="server" CssClass="hotelcore-alert hotelcore-alert-error" Visible="false">
                <asp:Literal ID="litError" runat="server"></asp:Literal>
            </asp:Panel>
            
            <!-- Room Stats -->
            <div class="row mb-4">
                <div class="col-lg-3 col-md-6 mb-3">
                    <div class="hotelcore-card text-center">
                        <span class="badge badge-success badge-lg p-2 mb-2">Available</span>
                        <h2 class="mb-0"><asp:Literal ID="litAvailable" runat="server">0</asp:Literal></h2>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 mb-3">
                    <div class="hotelcore-card text-center">
                        <span class="badge badge-danger badge-lg p-2 mb-2">Occupied</span>
                        <h2 class="mb-0"><asp:Literal ID="litOccupied" runat="server">0</asp:Literal></h2>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 mb-3">
                    <div class="hotelcore-card text-center">
                        <span class="badge badge-warning badge-lg p-2 mb-2">Cleaning</span>
                        <h2 class="mb-0"><asp:Literal ID="litCleaning" runat="server">0</asp:Literal></h2>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 mb-3">
                    <div class="hotelcore-card text-center">
                        <span class="badge badge-secondary badge-lg p-2 mb-2">Maintenance</span>
                        <h2 class="mb-0"><asp:Literal ID="litMaintenance" runat="server">0</asp:Literal></h2>
                    </div>
                </div>
            </div>
            
            <!-- Filters -->
            <div class="hotelcore-card mb-4">
                <div class="row">
                    <div class="col-md-3">
                        <div class="form-group">
                            <label>Room Status</label>
                            <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlStatus_SelectedIndexChanged">
                                <asp:ListItem Value="">All Statuses</asp:ListItem>
                                <asp:ListItem Value="Available">Available</asp:ListItem>
                                <asp:ListItem Value="Occupied">Occupied</asp:ListItem>
                                <asp:ListItem Value="Cleaning">Cleaning</asp:ListItem>
                                <asp:ListItem Value="Maintenance">Maintenance</asp:ListItem>
                                <asp:ListItem Value="OutOfOrder">Out of Order</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label>Floor</label>
                            <asp:DropDownList ID="ddlFloor" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlFloor_SelectedIndexChanged">
                                <asp:ListItem Value="">All Floors</asp:ListItem>
                                <asp:ListItem Value="1">Floor 1</asp:ListItem>
                                <asp:ListItem Value="2">Floor 2</asp:ListItem>
                                <asp:ListItem Value="3">Floor 3</asp:ListItem>
                                <asp:ListItem Value="4">Floor 4</asp:ListItem>
                                <asp:ListItem Value="5">Floor 5</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label>Room Type</label>
                            <asp:DropDownList ID="ddlRoomType" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlRoomType_SelectedIndexChanged">
                                <asp:ListItem Value="">All Types</asp:ListItem>
                                <asp:ListItem Value="Standard">Standard</asp:ListItem>
                                <asp:ListItem Value="Deluxe">Deluxe</asp:ListItem>
                                <asp:ListItem Value="Executive">Executive Suite</asp:ListItem>
                                <asp:ListItem Value="Presidential">Presidential Suite</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Rooms Grid -->
            <div class="hotelcore-card">
                <div class="row">
                    <asp:Repeater ID="rptRooms" runat="server">
                        <ItemTemplate>
                            <div class="col-lg-3 col-md-4 col-sm-6 mb-4">
                                <div class="card h-100">
                                    <div class="card-header d-flex justify-content-between align-items-center">
                                        <strong>Room <%# Eval("RoomNumber") %></strong>
                                        <span class="badge badge-<%# GetStatusBadgeClass(Eval("Status").ToString()) %>"><%# Eval("Status") %></span>
                                    </div>
                                    <div class="card-body">
                                        <p class="mb-1"><strong><%# Eval("TypeName") %></strong></p>
                                        <p class="mb-1 small text-muted">Floor <%# Eval("FloorNumber") %></p>
                                        <p class="mb-1 small text-muted">Max <%# Eval("MaxOccupancy") %> guests</p>
                                        <p class="mb-2 small text-muted"><%# Eval("BedConfiguration") %></p>
                                        <p class="mb-0 text-sage"><strong>$<%# Eval("BaseDailyRate", "{0:N2}") %></strong>/night</p>
                                    </div>
                                    <div class="card-footer">
                                        <div class="btn-group btn-group-sm w-100">
                                            <asp:LinkButton ID="lnkSetAvailable" runat="server" CssClass="btn btn-outline-success" CommandName="SetStatus" CommandArgument='<%# Eval("RoomID") & "|Available" %>' OnCommand="StatusCommand" ToolTip="Set Available">
                                                <i class="fa fa-check"></i>
                                            </asp:LinkButton>
                                            <asp:LinkButton ID="lnkSetCleaning" runat="server" CssClass="btn btn-outline-warning" CommandName="SetStatus" CommandArgument='<%# Eval("RoomID") & "|Cleaning" %>' OnCommand="StatusCommand" ToolTip="Set Cleaning">
                                                <i class="fa fa-refresh"></i>
                                            </asp:LinkButton>
                                            <asp:LinkButton ID="lnkSetMaintenance" runat="server" CssClass="btn btn-outline-secondary" CommandName="SetStatus" CommandArgument='<%# Eval("RoomID") & "|Maintenance" %>' OnCommand="StatusCommand" ToolTip="Set Maintenance">
                                                <i class="fa fa-wrench"></i>
                                            </asp:LinkButton>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
                
                <asp:Panel ID="pnlNoRooms" runat="server" Visible="false" CssClass="text-center py-4 text-muted">
                    <i class="fa fa-bed fa-3x mb-3"></i>
                    <p>No rooms found matching your criteria.</p>
                </asp:Panel>
            </div>
        </div>
    </section>
    
</asp:Content>
