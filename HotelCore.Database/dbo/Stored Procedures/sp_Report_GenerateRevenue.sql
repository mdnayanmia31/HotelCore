
-- SP: Generate Revenue Report

CREATE   PROCEDURE sp_Report_GenerateRevenue
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    
    SELECT 
        COUNT(DISTINCT b.BookingID) AS TotalBookings,
        SUM(b.TotalAmount) AS TotalRevenue,
        AVG(b.TotalAmount) AS AvgBookingValue,
        SUM(CASE WHEN DATEDIFF(HOUR, b.StartDateTime, b.EndDateTime) < 24 THEN 1 ELSE 0 END) AS MicroStayCount,
        SUM(CASE WHEN DATEDIFF(HOUR, b.StartDateTime, b.EndDateTime) >= 24 THEN 1 ELSE 0 END) AS FullDayCount,
        SUM(CASE WHEN b.Status = 'Cancelled' THEN 1 ELSE 0 END) As CancellationCount,
        CAST(SUM(CASE WHEN b.Status = 'Cancelled' THEN 1 ELSE 0 END ) * 100.0 / Count(*) AS DECIMAL(5,2)) AS CancellationRate
    FROM Bookings b
    WHERE CAST(b.CreatedDate AS DATE) >= @StartDate
        AND CAST(b.CreatedDate AS DATE) <= @EndDate;
    
    SELECT 
        ur.UpsellTitle,
        COUNT(*) As OfferedCount, 
        SUM(CASE WHEN uo.Status = 'Accepted' THEN 1 ELSE 0 END) AS AcceptedCount,
        CAST(SUM(CASE WHEN uo.Status = 'Accepted'  THEN 1 ELSE 0 END)  * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS AcceptanceRate,
        SUM(CASE WHEN uo.Status = 'Accepted' Then uo.OfferAmount ELSE 0 END) AS UpsellRevenue
    FROM UpsellOffers uo
    INNER JOIN UpsellRules ur ON uo.RuleID = ur.RuleID
    INNER JOIN Bookings b ON uo.BookingID = b.BookingID
    WHERE CAST(b.CreatedDate AS DATE) >= @StartDate
        AND CAST(b.CreatedDate AS DATE) <= @EndDate
    GROUP BY ur.UpsellTitle 
    ORDER BY UpsellRevenue DESC;
    
    SELECT
        p.PaymentMethod,
        COUNT(*) AS TransactionCount,
        SUM(p.Amount) AS TotalAmount, 
        AVG(p.Amount) AS AvgTransactionAmount
    FROM Payments p
    INNER JOIN Bookings b on p.BookingID = b.BookingID
    WHERE CAST(p.PaymentDate AS Date) >= @StartDate
        AND cast(p.PaymentDate as Date) <= @EndDate
        AND p.Status IN ('Captured', 'Authorized')
    GROUP BY p.PaymentMethod
    ORDER BY TotalAmount DESC;
END
