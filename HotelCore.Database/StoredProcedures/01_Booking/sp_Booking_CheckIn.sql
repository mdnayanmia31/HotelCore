USE HotelCore;
GO

-- SP: Booking Check-In

CREATE OR ALTER PROCEDURE sp_Booking_CheckIn
    @BookingID INT,
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
        
        DECLARE @Status NVARCHAR(20), @RoomID INT, @StartDateTime DATETIME2;
            SELECT @Status = Status, @RoomID = RoomID, @StartDateTime = StartDateTime
            FROM Bookings WHERE BookingID = @BookingID;
        
        IF @Status IS NULL
            BEGIN 
                SET @ErrorCode = -1;
                SET @ErrorMessage = 'Booking not found';
                ROLLBACK TRANSACTION;
                RETURN;
            END
        
        IF @Status != 'Confirmed'
        BEGIN 
            SET @ErrorCode = -2;
            SET @ErrorMessage = 'Only confirmed bookings can be checked in';
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        IF GETUTCDATE() < DATEADD(HOUR, -2, @StartDateTime)
            BEGIN 
                SET @ErrorCode = -3;
                SET @ErrorMessage = 'Check-in too early. Available 2 hours before booking time';
                ROLLBACK TRANSACTION;
                RETURN;
            END
            
            UPDATE Bookings
            SET Status = 'CheckedIn',
                CheckInDateTime = GETUTCDATE(),
                ModifiedBy = @CurrentUserID,
                ModifiedDate = GETUTCDATE()
            WHERE BookingID = @BookingID;
        UPDATE Rooms
        SET Status = 'Occupied',
            ModifiedBy = @CurrentUserID,
            ModifiedDate = GETUTCDATE()
        WHERE RoomID = @RoomID;
        
        -- Audit log
        INSERT INTO AuditLog (UserID, TableName, RecordID, ActionType, NewValues, CreatedDate)
            VALUES(@CurrentUserID, 'Bookings', @BookingID, 'UPDATE', 'Status=CheckedIn', GETUTCDATE());
        
        COMMIT TRANSACTION;
        SET @ErrorMessage = 'Check-in successful';
        
        END TRY
        BEGIN CATCH 
            IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
            SET @ErrorCode = -999;
            SET @ErrorMessage = ERROR_MESSAGE();
        END CATCH

END
GO