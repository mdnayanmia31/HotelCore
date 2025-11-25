
-- SP: Expire Old Reservations
CREATE   PROCEDURE sp_Reservation_ExpireOld
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE BookingReservations
    SET Status = 'EXPIRED',              
        ModifiedDate = GETUTCDATE()     
    WHERE Status = 'RESERVED'
        AND ExpiresAt < GETUTCDATE();
    
    SELECT @@ROWCOUNT AS ExpiredCount;
    
END
