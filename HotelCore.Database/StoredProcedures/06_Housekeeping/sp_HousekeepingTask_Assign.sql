USE HotelCore;
GO

-- SP: Assign Housekeeping task 
CREATE OR ALTER PROCEDURE sp_HousekeepingTask_Assign
    @TaskID INT,
    @StaffID INT,
    @ErrorCode INT OUTPUT, 
    @ErrorMessage NVARCHAR(500) OUTPUT
AS
        BEGIN
            SET NOCOUNT ON;
            SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

            SET @ErrorCode = 0;
            SET @ErrorMessage = NULL;

            BEGIN TRY
                BEGIN TRANSACTION;
                    --Get task details
                    DECLARE
                        @TaskDueDateTime  DATETIME2, 
                        @TaskStatus NVARCHAR(20),
                        @EstimatedMinutes INT; 
                        SELECT @TaskDueDateTime = DueDateTime, 
                            @TaskStatus = Status,
                            @EstimatedMinutes = EstimatedMinutes
                        FROM HousekeepingTasks
                        WHERE TaskID = @TaskID; 
                        IF @TaskStatus IS NULL
                    BEGIN
                        SET @ErrorCode = -50;
                        SET @ErrorMessage = 'Task not found';
                        ROLLBACK TRANSACTION;
                        RETURN;
                    END
                    IF @TaskStatus
                    NOT
                    IN
                    ('Pending', 'Assigned')
                    BEGIN
                        SET @ErrorCode = -51;
                        SET @ErrorMessage = 'Task status does not allow reassignmet (Status: ' + @TaskStatus + ')';
                        ROLLBACK TRANSACTION;
                        RETURN;
                    END

                    -- check staff is scheduled for that timme
                    DECLARE @DueDate
                    Date = CAST(@TaskDueDateTime AS DATE);
                    DECLARE
                        @DueTime             TIME = CAST(@TaskDueDateTime AS TIME);
                        DECLARE @IsScheduled BIT = 0; SELECT @IsScheduled      = 1
                        FROM StaffSchedule
                        WHERE StaffID                                          = @StaffID
                        AND ShiftDate                                          = @DueDate
                        AND StartTime <= @DueTime
                        AND EndTime >= DATEADD(MINUTE, @EstimatedMinutes, @DueTime)
                        AND Status in ('Scheduled', 'Active'); IF @IsScheduled = 0
                    BEGIN
                        SET @ErrorCode = -52;
                        SET @ErrorMessage = 'Staff member is not scheduled for this time slot';

                        ROLLBACK TRANSACTION;
                        RETURN;
                    END
                    -- check staff capacity (max hours of tasks per shift)
                    DECLARE @CurrentWorkload INT;
                    SELECT @CurrentWorkload = ISNULL(SUM(EstimatedMinutes), 0)
                    FROM HousekeepingTasks
                    WHERE AssignedStaffID = @StaffID
                      AND CAST(DueDateTime AS DATE) = @DueDate
                      AND Status IN ('Assigned', 'InProgress');
                    IF (@CurrentWorkload + @EstimatedMinutes) > 480 -- 8 hours
                    BEGIN
                        SET @ErrorCode = -53;
                        SET @ErrorMessage = 'Staff member is at capacity for this date';

                        ROLLBACK TRANSACTION;
                        RETURN;
                    END
                        -- Assign task
                        UPDATE HousekeepingTasks
                        SET AssignedStaffID = @StaffID,
                            Status           = 'Assigned',
                            Notes            = ISNULL(Notes + ' | ', '') + 'Assigned on ' +
                                               FORMAT(GETUTCDATE(), 'yyyy-MM-dd HH:mm')
                        WHERE TaskID = @TaskID;
                        
                        COMMIT TRANSACTION;
                        SET @ErrorCode = 0;
                        SET @ErrorMessage = 'Task assigned successfully';

    END TRY
  BEGIN CATCH
             IF @@TRANCOUNT > 0
             ROLLBACK TRANSACTION;

             SET @ErrorCode = -999;
             SET @ErrorMessage = ERROR_MESSAGE();
  END CATCH

END
GO
