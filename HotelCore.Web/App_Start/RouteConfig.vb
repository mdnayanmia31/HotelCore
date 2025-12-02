Imports System.Web.Routing
Imports Microsoft.AspNet.FriendlyUrls

Public Class RouteConfig
    Public Shared Sub RegisterRoutes(ByVal routes As RouteCollection)
        ' Enable Friendly URLs
        routes.EnableFriendlyUrls()

        ' Custom routes for clean URLs
        routes.MapPageRoute("Home", "", "~/Default.aspx")
        routes.MapPageRoute("Facilities", "facilities", "~/Facilities.aspx")
        routes.MapPageRoute("Contact", "contact", "~/Contact.aspx")
        routes.MapPageRoute("RoomSearch", "rooms", "~/Booking/Search.aspx")
        routes.MapPageRoute("RoomDetails", "room/{id}", "~/Booking/RoomDetails.aspx")
        routes.MapPageRoute("Checkout", "checkout", "~/Booking/Checkout.aspx")
        routes.MapPageRoute("Confirmation", "confirmation/{id}", "~/Booking/Confirmation.aspx")
        routes.MapPageRoute("Login", "login", "~/Account/Login.aspx")
        routes.MapPageRoute("Register", "register", "~/Account/Register.aspx")
        routes.MapPageRoute("Profile", "profile", "~/Account/Profile.aspx")
        routes.MapPageRoute("BookingDetails", "booking/{id}", "~/Account/BookingDetails.aspx")
        routes.MapPageRoute("AdminDashboard", "admin", "~/Admin/Dashboard.aspx")
        routes.MapPageRoute("AdminBookings", "admin/bookings", "~/Admin/Bookings.aspx")
        routes.MapPageRoute("AdminRooms", "admin/rooms", "~/Admin/Rooms.aspx")
    End Sub
End Class
