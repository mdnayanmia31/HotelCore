
-- SP: Room Get By ID
CREATE   PROCEDURE sp_Room_GetById
    @RoomID INT
AS
BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

    SELECT 
        r.RoomID,
        r.RoomNumber,
        r.FloorNumber,
        r.Status,
        r.LastCleanedDate,
        r.Notes,
        rt.RoomTypeID,
        rt.TypeName,
        rt.Description,
        rt.BaseHourlyRate,
        rt.BaseDailyRate,
        rt.MaxOccupancy,
        rt.SquareFeet,
        rt.BedConfiguration
    FROM Rooms r
    INNER JOIN RoomTypes rt ON r.RoomTypeID = rt.RoomTypeID
    WHERE r.RoomID = @RoomID AND r.IsActive = 1;
END
