USE HotelCore;
GO

-- SP: Payment Create
CREATE OR ALTER PROCEDURE sp_Payment_Create
    @BookingID INT,
    @PaymentMethod NVARCHAR(50),
    @Amount DECIMAL(10,2),
    @ProcessorTransactionID NVARCHAR(200) = NULL,
    @CurrentUserID INT,
    @PaymentID INT OUTPUT,
    @ErrorCode INT OUTPUT,
    @ErrorMessage NVARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @PaymentID = NULL;
    SET @ErrorCode = 0;
    SET @ErrorMessage = NULL;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM Bookings WHERE BookingID = @BookingID)
        BEGIN
            SET @ErrorCode = -1;
            SET @ErrorMessage = 'Booking not found';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        DECLARE @PaymentReference NVARCHAR(100);
        SET @PaymentReference = 'PAY' + FORMAT(GETUTCDATE(), 'yyyyMMddHHmmss') + '-' + 
                                RIGHT('0000' + CAST(ABS(CHECKSUM(NEWID())) % 10000 AS NVARCHAR), 4);

        INSERT INTO Payments (
            BookingID, PaymentReference, PaymentMethod, Amount,
            Status, ProcessorTransactionID, PaymentDate, CreatedBy, CreatedDate
        )
        VALUES (
            @BookingID, @PaymentReference, @PaymentMethod, @Amount,
            'Captured', @ProcessorTransactionID, GETUTCDATE(), @CurrentUserID, GETUTCDATE()
        );

        SET @PaymentID = SCOPE_IDENTITY();

        -- Update booking status if full payment received
        DECLARE @TotalAmount DECIMAL(10,2), @TotalPaid DECIMAL(10,2);
        SELECT @TotalAmount = TotalAmount FROM Bookings WHERE BookingID = @BookingID;
        SELECT @TotalPaid = SUM(Amount) FROM Payments 
        WHERE BookingID = @BookingID AND Status IN ('Captured', 'Authorized');

        IF @TotalPaid >= @TotalAmount
        BEGIN
            UPDATE Bookings 
            SET Status = 'Confirmed',
                ModifiedBy = @CurrentUserID,
                ModifiedDate = GETUTCDATE()
            WHERE BookingID = @BookingID AND Status = 'Pending';
        END

        COMMIT TRANSACTION;
        SET @ErrorMessage = 'Payment processed successfully';

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @ErrorCode = -999;
        SET @ErrorMessage = ERROR_MESSAGE();
    END CATCH
END
GO
