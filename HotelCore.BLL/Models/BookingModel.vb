''  DTO for Booking data transfer object
Public Class BookingModel
    Public Property BookingID As Integer
    Public Property BookingReference As String
    Public Property UserID As Integer
    Public Property RoomID As Integer
    Public Property RoomNumber As String
    Public Property RoomType As String
    Public Property ConfigID As Integer?
    Public Property StartDateTime As DateTime
    Public Property EndDateTime As DateTime
    Public Property GuestCount As Integer
    Public Property AdultCount As Integer
    Public Property ChildCount As Integer
    Public Property InfantCount As Integer
    Public Property Guests As New List(Of GuestModel)
    Public Property SpecialRequests As String
    Public Property TotalAmount As Decimal
    Public Property DepositAmount As Decimal
    Public Property Status As String
    Public Property CheckInDateTime As DateTime?
    Public Property CheckOutDateTime As DateTime?
    Public Property CreatedDate As DateTime
    Public Property Payments As New List(Of PaymentModel)
    Public Property CancelledDate As DateTime?
    Public Property CancellationReason As String
End Class