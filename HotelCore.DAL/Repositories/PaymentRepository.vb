Imports System.Data
Imports System.Data.SqlClient

Public Class PaymentRepository
    Implements IPaymentRepository

    Public Function CreatePayment(bookingID As Integer, paymentMethod As String, amount As Decimal,
                                 processorTransactionID As String, currentUserID As Integer,
                                 ByRef errorCode As Integer, ByRef errorMessage As String) As Integer Implements IPaymentRepository.CreatePayment

        Dim paymentID As Integer = 0

        Dim parameters As New List(Of SqlParameter) From {
            SqlHelper.CreateParameter("@BookingID", SqlDbType.Int, bookingID),
            SqlHelper.CreateParameter("@PaymentMethod", SqlDbType.NVarChar, paymentMethod),
            SqlHelper.CreateParameter("@Amount", SqlDbType.Decimal, amount),
            SqlHelper.CreateParameter("@ProcessorTransactionID", SqlDbType.NVarChar, processorTransactionID),
            SqlHelper.CreateParameter("@CurrentUserID", SqlDbType.Int, currentUserID),
            SqlHelper.CreateOutputParameter("@PaymentID", SqlDbType.Int),
            SqlHelper.CreateOutputParameter("@ErrorCode", SqlDbType.Int),
            SqlHelper.CreateOutputParameter("@ErrorMessage", SqlDbType.NVarChar, 500)
        }

        Dim outputParams As New Dictionary(Of String, Object) From {
            {"@PaymentID", Nothing},
            {"@ErrorCode", Nothing},
            {"@ErrorMessage", Nothing}
        }

        SqlHelper.ExecuteWithOutputs("sp_Payment_Create", outputParams, parameters.ToArray())

        paymentID = SqlHelper.SafeGetValue(outputParams("@PaymentID"), 0)
        errorCode = SqlHelper.SafeGetValue(outputParams("@ErrorCode"), -999)
        errorMessage = SqlHelper.SafeGetValue(outputParams("@ErrorMessage"), "Unknown error")

        Return paymentID
    End Function

    Public Function ProcessRefund(paymentID As Integer, refundAmount As Decimal, currentUserID As Integer,
                                 ByRef errorCode As Integer, ByRef errorMessage As String) As Boolean Implements IPaymentRepository.ProcessRefund

        Dim parameters As New List(Of SqlParameter) From {
            SqlHelper.CreateParameter("@PaymentID", SqlDbType.Int, paymentID),
            SqlHelper.CreateParameter("@RefundAmount", SqlDbType.Decimal, refundAmount),
            SqlHelper.CreateParameter("@CurrentUserID", SqlDbType.Int, currentUserID),
            SqlHelper.CreateOutputParameter("@ErrorCode", SqlDbType.Int),
            SqlHelper.CreateOutputParameter("@ErrorMessage", SqlDbType.NVarChar, 500)
        }

        Dim outputParams As New Dictionary(Of String, Object) From {
            {"@ErrorCode", Nothing},
            {"@ErrorMessage", Nothing}
        }

        SqlHelper.ExecuteWithOutputs("sp_Payment_ProcessRefund", outputParams, parameters.ToArray())

        errorCode = SqlHelper.SafeGetValue(outputParams("@ErrorCode"), -999)
        errorMessage = SqlHelper.SafeGetValue(outputParams("@ErrorMessage"), "Unknown error")

        Return errorCode = 0
    End Function

End Class