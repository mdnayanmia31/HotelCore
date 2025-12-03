(function ($) {
    'use strict';

    var HotelCore = {
        init: function () {
            this.initDatepickers();
            this.initPriceRangeSlider();
            this.initBackgroundImages();
            this.initFormValidation();
            this.initCarousels();
        },

        initDatepickers: function () {
            if ($.fn.datepicker) {
                $('.datepicker').datepicker({
                    dateFormat: 'mm/dd/yy',
                    minDate: 0,
                    changeMonth: true,
                    changeYear: true,
                    showAnim: 'fadeIn'
                });

                $('.datepicker-checkout').datepicker({
                    dateFormat: 'mm/dd/yy',
                    minDate: 1,
                    changeMonth: true,
                    changeYear: true,
                    showAnim: 'fadeIn'
                });
            }
        },

        initPriceRangeSlider: function () {
            if ($.fn.slider) {
                $('#priceRangeSlider').slider({
                    range: true,
                    min: 0,
                    max: 1000,
                    values: [50, 500],
                    slide: function (event, ui) {
                        $('#priceRangeMin').val(ui.values[0]);
                        $('#priceRangeMax').val(ui.values[1]);
                        $('#priceRangeDisplay').text('$' + ui.values[0] + ' - $' + ui.values[1]);
                    }
                });
            }
        },

        initBackgroundImages: function () {
            $('[data-setbg]').each(function () {
                var bg = $(this).data('setbg');
                if (bg) {
                    $(this).css('background-image', 'url(' + bg + ')');
                }
            });
        },

        initFormValidation: function () {
            $('.hotelcore-form').on('submit', function () {
                var isValid = true;
                var $form = $(this);

                $form.find('[required]').each(function () {
                    var $field = $(this);
                    if (!$field.val().trim()) {
                        isValid = false;
                        $field.addClass('is-invalid');
                    } else {
                        $field.removeClass('is-invalid');
                    }
                });

                $form.find('input[type="email"]').each(function () {
                    var $field = $(this);
                    var email = $field.val().trim();
                    if (email && !HotelCore.isValidEmail(email)) {
                        isValid = false;
                        $field.addClass('is-invalid');
                    }
                });

                return isValid;
            });

            $('.hotelcore-form input, .hotelcore-form select, .hotelcore-form textarea').on('change blur', function () {
                var $field = $(this);
                if ($field.val().trim()) {
                    $field.removeClass('is-invalid');
                }
            });
        },

        initCarousels: function () {
            if ($.fn.owlCarousel) {
                $('.hero-slider').owlCarousel({
                    loop: true,
                    nav: false,
                    dots: false,
                    mouseDrag: false,
                    animateOut: 'fadeOut',
                    animateIn: 'fadeIn',
                    items: 1,
                    autoplay: true,
                    autoplayTimeout: 5000
                });

                $('.testimonial-slider').owlCarousel({
                    loop: true,
                    nav: false,
                    dots: true,
                    items: 1,
                    autoplay: true,
                    autoplayTimeout: 6000,
                    smartSpeed: 1000
                });
            }
        },

        isValidEmail: function (email) {
            var regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return regex.test(email);
        },

        formatCurrency: function (amount) {
            return '$' + parseFloat(amount).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,');
        },

        calculateNights: function (checkIn, checkOut) {
            var oneDay = 24 * 60 * 60 * 1000;
            var startDate = new Date(checkIn);
            var endDate = new Date(checkOut);
            return Math.round(Math.abs((endDate - startDate) / oneDay));
        }
    };

    $(document).ready(function () {
        HotelCore.init();
    });

    window.HotelCore = HotelCore;

})(jQuery);
