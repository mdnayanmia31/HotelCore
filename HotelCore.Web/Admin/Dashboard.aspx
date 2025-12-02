<%@ Page Title="Admin Dashboard - HotelCore" Language="vb" AutoEventWireup="false" MasterPageFile="~/Shared/Site.Master" CodeBehind="Dashboard.aspx.vb" Inherits="HotelCore.Web.Admin.Dashboard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <!-- Breadcrumb Section -->
    <section class="hotelcore-breadcrumb">
        <div class="container">
            <h1>Admin Dashboard</h1>
            <div class="hotelcore-breadcrumb-nav">
                <a href="<%= ResolveUrl("~/Default.aspx") %>">Home</a>
                <span>/</span>
                <span>Admin</span>
            </div>
        </div>
    </section>
    
    <!-- Dashboard Section -->
    <section class="hotelcore-section">
        <div class="container">
            <!-- Stats Cards -->
            <div class="row mb-4">
                <div class="col-lg-3 col-md-6 mb-3">
                    <div class="hotelcore-card text-center bg-sage text-cream">
                        <i class="fa fa-calendar fa-2x mb-2"></i>
                        <h2 class="mb-0"><asp:Literal ID="litTotalBookings" runat="server">0</asp:Literal></h2>
                        <p class="mb-0">Total Bookings</p>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 mb-3">
                    <div class="hotelcore-card text-center">
                        <i class="fa fa-check-circle fa-2x text-sage mb-2"></i>
                        <h2 class="mb-0 text-sage"><asp:Literal ID="litActiveBookings" runat="server">0</asp:Literal></h2>
                        <p class="mb-0">Active Bookings</p>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 mb-3">
                    <div class="hotelcore-card text-center">
                        <i class="fa fa-bed fa-2x text-sage mb-2"></i>
                        <h2 class="mb-0 text-sage"><asp:Literal ID="litOccupancy" runat="server">0%</asp:Literal></h2>
                        <p class="mb-0">Occupancy Rate</p>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 mb-3">
                    <div class="hotelcore-card text-center">
                        <i class="fa fa-usd fa-2x text-sage mb-2"></i>
                        <h2 class="mb-0 text-sage">$<asp:Literal ID="litRevenue" runat="server">0</asp:Literal></h2>
                        <p class="mb-0">This Month</p>
                    </div>
                </div>
            </div>
            
            <!-- Quick Actions -->
            <div class="row mb-4">
                <div class="col-12">
                    <div class="hotelcore-card">
                        <h4 class="mb-3">Quick Actions</h4>
                        <a href="<%= ResolveUrl("~/Admin/Bookings.aspx") %>" class="btn-hotelcore btn-hotelcore-primary mr-2 mb-2">
                            <i class="fa fa-calendar mr-2"></i> Manage Bookings
                        </a>
                        <a href="<%= ResolveUrl("~/Admin/Rooms.aspx") %>" class="btn-hotelcore btn-hotelcore-outline mr-2 mb-2">
                            <i class="fa fa-bed mr-2"></i> Manage Rooms
                        </a>
                        <a href="<%= ResolveUrl("~/Booking/Search.aspx") %>" class="btn-hotelcore btn-hotelcore-outline mb-2">
                            <i class="fa fa-plus mr-2"></i> New Booking
                        </a>
                    </div>
                </div>
            </div>
            
            <div class="row">
                <!-- Recent Bookings -->
                <div class="col-lg-8">
                    <div class="hotelcore-card">
                        <div class="hotelcore-card-header d-flex justify-content-between align-items-center">
                            <h4>Recent Bookings</h4>
                            <a href="<%= ResolveUrl("~/Admin/Bookings.aspx") %>" class="small">View All</a>
                        </div>
                        
                        <asp:Panel ID="pnlNoBookings" runat="server" Visible="false" CssClass="text-center py-4 text-muted">
                            <i class="fa fa-calendar-o fa-3x mb-3"></i>
                            <p>No recent bookings found.</p>
                        </asp:Panel>
                        
                        <div class="table-responsive">
                            <asp:Repeater ID="rptRecentBookings" runat="server">
                                <HeaderTemplate>
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>Reference</th>
                                                <th>Guest</th>
                                                <th>Room</th>
                                                <th>Check-In</th>
                                                <th>Status</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td><strong><%# Eval("BookingReference") %></strong></td>
                                        <td>Guest</td>
                                        <td><%# Eval("RoomNumber") %></td>
                                        <td><%# CDate(Eval("StartDateTime")).ToShortDateString() %></td>
                                        <td><span class="badge badge-<%# GetStatusBadgeClass(Eval("Status").ToString()) %>"><%# Eval("Status") %></span></td>
                                        <td><a href='<%# ResolveUrl("~/Admin/Bookings.aspx?id=" & Eval("BookingID")) %>' class="btn btn-sm btn-outline-secondary">View</a></td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate>
                                        </tbody>
                                    </table>
                                </FooterTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                </div>
                
                <!-- Today's Activity -->
                <div class="col-lg-4">
                    <div class="hotelcore-card">
                        <div class="hotelcore-card-header">
                            <h4>Today's Activity</h4>
                        </div>
                        <ul class="list-unstyled mb-0">
                            <li class="d-flex justify-content-between py-2 border-bottom">
                                <span><i class="fa fa-sign-in text-success mr-2"></i> Check-Ins</span>
                                <strong><asp:Literal ID="litTodayCheckIns" runat="server">0</asp:Literal></strong>
                            </li>
                            <li class="d-flex justify-content-between py-2 border-bottom">
                                <span><i class="fa fa-sign-out text-info mr-2"></i> Check-Outs</span>
                                <strong><asp:Literal ID="litTodayCheckOuts" runat="server">0</asp:Literal></strong>
                            </li>
                            <li class="d-flex justify-content-between py-2 border-bottom">
                                <span><i class="fa fa-calendar-plus-o text-primary mr-2"></i> New Bookings</span>
                                <strong><asp:Literal ID="litTodayNewBookings" runat="server">0</asp:Literal></strong>
                            </li>
                            <li class="d-flex justify-content-between py-2">
                                <span><i class="fa fa-times text-danger mr-2"></i> Cancellations</span>
                                <strong><asp:Literal ID="litTodayCancellations" runat="server">0</asp:Literal></strong>
                            </li>
                        </ul>
                    </div>
                    
                    <!-- Room Status Summary -->
                    <div class="hotelcore-card mt-3">
                        <div class="hotelcore-card-header">
                            <h4>Room Status</h4>
                        </div>
                        <ul class="list-unstyled mb-0">
                            <li class="d-flex justify-content-between py-2 border-bottom">
                                <span><span class="badge badge-success">Available</span></span>
                                <strong><asp:Literal ID="litRoomsAvailable" runat="server">0</asp:Literal></strong>
                            </li>
                            <li class="d-flex justify-content-between py-2 border-bottom">
                                <span><span class="badge badge-danger">Occupied</span></span>
                                <strong><asp:Literal ID="litRoomsOccupied" runat="server">0</asp:Literal></strong>
                            </li>
                            <li class="d-flex justify-content-between py-2 border-bottom">
                                <span><span class="badge badge-warning">Cleaning</span></span>
                                <strong><asp:Literal ID="litRoomsCleaning" runat="server">0</asp:Literal></strong>
                            </li>
                            <li class="d-flex justify-content-between py-2">
                                <span><span class="badge badge-secondary">Maintenance</span></span>
                                <strong><asp:Literal ID="litRoomsMaintenance" runat="server">0</asp:Literal></strong>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
</asp:Content>
