USE HotelCore;
GO

-- SP: Calculate Dynamic Price
CREATE OR ALTER PROCEDURE sp_Pricing_Calculate
    @RoomID INT,
    @StartDateTime DATETIME2, 
    @EndDateTime DATETIME2, 
    @BasePrice DECIMAL(10,2) OUTPUT,
    @FinalPrice DECIMAL(10,2) OUTPUT,
    @PriceBreakdown NVARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @OccupancyAdj DECIMAL(10,2) = 0;
    DECLARE @UrgencyAdj DECIMAL(10,2) = 0;
    DECLARE @HolidayAdj DECIMAL(10,2) = 0;
    DECLARE @DiscountAdj DECIMAL(10,2) = 0;
    
    -- get base price from RoomType
    SELECT @BasePrice = rt.BaseDailyRate
    FROM Rooms r
    INNER JOIN RoomTypes rt ON r.RoomTypeID = rt.RoomTypeID
    WHERE r.RoomID = @RoomID;
        
    SET @FinalPrice = @BasePrice;
        
    -- 1. OCCUPANCY STRATEGY
    DECLARE @CurrentOccupancy DECIMAL (5,2);
    SELECT @CurrentOccupancy = 
        CAST(COUNT(DISTINCT b.RoomID) AS DECIMAL) /
        (SELECT COUNT(*) FROM Rooms WHERE IsActive = 1)
    FROM Bookings b
    WHERE b.StartDateTime <= @StartDateTime
        AND b.EndDateTime >= @StartDateTime
        AND b.Status IN ('Confirmed', 'CheckedIn');
    
    IF @CurrentOccupancy > 0.80
    BEGIN 
        SET @OccupancyAdj = @FinalPrice * 0.10; -- +10%
        SET @FinalPrice = @FinalPrice + @OccupancyAdj;
    END 
    
    -- 2. URGENCY STRATEGY
        DECLARE @DaysUntilCheckIn INT = DATEDIFF(DAY, GETUTCDATE(), @StartDateTime);
        IF @DaysUntilCheckIn < 7
        BEGIN
            SET @UrgencyAdj = @FinalPrice * 0.15; -- +15%
            SET @FinalPrice = @FinalPrice + @UrgencyAdj;
        END
        
        -- 3. HOLIDAY STRATEGY
        IF EXISTS (
            SELECT 1 FROM DynamicPricingStrategies
            WHERE  StrategyType = 'Holiday'
                AND IsActive = 1
                AND @StartDateTime BETWEEN HolidayStartDate AND HolidayEndDate
        )
        BEGIN 
            SET @HolidayAdj = @FinalPrice * 0.20; -- +20%
            SET @FinalPrice = @FinalPrice + @HolidayAdj;
        END
        
        -- 4. DISCOUNT STRATEGY (Early bird booking before 12 PM)
        IF DATEPART(HOUR, GETUTCDATE()) < 12
        BEGIN 
            SET @DiscountAdj = @FinalPrice * -0.10; -- -10%
            SET @FinalPrice = @FinalPrice + @DiscountAdj;
        END
        
        SET @PriceBreakdown = (
            SELECT
                @BasePrice as basePrice,
                @OccupancyAdj as occupancyAdjustment,
                @UrgencyAdj as urgencyAdjustment,
                @HolidayAdj as holidayAdjustment,
                @FinalPrice as finalPrice,
                @CurrentOccupancy as currentOccupancy,
                @DaysUntilCheckIn as daysUntilCheckIn
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
        );
END
GO