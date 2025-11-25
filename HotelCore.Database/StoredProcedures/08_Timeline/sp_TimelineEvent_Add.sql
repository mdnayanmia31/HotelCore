USE HotelCore;
GO

-- SP: Add Timeline Event
CREATE OR ALTER PROCEDURE sp_TimelineEvent_Add
    @BookingID INT,
    @EventType NVARCHAR(50),
    @EventDateTime DATETIME2,
    @Title NVARCHAR(200),
    @Description NVARCHAR(1000),
    @ActionURL NVARCHAR(500) = NULL,
    @EventID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
        INSERT INTO GuestTimelineEvents (
            BookingID, EventType, EventDateTime, Title, Description, ActionURL, Status, CreatedDate
        ) VALUES (
            @BookingID, @EventType, @EventDateTime, @Title, @Description, @ActionURL, 'Pending', GETUTCDATE()
        );
    
    SET @EventID = SCOPE_IDENTITY();
    
    SELECT @EventID AS EventID;
END 
GO
