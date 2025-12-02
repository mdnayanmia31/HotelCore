<%@ Page Title="Login - HotelCore" Language="vb" AutoEventWireup="false" MasterPageFile="~/Shared/Site.Master" CodeBehind="Login.aspx.vb" Inherits="HotelCore.Web.Account.Login" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <!-- Login Section -->
    <section class="hotelcore-section pt-navbar">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-5 col-md-7">
                    <div class="hotelcore-card">
                        <div class="text-center mb-4">
                            <h2>Welcome Back</h2>
                            <p class="text-muted">Sign in to your account</p>
                        </div>
                        
                        <asp:Panel ID="pnlError" runat="server" CssClass="hotelcore-alert hotelcore-alert-error" Visible="false">
                            <asp:Literal ID="litError" runat="server"></asp:Literal>
                        </asp:Panel>
                        
                        <asp:Panel ID="pnlSuccess" runat="server" CssClass="hotelcore-alert hotelcore-alert-success" Visible="false">
                            <asp:Literal ID="litSuccess" runat="server"></asp:Literal>
                        </asp:Panel>
                        
                        <div class="hotelcore-form">
                            <div class="form-group">
                                <label>Email Address <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="Enter your email"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" CssClass="text-danger small" ErrorMessage="Email is required" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>
                            
                            <div class="form-group">
                                <label>Password <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Enter your password"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword" CssClass="text-danger small" ErrorMessage="Password is required" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>
                            
                            <div class="form-group d-flex justify-content-between align-items-center">
                                <div class="form-check">
                                    <asp:CheckBox ID="chkRememberMe" runat="server" CssClass="form-check-input" />
                                    <label class="form-check-label">Remember me</label>
                                </div>
                                <a href="#" class="small">Forgot Password?</a>
                            </div>
                            
                            <asp:Button ID="btnLogin" runat="server" Text="Sign In" CssClass="btn-hotelcore btn-hotelcore-primary w-100" OnClick="btnLogin_Click" />
                        </div>
                        
                        <hr />
                        
                        <div class="text-center">
                            <p class="mb-0">Don't have an account? <a href="<%= ResolveUrl("~/Account/Register.aspx") %>" class="text-sage">Create Account</a></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
</asp:Content>
