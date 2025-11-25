CREATE TABLE [dbo].[Users] (
    [UserID]        INT            IDENTITY (1, 1) NOT NULL,
    [Email]         NVARCHAR (255) NOT NULL,
    [PasswordHash]  NVARCHAR (500) NOT NULL,
    [PasswordSalt]  NVARCHAR (100) NOT NULL,
    [FirstName]     NVARCHAR (100) NOT NULL,
    [LastName]      NVARCHAR (100) NOT NULL,
    [PhoneNumber]   NVARCHAR (20)  NULL,
    [RoleID]        INT            NOT NULL,
    [IsActive]      BIT            DEFAULT ((1)) NULL,
    [LastLoginDate] DATETIME2 (7)  NULL,
    [CreatedDate]   DATETIME2 (7)  DEFAULT (getutcdate()) NULL,
    [ModifiedDate]  DATETIME2 (7)  DEFAULT (getutcdate()) NULL,
    [CreatedBy]     INT            NULL,
    [ModifiedBy]    INT            NULL,
    PRIMARY KEY CLUSTERED ([UserID] ASC),
    CONSTRAINT [FK_Users_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[Users] ([UserID]),
    CONSTRAINT [FK_Users_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserID]),
    CONSTRAINT [FK_Users_Roles] FOREIGN KEY ([RoleID]) REFERENCES [dbo].[Roles] ([RoleID]),
    UNIQUE NONCLUSTERED ([Email] ASC)
);

