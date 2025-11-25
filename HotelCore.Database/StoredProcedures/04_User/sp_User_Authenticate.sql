USE HotelCore;
GO

-- SP: User Authenticate

CREATE OR ALTER PROCEDURE sp_User_Authenticate
    @Email NVARCHAR(255),
    @PasswordHash NVARCHAR(500),
    @IPAddress NVARCHAR(50) = NULL,
    @UserAgent NVARCHAR(500) = NULL,
    @UserID INT OUTPUT,
    @RoleID INT OUTPUT,
    @RoleName NVARCHAR(50) OUTPUT,
    @FullName NVARCHAR(200) OUTPUT,
    @ErrorCode INT OUTPUT,
    @ErrorMessage NVARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @UserID = NULL;
    SET @ErrorCode = 0;
    SET @ErrorMessage = NULL;
    
    BEGIN TRY 
        -- get user details
        SELECT 
            @UserID = u.UserID,
            @RoleID = u.RoleID,
            @RoleName = r.RoleName,
            @FullName = u.FirstName + ' ' + u.LastName
        FROM Users u
        INNER JOIN Roles  r ON u.RoleID = r.RoleID
        WHERE u.Email = @Email
            AND u.PasswordHash = @PasswordHash
            AND u.IsActive = 1;
        
        IF @UserID IS NULL
        BEGIN
            SET @ErrorCode = -1;
            SET @ErrorMessage = 'Invalid email or password';
            RETURN;
        END
        
        UPDATE Users
        SET LastLoginDate = GETUTCDATE()
        WHERE UserID = @UserID;
        
        -- Audit log
        INSERT INTO AuditLog (UserID, TableName, RecordID, ActionType, IPAddress, UserAgent, CreatedDate)
        VALUES (@UserID, 'Users', @UserID, 'LOGIN', @IPAddress,  @UserAgent, GETUTCDATE());
    
        SET @ErrorMessage = 'Login successful';
    
    END TRY
    BEGIN CATCH
        SET @ErrorCode =  -999;
        SET @ErrorMessage = ERROR_MESSAGE();
    END CATCH
END
GO