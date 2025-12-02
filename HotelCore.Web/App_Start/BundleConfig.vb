Imports System.Web.Optimization

Public Class BundleConfig
    Public Shared Sub RegisterBundles(ByVal bundles As BundleCollection)
        ' CSS Bundles
        bundles.Add(New StyleBundle("~/bundles/css").Include(
            "~/Content/css/bootstrap.min.css",
            "~/Content/css/font-awesome.min.css",
            "~/Content/css/elegant-icons.css",
            "~/Content/css/flaticon.css",
            "~/Content/css/owl.carousel.min.css",
            "~/Content/css/nice-select.css",
            "~/Content/css/jquery-ui.min.css",
            "~/Content/css/magnific-popup.css",
            "~/Content/css/slicknav.min.css",
            "~/Content/css/style.css",
            "~/Content/css/HotelCore-custom.css",
            "~/Content/css/Site.css"))

        ' JavaScript Bundles
        bundles.Add(New ScriptBundle("~/bundles/jquery").Include(
            "~/Scripts/jquery-3.3.1.min.js"))

        bundles.Add(New ScriptBundle("~/bundles/jqueryui").Include(
            "~/Scripts/jquery-ui.min.js"))

        bundles.Add(New ScriptBundle("~/bundles/bootstrap").Include(
            "~/Scripts/bootstrap.min.js"))

        bundles.Add(New ScriptBundle("~/bundles/plugins").Include(
            "~/Scripts/jquery.nice-select.min.js",
            "~/Scripts/jquery.magnific-popup.min.js",
            "~/Scripts/owl.carousel.min.js",
            "~/Scripts/jquery.slicknav.js",
            "~/Scripts/main.js"))

        ' jQuery Validation Bundle
        bundles.Add(New ScriptBundle("~/bundles/jqueryval").Include(
            "~/Scripts/jquery.validate.min.js",
            "~/Scripts/jquery.validate.unobtrusive.min.js"))

        ' Custom Scripts Bundle
        bundles.Add(New ScriptBundle("~/bundles/custom").Include(
            "~/Scripts/hotelcore.js"))

        ' Enable bundling optimization in release mode
        BundleTable.EnableOptimizations = False
    End Sub
End Class
