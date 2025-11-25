USE HotelCore;
GO

-- SP: Payment Process Refund
CREATE OR ALTER PROCEDURE sp_Payment_ProcessRefund
    @PaymentID INT,
    @RefundAmount DECIMAL(10,2),
    @CurrentUserID INT,
    @ErrorCode INT OUTPUT,
    @ErrorMessage NVARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @ErrorCode = 0;
    SET @ErrorMessage = NULL;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @Amount DECIMAL(10,2), @RefundedAmount DECIMAL(10,2), @Status NVARCHAR(20);
        SELECT @Amount = Amount, @RefundedAmount = RefundedAmount, @Status = Status
        FROM Payments WHERE PaymentID = @PaymentID;

        IF @Amount IS NULL
        BEGIN
            SET @ErrorCode = -1;
            SET @ErrorMessage = 'Payment not found';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        IF @Status NOT IN ('Captured', 'Authorized')
        BEGIN
            SET @ErrorCode = -2;
            SET @ErrorMessage = 'Payment cannot be refunded';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        IF (@RefundedAmount + @RefundAmount) > @Amount
        BEGIN
            SET @ErrorCode = -3;
            SET @ErrorMessage = 'Refund amount exceeds payment amount';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        DECLARE @NewRefundedAmount DECIMAL(10,2) = @RefundedAmount + @RefundAmount;
        DECLARE @NewStatus NVARCHAR(20) = CASE 
            WHEN @NewRefundedAmount >= @Amount THEN 'Refunded'
            ELSE 'PartialRefund'
        END;

        UPDATE Payments
        SET RefundedAmount = @NewRefundedAmount,
            Status = @NewStatus,
            RefundedDate = GETUTCDATE()
        WHERE PaymentID = @PaymentID;

        -- Audit log
        INSERT INTO AuditLog (UserID, TableName, RecordID, ActionType, NewValues, CreatedDate)
        VALUES (@CurrentUserID, 'Payments', @PaymentID, 'UPDATE', 
                'Refund=' + CAST(@RefundAmount AS NVARCHAR), GETUTCDATE());

        COMMIT TRANSACTION;
        SET @ErrorMessage = 'Refund processed successfully';

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @ErrorCode = -999;
        SET @ErrorMessage = ERROR_MESSAGE();
    END CATCH
END
GO