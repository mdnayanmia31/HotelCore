USE HotelCore;
GO

-- SP: Get Occupancy Report

CREATE OR ALTER PROCEDURE sp_Report_GetOccupancy
            @StartDate DATE,
            @EndDate DATE
AS
BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    
    -- Daily occupancy
    SELECT 
        CAST(b.StartDateTime AS DATE) AS OccupancyDate,
        COUNT(DISTINCT b.BookingID) AS TotalBookings,
        COUNT(DISTINCT b.RoomID) AS RoomsOccupied,
        (SELECT COUNT(*) FROM Rooms WHERE IsActive = 1) AS TotalRooms,
        CAST(COUNT(DISTINCT b.RoomID) * 100.0 / (SELECT COUNT(*) FROM Rooms WHERE IsActive = 1) AS DECIMAL(5,2)) AS OccupancyRate,
        SUM(b.TotalAmount) AS TotalRevenue,
        AVG(b.TotalAmount) AS AvgBookingValue
    FROM Bookings b
    WHERE CAST(b.StartDateTime AS DATE) >= @StartDate
        AND CAST(b.StartDateTime AS  DATE) <= @EndDate
        AND b.Status IN ('Confirmed', 'CheckedIn', 'CheckedOut')
    GROUP BY CAST(b.StartDateTime AS DATE)
    ORDER BY OccupancyDate;
    
    -- Room type breakdown
    SELECT
        rt.TypeName, 
        COUNT(DISTINCT b.BookingID) AS Bookings,
        SUM(b.TotalAmount) AS Revenue,
        AVG(b.TotalAmount) AS AvgRevenue,
        AVG(DATEDIFF(HOUR, b.StartDateTime, b.EndDateTime)) AS AvgDurationHours
    FROM Bookings b
    INNER JOIN Rooms r on b.RoomID = r.RoomID
    INNER JOIN RoomTypes rt ON r.RoomTypeID = rt.RoomTypeID
    WHERE CAST(b.StartDateTime AS DATE) >= @StartDate
        AND CAST(b.StartDateTime AS DATE) <= @EndDate
        AND b.Status IN ('Confirmed', 'CheckedIn', 'CheckedOut')
    GROUP BY rt.TypeName
    ORDER BY Revenue DESC;
END
GO