USE HotelCore;
GO

-- SP: Room Type Get All
CREATE OR ALTER PROCEDURE sp_RoomType_GetAll
AS
BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

    SELECT 
        RoomTypeID,
        TypeName,
        Description,
        BaseHourlyRate,
        BaseDailyRate,
        MaxOccupancy,
        SquareFeet,
        BedConfiguration,
        (SELECT COUNT(*) FROM Rooms WHERE RoomTypeID = rt.RoomTypeID AND IsActive = 1) AS TotalRooms,
        (SELECT COUNT(*) FROM Rooms WHERE RoomTypeID = rt.RoomTypeID AND Status = 'Available' AND IsActive = 1) AS AvailableRooms
    FROM RoomTypes rt
    WHERE IsActive = 1
    ORDER BY TypeName;
END
GO