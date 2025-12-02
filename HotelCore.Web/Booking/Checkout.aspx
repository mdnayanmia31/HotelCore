<%@ Page Title="Checkout - HotelCore" Language="vb" AutoEventWireup="false" MasterPageFile="~/Shared/Site.Master" CodeBehind="Checkout.aspx.vb" Inherits="HotelCore.Web.Booking.Checkout" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <!-- Breadcrumb Section -->
    <section class="hotelcore-breadcrumb">
        <div class="container">
            <h1>Complete Your Booking</h1>
            <div class="hotelcore-breadcrumb-nav">
                <a href="<%= ResolveUrl("~/Default.aspx") %>">Home</a>
                <span>/</span>
                <a href="<%= ResolveUrl("~/Booking/Search.aspx") %>">Rooms</a>
                <span>/</span>
                <span>Checkout</span>
            </div>
        </div>
    </section>
    
    <!-- Checkout Section -->
    <section class="hotelcore-section">
        <div class="container">
            <asp:Panel ID="pnlError" runat="server" CssClass="hotelcore-alert hotelcore-alert-error" Visible="false">
                <asp:Literal ID="litError" runat="server"></asp:Literal>
            </asp:Panel>
            
            <div class="row">
                <!-- Booking Form -->
                <div class="col-lg-8">
                    <div class="hotelcore-card">
                        <div class="hotelcore-card-header">
                            <h4>Guest Information</h4>
                        </div>
                        
                        <!-- Primary Guest -->
                        <h5 class="mb-3">Primary Guest</h5>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label>First Name <span class="text-danger">*</span></label>
                                    <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" required="required"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvFirstName" runat="server" ControlToValidate="txtFirstName" CssClass="text-danger" ErrorMessage="First name is required" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label>Last Name <span class="text-danger">*</span></label>
                                    <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" required="required"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvLastName" runat="server" ControlToValidate="txtLastName" CssClass="text-danger" ErrorMessage="Last name is required" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label>Email <span class="text-danger">*</span></label>
                                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" required="required"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" CssClass="text-danger" ErrorMessage="Email is required" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label>Phone <span class="text-danger">*</span></label>
                                    <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" required="required"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvPhone" runat="server" ControlToValidate="txtPhone" CssClass="text-danger" ErrorMessage="Phone is required" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Additional Guests -->
                        <asp:Panel ID="pnlAdditionalGuests" runat="server" Visible="false">
                            <hr />
                            <h5 class="mb-3">Additional Guests</h5>
                            <asp:Repeater ID="rptAdditionalGuests" runat="server">
                                <ItemTemplate>
                                    <div class="row mb-3">
                                        <div class="col-md-4">
                                            <label>Guest <%# Container.ItemIndex + 2 %> Name</label>
                                            <asp:TextBox ID="txtGuestName" runat="server" CssClass="form-control" placeholder="Full Name"></asp:TextBox>
                                        </div>
                                        <div class="col-md-4">
                                            <label>Age Category</label>
                                            <asp:DropDownList ID="ddlAgeCategory" runat="server" CssClass="form-control">
                                                <asp:ListItem Value="Adult">Adult</asp:ListItem>
                                                <asp:ListItem Value="Child">Child (2-12)</asp:ListItem>
                                                <asp:ListItem Value="Infant">Infant (0-2)</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                        <div class="col-md-4">
                                            <label>Email (Optional)</label>
                                            <asp:TextBox ID="txtGuestEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="Email"></asp:TextBox>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </asp:Panel>
                        
                        <!-- Special Requests -->
                        <hr />
                        <h5 class="mb-3">Special Requests</h5>
                        <div class="form-group">
                            <label>Any special requests or requirements?</label>
                            <asp:TextBox ID="txtSpecialRequests" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" placeholder="E.g., early check-in, dietary requirements, accessibility needs..."></asp:TextBox>
                        </div>
                    </div>
                    
                    <!-- Payment Information -->
                    <div class="hotelcore-card mt-4">
                        <div class="hotelcore-card-header">
                            <h4>Payment Information</h4>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label>Payment Method</label>
                                    <asp:DropDownList ID="ddlPaymentMethod" runat="server" CssClass="form-control">
                                        <asp:ListItem Value="CreditCard">Credit Card</asp:ListItem>
                                        <asp:ListItem Value="DebitCard">Debit Card</asp:ListItem>
                                        <asp:ListItem Value="PayAtHotel">Pay at Hotel</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </div>
                        <asp:Panel ID="pnlCardDetails" runat="server">
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="form-group">
                                        <label>Card Number</label>
                                        <asp:TextBox ID="txtCardNumber" runat="server" CssClass="form-control" placeholder="1234 5678 9012 3456" MaxLength="19"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>Expiry Month</label>
                                        <asp:DropDownList ID="ddlExpiryMonth" runat="server" CssClass="form-control">
                                            <asp:ListItem Value="01">01</asp:ListItem>
                                            <asp:ListItem Value="02">02</asp:ListItem>
                                            <asp:ListItem Value="03">03</asp:ListItem>
                                            <asp:ListItem Value="04">04</asp:ListItem>
                                            <asp:ListItem Value="05">05</asp:ListItem>
                                            <asp:ListItem Value="06">06</asp:ListItem>
                                            <asp:ListItem Value="07">07</asp:ListItem>
                                            <asp:ListItem Value="08">08</asp:ListItem>
                                            <asp:ListItem Value="09">09</asp:ListItem>
                                            <asp:ListItem Value="10">10</asp:ListItem>
                                            <asp:ListItem Value="11">11</asp:ListItem>
                                            <asp:ListItem Value="12">12</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>Expiry Year</label>
                                        <asp:DropDownList ID="ddlExpiryYear" runat="server" CssClass="form-control">
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>CVV</label>
                                        <asp:TextBox ID="txtCVV" runat="server" CssClass="form-control" placeholder="123" MaxLength="4"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                        </asp:Panel>
                    </div>
                    
                    <!-- Terms and Conditions -->
                    <div class="hotelcore-card mt-4">
                        <div class="form-check">
                            <asp:CheckBox ID="chkTerms" runat="server" CssClass="form-check-input" />
                            <label class="form-check-label">
                                I agree to the <a href="#" data-toggle="modal" data-target="#termsModal">Terms and Conditions</a> and <a href="#" data-toggle="modal" data-target="#privacyModal">Privacy Policy</a>
                            </label>
                        </div>
                    </div>
                    
                    <div class="mt-4">
                        <asp:Button ID="btnCompleteBooking" runat="server" Text="Complete Booking" CssClass="btn-hotelcore btn-hotelcore-primary btn-lg" OnClick="btnCompleteBooking_Click" />
                        <a href="<%= ResolveUrl("~/Booking/Search.aspx") %>" class="btn btn-outline-secondary btn-lg ml-2">Cancel</a>
                    </div>
                </div>
                
                <!-- Booking Summary -->
                <div class="col-lg-4">
                    <div class="hotelcore-card">
                        <div class="hotelcore-card-header">
                            <h4>Booking Summary</h4>
                        </div>
                        <table class="w-100">
                            <tr>
                                <td><strong>Room Type:</strong></td>
                                <td class="text-right"><asp:Literal ID="litRoomType" runat="server"></asp:Literal></td>
                            </tr>
                            <tr>
                                <td><strong>Room Number:</strong></td>
                                <td class="text-right"><asp:Literal ID="litRoomNumber" runat="server"></asp:Literal></td>
                            </tr>
                            <tr>
                                <td><strong>Check-In:</strong></td>
                                <td class="text-right"><asp:Literal ID="litCheckIn" runat="server"></asp:Literal></td>
                            </tr>
                            <tr>
                                <td><strong>Check-Out:</strong></td>
                                <td class="text-right"><asp:Literal ID="litCheckOut" runat="server"></asp:Literal></td>
                            </tr>
                            <tr>
                                <td><strong>Guests:</strong></td>
                                <td class="text-right"><asp:Literal ID="litGuests" runat="server"></asp:Literal></td>
                            </tr>
                            <tr>
                                <td><strong>Nights:</strong></td>
                                <td class="text-right"><asp:Literal ID="litNights" runat="server"></asp:Literal></td>
                            </tr>
                        </table>
                        <hr />
                        <table class="w-100">
                            <tr>
                                <td>Daily Rate:</td>
                                <td class="text-right">$<asp:Literal ID="litDailyRate" runat="server"></asp:Literal></td>
                            </tr>
                            <tr>
                                <td>Subtotal:</td>
                                <td class="text-right">$<asp:Literal ID="litSubtotal" runat="server"></asp:Literal></td>
                            </tr>
                            <tr>
                                <td>Tax (10%):</td>
                                <td class="text-right">$<asp:Literal ID="litTax" runat="server"></asp:Literal></td>
                            </tr>
                            <tr class="border-top">
                                <td><strong>Total:</strong></td>
                                <td class="text-right text-sage"><strong>$<asp:Literal ID="litTotal" runat="server"></asp:Literal></strong></td>
                            </tr>
                        </table>
                    </div>
                    
                    <!-- Cancellation Policy -->
                    <div class="hotelcore-card mt-3">
                        <h5>Cancellation Policy</h5>
                        <p class="small text-muted">Free cancellation up to 24 hours before check-in. Cancellations made within 24 hours of check-in will be charged for one night.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Terms Modal -->
    <div class="modal fade" id="termsModal" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Terms and Conditions</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <h6>Booking Terms</h6>
                    <p>By completing this booking, you agree to our terms and conditions. Bookings are subject to availability and confirmation.</p>
                    <h6>Payment</h6>
                    <p>Payment is required at the time of booking unless "Pay at Hotel" is selected. All prices are in USD.</p>
                    <h6>Cancellation</h6>
                    <p>Free cancellation is available up to 24 hours before check-in. Late cancellations may be subject to a one-night charge.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
    
</asp:Content>
