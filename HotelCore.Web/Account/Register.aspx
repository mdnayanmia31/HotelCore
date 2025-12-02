<%@ Page Title="Register - HotelCore" Language="vb" AutoEventWireup="false" MasterPageFile="~/Shared/Site.Master" CodeBehind="Register.aspx.vb" Inherits="HotelCore.Web.Account.Register" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <!-- Register Section -->
    <section class="hotelcore-section pt-navbar">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-6 col-md-8">
                    <div class="hotelcore-card">
                        <div class="text-center mb-4">
                            <h2>Create Account</h2>
                            <p class="text-muted">Join HotelCore and enjoy exclusive benefits</p>
                        </div>
                        
                        <asp:Panel ID="pnlError" runat="server" CssClass="hotelcore-alert hotelcore-alert-error" Visible="false">
                            <asp:Literal ID="litError" runat="server"></asp:Literal>
                        </asp:Panel>
                        
                        <div class="hotelcore-form">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>First Name <span class="text-danger">*</span></label>
                                        <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" placeholder="Enter first name"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rfvFirstName" runat="server" ControlToValidate="txtFirstName" CssClass="text-danger small" ErrorMessage="First name is required" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Last Name <span class="text-danger">*</span></label>
                                        <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" placeholder="Enter last name"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rfvLastName" runat="server" ControlToValidate="txtLastName" CssClass="text-danger small" ErrorMessage="Last name is required" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label>Email Address <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="Enter your email"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" CssClass="text-danger small" ErrorMessage="Email is required" Display="Dynamic"></asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail" CssClass="text-danger small" ErrorMessage="Please enter a valid email" ValidationExpression="^[\w\.-]+@[\w\.-]+\.\w+$" Display="Dynamic"></asp:RegularExpressionValidator>
                            </div>
                            
                            <div class="form-group">
                                <label>Phone Number</label>
                                <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="Enter phone number"></asp:TextBox>
                            </div>
                            
                            <div class="form-group">
                                <label>Password <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Create a password"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword" CssClass="text-danger small" ErrorMessage="Password is required" Display="Dynamic"></asp:RequiredFieldValidator>
                                <small class="text-muted">Minimum 8 characters</small>
                            </div>
                            
                            <div class="form-group">
                                <label>Confirm Password <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Confirm your password"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server" ControlToValidate="txtConfirmPassword" CssClass="text-danger small" ErrorMessage="Please confirm your password" Display="Dynamic"></asp:RequiredFieldValidator>
                                <asp:CompareValidator ID="cvPassword" runat="server" ControlToValidate="txtConfirmPassword" ControlToCompare="txtPassword" CssClass="text-danger small" ErrorMessage="Passwords do not match" Display="Dynamic"></asp:CompareValidator>
                            </div>
                            
                            <div class="form-group">
                                <div class="form-check">
                                    <asp:CheckBox ID="chkTerms" runat="server" CssClass="form-check-input" />
                                    <label class="form-check-label">I agree to the <a href="#">Terms of Service</a> and <a href="#">Privacy Policy</a></label>
                                </div>
                            </div>
                            
                            <asp:Button ID="btnRegister" runat="server" Text="Create Account" CssClass="btn-hotelcore btn-hotelcore-primary w-100" OnClick="btnRegister_Click" />
                        </div>
                        
                        <hr />
                        
                        <div class="text-center">
                            <p class="mb-0">Already have an account? <a href="<%= ResolveUrl("~/Account/Login.aspx") %>" class="text-sage">Sign In</a></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
</asp:Content>
