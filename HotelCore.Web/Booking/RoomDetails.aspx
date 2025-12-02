<%@ Page Title="Room Details - HotelCore" Language="vb" AutoEventWireup="false" MasterPageFile="~/Shared/Site.Master" CodeBehind="RoomDetails.aspx.vb" Inherits="HotelCore.Web.Booking.RoomDetails" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <!-- Breadcrumb Section -->
    <section class="hotelcore-breadcrumb">
        <div class="container">
            <h1><asp:Literal ID="litRoomType" runat="server">Room Details</asp:Literal></h1>
            <div class="hotelcore-breadcrumb-nav">
                <a href="<%= ResolveUrl("~/Default.aspx") %>">Home</a>
                <span>/</span>
                <a href="<%= ResolveUrl("~/Booking/Search.aspx") %>">Rooms</a>
                <span>/</span>
                <span>Room Details</span>
            </div>
        </div>
    </section>
    
    <!-- Room Details Section -->
    <section class="room-details-section spad">
        <div class="container">
            <asp:Panel ID="pnlError" runat="server" CssClass="hotelcore-alert hotelcore-alert-error" Visible="false">
                <asp:Literal ID="litError" runat="server"></asp:Literal>
            </asp:Panel>
            
            <asp:Panel ID="pnlRoomDetails" runat="server">
                <div class="row">
                    <div class="col-lg-8">
                        <div class="room-details-item">
                            <img src="<%= ResolveUrl("~/Content/img/room/room-details.jpg") %>" alt="Room Image" class="img-fluid mb-4" />
                            <div class="rd-text">
                                <div class="rd-title">
                                    <h3><asp:Literal ID="litRoomTypeName" runat="server"></asp:Literal></h3>
                                    <div class="rdt-right">
                                        <div class="rating">
                                            <i class="icon_star"></i>
                                            <i class="icon_star"></i>
                                            <i class="icon_star"></i>
                                            <i class="icon_star"></i>
                                            <i class="icon_star-half_alt"></i>
                                        </div>
                                    </div>
                                </div>
                                <h2>$<asp:Literal ID="litDailyRate" runat="server"></asp:Literal><span>/Night</span></h2>
                                <table>
                                    <tbody>
                                        <tr>
                                            <td class="r-o">Room Number:</td>
                                            <td><asp:Literal ID="litRoomNumber" runat="server"></asp:Literal></td>
                                        </tr>
                                        <tr>
                                            <td class="r-o">Floor:</td>
                                            <td><asp:Literal ID="litFloor" runat="server"></asp:Literal></td>
                                        </tr>
                                        <tr>
                                            <td class="r-o">Size:</td>
                                            <td><asp:Literal ID="litSize" runat="server"></asp:Literal> sq ft</td>
                                        </tr>
                                        <tr>
                                            <td class="r-o">Capacity:</td>
                                            <td>Max <asp:Literal ID="litCapacity" runat="server"></asp:Literal> Guests</td>
                                        </tr>
                                        <tr>
                                            <td class="r-o">Bed:</td>
                                            <td><asp:Literal ID="litBedConfig" runat="server"></asp:Literal></td>
                                        </tr>
                                        <tr>
                                            <td class="r-o">Status:</td>
                                            <td><asp:Literal ID="litStatus" runat="server"></asp:Literal></td>
                                        </tr>
                                    </tbody>
                                </table>
                                <p class="f-para"><asp:Literal ID="litDescription" runat="server"></asp:Literal></p>
                                <p class="s-para">Enjoy a comfortable stay with premium amenities including complimentary Wi-Fi, flat-screen TV, mini-bar, in-room safe, and 24-hour room service. Our rooms feature modern décor with luxurious bedding to ensure a restful night's sleep.</p>
                            </div>
                        </div>
                        
                        <!-- Room Amenities -->
                        <div class="hotelcore-card">
                            <div class="hotelcore-card-header">
                                <h4>Room Amenities</h4>
                            </div>
                            <div class="row">
                                <div class="col-md-4 col-6 mb-3">
                                    <i class="fa fa-wifi text-sage mr-2"></i> Free Wi-Fi
                                </div>
                                <div class="col-md-4 col-6 mb-3">
                                    <i class="fa fa-tv text-sage mr-2"></i> Flat Screen TV
                                </div>
                                <div class="col-md-4 col-6 mb-3">
                                    <i class="fa fa-snowflake-o text-sage mr-2"></i> Air Conditioning
                                </div>
                                <div class="col-md-4 col-6 mb-3">
                                    <i class="fa fa-coffee text-sage mr-2"></i> Coffee Maker
                                </div>
                                <div class="col-md-4 col-6 mb-3">
                                    <i class="fa fa-bath text-sage mr-2"></i> Private Bathroom
                                </div>
                                <div class="col-md-4 col-6 mb-3">
                                    <i class="fa fa-lock text-sage mr-2"></i> In-Room Safe
                                </div>
                                <div class="col-md-4 col-6 mb-3">
                                    <i class="fa fa-cutlery text-sage mr-2"></i> Mini Bar
                                </div>
                                <div class="col-md-4 col-6 mb-3">
                                    <i class="fa fa-phone text-sage mr-2"></i> Room Service
                                </div>
                                <div class="col-md-4 col-6 mb-3">
                                    <i class="fa fa-tint text-sage mr-2"></i> Hair Dryer
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Booking Sidebar -->
                    <div class="col-lg-4">
                        <div class="room-booking">
                            <h3>Book This Room</h3>
                            <div class="hotelcore-form">
                                <div class="check-date">
                                    <label>Check In</label>
                                    <asp:TextBox ID="txtCheckIn" runat="server" CssClass="form-control datepicker" placeholder="Select Date"></asp:TextBox>
                                    <i class="icon_calendar"></i>
                                </div>
                                <div class="check-date">
                                    <label>Check Out</label>
                                    <asp:TextBox ID="txtCheckOut" runat="server" CssClass="form-control datepicker" placeholder="Select Date"></asp:TextBox>
                                    <i class="icon_calendar"></i>
                                </div>
                                <div class="select-option">
                                    <label>Number of Guests</label>
                                    <asp:DropDownList ID="ddlGuests" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlGuests_SelectedIndexChanged">
                                        <asp:ListItem Value="1">1 Guest</asp:ListItem>
                                        <asp:ListItem Value="2" Selected="True">2 Guests</asp:ListItem>
                                        <asp:ListItem Value="3">3 Guests</asp:ListItem>
                                        <asp:ListItem Value="4">4 Guests</asp:ListItem>
                                        <asp:ListItem Value="5">5 Guests</asp:ListItem>
                                        <asp:ListItem Value="6">6 Guests</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                
                                <!-- Price Estimate -->
                                <div class="hotelcore-card mt-3 p-3">
                                    <h5>Price Estimate</h5>
                                    <table class="w-100">
                                        <tr>
                                            <td>Daily Rate:</td>
                                            <td class="text-right">$<asp:Literal ID="litEstDailyRate" runat="server">0.00</asp:Literal></td>
                                        </tr>
                                        <tr>
                                            <td>Number of Nights:</td>
                                            <td class="text-right"><asp:Literal ID="litNights" runat="server">0</asp:Literal></td>
                                        </tr>
                                        <tr class="border-top">
                                            <td><strong>Total:</strong></td>
                                            <td class="text-right text-sage"><strong>$<asp:Literal ID="litTotalPrice" runat="server">0.00</asp:Literal></strong></td>
                                        </tr>
                                    </table>
                                </div>
                                
                                <asp:Button ID="btnCalculate" runat="server" Text="Calculate Price" CssClass="btn btn-outline-secondary w-100 mt-3" OnClick="btnCalculate_Click" />
                                <asp:Button ID="btnBookNow" runat="server" Text="Book Now" CssClass="btn-hotelcore btn-hotelcore-primary w-100 mt-2" OnClick="btnBookNow_Click" />
                            </div>
                        </div>
                    </div>
                </div>
            </asp:Panel>
        </div>
    </section>
    
</asp:Content>
