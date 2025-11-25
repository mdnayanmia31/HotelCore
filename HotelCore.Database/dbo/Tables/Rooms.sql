CREATE TABLE [dbo].[Rooms] (
    [RoomID]          INT             IDENTITY (1, 1) NOT NULL,
    [RoomNumber]      NVARCHAR (10)   NOT NULL,
    [RoomTypeID]      INT             NOT NULL,
    [FloorNumber]     INT             NOT NULL,
    [Status]          NVARCHAR (20)   DEFAULT ('Available') NOT NULL,
    [LastCleanedDate] DATETIME2 (7)   NULL,
    [Notes]           NVARCHAR (1000) NULL,
    [IsActive]        BIT             DEFAULT ((1)) NULL,
    [CreatedBy]       INT             NULL,
    [CreatedDate]     DATETIME2 (7)   DEFAULT (getutcdate()) NULL,
    [ModifiedBy]      INT             NULL,
    [ModifiedDate]    DATETIME2 (7)   DEFAULT (getutcdate()) NULL,
    PRIMARY KEY CLUSTERED ([RoomID] ASC),
    CONSTRAINT [CHK_Rooms_Floor] CHECK ([FloorNumber]>(0)),
    CONSTRAINT [CHK_Rooms_Status] CHECK ([Status]='OutOfOrder' OR [Status]='Maintenance' OR [Status]='Cleaning' OR [Status]='Occupied' OR [Status]='Available'),
    CONSTRAINT [FK_Rooms_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[Users] ([UserID]),
    CONSTRAINT [FK_Rooms_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserID]),
    CONSTRAINT [FK_Rooms_RoomTypes] FOREIGN KEY ([RoomTypeID]) REFERENCES [dbo].[RoomTypes] ([RoomTypeID]),
    UNIQUE NONCLUSTERED ([RoomNumber] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_Rooms_TypeStatus]
    ON [dbo].[Rooms]([RoomTypeID] ASC, [Status] ASC)
    INCLUDE([RoomNumber], [FloorNumber]);


GO
CREATE NONCLUSTERED INDEX [IX_Rooms_Status]
    ON [dbo].[Rooms]([Status] ASC)
    INCLUDE([RoomID], [RoomNumber], [RoomTypeID]);

