<%@ Page Title="Error - HotelCore" Language="vb" AutoEventWireup="false" MasterPageFile="~/Shared/Site.Master" CodeBehind="Error.aspx.vb" Inherits="HotelCore.Web.ErrorPage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <section class="hotelcore-section pt-navbar">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-6 text-center">
                    <div class="hotelcore-card">
                        <div class="error-icon mb-4">
                            <i class="fa fa-exclamation-triangle fa-5x text-sage"></i>
                        </div>
                        <h1 class="display-4 mb-3">
                            <asp:Literal ID="litErrorCode" runat="server">Error</asp:Literal>
                        </h1>
                        <h4 class="mb-4">
                            <asp:Literal ID="litErrorTitle" runat="server">Something went wrong</asp:Literal>
                        </h4>
                        <p class="text-muted mb-4">
                            <asp:Literal ID="litErrorMessage" runat="server">We apologize for the inconvenience. Please try again later.</asp:Literal>
                        </p>
                        <div class="mt-4">
                            <a href="<%= ResolveUrl("~/Default.aspx") %>" class="btn-hotelcore btn-hotelcore-primary">
                                <i class="fa fa-home mr-2"></i>Return to Home
                            </a>
                            <a href="<%= ResolveUrl("~/Contact.aspx") %>" class="btn-hotelcore btn-hotelcore-outline ml-2">
                                <i class="fa fa-envelope mr-2"></i>Contact Support
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
</asp:Content>
