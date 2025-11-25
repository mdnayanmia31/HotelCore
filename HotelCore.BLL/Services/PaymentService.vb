'' Business Logic Service for Payment Operations

Imports HotelCore.DAL

Public Class PaymentService

    Private ReadOnly _paymentRepo As IPaymentRepository

    Public Sub New()
        _paymentRepo = New PaymentRepository()
    End Sub

    Public Sub New(paymentRepo As IPaymentRepository)
        _paymentRepo = paymentRepo
    End Sub

    '' Process payment for booking
    Public Function ProcessPayment(model As PaymentModel, currentUserID As Integer) As OperationResult(Of PaymentModel)
        Dim result As New OperationResult(Of PaymentModel)

        Try
            ' BUSINESS RULE VALIDATION
            If model.Amount <= 0 Then
                result.Success = False
                result.ErrorMessage = "Payment amount must be greater than zero"
                Return result
            End If

            If model.Amount > 50000 Then
                result.Success = False
                result.ErrorMessage = "Payment amount exceeds maximum limit"
                Return result
            End If

            If String.IsNullOrWhiteSpace(model.PaymentMethod) Then
                result.Success = False
                result.ErrorMessage = "Payment method is required"
                Return result
            End If

            ' Call DAL
            Dim errorCode As Integer = 0
            Dim errorMessage As String = ""

            Dim paymentID As Integer = _paymentRepo.CreatePayment(
                model.BookingID,
                model.PaymentMethod,
                model.Amount,
                model.ProcessorTransactionID,
                currentUserID,
                errorCode,
                errorMessage
            )

            If paymentID > 0 AndAlso errorCode = 0 Then
                model.PaymentID = paymentID
                result.Success = True
                result.Data = model
                result.Message = "Payment processed successfully"
            Else
                result.Success = False
                result.ErrorCode = errorCode
                result.ErrorMessage = errorMessage
            End If

        Catch ex As Exception
            result.Success = False
            result.ErrorMessage = $"Error processing payment: {ex.Message}"
        End Try

        Return result
    End Function

    '' Process refund
    Public Function ProcessRefund(paymentID As Integer, refundAmount As Decimal, currentUserID As Integer) As OperationResult
        Dim result As New OperationResult


        Try
            ' BUSINESS RULE VALIDATION
            If refundAmount <= 0 Then
                result.Success = False
                result.ErrorMessage = "Refund amount must be greater than zero"
                Return result
            End If

            ' Call DAL
            Dim errorCode As Integer = 0
            Dim errorMessage As String = ""

            Dim success As Boolean = _paymentRepo.ProcessRefund(
                paymentID,
                refundAmount,
                currentUserID,
                errorCode,
                errorMessage
            )

            If success AndAlso errorCode = 0 Then
                result.Success = True
                result.Message = "Refund processed successfully"
            Else
                result.Success = False
                result.ErrorCode = errorCode
                result.ErrorMessage = errorMessage
            End If

        Catch ex As Exception
            result.Success = False
            result.ErrorMessage = $"Error processing refund: {ex.Message}"
        End Try

        Return result
    End Function

End Class
