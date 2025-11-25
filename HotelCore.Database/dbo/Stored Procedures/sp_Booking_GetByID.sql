
-- SP: Booking GET by ID
CREATE   PROCEDURE sp_Booking_GetByID
    @BookingID INT,
    @UserID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    -- booking details
    SELECT 
        b.BookingID,
        b.BookingReference,
        b.UserID,
        u.FirstName + ' ' + u.LastName AS GuestName,
        u.Email AS GuestEmail,
        u.PhoneNumber AS GuestPhone,
        b.RoomID,
        r.RoomNumber,
        rt.TypeName AS RoomType,
        rt.Description AS RoomDescription,
        b.ConfigID,
        rc.ConfigName,
        b.StartDateTime,
        b.EndDateTime,
        DATEDIFF(HOUR, b.StartDateTime, b.EndDateTime) as DurationHours,
        b.TotalAmount, 
        b.DepositAmount,
        b.Status,
        b.GuestCount,
        b.AdultCount,
        b.ChildCount,
        b.InfantCount,
        b.SpecialRequests,
        b.CheckInDateTime,
        b.CheckOutDateTime,
        b.CreatedDate,
        b.CancelledDate,
        b.CancellationReason
    FROM Bookings b
    INNER JOIN Users u ON b.UserID = u.UserID
    INNER JOIN Rooms r ON b.RoomID = r.RoomID
    INNER JOIN RoomTypes rt on r.RoomTypeID = rt.RoomTypeID
    LEFT JOIN RoomConfigurations rc on b.ConfigID = rc.ConfigID
    WHERE b.BookingID = @BookingID
        AND(@UserID IS NULL OR b.UserID = @UserID);
    
    -- booking guests
    SELECT 
        GuestID,
        GuestType,
        FullName,
        Email,
        Phone,
        AgeCategory,
        DateOfBirth,
        IDType,
        IDNumber,
        Nationality,
        IsCheckedIn
    FROM BookingGuests
    WHERE BookingID = @BookingID;
    -- payment details
    SELECT 
        PaymentID,
        PaymentReference,
        PaymentMethod,
        Amount,
        Status,
        PaymentDate,
        RefundedAmount
    FROM Payments
    WHERE BookingID = @BookingID
    ORDER BY PaymentDate DESC;
END
