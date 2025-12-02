<%@ Page Title="Contact Us - HotelCore" Language="vb" AutoEventWireup="false" MasterPageFile="~/Shared/Site.Master" CodeBehind="Contact.aspx.vb" Inherits="HotelCore.Web.Contact" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <!-- Breadcrumb Section -->
    <section class="hotelcore-breadcrumb">
        <div class="container">
            <h1>Contact Us</h1>
            <div class="hotelcore-breadcrumb-nav">
                <a href="<%= ResolveUrl("~/Default.aspx") %>">Home</a>
                <span>/</span>
                <span>Contact</span>
            </div>
        </div>
    </section>
    
    <!-- Contact Section -->
    <section class="contact-section">
        <div class="container">
            <div class="row">
                <div class="col-lg-4">
                    <div class="contact-text">
                        <h2>Get In Touch</h2>
                        <p>We'd love to hear from you. Whether you have a question about reservations, facilities, pricing, or anything else, our team is ready to answer all your questions.</p>
                        <table>
                            <tbody>
                                <tr>
                                    <td class="c-o">Address:</td>
                                    <td>123 Hotel Street, Downtown<br />City, State 12345</td>
                                </tr>
                                <tr>
                                    <td class="c-o">Phone:</td>
                                    <td>+1 234 567 8900</td>
                                </tr>
                                <tr>
                                    <td class="c-o">Email:</td>
                                    <td>info@hotelcore.com</td>
                                </tr>
                            </tbody>
                        </table>
                        
                        <h5 class="mt-4 mb-3">Operating Hours</h5>
                        <table>
                            <tbody>
                                <tr>
                                    <td class="c-o">Front Desk:</td>
                                    <td>24 Hours / 7 Days</td>
                                </tr>
                                <tr>
                                    <td class="c-o">Restaurant:</td>
                                    <td>6:00 AM - 11:00 PM</td>
                                </tr>
                                <tr>
                                    <td class="c-o">Spa:</td>
                                    <td>9:00 AM - 9:00 PM</td>
                                </tr>
                                <tr>
                                    <td class="c-o">Pool:</td>
                                    <td>6:00 AM - 10:00 PM</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="col-lg-7 offset-lg-1">
                    <asp:Panel ID="pnlSuccess" runat="server" CssClass="hotelcore-alert hotelcore-alert-success" Visible="false">
                        <i class="fa fa-check-circle mr-2"></i> Thank you for your message! We'll get back to you soon.
                    </asp:Panel>
                    
                    <asp:Panel ID="pnlError" runat="server" CssClass="hotelcore-alert hotelcore-alert-error" Visible="false">
                        <asp:Literal ID="litError" runat="server"></asp:Literal>
                    </asp:Panel>
                    
                    <asp:Panel ID="pnlForm" runat="server">
                        <div class="contact-form">
                            <div class="row">
                                <div class="col-lg-6">
                                    <asp:TextBox ID="txtName" runat="server" CssClass="form-control" placeholder="Your Name *"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName" CssClass="text-danger small" ErrorMessage="Name is required" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-lg-6">
                                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="Your Email *"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" CssClass="text-danger small" ErrorMessage="Email is required" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-lg-12">
                                    <asp:TextBox ID="txtSubject" runat="server" CssClass="form-control" placeholder="Subject"></asp:TextBox>
                                </div>
                                <div class="col-lg-12">
                                    <asp:TextBox ID="txtMessage" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="5" placeholder="Your Message *"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvMessage" runat="server" ControlToValidate="txtMessage" CssClass="text-danger small" ErrorMessage="Message is required" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-lg-12">
                                    <asp:Button ID="btnSubmit" runat="server" Text="Send Message" CssClass="btn-hotelcore btn-hotelcore-primary" OnClick="btnSubmit_Click" />
                                </div>
                            </div>
                        </div>
                    </asp:Panel>
                </div>
            </div>
            
            <!-- Map Placeholder -->
            <div class="map mt-5">
                <div class="bg-light d-flex align-items-center justify-content-center" style="height: 400px;">
                    <div class="text-center text-muted">
                        <i class="fa fa-map-marker fa-4x mb-3"></i>
                        <h4>Hotel Location</h4>
                        <p>123 Hotel Street, Downtown, City</p>
                        <p class="small">Map integration available - API key required</p>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
</asp:Content>
