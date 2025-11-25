CREATE TABLE [dbo].[Staff] (
    [StaffID]        INT           IDENTITY (1, 1) NOT NULL,
    [UserID]         INT           NOT NULL,
    [EmployeeNumber] NVARCHAR (20) NOT NULL,
    [Department]     NVARCHAR (50) NOT NULL,
    [Position]       NVARCHAR (50) NOT NULL,
    [HireDate]       DATE          NOT NULL,
    [IsActive]       BIT           DEFAULT ((1)) NULL,
    [CreatedBy]      INT           NULL,
    [CreatedDate]    DATETIME2 (7) DEFAULT (getutcdate()) NULL,
    [ModifiedBy]     INT           NULL,
    [ModifiedDate]   DATETIME2 (7) DEFAULT (getutcdate()) NULL,
    PRIMARY KEY CLUSTERED ([StaffID] ASC),
    CONSTRAINT [CHK_Staff_Department] CHECK ([Department]='Maintenance' OR [Department]='Management' OR [Department]='Housekeeping' OR [Department]='FrontDesk'),
    CONSTRAINT [FK_Staff_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[Users] ([UserID]),
    CONSTRAINT [FK_Staff_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserID]),
    CONSTRAINT [FK_Staff_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([UserID]),
    UNIQUE NONCLUSTERED ([EmployeeNumber] ASC),
    UNIQUE NONCLUSTERED ([UserID] ASC)
);

