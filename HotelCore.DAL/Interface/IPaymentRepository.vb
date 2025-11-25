Public Interface IPaymentRepository
    Function CreatePayment(bookingID As Integer, paymentMethod As String, amount As Decimal,
                          processorTransactionID As String, currentUserID As Integer,
                          ByRef errorCode As Integer, ByRef errorMessage As String) As Integer

    Function ProcessRefund(paymentID As Integer, refundAmount As Decimal, currentUserID As Integer,
                          ByRef errorCode As Integer, ByRef errorMessage As String) As Boolean
End Interface
