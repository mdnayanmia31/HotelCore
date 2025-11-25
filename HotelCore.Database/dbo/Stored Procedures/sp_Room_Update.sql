
-- SP: Room Update
CREATE   PROCEDURE sp_Room_Update
    @RoomID INT,
    @Status NVARCHAR(20),
    @Notes NVARCHAR(1000) = NULL,
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

        IF NOT EXISTS (SELECT 1 FROM Rooms WHERE RoomID = @RoomID AND IsActive = 1)
        BEGIN
            SET @ErrorCode = -1;
            SET @ErrorMessage = 'Room not found';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        UPDATE Rooms
        SET Status = @Status,
            Notes = ISNULL(@Notes, Notes),
            ModifiedBy = @CurrentUserID,
            ModifiedDate = GETUTCDATE()
        WHERE RoomID = @RoomID;

        -- Audit log
        INSERT INTO AuditLog (UserID, TableName, RecordID, ActionType, NewValues, CreatedDate)
        VALUES (@CurrentUserID, 'Rooms', @RoomID, 'UPDATE', 'Status=' + @Status, GETUTCDATE());

        COMMIT TRANSACTION;
        SET @ErrorMessage = 'Room updated successfully';

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @ErrorCode = -999;
        SET @ErrorMessage = ERROR_MESSAGE();
    END CATCH
END
