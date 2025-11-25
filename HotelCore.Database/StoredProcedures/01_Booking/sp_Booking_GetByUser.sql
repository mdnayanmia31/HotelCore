USE HotelCore;
GO

-- SP: Booking GET by User
CREATE OR ALTER PROCEDURE sp_Booking_GetByUser
    @UserID INT,
    @Status NVARCHAR(20) = NULL,
    @StartDate DATE = NULL,
    @EndDate DATE = NULL
AS
BEGIN 
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    
    SELECT 
        b.BookingID,
        b.BookingReference,
        b.StartDateTime,
        b.EndDateTime, 
        r.RoomNumber,
        rt.TypeName as RoomType,
        b.TotalAmount,
        b.Status,
        b.GuestCount,
        b.CreatedDate,
        CASE
            WHEN b.Status = 'Pending' AND b.StartDateTime > GETUTCDATE() THEN 'Upcoming'
            WHEN b.Status = 'CheckedIn' THEN 'Active'
            WHEN b.Status = 'CheckedOut' THEN 'Completed'
            ELSE b.Status
        END as DisplayStatus
    FROM Bookings b
    INNER JOIN Rooms r ON b.RoomID = r.RoomID
    INNER JOIN RoomTypes rt on r.RoomTypeID = rt.RoomTypeID
    WHERE b.UserID = @UserID
        AND (@Status IS NULL OR b.Status = @Status)
        AND (@StartDate IS NULL OR CAST(b.StartDateTime AS DATE) >= @StartDate)
        AND (@EndDate IS NULL OR CAST(b.EndDateTime AS DATE) <= @EndDate)
    ORDER BY b.StartDateTime DESC;
END
GO