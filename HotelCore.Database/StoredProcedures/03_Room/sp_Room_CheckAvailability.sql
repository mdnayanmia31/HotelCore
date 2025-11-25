USE HotelCore;
GO

-- SP: Check Availability for Specific Room
CREATE OR ALTER PROCEDURE sp_Room_CheckAvailability
    @RoomID INT,
    @StartDateTime DATETIME2,
    @EndDateTime DATETIME2
    AS
BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

    DECLARE
        @IsAvailable                 BIT = 0;
        DECLARE @ConflictingBookings INT = 0;

        -- Check for overlapping bookings
        SELECT @ConflictingBookings                                   = COUNT(*)
        FROM BookingSlots            bs
        INNER                        JOIN Bookings b ON bs.BookingID  = b.BookingID
        WHERE bs.RoomID                                               = @RoomID
        AND b.Status IN ('Confirmed', 'CheckedIN', 'Pending')
        AND bs.StartDateTime < @EndDateTime
        AND bs.EndDateTime > @StartDateTime

        -- Check room status
        DECLARE @RoomStatus          NVARCHAR(20); SELECT @RoomStatus = Status FROM Rooms WHERE RoomID = @RoomID;

        -- Available if no conflicts and room is operational
        IF @ConflictingBookings                                       = 0 AND @RoomStatus IN ('Available', 'Cleaning')
    BEGIN
        SET @IsAvailable = 1;
    END

    -- Return availability result
    SELECT @IsAvailable AS IsAvailable,
        @ConflictingBookings AS ConflictingBookings,
        @RoomStatus AS RoomStatus, 
        @StartDateTime as RequestedStart,
        @EndDateTime as RequestedEnd;

    -- Return conflicting slots
    IF @ConflictingBookings > 0
    BEGIN
        SELECT bs.StartDateTime,
               bs.EndDateTime,
               b.BookingReference,
               b.Status
        FROM BookingSlots bs
                 INNER JOIN Bookings b on bs.BookingID = b.BookingID
        WHERE bs.RoomID = @RoomID
          AND b.Status IN ('Confirmed', 'CheckedIn', 'Pending')
          AND bs.StartDateTime < @EndDateTime
          AND bs.EndDateTime < @StartDateTime
        ORDER BY bs.StartDateTime;
    END

END 
GO
