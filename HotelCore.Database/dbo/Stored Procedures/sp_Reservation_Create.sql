
-- SP: Create Temporary Reservatiion

CREATE   PROCEDURE sp_Reservation_Create
    @UserID INT,
    @RoomID INT,
    @StartDateTime DATETIME2,
    @EndDateTime DATETIME2,
    @EstimatedAmount DECIMAL(10, 2),
    @ReservationID INT OUTPUT,
    @ErrorCode INT OUTPUT,
    @ErrorMessage NVARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    
    SET @ReservationID = NULL;
    SET @ErrorCode = 0;
    SET @ErrorMessage = NULL;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Check for conflicts with confirmed bookings
        IF EXISTS(
            SELECT 1 FROM BookingSlots with (UPDLOCK, ROWLOCK)
            WHERE RoomID = @RoomID
                AND StartDateTime < @EndDateTime
                AND EndDateTime > @StartDateTime
        )
        BEGIN
            SET @ErrorCode = -1;
            SET @ErrorMessage = 'Room is already booked for this time period';
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        IF EXISTS (
            SELECT 1 FROM BookingReservations with (UPDLOCK, ROWLOCK)
            WHERE RoomID = @RoomID
                AND Status = 'RESERVED'
                AND ExpiresAt > GETUTCDATE()
                AND StartDateTime < @EndDateTime
                AND EndDateTime > @StartDateTime
            )
            BEGIN 
                SET @ErrorCode = -2;
                SET @ErrorMessage = 'Room is temporarily reserved by another user';
                ROLLBACK TRANSACTION;
                RETURN;
            END
            
            -- create reservation (10-minute hold)
            INSERT INTO BookingReservations (
                UserID, RoomID, StartDateTime, EndDateTime, 
                Status, ExpiresAt, ReservedAmount
            )
            VALUES (
                @UserID, @RoomID, @StartDateTime,  @EndDateTime,
                'RESERVED', DATEADD(MINUTE, 10, GETUTCDATE()), @EstimatedAmount
            );
            
            SET @ReservationID = SCOPE_IDENTITY();
            
        COMMIT TRANSACTION;
        
        SET @ErrorCode = 0;
        SET @ErrorMessage = 'Reservation created successfully. Complete booking within 10 minutes.';
    
    END TRY
    BEGIN CATCH 
        IF @@TRANCOUNT > 0 
            ROLLBACK TRANSACTION;
        
        SET @ErrorCode = -999;
        SET @ErrorMessage = ERROR_MESSAGE();
        SET @ReservationID = NULL;
    END CATCH         
END          
