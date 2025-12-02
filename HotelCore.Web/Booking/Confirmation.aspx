<%@ Page Title="Booking Confirmed - HotelCore" Language="vb" AutoEventWireup="false" MasterPageFile="~/Shared/Site.Master" CodeBehind="Confirmation.aspx.vb" Inherits="HotelCore.Web.Booking.Confirmation" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .confirmation-icon {
            font-size: 80px;
            color: var(--primary-sage);
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <!-- Confirmation Section -->
    <section class="hotelcore-section pt-navbar">
        <div class="container">
            <asp:Panel ID="pnlError" runat="server" CssClass="hotelcore-alert hotelcore-alert-error" Visible="false">
                <asp:Literal ID="litError" runat="server"></asp:Literal>
            </asp:Panel>
            
            <asp:Panel ID="pnlConfirmation" runat="server">
                <div class="text-center mb-5">
                    <i class="fa fa-check-circle confirmation-icon"></i>
                    <h1 class="mt-3">Booking Confirmed!</h1>
                    <p class="lead">Thank you for your reservation. Your booking has been successfully confirmed.</p>
                </div>
                
                <div class="row justify-content-center">
                    <div class="col-lg-8">
                        <!-- Booking Details Card -->
                        <div class="hotelcore-card">
                            <div class="hotelcore-card-header text-center">
                                <h4>Booking Details</h4>
                                <p class="mb-0 text-sage">Reference: <strong><asp:Literal ID="litBookingRef" runat="server"></asp:Literal></strong></p>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <table class="w-100">
                                        <tr>
                                            <td class="py-2"><strong>Room Type:</strong></td>
                                            <td class="py-2 text-right"><asp:Literal ID="litRoomType" runat="server"></asp:Literal></td>
                                        </tr>
                                        <tr>
                                            <td class="py-2"><strong>Room Number:</strong></td>
                                            <td class="py-2 text-right"><asp:Literal ID="litRoomNumber" runat="server"></asp:Literal></td>
                                        </tr>
                                        <tr>
                                            <td class="py-2"><strong>Check-In:</strong></td>
                                            <td class="py-2 text-right"><asp:Literal ID="litCheckIn" runat="server"></asp:Literal></td>
                                        </tr>
                                        <tr>
                                            <td class="py-2"><strong>Check-Out:</strong></td>
                                            <td class="py-2 text-right"><asp:Literal ID="litCheckOut" runat="server"></asp:Literal></td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="col-md-6">
                                    <table class="w-100">
                                        <tr>
                                            <td class="py-2"><strong>Guests:</strong></td>
                                            <td class="py-2 text-right"><asp:Literal ID="litGuests" runat="server"></asp:Literal></td>
                                        </tr>
                                        <tr>
                                            <td class="py-2"><strong>Status:</strong></td>
                                            <td class="py-2 text-right"><span class="badge badge-success"><asp:Literal ID="litStatus" runat="server"></asp:Literal></span></td>
                                        </tr>
                                        <tr>
                                            <td class="py-2"><strong>Total Amount:</strong></td>
                                            <td class="py-2 text-right text-sage"><strong>$<asp:Literal ID="litTotal" runat="server"></asp:Literal></strong></td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                            
                            <!-- Guest List -->
                            <asp:Panel ID="pnlGuests" runat="server" Visible="false">
                                <hr />
                                <h5>Guest List</h5>
                                <asp:Repeater ID="rptGuests" runat="server">
                                    <ItemTemplate>
                                        <div class="d-flex justify-content-between py-2 border-bottom">
                                            <span><%# Eval("FullName") %></span>
                                            <span class="text-muted"><%# Eval("GuestType") %> - <%# Eval("AgeCategory") %></span>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </asp:Panel>
                        </div>
                        
                        <!-- Important Information -->
                        <div class="hotelcore-card mt-4">
                            <h5><i class="fa fa-info-circle text-sage mr-2"></i> Important Information</h5>
                            <ul class="mb-0">
                                <li class="mb-2">Check-in time is from 3:00 PM. Early check-in may be available upon request.</li>
                                <li class="mb-2">Check-out time is 11:00 AM. Late check-out may be available upon request.</li>
                                <li class="mb-2">Please bring a valid photo ID at check-in.</li>
                                <li class="mb-2">A confirmation email has been sent to your registered email address.</li>
                            </ul>
                        </div>
                        
                        <!-- Action Buttons -->
                        <div class="text-center mt-4">
                            <button type="button" class="btn-hotelcore btn-hotelcore-primary mr-2" onclick="window.print();">
                                <i class="fa fa-print mr-2"></i> Print Confirmation
                            </button>
                            <a href="<%= ResolveUrl("~/Account/Profile.aspx") %>" class="btn-hotelcore btn-hotelcore-outline">
                                <i class="fa fa-user mr-2"></i> View My Bookings
                            </a>
                        </div>
                        
                        <!-- Contact Info -->
                        <div class="text-center mt-4">
                            <p class="text-muted">Need assistance? Contact us at <strong>+1 234 567 8900</strong> or <strong>info@hotelcore.com</strong></p>
                        </div>
                    </div>
                </div>
            </asp:Panel>
        </div>
    </section>
    
</asp:Content>
