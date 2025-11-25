
-- SP: Convert Reservation to Booking
CREATE   PROCEDURE sp_Reservation_ConvertToBooking
    @ReservationID INT,
    @UserID INT, 
    @ConfigID INT = NULL,
    @GuestCount INT,
    @AdultCount INT, 
    @ChildCount INT,
    @InfantCount INT,
    @SpecialRequests NVARCHAR(1000)  = NULL,
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
        
        DECLARE @RoomID INT, @StartDateTime DATETIME2, @EndDateTime DATETIME2,
                @ReservedAmount DECIMAL(10,2), @ExpiresAt DATETIME2, @Status NVARCHAR(20);
            
        SELECT 
            @RoomID = RoomID,
            @StartDateTime = StartDateTime,
            @EndDateTime = EndDateTime,
            @ReservedAmount = ReservedAmount,
            @ExpiresAt = ExpiresAt,
            @Status = Status
        FROM BookingReservations WITH (UPDLOCK, ROWLOCK)
        WHERE ReservationID = @ReservationID
            AND UserID = @UserID
        
        IF @RoomID IS NULL
            BEGIN 
                SET @ErrorCode = -10;
                SET @ErrorMessage = 'Reservation not found or access denied';
                
                ROLLBACK TRANSACTION;
                RETURN;
            END
        
        IF @Status <> 'RESERVED'
        BEGIN
            SET @ErrorCode = -11;
            SET @ErrorMessage= 'Reservation is no longer active (Status: ' + @Status + ')';
            
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        IF @ExpiresAt < GETUTCDATE()
        BEGIN
            -- Auto-expire
            UPDATE BookingReservations SET Status = 'EXPIRED' WHERE ReservationID = @ReservationID;
            
            SET @ErrorCode = -12;
            SET @ErrorMessage = 'Reservation has expired, Please search again.';
            ROLLBACK TRANSACTION;
            RETURN;
        END 
        
    EXEC sp_Booking_Create
        @UserID = @UserID,
        @RoomID = @RoomID,
        @ConfigID = @ConfigID,
        @StartDateTime = @StartDateTime,
        @EndDateTime = @EndDateTime,
        @GuestCount = @GuestCount,
        @SpecialRequests = @SpecialRequests,
        @CurrentUserID = @UserID,  
        @BookingID = @BookingID OUTPUT,
        @ErrorCode = @ErrorCode OUTPUT,
        @ErrorMessage = @ErrorMessage OUTPUT;
        
        IF @ErrorCode <> 0
        BEGIN 
            ROLLBACK TRANSACTION;
            RETURN;
        END 
        
        UPDATE Bookings
        SET AdultCount = @AdultCount,
            ChildCount = @ChildCount, 
            InfantCount = @InfantCount
        WHERE BookingID = @BookingID;
        
        UPDATE BookingReservations
            SET Status = 'CONVERTED',
                BookingID = @BookingID,
                ModifiedDate = GETUTCDATE()
            WHERE ReservationID = @ReservationID;
        
        COMMIT TRANSACTION;
        
        SET @ErrorCode = 0;
        SET @ErrorMessage = 'Booking confirmed successfully';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        SET @ErrorCode = -999;
        SET @ErrorMessage = ERROR_MESSAGE();
        SET @BookingID = NULL;
    END CATCH
END
