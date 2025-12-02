<%@ Page Title="Facilities - HotelCore" Language="vb" AutoEventWireup="false" MasterPageFile="~/Shared/Site.Master" CodeBehind="Facilities.aspx.vb" Inherits="HotelCore.Web.Facilities" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <!-- Breadcrumb Section -->
    <section class="hotelcore-breadcrumb">
        <div class="container">
            <h1>Our Facilities</h1>
            <div class="hotelcore-breadcrumb-nav">
                <a href="<%= ResolveUrl("~/Default.aspx") %>">Home</a>
                <span>/</span>
                <span>Facilities</span>
            </div>
        </div>
    </section>
    
    <!-- About Section -->
    <section class="aboutus-page-section spad">
        <div class="container">
            <div class="about-page-text">
                <div class="row">
                    <div class="col-lg-6">
                        <div class="ap-title">
                            <h2>World-Class Amenities</h2>
                            <p>At HotelCore, we pride ourselves on offering exceptional facilities that cater to every guest's needs. From relaxation to recreation, we have everything you need for a perfect stay.</p>
                        </div>
                        <ul class="ap-services">
                            <li><i class="icon_check"></i> 24/7 Front Desk Service</li>
                            <li><i class="icon_check"></i> Complimentary Wi-Fi</li>
                            <li><i class="icon_check"></i> Fine Dining Restaurant</li>
                            <li><i class="icon_check"></i> Full-Service Spa</li>
                            <li><i class="icon_check"></i> Fitness Center</li>
                            <li><i class="icon_check"></i> Business Center</li>
                        </ul>
                    </div>
                    <div class="col-lg-6">
                        <div class="row">
                            <div class="col-sm-6">
                                <img src="<%= ResolveUrl("~/Content/img/about/about-p1.jpg") %>" alt="Facility" class="img-fluid mb-4" />
                            </div>
                            <div class="col-sm-6">
                                <img src="<%= ResolveUrl("~/Content/img/about/about-p2.jpg") %>" alt="Facility" class="img-fluid mb-4" />
                            </div>
                            <div class="col-sm-6">
                                <img src="<%= ResolveUrl("~/Content/img/about/about-p3.jpg") %>" alt="Facility" class="img-fluid mb-4" />
                            </div>
                            <div class="col-sm-6">
                                <img src="<%= ResolveUrl("~/Content/img/about/about-1.jpg") %>" alt="Facility" class="img-fluid mb-4" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Services Section -->
    <section class="services-section spad bg-light">
        <div class="container">
            <div class="hotelcore-section-title">
                <span>What We Offer</span>
                <h2>Our Services & Facilities</h2>
            </div>
            <div class="row">
                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="hotelcore-card text-center h-100">
                        <i class="flaticon-033-dinner fa-4x text-sage mb-3"></i>
                        <h4>Fine Dining</h4>
                        <p>Experience culinary excellence at our award-winning restaurant. Our expert chefs create memorable dishes using the finest local and international ingredients.</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="hotelcore-card text-center h-100">
                        <i class="flaticon-024-towel fa-4x text-sage mb-3"></i>
                        <h4>Spa & Wellness</h4>
                        <p>Rejuvenate your body and mind at our full-service spa. Enjoy massages, facials, and wellness treatments in a tranquil setting.</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="hotelcore-card text-center h-100">
                        <i class="flaticon-034-dumbbell fa-4x text-sage mb-3"></i>
                        <h4>Fitness Center</h4>
                        <p>Stay fit during your stay with our state-of-the-art fitness center. Open 24/7 with modern equipment and personal training available.</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="hotelcore-card text-center h-100">
                        <i class="flaticon-035-swim fa-4x text-sage mb-3"></i>
                        <h4>Swimming Pool</h4>
                        <p>Take a refreshing dip in our temperature-controlled pool. Enjoy poolside service and comfortable loungers.</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="hotelcore-card text-center h-100">
                        <i class="flaticon-012-cocktail fa-4x text-sage mb-3"></i>
                        <h4>Bar & Lounge</h4>
                        <p>Unwind with premium cocktails and fine wines at our stylish bar. Enjoy live entertainment on selected evenings.</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="hotelcore-card text-center h-100">
                        <i class="flaticon-036-parking fa-4x text-sage mb-3"></i>
                        <h4>Valet Parking</h4>
                        <p>Enjoy complimentary valet parking with secure 24-hour surveillance. Electric vehicle charging stations available.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Additional Facilities -->
    <section class="hotelcore-section">
        <div class="container">
            <div class="hotelcore-section-title">
                <span>More Amenities</span>
                <h2>Additional Services</h2>
            </div>
            <div class="row">
                <div class="col-lg-3 col-md-4 col-6 mb-4">
                    <div class="text-center">
                        <i class="fa fa-wifi fa-2x text-sage mb-2"></i>
                        <h6>Free Wi-Fi</h6>
                    </div>
                </div>
                <div class="col-lg-3 col-md-4 col-6 mb-4">
                    <div class="text-center">
                        <i class="fa fa-plane fa-2x text-sage mb-2"></i>
                        <h6>Airport Transfer</h6>
                    </div>
                </div>
                <div class="col-lg-3 col-md-4 col-6 mb-4">
                    <div class="text-center">
                        <i class="fa fa-coffee fa-2x text-sage mb-2"></i>
                        <h6>Room Service</h6>
                    </div>
                </div>
                <div class="col-lg-3 col-md-4 col-6 mb-4">
                    <div class="text-center">
                        <i class="fa fa-briefcase fa-2x text-sage mb-2"></i>
                        <h6>Business Center</h6>
                    </div>
                </div>
                <div class="col-lg-3 col-md-4 col-6 mb-4">
                    <div class="text-center">
                        <i class="fa fa-users fa-2x text-sage mb-2"></i>
                        <h6>Conference Rooms</h6>
                    </div>
                </div>
                <div class="col-lg-3 col-md-4 col-6 mb-4">
                    <div class="text-center">
                        <i class="fa fa-child fa-2x text-sage mb-2"></i>
                        <h6>Kids Club</h6>
                    </div>
                </div>
                <div class="col-lg-3 col-md-4 col-6 mb-4">
                    <div class="text-center">
                        <i class="fa fa-paw fa-2x text-sage mb-2"></i>
                        <h6>Pet Friendly</h6>
                    </div>
                </div>
                <div class="col-lg-3 col-md-4 col-6 mb-4">
                    <div class="text-center">
                        <i class="fa fa-wheelchair fa-2x text-sage mb-2"></i>
                        <h6>Accessibility</h6>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
    <!-- CTA Section -->
    <section class="hotelcore-section bg-sage text-cream text-center">
        <div class="container">
            <div class="row">
                <div class="col-lg-8 offset-lg-2">
                    <h2 class="text-white mb-4">Experience Our Facilities</h2>
                    <p class="mb-4">Book your stay today and enjoy world-class amenities that make HotelCore your home away from home.</p>
                    <a href="<%= ResolveUrl("~/Booking/Search.aspx") %>" class="btn-book-now">Book Your Stay</a>
                </div>
            </div>
        </div>
    </section>
    
</asp:Content>
