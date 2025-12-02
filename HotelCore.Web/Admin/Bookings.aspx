<%@ Page Title="Manage Bookings - HotelCore Admin" Language="vb" AutoEventWireup="false" MasterPageFile="~/Shared/Site.Master" CodeBehind="Bookings.aspx.vb" Inherits="HotelCore.Web.Admin.Bookings" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <!-- Breadcrumb Section -->
    <section class="hotelcore-breadcrumb">
        <div class="container">
            <h1>Manage Bookings</h1>
            <div class="hotelcore-breadcrumb-nav">
                <a href="<%= ResolveUrl("~/Default.aspx") %>">Home</a>
                <span>/</span>
                <a href="<%= ResolveUrl("~/Admin/Dashboard.aspx") %>">Admin</a>
                <span>/</span>
                <span>Bookings</span>
            </div>
        </div>
    </section>
    
    <!-- Bookings Section -->
    <section class="hotelcore-section">
        <div class="container">
            <asp:Panel ID="pnlSuccess" runat="server" CssClass="hotelcore-alert hotelcore-alert-success" Visible="false">
                <asp:Literal ID="litSuccess" runat="server"></asp:Literal>
            </asp:Panel>
            
            <asp:Panel ID="pnlError" runat="server" CssClass="hotelcore-alert hotelcore-alert-error" Visible="false">
                <asp:Literal ID="litError" runat="server"></asp:Literal>
            </asp:Panel>
            
            <!-- Filters -->
            <div class="hotelcore-card mb-4">
                <div class="row">
                    <div class="col-md-3">
                        <div class="form-group">
                            <label>Search Reference / Guest</label>
                            <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search..."></asp:TextBox>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="form-group">
                            <label>Status</label>
                            <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control">
                                <asp:ListItem Value="">All Statuses</asp:ListItem>
                                <asp:ListItem Value="Pending">Pending</asp:ListItem>
                                <asp:ListItem Value="Confirmed">Confirmed</asp:ListItem>
                                <asp:ListItem Value="CheckedIn">Checked In</asp:ListItem>
                                <asp:ListItem Value="CheckedOut">Checked Out</asp:ListItem>
                                <asp:ListItem Value="Cancelled">Cancelled</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="form-group">
                            <label>From Date</label>
                            <asp:TextBox ID="txtFromDate" runat="server" CssClass="form-control datepicker" placeholder="From"></asp:TextBox>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="form-group">
                            <label>To Date</label>
                            <asp:TextBox ID="txtToDate" runat="server" CssClass="form-control datepicker" placeholder="To"></asp:TextBox>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label>&nbsp;</label>
                            <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn-hotelcore btn-hotelcore-primary w-100" OnClick="btnSearch_Click" />
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Bookings Table -->
            <div class="hotelcore-card">
                <div class="table-responsive">
                    <asp:Panel ID="pnlNoResults" runat="server" Visible="false" CssClass="text-center py-4 text-muted">
                        <i class="fa fa-calendar-o fa-3x mb-3"></i>
                        <p>No bookings found matching your criteria.</p>
                    </asp:Panel>
                    
                    <asp:Repeater ID="rptBookings" runat="server">
                        <HeaderTemplate>
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Reference</th>
                                        <th>Room</th>
                                        <th>Check-In</th>
                                        <th>Check-Out</th>
                                        <th>Guests</th>
                                        <th>Total</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td><strong><%# Eval("BookingReference") %></strong></td>
                                <td><%# Eval("RoomNumber") %><br /><small class="text-muted"><%# Eval("RoomType") %></small></td>
                                <td><%# CDate(Eval("StartDateTime")).ToShortDateString() %></td>
                                <td><%# CDate(Eval("EndDateTime")).ToShortDateString() %></td>
                                <td><%# Eval("GuestCount") %></td>
                                <td>$<%# Eval("TotalAmount", "{0:N2}") %></td>
                                <td><span class="badge badge-<%# GetStatusBadgeClass(Eval("Status").ToString()) %>"><%# Eval("Status") %></span></td>
                                <td>
                                    <div class="btn-group btn-group-sm">
                                        <asp:LinkButton ID="lnkCheckIn" runat="server" CssClass='<%# If(Eval("Status").ToString() = "Confirmed", "btn btn-success", "btn btn-success disabled") %>' CommandName="CheckIn" CommandArgument='<%# Eval("BookingID") %>' OnCommand="BookingCommand" ToolTip="Check In" Enabled='<%# Eval("Status").ToString() = "Confirmed" %>'>
                                            <i class="fa fa-sign-in"></i>
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="lnkCheckOut" runat="server" CssClass='<%# If(Eval("Status").ToString() = "CheckedIn", "btn btn-info", "btn btn-info disabled") %>' CommandName="CheckOut" CommandArgument='<%# Eval("BookingID") %>' OnCommand="BookingCommand" ToolTip="Check Out" Enabled='<%# Eval("Status").ToString() = "CheckedIn" %>'>
                                            <i class="fa fa-sign-out"></i>
                                        </asp:LinkButton>
                                        <a href='<%# ResolveUrl("~/Account/BookingDetails.aspx?id=" & Eval("BookingID")) %>' class="btn btn-outline-secondary" title="View Details">
                                            <i class="fa fa-eye"></i>
                                        </a>
                                    </div>
                                </td>
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
    </section>
    
</asp:Content>
