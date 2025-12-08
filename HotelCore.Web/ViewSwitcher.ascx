<%@ Control Language="VB" AutoEventWireup="false" CodeBehind="ViewSwitcher.ascx.vb" Inherits="HotelCore.Web.ViewSwitcher" %>
<div id="viewSwitcher">
    <%: CurrentView %> view | <a href="<%: SwitchUrl %>" data-ajax="false">Switch to <%: AlternateView %></a>
</div>
