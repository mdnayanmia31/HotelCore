USE HotelCore;
GO

-- SP: Staff Get Schedule
CREATE OR ALTER PROCEDURE sp_Staff_GetSchedule
    @StaffID INT,
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

    SELECT 
        ss.ScheduleID,
        ss.ShiftDate,
        ss.StartTime,
        ss.EndTime,
        ss.Status,
        ss.Notes,
        DATEDIFF(MINUTE, ss.StartTime, ss.EndTime) AS ShiftDurationMinutes,
        (SELECT COUNT(*) FROM HousekeepingTasks 
         WHERE AssignedStaffID = @StaffID 
           AND CAST(DueDateTime AS DATE) = ss.ShiftDate
           AND Status IN ('Assigned', 'InProgress')) AS AssignedTaskCount
    FROM StaffSchedule ss
    WHERE ss.StaffID = @StaffID
      AND ss.ShiftDate >= @StartDate
      AND ss.ShiftDate <= @EndDate
    ORDER BY ss.ShiftDate, ss.StartTime;
END
GO
