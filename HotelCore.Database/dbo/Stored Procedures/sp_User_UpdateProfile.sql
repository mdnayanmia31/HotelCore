
-- SP: User Update Profile
CREATE   PROCEDURE sp_User_UpdateProfile
    @UserID INT,
    @FirstName NVARCHAR(100),
    @LastName NVARCHAR(100),
    @PhoneNumber NVARCHAR(20),
    @CurrentUserID INT,
    @ErrorCode INT OUTPUT,
    @ErrorMessage NVARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @ErrorCode = 0;
    SET @ErrorMessage = NULL;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        IF NOT EXISTS (SELECT 1 FROM Users WHERE UserID = @UserID and IsActive = 1)
            BEGIN
                SET @ErrorCode = -1;
                SET @ErrorMessage = 'User not found';
                ROLLBACK TRANSACTION;
                RETURN;
            END
            
            DECLARE @OldValues NVARCHAR(MAX);
            SELECT @OldValues = 'FirstName= ' + FirstName + ',LastName=' + LastName + ',Phone=' + ISNULL(PhoneNumber, '')
                FROM Users WHERE UserID = @UserID;
            
            UPDATE Users 
                SET FirstName = @FirstName,
                    LastName = @LastName, 
                    PhoneNumber = @PhoneNumber, 
                    ModifiedBy = @CurrentUserID,
                    ModifiedDate = GETUTCDATE()
                WHERE UserID = @UserID;
        
        -- Audit log
            INSERT INTO AuditLog (UserID, TableName, RecordID, ActionType, OldValues, NewValues, CreatedDate)
            VALUES ( @CurrentUserID, 'Users', @UserID, 'UPDATE', @OldValues,
                    'FirstName=' + @FirstName + ',LastName=' + @LastName, GETUTCDATE());
        
            COMMIT TRANSACTION;
            SET @ErrorMessage = 'Profile updated successfully';
        
        END TRY
        BEGIN CATCH 
            IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
            SET @ErrorCode = -999;
            SET @ErrorMessage = ERROR_MESSAGE();
        END CATCH
END
