USE HotelCore;
GO

-- SP: Booking Guest Add
CREATE OR ALTER PROCEDURE sp_BookingGuest_Add
    @BookingID INT,
    @GuestType NVARCHAR(20),
    @FullName NVARCHAR(200),
    @Email NVARCHAR(255),
    @Phone NVARCHAR(20),
    @AgeCategory NVARCHAR(20),
    @DateOfBirth DATE = NULL,
    @IDType NVARCHAR(50) = NULL,
    @IDNumber NVARCHAR(100) = NULL,
    @IDExpiryDate DATE = NULL,
    @Nationality NVARCHAR(100) = NULL,
    @CurrentUserID INT,
    @GuestID INT OUTPUT,
    @ErrorCode INT OUTPUT,
    @ErrorMessage NVARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @GuestID = NULL;
    SET @ErrorCode = 0;
    SET @ErrorMessage = NULL;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM Bookings WHERE BookingID = @BookingID)
        BEGIN
            SET @ErrorCode = -1;
            SET @ErrorMessage = 'Booking not found';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Check if primary guest already exists
        IF @GuestType = 'Primary' AND EXISTS (
            SELECT 1 FROM BookingGuests WHERE BookingID = @BookingID AND GuestType = 'Primary'
        )
        BEGIN
            SET @ErrorCode = -2;
            SET @ErrorMessage = 'Primary guest already exists for this booking';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        INSERT INTO BookingGuests (
            BookingID, GuestType, FullName, Email, Phone, AgeCategory,
            DateOfBirth, IDType, IDNumber, IDExpiryDate, Nationality,
            CreatedBy, CreatedDate
        )
        VALUES (
            @BookingID, @GuestType, @FullName, @Email, @Phone, @AgeCategory,
            @DateOfBirth, @IDType, @IDNumber, @IDExpiryDate, @Nationality,
            @CurrentUserID, GETUTCDATE()
        );

        SET @GuestID = SCOPE_IDENTITY();

        COMMIT TRANSACTION;
        SET @ErrorMessage = 'Guest added successfully';

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @ErrorCode = -999;
        SET @ErrorMessage = ERROR_MESSAGE();
    END CATCH
END
GO
