<%@ Page Title="Booking Details - HotelCore" Language="vb" AutoEventWireup="false" MasterPageFile="~/Shared/Site.Master" CodeBehind="BookingDetails.aspx.vb" Inherits="HotelCore.Web.Account.BookingDetails" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <!-- Breadcrumb Section -->
    <section class="hotelcore-breadcrumb">
        <div class="container">
            <h1>Booking Details</h1>
            <div class="hotelcore-breadcrumb-nav">
                <a href="<%= ResolveUrl("~/Default.aspx") %>">Home</a>
                <span>/</span>
                <a href="<%= ResolveUrl("~/Account/Profile.aspx?tab=bookings") %>">My Bookings</a>
                <span>/</span>
                <span>Details</span>
            </div>
        </div>
    </section>
    
    <!-- Booking Details Section -->
    <section class="hotelcore-section">
        <div class="container">
            <asp:Panel ID="pnlError" runat="server" CssClass="hotelcore-alert hotelcore-alert-error" Visible="false">
                <asp:Literal ID="litError" runat="server"></asp:Literal>
            </asp:Panel>
            
            <asp:Panel ID="pnlSuccess" runat="server" CssClass="hotelcore-alert hotelcore-alert-success" Visible="false">
                <asp:Literal ID="litSuccess" runat="server"></asp:Literal>
            </asp:Panel>
            
            <asp:Panel ID="pnlBookingDetails" runat="server">
                <div class="row">
                    <div class="col-lg-8">
                        <!-- Booking Information -->
                        <div class="hotelcore-card">
                            <div class="hotelcore-card-header d-flex justify-content-between align-items-center">
                                <h4>Booking Information</h4>
                                <span class="badge badge-<%# GetStatusBadgeClass() %> badge-lg p-2"><asp:Literal ID="litStatus" runat="server"></asp:Literal></span>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <table class="w-100">
                                        <tr>
                                            <td class="py-2 text-muted">Booking Reference:</td>
                                            <td class="py-2 text-right"><strong><asp:Literal ID="litBookingRef" runat="server"></asp:Literal></strong></td>
                                        </tr>
                                        <tr>
                                            <td class="py-2 text-muted">Room Type:</td>
                                            <td class="py-2 text-right"><asp:Literal ID="litRoomType" runat="server"></asp:Literal></td>
                                        </tr>
                                        <tr>
                                            <td class="py-2 text-muted">Room Number:</td>
                                            <td class="py-2 text-right"><asp:Literal ID="litRoomNumber" runat="server"></asp:Literal></td>
                                        </tr>
                                        <tr>
                                            <td class="py-2 text-muted">Booking Date:</td>
                                            <td class="py-2 text-right"><asp:Literal ID="litBookingDate" runat="server"></asp:Literal></td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="col-md-6">
                                    <table class="w-100">
                                        <tr>
                                            <td class="py-2 text-muted">Check-In:</td>
                                            <td class="py-2 text-right"><asp:Literal ID="litCheckIn" runat="server"></asp:Literal></td>
                                        </tr>
                                        <tr>
                                            <td class="py-2 text-muted">Check-Out:</td>
                                            <td class="py-2 text-right"><asp:Literal ID="litCheckOut" runat="server"></asp:Literal></td>
                                        </tr>
                                        <tr>
                                            <td class="py-2 text-muted">Number of Guests:</td>
                                            <td class="py-2 text-right"><asp:Literal ID="litGuests" runat="server"></asp:Literal></td>
                                        </tr>
                                        <tr>
                                            <td class="py-2 text-muted">Total Amount:</td>
                                            <td class="py-2 text-right text-sage"><strong>$<asp:Literal ID="litTotal" runat="server"></asp:Literal></strong></td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Guest List -->
                        <asp:Panel ID="pnlGuests" runat="server" Visible="false">
                            <div class="hotelcore-card mt-4">
                                <div class="hotelcore-card-header">
                                    <h4>Guest List</h4>
                                </div>
                                <asp:Repeater ID="rptGuests" runat="server">
                                    <ItemTemplate>
                                        <div class="d-flex justify-content-between py-2 border-bottom">
                                            <div>
                                                <strong><%# Eval("FullName") %></strong>
                                                <span class="text-muted ml-2">(<%# Eval("GuestType") %>)</span>
                                            </div>
                                            <div>
                                                <span class="badge badge-secondary"><%# Eval("AgeCategory") %></span>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </asp:Panel>
                        
                        <!-- Payment History -->
                        <asp:Panel ID="pnlPayments" runat="server" Visible="false">
                            <div class="hotelcore-card mt-4">
                                <div class="hotelcore-card-header">
                                    <h4>Payment History</h4>
                                </div>
                                <asp:Repeater ID="rptPayments" runat="server">
                                    <ItemTemplate>
                                        <div class="d-flex justify-content-between py-2 border-bottom">
                                            <div>
                                                <strong>$<%# Eval("Amount", "{0:N2}") %></strong>
                                                <span class="text-muted ml-2">via <%# Eval("PaymentMethod") %></span>
                                            </div>
                                            <div>
                                                <span class="badge badge-success"><%# Eval("Status") %></span>
                                                <small class="text-muted ml-2"><%# CDate(Eval("PaymentDate")).ToShortDateString() %></small>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </asp:Panel>
                    </div>
                    
                    <!-- Sidebar Actions -->
                    <div class="col-lg-4">
                        <div class="hotelcore-card">
                            <h5>Actions</h5>
                            <asp:Panel ID="pnlCanCancel" runat="server">
                                <p class="text-muted small">You can cancel this booking up to 24 hours before check-in.</p>
                                <asp:Button ID="btnCancelBooking" runat="server" Text="Cancel Booking" CssClass="btn btn-outline-danger w-100 mb-2" OnClick="btnCancelBooking_Click" OnClientClick="return confirm('Are you sure you want to cancel this booking?');" />
                            </asp:Panel>
                            <a href="<%= ResolveUrl("~/Account/Profile.aspx?tab=bookings") %>" class="btn btn-outline-secondary w-100">Back to My Bookings</a>
                        </div>
                        
                        <!-- Cancellation Info -->
                        <asp:Panel ID="pnlCancellationInfo" runat="server" Visible="false">
                            <div class="hotelcore-card mt-3 bg-light">
                                <h5 class="text-danger">Booking Cancelled</h5>
                                <p class="text-muted small mb-1"><strong>Cancelled On:</strong> <asp:Literal ID="litCancelledDate" runat="server"></asp:Literal></p>
                                <p class="text-muted small mb-0"><strong>Reason:</strong> <asp:Literal ID="litCancellationReason" runat="server"></asp:Literal></p>
                            </div>
                        </asp:Panel>
                        
                        <!-- Contact Support -->
                        <div class="hotelcore-card mt-3">
                            <h5>Need Help?</h5>
                            <p class="text-muted small">Contact our support team for any questions about your booking.</p>
                            <p class="mb-1"><i class="fa fa-phone text-sage mr-2"></i> +1 234 567 8900</p>
                            <p class="mb-0"><i class="fa fa-envelope text-sage mr-2"></i> support@hotelcore.com</p>
                        </div>
                    </div>
                </div>
            </asp:Panel>
            
            <!-- Cancel Booking Modal Content -->
            <asp:Panel ID="pnlCancelForm" runat="server" Visible="false">
                <div class="hotelcore-card">
                    <div class="hotelcore-card-header">
                        <h4>Cancel Booking</h4>
                    </div>
                    <p>Please provide a reason for cancellation:</p>
                    <div class="form-group">
                        <asp:TextBox ID="txtCancellationReason" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" placeholder="Enter cancellation reason (minimum 10 characters)"></asp:TextBox>
                    </div>
                    <asp:Button ID="btnConfirmCancel" runat="server" Text="Confirm Cancellation" CssClass="btn-hotelcore btn-hotelcore-primary" OnClick="btnConfirmCancel_Click" />
                    <asp:Button ID="btnCancelCancelation" runat="server" Text="Go Back" CssClass="btn btn-outline-secondary ml-2" OnClick="btnCancelCancelation_Click" CausesValidation="false" />
                </div>
            </asp:Panel>
        </div>
    </section>
    
</asp:Content>
