CREATE TABLE [dbo].[RoomConfigurations] (
    [ConfigID]            INT            IDENTITY (1, 1) NOT NULL,
    [ConfigName]          NVARCHAR (100) NOT NULL,
    [Description]         NVARCHAR (500) NULL,
    [SetupTimeMinutes]    INT            DEFAULT ((30)) NOT NULL,
    [TeardownTimeMinutes] INT            DEFAULT ((15)) NOT NULL,
    [IsActive]            BIT            DEFAULT ((1)) NULL,
    [CreatedBy]           INT            NULL,
    [CreatedDate]         DATETIME2 (7)  DEFAULT (getutcdate()) NULL,
    [ModifiedBy]          INT            NULL,
    [ModifiedDate]        DATETIME2 (7)  DEFAULT (getutcdate()) NULL,
    PRIMARY KEY CLUSTERED ([ConfigID] ASC),
    CONSTRAINT [CHK_Config_Time] CHECK ([SetupTimeMinutes]>=(0) AND [TeardownTimeMinutes]>=(0)),
    CONSTRAINT [FK_RoomConfigurations_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[Users] ([UserID]),
    CONSTRAINT [FK_RoomConfigurations_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserID]),
    UNIQUE NONCLUSTERED ([ConfigName] ASC)
);

