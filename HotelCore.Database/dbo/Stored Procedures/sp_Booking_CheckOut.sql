
-- SP: Booking Check Out
CREATE   PROCEDURE sp_Booking_CheckOut
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
        DECLARE @Status NVARCHAR(20), @RoomID INT;
        SELECT @Status = Status, @RoomID = RoomID
        FROM Bookings WHERE BookingID = @BookingID;
        
        IF @Status IS NULL
        BEGIN 
            SET @ErrorCode = -1;
            SET @ErrorMessage = 'Booking not found';
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        IF @Status != 'CheckedIn'
        BEGIN
            SET @ErrorCode = -2;
            SET @ErrorMessage = 'Only checked-in bookings can be checked out';
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        UPDATE Bookings
        SET Status = 'CheckedOut',
            CheckOutDateTime = GETUTCDATE(),
            ModifiedBy = @CurrentUserID,
            ModifiedDate = GETUTCDATE()
        WHERE BookingID = @BookingID;
        
        UPDATE Rooms
            SET Status = 'Cleaning',
                ModifiedBy = @CurrentUserID,
                ModifiedDate = GETUTCDATE()
            WHERE RoomID = @RoomID;
        
        -- create cleaning task
        INSERT INTO HousekeepingTasks (
                                       RoomID, BookingID, TaskType, Priority,  Status, DueDateTime, EstimatedMinutes, CreatedBy
        ) VALUES (
                  @RoomID, @BookingID, 'Checkout', 'High', 'Pending',
            DATEADD(MINUTE, 30, GETUTCDATE()), 30, @CurrentUserID
        );
        
        -- Audit log
        INSERT INTO AuditLog (UserID, TableName, RecordID, ActionType, NewValues, CreatedDate)
        VALUES (@CurrentUserID, 'Bookings', @BookingID, 'UPDATE', 'Status=CheckedOut', GETUTCDATE());
        
        COMMIT TRANSACTION;
        SET @ErrorMessage = 'Check-out successful';
        
        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
            SET @ErrorCode = -999;
            SET @ErrorMessage = ERROR_MESSAGE();
        END CATCH
END
