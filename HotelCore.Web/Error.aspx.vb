Namespace HotelCore.Web
    Public Class ErrorPage
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
            Dim statusCode As Integer = 500
            Dim errorCode As String = Request.QueryString("code")

            If Not String.IsNullOrEmpty(errorCode) Then
                Integer.TryParse(errorCode, statusCode)
            End If

            SetErrorContent(statusCode)
        End Sub

        Private Sub SetErrorContent(statusCode As Integer)
            Select Case statusCode
                Case 404
                    litErrorCode.Text = "404"
                    litErrorTitle.Text = "Page Not Found"
                    litErrorMessage.Text = "The page you are looking for might have been removed, had its name changed, or is temporarily unavailable."
                    Page.Title = "Page Not Found - HotelCore"
                Case 403
                    litErrorCode.Text = "403"
                    litErrorTitle.Text = "Access Denied"
                    litErrorMessage.Text = "You do not have permission to access this resource."
                    Page.Title = "Access Denied - HotelCore"
                Case 500
                    litErrorCode.Text = "500"
                    litErrorTitle.Text = "Internal Server Error"
                    litErrorMessage.Text = "We apologize for the inconvenience. Our team has been notified and is working to resolve the issue."
                    Page.Title = "Server Error - HotelCore"
                Case Else
                    litErrorCode.Text = statusCode.ToString()
                    litErrorTitle.Text = "An Error Occurred"
                    litErrorMessage.Text = "We apologize for the inconvenience. Please try again later."
                    Page.Title = "Error - HotelCore"
            End Select
        End Sub

    End Class
End Namespace
