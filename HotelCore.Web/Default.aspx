<%@ Page Title="Home - HotelCore" Language="vb" AutoEventWireup="false" MasterPageFile="~/Shared/Site.Master" CodeBehind="Default.aspx.vb" Inherits="HotelCore.Web._Default" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <!-- Hero Section -->
    <section class="hero-section">
        <div class="container">
            <div class="row">
                <div class="col-lg-6">
                    <div class="hero-text">
                        <h1>Welcome to HotelCore</h1>
                        <p>Experience luxury and comfort like never before. Book your perfect stay with us and create unforgettable memories.</p>
                        <a href="<%= ResolveUrl("~/Booking/Search.aspx") %>" class="btn-hotelcore btn-hotelcore-primary">Explore Rooms</a>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="booking-form">
                        <h3>Book Your Stay</h3>
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
                            <label>Guests</label>
                            <asp:DropDownList ID="ddlGuests" runat="server" CssClass="form-control">
                                <asp:ListItem Value="1">1 Guest</asp:ListItem>
                                <asp:ListItem Value="2" Selected="True">2 Guests</asp:ListItem>
                                <asp:ListItem Value="3">3 Guests</asp:ListItem>
                                <asp:ListItem Value="4">4 Guests</asp:ListItem>
                                <asp:ListItem Value="5">5+ Guests</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <asp:Button ID="btnCheckAvailability" runat="server" Text="Check Availability" CssClass="btn-search-rooms" OnClick="btnCheckAvailability_Click" />
                    </div>
                </div>
            </div>
        </div>
        <div class="hero-slider owl-carousel">
            <div class="hs-item set-bg" data-setbg="<%= ResolveUrl("~/Content/img/hero/hero-1.jpg") %>"></div>
            <div class="hs-item set-bg" data-setbg="<%= ResolveUrl("~/Content/img/hero/hero-2.jpg") %>"></div>
            <div class="hs-item set-bg" data-setbg="<%= ResolveUrl("~/Content/img/hero/hero-3.jpg") %>"></div>
        </div>
    </section>
    
    <!-- About Section -->
    <section class="hotelcore-section">
        <div class="container">
            <div class="row">
                <div class="col-lg-6">
                    <div class="about-pic">
                        <div class="row">
                            <div class="col-sm-6">
                                <img src="<%= ResolveUrl("~/Content/img/about/about-1.jpg") %>" alt="About Hotel" class="img-fluid mb-4" />
                            </div>
                            <div class="col-sm-6">
                                <img src="<%= ResolveUrl("~/Content/img/about/about-2.jpg") %>" alt="About Hotel" class="img-fluid mb-4" />
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="about-text">
                        <div class="hotelcore-section-title text-left">
                            <span>About Us</span>
                            <h2>A Sanctuary of Luxury</h2>
                        </div>
                        <p class="f-para">HotelCore offers an unparalleled hospitality experience. Our commitment to excellence ensures every guest enjoys world-class service, luxurious accommodations, and memorable moments.</p>
                        <p class="s-para">From our elegantly appointed rooms to our gourmet dining options and spa services, every aspect of your stay is designed with your comfort in mind. Experience the perfect blend of modern amenities and timeless hospitality.</p>
                        <a href="<%= ResolveUrl("~/Facilities.aspx") %>" class="btn-hotelcore btn-hotelcore-outline">Discover More</a>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Services Section -->
    <section class="services-section spad">
        <div class="container">
            <div class="hotelcore-section-title">
                <span>What We Offer</span>
                <h2>Our Services</h2>
            </div>
            <div class="row">
                <div class="col-lg-4 col-sm-6">
                    <div class="service-item">
                        <i class="flaticon-036-parking"></i>
                        <h4>Free Parking</h4>
                        <p>Complimentary secure parking for all our guests with 24-hour surveillance.</p>
                    </div>
                </div>
                <div class="col-lg-4 col-sm-6">
                    <div class="service-item">
                        <i class="flaticon-033-dinner"></i>
                        <h4>Fine Dining</h4>
                        <p>Experience culinary excellence at our award-winning restaurant.</p>
                    </div>
                </div>
                <div class="col-lg-4 col-sm-6">
                    <div class="service-item">
                        <i class="flaticon-026-bed"></i>
                        <h4>Premium Rooms</h4>
                        <p>Luxuriously appointed rooms with premium bedding and amenities.</p>
                    </div>
                </div>
                <div class="col-lg-4 col-sm-6">
                    <div class="service-item">
                        <i class="flaticon-024-towel"></i>
                        <h4>Spa & Wellness</h4>
                        <p>Rejuvenate your body and mind at our full-service spa.</p>
                    </div>
                </div>
                <div class="col-lg-4 col-sm-6">
                    <div class="service-item">
                        <i class="flaticon-044-clock-1"></i>
                        <h4>24/7 Service</h4>
                        <p>Round-the-clock concierge and room service for your convenience.</p>
                    </div>
                </div>
                <div class="col-lg-4 col-sm-6">
                    <div class="service-item">
                        <i class="flaticon-012-cocktail"></i>
                        <h4>Bar & Lounge</h4>
                        <p>Unwind with premium cocktails and live entertainment.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Featured Rooms Section -->
    <section class="hp-room-section">
        <div class="container-fluid">
            <div class="hotelcore-section-title">
                <span>Our Accommodations</span>
                <h2>Featured Rooms</h2>
            </div>
            <div class="hp-room-items">
                <div class="row">
                    <div class="col-lg-4 col-md-6">
                        <div class="hp-room-item set-bg" data-setbg="<%= ResolveUrl("~/Content/img/room/room-b1.jpg") %>">
                            <div class="hr-text">
                                <h3>Deluxe Room</h3>
                                <h2>$150<span>/Night</span></h2>
                                <table>
                                    <tbody>
                                        <tr>
                                            <td class="r-o">Size:</td>
                                            <td>35 m²</td>
                                        </tr>
                                        <tr>
                                            <td class="r-o">Capacity:</td>
                                            <td>2 Guests</td>
                                        </tr>
                                        <tr>
                                            <td class="r-o">Bed:</td>
                                            <td>King Size</td>
                                        </tr>
                                    </tbody>
                                </table>
                                <a href="<%= ResolveUrl("~/Booking/Search.aspx") %>" class="primary-btn">Book Now</a>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-4 col-md-6">
                        <div class="hp-room-item set-bg" data-setbg="<%= ResolveUrl("~/Content/img/room/room-b2.jpg") %>">
                            <div class="hr-text">
                                <h3>Executive Suite</h3>
                                <h2>$250<span>/Night</span></h2>
                                <table>
                                    <tbody>
                                        <tr>
                                            <td class="r-o">Size:</td>
                                            <td>55 m²</td>
                                        </tr>
                                        <tr>
                                            <td class="r-o">Capacity:</td>
                                            <td>4 Guests</td>
                                        </tr>
                                        <tr>
                                            <td class="r-o">Bed:</td>
                                            <td>2 Queen Size</td>
                                        </tr>
                                    </tbody>
                                </table>
                                <a href="<%= ResolveUrl("~/Booking/Search.aspx") %>" class="primary-btn">Book Now</a>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-4 col-md-6">
                        <div class="hp-room-item set-bg" data-setbg="<%= ResolveUrl("~/Content/img/room/room-b3.jpg") %>">
                            <div class="hr-text">
                                <h3>Presidential Suite</h3>
                                <h2>$450<span>/Night</span></h2>
                                <table>
                                    <tbody>
                                        <tr>
                                            <td class="r-o">Size:</td>
                                            <td>100 m²</td>
                                        </tr>
                                        <tr>
                                            <td class="r-o">Capacity:</td>
                                            <td>6 Guests</td>
                                        </tr>
                                        <tr>
                                            <td class="r-o">Bed:</td>
                                            <td>3 King Size</td>
                                        </tr>
                                    </tbody>
                                </table>
                                <a href="<%= ResolveUrl("~/Booking/Search.aspx") %>" class="primary-btn">Book Now</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Testimonials Section -->
    <section class="testimonial-section spad">
        <div class="container">
            <div class="hotelcore-section-title">
                <span>Testimonials</span>
                <h2>What Our Guests Say</h2>
            </div>
            <div class="row">
                <div class="col-lg-8 offset-lg-2">
                    <div class="testimonial-slider owl-carousel">
                        <div class="ts-item">
                            <p>"An absolutely wonderful experience! The staff was incredibly attentive, and the rooms were immaculate. I can't wait to return."</p>
                            <div class="ti-author">
                                <div class="rating">
                                    <i class="icon_star"></i>
                                    <i class="icon_star"></i>
                                    <i class="icon_star"></i>
                                    <i class="icon_star"></i>
                                    <i class="icon_star"></i>
                                </div>
                                <h5> - Sarah Johnson</h5>
                            </div>
                            <img src="<%= ResolveUrl("~/Content/img/testimonial-logo.png") %>" alt="Testimonial" />
                        </div>
                        <div class="ts-item">
                            <p>"Perfect location, stunning views, and exceptional service. HotelCore exceeded all my expectations. Highly recommended!"</p>
                            <div class="ti-author">
                                <div class="rating">
                                    <i class="icon_star"></i>
                                    <i class="icon_star"></i>
                                    <i class="icon_star"></i>
                                    <i class="icon_star"></i>
                                    <i class="icon_star"></i>
                                </div>
                                <h5> - Michael Chen</h5>
                            </div>
                            <img src="<%= ResolveUrl("~/Content/img/testimonial-logo.png") %>" alt="Testimonial" />
                        </div>
                        <div class="ts-item">
                            <p>"The spa was divine, and the restaurant served the most delicious food. A truly five-star experience from start to finish."</p>
                            <div class="ti-author">
                                <div class="rating">
                                    <i class="icon_star"></i>
                                    <i class="icon_star"></i>
                                    <i class="icon_star"></i>
                                    <i class="icon_star"></i>
                                    <i class="icon_star-half_alt"></i>
                                </div>
                                <h5> - Emma Williams</h5>
                            </div>
                            <img src="<%= ResolveUrl("~/Content/img/testimonial-logo.png") %>" alt="Testimonial" />
                        </div>
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
                    <h2 class="text-white mb-4">Ready for an Unforgettable Stay?</h2>
                    <p class="mb-4">Book your room today and experience the finest hospitality. Special rates available for extended stays.</p>
                    <a href="<%= ResolveUrl("~/Booking/Search.aspx") %>" class="btn-book-now">Book Your Stay</a>
                </div>
            </div>
        </div>
    </section>
    
</asp:Content>
