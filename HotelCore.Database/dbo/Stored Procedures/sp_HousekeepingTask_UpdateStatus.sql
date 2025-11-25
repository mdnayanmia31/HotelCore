
-- SP: Housekeeping Task Update Status
CREATE   PROCEDURE sp_HousekeepingTask_UpdateStatus
    @TaskID INT,
    @Status NVARCHAR(20),
    @ActualMinutes INT = NULL,
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

        DECLARE @CurrentStatus NVARCHAR(20), @RoomID INT;
        SELECT @CurrentStatus = Status, @RoomID = RoomID
        FROM HousekeepingTasks WHERE TaskID = @TaskID;

        IF @CurrentStatus IS NULL
        BEGIN
            SET @ErrorCode = -1;
            SET @ErrorMessage = 'Task not found';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Update task
        UPDATE HousekeepingTasks
        SET Status = @Status,
            StartedDateTime = CASE WHEN @Status = 'InProgress' AND StartedDateTime IS NULL 
                                  THEN GETUTCDATE() ELSE StartedDateTime END,
            CompletedDateTime = CASE WHEN @Status = 'Completed' THEN GETUTCDATE() ELSE NULL END,
            ActualMinutes = ISNULL(@ActualMinutes, ActualMinutes),
            Notes = ISNULL(@Notes, Notes),
            ModifiedBy = @CurrentUserID,
            ModifiedDate = GETUTCDATE()
        WHERE TaskID = @TaskID;

        -- Update room status if task completed
        IF @Status = 'Completed'
        BEGIN
            UPDATE Rooms
            SET Status = 'Available',
                LastCleanedDate = GETUTCDATE(),
                ModifiedBy = @CurrentUserID,
                ModifiedDate = GETUTCDATE()
            WHERE RoomID = @RoomID;
        END

        COMMIT TRANSACTION;
        SET @ErrorMessage = 'Task status updated successfully';

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @ErrorCode = -999;
        SET @ErrorMessage = ERROR_MESSAGE();
    END CATCH
END
