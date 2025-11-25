CREATE TABLE [dbo].[Roles] (
    [RoleID]      INT            IDENTITY (1, 1) NOT NULL,
    [RoleName]    NVARCHAR (50)  NOT NULL,
    [Description] NVARCHAR (255) NULL,
    [CreatedDate] DATETIME2 (7)  DEFAULT (getutcdate()) NULL,
    PRIMARY KEY CLUSTERED ([RoleID] ASC),
    CONSTRAINT [CHK_Roles_RoleName] CHECK ([RoleName]='Admin' OR [RoleName]='Manager' OR [RoleName]='Housekeeping' OR [RoleName]='FrontDesk' OR [RoleName]='Guest'),
    UNIQUE NONCLUSTERED ([RoleName] ASC)
);

