-- SP : Create Booking
CREATE OR ALTER PROCEDURE sp_Booking_Create
    @UserID INT,
    @RoomID INT,
    @ConfigID INT = NULL,
    @StartDateTime DATETIME2, 
    @EndDateTime DATETIME2, 
    @GuestCount INT = 1,
    @SpecialRequests NVARCHAR(1000) = NULL,
    @CurrentUserID INT,
    @BookingID INT OUTPUT,
    @ErrorCode INT OUTPUT,
    @ErrorMessage NVARCHAR(500) OUTPUT
AS
    BEGIN
        SET NOCOUNT ON;
        SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

        SET @BookingID = NULL;
        SET @ErrorCode = 0;
        SET @ErrorMessage = NULL;

        BEGIN TRY
            BEGIN TRANSACTION;

                IF @StartDateTime >= @EndDateTime
                BEGIN
                    SET @ErrorCode = -10;
                    SET @ErrorMessage = 'End date must be after start date';
                    ROLLBACK TRANSACTION;
                    RETURN;
                END
                IF @StartDateTime < DATEADD(MINUTE, -5, GETUTCDATE()) -- allow a 5-minute buffer for network latency
                BEGIN
                    SET @ErrorCode = -11;
                    SET @ErrorMessage = 'Cannot Book in the past';
                    ROLLBACK TRANSACTION;
                    RETURN;
                END

                -- check room exists and is active
                DECLARE @RoomStatus NVARCHAR(20), @RoomTypeID INT;
                SELECT @RoomStatus = Status, @RoomTypeID = RoomTypeID
                FROM Rooms WITH(UPDLOCK, ROWLOCK) 
                    WHERE RoomID = @RoomID and IsActive = 1;

                IF @RoomStatus IS NULL
                BEGIN
                    SET @ErrorCode = -20;
                    SET @ErrorMessage = 'Room unavailable';
                    ROLLBACK TRANSACTION;
                    RETURN;
                END
                IF @RoomStatus
                NOT
                IN
                ('Available', 'Cleaning')
                BEGIN
                    SET @ErrorCode = -21;
                    SET @ErrorMessage = 'Room unavailable (Status: ' + @RoomStatus + ')';
                    ROLLBACK TRANSACTION;
                    RETURN;
                END
                DECLARE @ConflictCount INT;
                SELECT @ConflictCount = COUNT(*)
                FROM BookingSlots bs with (UPDLOCK, ROWLOCK)
                INNER JOIN Bookings b
                on bs.BookingID = b.BookingID
                WHERE bs.RoomID = @RoomID
                  AND b.Status IN ('Confirmed', 'CheckedIn', 'Pending')
                  AND bs.StartDateTime
                    < @EndDateTime
                  AND bs.EndDateTime
                    > @StartDateTime;
                IF @ConflictCount > 0
                BEGIN
                    SET @ErrorCode = -1;
                    SET @ErrorMessage = 'Time slot unavailable - conflicting booking exists';
                    ROLLBACK TRANSACTION;
                    RETURN;
                END

                -- get room pricing
                DECLARE @BaseHourlyRate DECIMAL(10,2), @BaseDailyRate DECIMAL(10,2), @MaxOccupancy INT;
                SELECT 
                @BaseHourlyRate = BaseHourlyRate,
                @BaseDailyRate = BaseDailyRate,
                @MaxOccupancy = MaxOccupancy
                FROM RoomTypes
                WHERE RoomTypeID = @RoomTypeID;

                -- check occupancy
                IF @GuestCount > @MaxOccupancy
                BEGIN
                    SET @ErrorCode = -30;
                    SET @ErrorMessage = 'Guest count exceeds room capacity';
                    Rollback Transaction;
                    RETURN;
                END
                -- Calculate total amount
                DECLARE @DurationHours INT = DATEDIFF(HOUR,@StartDateTime, @EndDateTime);
                DECLARE @DurationDays INT = DATEDIFF(DAY, @StartDateTime, @EndDateTime);
                DECLARE @TotalAmount  DECIMAL(10, 2);
                DECLARE @IsMicroStay BIT = CASE WHEN @DurationHours < 20 THEN 1 ELSE 0 END;
        
            IF @IsMicroStay = 1
            SET @TotalAmount = @BaseHourlyRate * @DurationHours;
            ELSE
            SET @TotalAmount = @BaseDailyRate * @DurationDays;
            -- Apply pricing rules
            IF DATEPART(WEEKDAY, @StartDateTime) IN (1, 7)
            SET @TotalAmount = @TotalAmount * 1.1;

            -- Generate booking reference
            Declare @BookingReference NVARCHAR(20);
            SET @BookingReference = 'BK' + FORMAT(GETUTCDATE(), 'yyyyMMdd') + '-' +
                RIGHT('0000' + CAST(ABS(CHECKSUM(NEWID())) % 10000 AS NVARCHAR), 4);

            INSERT INTO Bookings (BookingReference, UserID, RoomID, ConfigID,
                                  StartDateTime, EndDateTime, TotalAmount,
                                  Status, GuestCount, SpecialRequests,
                                  CreatedDate, ModifiedDate,
                                  CreatedBy, ModifiedBy)
            VALUES (@BookingReference, @UserID, @RoomID, @ConfigID, @StartDateTime, @EndDateTime, @TotalAmount,
                    'Pending', @GuestCount, @SpecialRequests, GETUTCDATE(), GETUTCDATE(), @CurrentUserID,
                    @CurrentUserID);
            SET @BookingID = SCOPE_IDENTITY();

            -- Insert booking slot (for micro-stays)
            INSERT INTO BookingSlots (BookingID, RoomID, StartDateTime,
                                      EndDateTime, HourlyRate, DailyRate, SlotAmount)
            VALUES (@BookingID, @RoomID, @StartDateTime, @EndDateTime,
                    @BaseHourlyRate, @BaseDailyRate, @TotalAmount);

            -- Create housekeeping task for checkout
            DECLARE @CheckoutTaskDue DATETIME2 = DATEADD(MINUTE, 30, @EndDateTime);

            INSERT INTO HousekeepingTasks (RoomID, BookingID, TaskType, Priority,
                                           Status, DueDateTime, EstimatedMinutes)
            VALUES (@RoomID, @BookingID, 'Checkout', 'Normal',
                    'Pending', @CheckoutTaskDue, 30);
            -- Create guest timeline events
            INSERT INTO GuestTimelineEvents (BookingID, EventType, EventDateTime, Title, Description, Status)
            VALUES (@BookingID, 'PreArrivalEmail', DATEADD(DAY, -1, @StartDateTime), 'Pre-Arrival Information',
                    'Welcome email with check-in details', 'Pending'),
                   (@BookingID, 'MobileCheckIn', DATEADD(Hour, -4, @StartDateTime), 'Mobile Check-In Available',
                    'Complete check-in from your mobile device', 'Pending'),
                   (@BookingID, 'CheckoutReminder', DATEADD(HOUR, -2, @EndDateTime), 'Checkout Reminder',
                    'Your checkout time is approaching', 'Pending'),
                   (@BookingID, 'PostStayFeedback', DATEADD(Day, 1, @EndDateTime), 'Share Your Experience',
                    'We would love to hear your feedback', 'Pending');
            -- update room status
            UPDATE Rooms
            SET Status        = 'Occupied',
                ModifiedDate = GETUTCDATE()
            WHERE RoomID = @RoomID;

            -- Audit log
            INSERT INTO AuditLog (UserID, TableName, RecordID, ActionType, NewValues, CreatedDate)
            VALUES (@UserID, 'Bookings', @BookingID, 'INSERT',
                    'BookingRef=' + @BookingReference + ', Room=' + CAST(@RoomID AS NVARCHAR) + ' ,Amount=' +
                    CAST(@TotalAmount AS NVARCHAR), GETUTCDATE());

            COMMIT TRANSACTION;

            SET @ErrorCode = 0;
            SET @ErrorMessage = 'Booking created successfully';

        END TRY
        BEGIN
            CATCH
            IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

            SET @ErrorCode = -999;
            SET @ErrorMessage = ERROR_MESSAGE();
            SET @BookingID = NULL;
        END CATCH
END
GO