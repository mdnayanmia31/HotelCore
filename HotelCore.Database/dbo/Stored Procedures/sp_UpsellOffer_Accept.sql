
-- SP: Upsell Offer Accept
CREATE   PROCEDURE sp_UpsellOffer_Accept
    @OfferID INT,
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

        DECLARE @Status NVARCHAR(20), @BookingID INT, @OfferAmount DECIMAL(10,2);
        SELECT @Status = Status, @BookingID = BookingID, @OfferAmount = OfferAmount
        FROM UpsellOffers WHERE OfferID = @OfferID;

        IF @Status IS NULL
        BEGIN
            SET @ErrorCode = -1;
            SET @ErrorMessage = 'Upsell offer not found';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        IF @Status != 'Offered'
        BEGIN
            SET @ErrorCode = -2;
            SET @ErrorMessage = 'Offer already ' + @Status;
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Update offer status
        UPDATE UpsellOffers
        SET Status = 'Accepted',
            ResponseDate = GETUTCDATE()
        WHERE OfferID = @OfferID;

        -- Add upsell amount to booking
        UPDATE Bookings
        SET TotalAmount = TotalAmount + @OfferAmount,
            ModifiedBy = @CurrentUserID,
            ModifiedDate = GETUTCDATE()
        WHERE BookingID = @BookingID;

        -- Audit log
        INSERT INTO AuditLog (UserID, TableName, RecordID, ActionType, NewValues, CreatedDate)
        VALUES (@CurrentUserID, 'UpsellOffers', @OfferID, 'UPDATE', 
                'Status=Accepted,Amount=' + CAST(@OfferAmount AS NVARCHAR), GETUTCDATE());

        COMMIT TRANSACTION;
        SET @ErrorMessage = 'Upsell offer accepted successfully';

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @ErrorCode = -999;
        SET @ErrorMessage = ERROR_MESSAGE();
    END CATCH
END
