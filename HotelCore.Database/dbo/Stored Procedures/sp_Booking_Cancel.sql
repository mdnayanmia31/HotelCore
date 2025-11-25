
--SP: Cancel Booking

CREATE   PROCEDURE sp_Booking_Cancel
    @BookingID INT,
    @CancellationReason NVARCHAR(500),
    @UserID INT,
    @ErrorCode INT OUTPUT,
    @ErrorMessage NVARCHAR(500) OUTPUT
AS
BEGIN
        SET NOCOUNT ON;
        SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
        SET @ErrorCode = 0;
        SET @ErrorMessage = NULL;

        BEGIN
            TRY
            BEGIN
                TRANSACTION;

                DECLARE  @CurrentStatus NVARCHAR(20), @RoomID INT;
                SELECT @CurrentStatus = Status, @RoomID = RoomID
                FROM Bookings
                WHERE BookingID = @BookingID;

                IF @CurrentStatus IS NULL
                BEGIN
                    SET @ErrorCode = -40;
                    SET @ErrorMessage = 'Booking not found';
                    ROLLBACK TRANSACTION;
                    RETURN;
                END
                IF @CurrentStatus IN ('Cancelled', 'CheckedOut')
                BEGIN
                    SET @ErrorCode = -41;
                    SET @ErrorMessage = 'Booking already ' + @CurrentStatus;
                    ROLLBACK TRANSACTION;
                    RETURN;
                END
                -- Update status
                UPDATE Bookings
                SET Status = 'Cancelled',
            CancelledDate = GETUTCDATE(),
            CancellationReason = @CancellationReason,
            ModifiedDate = GETUTCDATE()
        WHERE BookingID = @BookingID;

                -- Cancel pending housekeeping tasks
                UPDATE HousekeepingTasks
                SET Status = 'Cancelled',
                    Notes  = ISNULL(Notes + ' | ', '') + 'Cancelled due to booking cancellation'
                WHERE BookingID = @BookingID
                  AND Status IN ('Pending', 'Assigned');

                -- Update room status
                UPDATE Rooms
                SET Status = 'Available', ModifiedDate = GETUTCDATE()
                WHERE RoomID = @RoomID AND Status = 'Occupied';
                -- audit log
                INSERT INTO AuditLog (UserID, TableName, RecordID, ActionType, NewValues, CreatedDate)
                VALUES (@UserID, 'Bookings', @BookingID, 'UPDATE', 'Status=Cancelled, Reason=' + @CancellationReason,
                        GETUTCDATE());
                
                COMMIT TRANSACTION;

                SET @ErrorCode = 0;
                SET @ErrorMessage = 'Booking cancelled successfully';

            END TRY
            BEGIN CATCH
                IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
                SET @ErrorCode = -999;
                SET @ErrorMessage = ERROR_MESSAGE();
            END CATCH
END
