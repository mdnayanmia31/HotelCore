
-- SP: Get Upsells for Booking
 CREATE   PROCEDURE sp_Booking_GetUpsells
        @BookingID INT
AS 
BEGIN 
   SET NOCOUNT ON;
   SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
            
            -- get booking details
            DECLARE @RoomTypeID INT, @StartDateTime DATETIME2, @EndDateTime DATETIME2, @DurationHours INT;
                SELECT 
                    @RoomTypeID = rt.RoomTypeID,
                    @StartDateTime = b.StartDateTime,
                    @EndDateTime = b.EndDateTime,
                    @DurationHours = DATEDIFF(HOUR, b.StartDateTime, b.EndDateTime)
                FROM Bookings b
                INNER JOIN Rooms r ON b.RoomID = r.RoomID
                INNER JOIN RoomTypes rt on r.RoomTypeID = rt.RoomTypeID
                WHERE b.BookingID = @BookingID;
                
                SELECT 
                    ur.RuleID,
                    ur.RuleName,
                    ur.UpsellTitle,
                    ur.UpsellDescription,
                    ur.UpsellAmount,
                    ur.DiscountPercent,
                    CASE
                        WHEN ur.DiscountPercent > 0 THEN ur.UpsellAmount * (1 - ur.DiscountPercent / 100.0)
                        ELSE ur.UpsellAmount
                    END AS FinalAmount, 
                    ur.Priority
                FROM UpsellRules ur
                WHERE ur.IsActive = 1
                    AND (
                        (ur.TriggerType = 'StayDuration' AND @DurationHours >= 24)
                    OR (ur.TriggerType = 'BookingTime' AND DATEPART(HOUR, GETUTCDATE()) < 12)
                    OR (ur. TriggerType = 'DayOfWeek' AND DATEPART(WEEKDAY, @StartDateTime) IN (6,7))
                    OR ur.TriggerType = 'RoomType' 
                    )
                    AND NOT EXISTS (
                        SELECT 1 FROM UpsellOffers uo
                        WHERE  uo.BookingID = @BookingID
                                AND uo.RuleID = ur.RuleID
                                AND uo.Status IN ('Accepted', 'Offered')
                    )
			ORDER BY ur.Priority DESC, FinalAmount ASC;        
END 
