Imports System.Web.Optimization
Imports System.Web.Routing

Namespace HotelCore.Web
    Public Class Global_asax
        Inherits HttpApplication

        Sub Application_Start(sender As Object, e As EventArgs)
            RouteConfig.RegisterRoutes(RouteTable.Routes)
            BundleConfig.RegisterBundles(BundleTable.Bundles)
        End Sub

        Sub Application_Error(sender As Object, e As EventArgs)
            Dim ex As Exception = Server.GetLastError()
            If ex IsNot Nothing Then
                Dim httpEx As HttpException = TryCast(ex, HttpException)
                Dim statusCode As Integer = 500
                If httpEx IsNot Nothing Then
                    statusCode = httpEx.GetHttpCode()
                End If
                Server.ClearError()
                Response.Redirect("~/Error.aspx?code=" & statusCode.ToString(), False)
            End If
        End Sub
    End Class
End Namespace