
-- SP: Search Rooms with Filters

CREATE   PROCEDURE sp_Room_Search
    @StartDateTime DATETIME2,
    @EndDateTime DATETIME2,
    @ConfigID INT = NULL,
    @MinOccupancy INT = 1,
    @MaxPrice DECIMAL (10,2) = NULL,
    @AmenityIDs NVARCHAR(100) = NULL,
    @FloorNumber INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

    -- Calculate if this is a micro-stay (< 24 hours) or full-day
    DECLARE @DurationHours INT = DATEDIFF(HOUR, @StartDateTime, @EndDateTime);
    DECLARE @IsMicroStay BIT = CASE WHEN @DurationHours < 24 THEN 1 ELSE 0 END;

    -- Find available rooms not overlapping with existing bookigs
    SELECT DISTINCT r.RoomID,
                    r.RoomNumber,
                    r.FloorNumber,
                    rt.TypeName,
                    rt.Description,
                    rt.MaxOccupancy,
                    rt.SquareFeet,
                    rt.BedConfiguration,
                    CASE
                        WHEN @IsMicroStay = 1 then rt.BaseHourlyRate * @DurationHours
                        ELSE rt.BaseDailyRate * DATEDIFF(DAY, @StartDateTime, @EndDateTime)
                        END                                                                        as EstimatedPrice,
                    rc.ConfigName,
                    rc.SetupTimeMinutes,
                    (SELECT COUNT(*) FROM ConfigurationAmenities ca WHERE ca.ConfigID = @ConfigID) AS AmenityMatchCount
    FROM Rooms r
             INNER JOIN RoomTypes rt ON r.RoomTypeID = rt.RoomTypeID
             LEFT JOIN RoomConfigurations rc ON rc.ConfigID = @ConfigID
    WHERE r.IsActive = 1
      AND r.Status IN ('Available', 'Cleaning')
      AND rt.MaxOccupancy >= @MinOccupancy
      AND (@FloorNumber IS NULL OR r.FloorNumber = @FloorNumber)
      AND (
            @AmenityIDs IS NULL
            OR NOT EXISTS (
            SELECT value FROM STRING_SPLIT(@AmenityIDs, ',')
            EXCEPT
            SELECT CAST(AmenityID AS NVARCHAR)
            FROM ConfigurationAmenities ca
            WHERE ca.ConfigID = ISNULL(@ConfigID, -1) -- only checks if Config is selected (amenities are linked to configurations, not rooms)
        )
        )
      -- check room is not booked during requested time
      AND NOT EXISTS (SELECT 1
                      FROM BookingSlots bs
                               INNER JOIN Bookings b on bs.BookingID = b.BookingID
                      WHERE bs.RoomID = r.RoomID
                        AND b.Status IN ('Confirmed', 'CheckedIn', 'Pending')
                        AND bs.StartDateTime < @EndDateTime
                        AND bs.EndDateTime > @StartDateTime)
      -- price filter
      AND (
        @MaxPrice IS null
            OR (
            @IsMicroStay = 1 AND rt.BaseHourlyRate * @DurationHours <= @MaxPrice
            )
            OR (
            @IsMicroStay = 0 AND rt.BaseDailyRate * DATEDIFF(DAY, @StartDateTime, @EndDateTime) <= @MaxPrice
            )
        )
      -- Amenity filter (if specified, room must support that configuration)
      AND (
        @ConfigID IS NULL
            OR EXISTS(SELECT 1
                      FROM RoomTypes rt2
                      WHERE rt2.RoomTypeID = r.RoomTypeID
                        AND rt2.IsActive = 1)
        )
    ORDER BY EstimatedPrice ASC, r.RoomNumber;
END
