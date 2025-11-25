
-- SP: Get Booking Timeline

CREATE   PROCEDURE sp_Booking_GetTimeline
    @BookingID INT
AS 
BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SELECT
        EventID,
        EventType,
        EventDateTime,
        Title,
        Description,
        Status,
        ActionURL,
        CreatedDate
    FROM GuestTimelineEvents
    WHERE BookingID = @BookingID
        AND IsVisible = 1
    ORDER BY EventDateTime ASC;
END
