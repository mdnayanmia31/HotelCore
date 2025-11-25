
-- SP: Housekeeping Task Get By Staff
CREATE   PROCEDURE sp_HousekeepingTask_GetByStaff
    @StaffID INT,
    @Status NVARCHAR(20) = NULL,
    @StartDate DATE = NULL,
    @EndDate DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

    SELECT 
        ht.TaskID,
        ht.TaskType,
        ht.Priority,
        ht.Status,
        ht.DueDateTime,
        ht.EstimatedMinutes,
        ht.ActualMinutes,
        r.RoomNumber,
        rt.TypeName AS RoomType,
        b.BookingReference,
        ht.Notes
    FROM HousekeepingTasks ht
    INNER JOIN Rooms r ON ht.RoomID = r.RoomID
    INNER JOIN RoomTypes rt ON r.RoomTypeID = rt.RoomTypeID
    LEFT JOIN Bookings b ON ht.BookingID = b.BookingID
    WHERE ht.AssignedStaffID = @StaffID
      AND (@Status IS NULL OR ht.Status = @Status)
      AND (@StartDate IS NULL OR CAST(ht.DueDateTime AS DATE) >= @StartDate)
      AND (@EndDate IS NULL OR CAST(ht.DueDateTime AS DATE) <= @EndDate)
    ORDER BY 
        CASE ht.Priority 
            WHEN 'Urgent' THEN 1 
            WHEN 'High' THEN 2 
            WHEN 'Normal' THEN 3 
            ELSE 4 
        END,
        ht.DueDateTime;
END
