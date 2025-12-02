<%@ Page Title="Search Rooms - HotelCore" Language="vb" AutoEventWireup="false" MasterPageFile="~/Shared/Site.Master" CodeBehind="Search.aspx.vb" Inherits="HotelCore.Web.Booking.Search" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <!-- Breadcrumb Section -->
    <section class="hotelcore-breadcrumb">
        <div class="container">
            <h1>Find Your Perfect Room</h1>
            <div class="hotelcore-breadcrumb-nav">
                <a href="<%= ResolveUrl("~/Default.aspx") %>">Home</a>
                <span>/</span>
                <span>Rooms</span>
            </div>
        </div>
    </section>
    
    <!-- Room Search Section -->
    <section class="rooms-section spad">
        <div class="container">
            <div class="row">
                <!-- Search Filters -->
                <div class="col-lg-4">
                    <div class="hotelcore-card">
                        <div class="hotelcore-card-header">
                            <h4>Search Filters</h4>
                        </div>
                        <div class="hotelcore-form">
                            <div class="form-group">
                                <label>Check-In Date</label>
                                <asp:TextBox ID="txtCheckIn" runat="server" CssClass="form-control datepicker" placeholder="Select Date"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <label>Check-Out Date</label>
                                <asp:TextBox ID="txtCheckOut" runat="server" CssClass="form-control datepicker" placeholder="Select Date"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <label>Number of Guests</label>
                                <asp:DropDownList ID="ddlGuests" runat="server" CssClass="form-control">
                                    <asp:ListItem Value="1">1 Guest</asp:ListItem>
                                    <asp:ListItem Value="2" Selected="True">2 Guests</asp:ListItem>
                                    <asp:ListItem Value="3">3 Guests</asp:ListItem>
                                    <asp:ListItem Value="4">4 Guests</asp:ListItem>
                                    <asp:ListItem Value="5">5 Guests</asp:ListItem>
                                    <asp:ListItem Value="6">6+ Guests</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="form-group">
                                <label>Room Type</label>
                                <asp:DropDownList ID="ddlRoomType" runat="server" CssClass="form-control">
                                    <asp:ListItem Value="">All Room Types</asp:ListItem>
                                    <asp:ListItem Value="1">Standard Room</asp:ListItem>
                                    <asp:ListItem Value="2">Deluxe Room</asp:ListItem>
                                    <asp:ListItem Value="3">Executive Suite</asp:ListItem>
                                    <asp:ListItem Value="4">Presidential Suite</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="form-group">
                                <label>Max Price per Night</label>
                                <asp:DropDownList ID="ddlMaxPrice" runat="server" CssClass="form-control">
                                    <asp:ListItem Value="">Any Price</asp:ListItem>
                                    <asp:ListItem Value="100">Up to $100</asp:ListItem>
                                    <asp:ListItem Value="200">Up to $200</asp:ListItem>
                                    <asp:ListItem Value="300">Up to $300</asp:ListItem>
                                    <asp:ListItem Value="500">Up to $500</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <asp:Button ID="btnSearch" runat="server" Text="Search Rooms" CssClass="btn-hotelcore btn-hotelcore-primary w-100" OnClick="btnSearch_Click" />
                        </div>
                    </div>
                </div>
                
                <!-- Search Results -->
                <div class="col-lg-8">
                    <asp:Panel ID="pnlNoResults" runat="server" CssClass="hotelcore-alert hotelcore-alert-info" Visible="false">
                        <i class="fa fa-info-circle mr-2"></i> No rooms found matching your criteria. Please adjust your search filters.
                    </asp:Panel>
                    
                    <asp:Panel ID="pnlError" runat="server" CssClass="hotelcore-alert hotelcore-alert-error" Visible="false">
                        <asp:Literal ID="litError" runat="server"></asp:Literal>
                    </asp:Panel>
                    
                    <asp:Repeater ID="rptRooms" runat="server">
                        <ItemTemplate>
                            <div class="room-item">
                                <img src='<%# ResolveUrl("~/Content/img/room/room-" & (Container.ItemIndex Mod 6 + 1) & ".jpg") %>' alt="Room Image" />
                                <div class="ri-text">
                                    <h4><%# Eval("TypeName") %></h4>
                                    <h3>$<%# Eval("BaseDailyRate", "{0:N2}") %><span>/Night</span></h3>
                                    <table>
                                        <tbody>
                                            <tr>
                                                <td class="r-o">Size:</td>
                                                <td><%# Eval("SquareFeet") %> sq ft</td>
                                            </tr>
                                            <tr>
                                                <td class="r-o">Capacity:</td>
                                                <td>Max <%# Eval("MaxOccupancy") %> Guests</td>
                                            </tr>
                                            <tr>
                                                <td class="r-o">Bed:</td>
                                                <td><%# Eval("BedConfiguration") %></td>
                                            </tr>
                                            <tr>
                                                <td class="r-o">Room:</td>
                                                <td><%# Eval("RoomNumber") %> (Floor <%# Eval("FloorNumber") %>)</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <a href='<%# ResolveUrl("~/Booking/RoomDetails.aspx?id=" & Eval("RoomID")) %>' class="primary-btn">View Details</a>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    
                    <!-- Static Room Display when no search performed -->
                    <asp:Panel ID="pnlDefaultRooms" runat="server" Visible="true">
                        <div class="row">
                            <div class="col-lg-6">
                                <div class="room-item">
                                    <img src="<%= ResolveUrl("~/Content/img/room/room-1.jpg") %>" alt="Standard Room" />
                                    <div class="ri-text">
                                        <h4>Standard Room</h4>
                                        <h3>$99<span>/Night</span></h3>
                                        <table>
                                            <tbody>
                                                <tr>
                                                    <td class="r-o">Size:</td>
                                                    <td>300 sq ft</td>
                                                </tr>
                                                <tr>
                                                    <td class="r-o">Capacity:</td>
                                                    <td>Max 2 Guests</td>
                                                </tr>
                                                <tr>
                                                    <td class="r-o">Bed:</td>
                                                    <td>1 Queen</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                        <a href="<%= ResolveUrl("~/Booking/RoomDetails.aspx?id=1") %>" class="primary-btn">View Details</a>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-6">
                                <div class="room-item">
                                    <img src="<%= ResolveUrl("~/Content/img/room/room-2.jpg") %>" alt="Deluxe Room" />
                                    <div class="ri-text">
                                        <h4>Deluxe Room</h4>
                                        <h3>$150<span>/Night</span></h3>
                                        <table>
                                            <tbody>
                                                <tr>
                                                    <td class="r-o">Size:</td>
                                                    <td>400 sq ft</td>
                                                </tr>
                                                <tr>
                                                    <td class="r-o">Capacity:</td>
                                                    <td>Max 3 Guests</td>
                                                </tr>
                                                <tr>
                                                    <td class="r-o">Bed:</td>
                                                    <td>1 King</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                        <a href="<%= ResolveUrl("~/Booking/RoomDetails.aspx?id=2") %>" class="primary-btn">View Details</a>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-6">
                                <div class="room-item">
                                    <img src="<%= ResolveUrl("~/Content/img/room/room-3.jpg") %>" alt="Executive Suite" />
                                    <div class="ri-text">
                                        <h4>Executive Suite</h4>
                                        <h3>$250<span>/Night</span></h3>
                                        <table>
                                            <tbody>
                                                <tr>
                                                    <td class="r-o">Size:</td>
                                                    <td>600 sq ft</td>
                                                </tr>
                                                <tr>
                                                    <td class="r-o">Capacity:</td>
                                                    <td>Max 4 Guests</td>
                                                </tr>
                                                <tr>
                                                    <td class="r-o">Bed:</td>
                                                    <td>2 Queens</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                        <a href="<%= ResolveUrl("~/Booking/RoomDetails.aspx?id=3") %>" class="primary-btn">View Details</a>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-6">
                                <div class="room-item">
                                    <img src="<%= ResolveUrl("~/Content/img/room/room-4.jpg") %>" alt="Presidential Suite" />
                                    <div class="ri-text">
                                        <h4>Presidential Suite</h4>
                                        <h3>$450<span>/Night</span></h3>
                                        <table>
                                            <tbody>
                                                <tr>
                                                    <td class="r-o">Size:</td>
                                                    <td>1000 sq ft</td>
                                                </tr>
                                                <tr>
                                                    <td class="r-o">Capacity:</td>
                                                    <td>Max 6 Guests</td>
                                                </tr>
                                                <tr>
                                                    <td class="r-o">Bed:</td>
                                                    <td>3 Kings</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                        <a href="<%= ResolveUrl("~/Booking/RoomDetails.aspx?id=4") %>" class="primary-btn">View Details</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </asp:Panel>
                </div>
            </div>
        </div>
    </section>
    
</asp:Content>
