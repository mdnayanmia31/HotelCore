CREATE TABLE [dbo].[RoomTypes] (
    [RoomTypeID]       INT             IDENTITY (1, 1) NOT NULL,
    [TypeName]         NVARCHAR (100)  NOT NULL,
    [Description]      NVARCHAR (500)  NULL,
    [BaseHourlyRate]   DECIMAL (10, 2) NOT NULL,
    [BaseDailyRate]    DECIMAL (10, 2) NOT NULL,
    [MaxOccupancy]     INT             NOT NULL,
    [SquareFeet]       INT             NULL,
    [BedConfiguration] NVARCHAR (100)  NULL,
    [IsActive]         BIT             DEFAULT ((1)) NULL,
    [CreatedBy]        INT             NULL,
    [CreatedDate]      DATETIME2 (7)   DEFAULT (getutcdate()) NULL,
    [ModifiedBy]       INT             NULL,
    [ModifiedDate]     DATETIME2 (7)   DEFAULT (getutcdate()) NULL,
    PRIMARY KEY CLUSTERED ([RoomTypeID] ASC),
    CONSTRAINT [CHK_RoomTypes_Occupancy] CHECK ([MaxOccupancy]>(0)),
    CONSTRAINT [CHK_RoomTypes_Rates] CHECK ([BaseHourlyRate]>(0) AND [BaseDailyRate]>(0)),
    CONSTRAINT [FK_RoomTypes_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[Users] ([UserID]),
    CONSTRAINT [FK_RoomTypes_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserID]),
    UNIQUE NONCLUSTERED ([TypeName] ASC)
);

