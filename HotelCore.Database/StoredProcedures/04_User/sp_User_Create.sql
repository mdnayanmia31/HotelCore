USE HotelCore;
GO

-- SP: User Create
CREATE OR ALTER PROCEDURE sp_User_Create
    @Email NVARCHAR(255),
    @PasswordHash NVARCHAR(500),
    @PasswordSalt NVARCHAR(100),
    @FirstName NVARCHAR(100),
    @LastName NVARCHAR(100),
    @PhoneNumber NVARCHAR(20),
    @RoleID INT,
    @CurrentUserID INT = NULL,
    @UserID INT OUTPUT,
    @ErrorCode INT OUTPUT,
    @ErrorMessage NVARCHAR(500) OUTPUT
AS 
BEGIN
    SET NOCOUNT ON;
    SET @UserID = NULL;
    SET @ErrorCode = 0;
    SET @ErrorMessage = NULL;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- check if email already exists
        IF EXISTS (SELECT 1 FROM Users WHERE Email = @Email)
        BEGIN
            SET @ErrorCode = -1;
            SET @ErrorMessage = 'Email already exists';
            ROLLBACK TRANSACTION;
            RETURN;
        END
        -- validate role
        IF NOT EXISTS(SELECT 1 from Roles WHERE RoleID = @RoleID AND RoleName != 'Admin' )
            BEGIN
                SET @ErrorCode = -2;
                SET @ErrorMessage = 'Invalid role';
                ROLLBACK TRANSACTION;
                RETURN;
            END
        
        INSERT INTO Users (
                Email, PasswordHash, PasswordSalt, FirstName, LastName, 
                PhoneNumber, RoleID, IsActive, CreatedBy, ModifiedBy, CreatedDate, ModifiedDate 
        ) VALUES (
                @Email, @PasswordHash, @PasswordSalt, @FirstName, @LastName,
                @PhoneNumber, @RoleID, 1, @CurrentUserID, @CurrentUserID, GETUTCDATE(), GETUTCDATE() 
        );
        
        SET @UserID = SCOPE_IDENTITY();
        
        -- Audit log
        INSERT INTO AuditLog(UserID, TableName, RecordID, ActionType,NewValues, CreatedDate)
        VALUES(@CurrentUserID, 'Users', @UserID, 'INSERT', 'Email=' + @Email, GETUTCDATE());
        
        COMMIT TRANSACTION;
        SET @ErrorMessage = 'User created successsfully';
    
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 00 ROLLBACK TRANSACTION;
        SET @ErrorCode = -999;
        SET @ErrorMessage = ERROR_MESSAGE();
    END CATCH
END
GO
