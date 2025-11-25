CREATE TABLE [dbo].[Bookings] (
    [BookingID]          INT             IDENTITY (1, 1) NOT NULL,
    [BookingReference]   NVARCHAR (20)   NOT NULL,
    [UserID]             INT             NOT NULL,
    [RoomID]             INT             NOT NULL,
    [ConfigID]           INT             NULL,
    [StartDateTime]      DATETIME2 (7)   NOT NULL,
    [EndDateTime]        DATETIME2 (7)   NOT NULL,
    [TotalAmount]        DECIMAL (10, 2) NOT NULL,
    [DepositAmount]      DECIMAL (10, 2) DEFAULT ((0)) NULL,
    [Status]             NVARCHAR (20)   DEFAULT ('Pending') NOT NULL,
    [GuestCount]         INT             DEFAULT ((1)) NULL,
    [AdultCount]         INT             DEFAULT ((1)) NULL,
    [ChildCount]         INT             DEFAULT ((0)) NULL,
    [InfantCount]        INT             DEFAULT ((0)) NULL,
    [SpecialRequests]    NVARCHAR (1000) NULL,
    [CheckInDateTime]    DATETIME2 (7)   NULL,
    [CheckOutDateTime]   DATETIME2 (7)   NULL,
    [CreatedBy]          INT             NULL,
    [CreatedDate]        DATETIME2 (7)   DEFAULT (getutcdate()) NULL,
    [ModifiedBy]         INT             NULL,
    [ModifiedDate]       DATETIME2 (7)   DEFAULT (getutcdate()) NULL,
    [CancelledDate]      DATETIME2 (7)   NULL,
    [CancellationReason] NVARCHAR (500)  NULL,
    PRIMARY KEY CLUSTERED ([BookingID] ASC),
    CONSTRAINT [CHK_Bookings_Amount] CHECK ([TotalAmount]>=(0) AND [DepositAmount]>=(0)),
    CONSTRAINT [CHK_Bookings_DateTime] CHECK ([EndDateTime]>[StartDateTime]),
    CONSTRAINT [CHK_Bookings_Status] CHECK ([Status]='NoShow' OR [Status]='Cancelled' OR [Status]='CheckedOut' OR [Status]='CheckedIn' OR [Status]='Confirmed' OR [Status]='Pending'),
    CONSTRAINT [FK_Bookings_Config] FOREIGN KEY ([ConfigID]) REFERENCES [dbo].[RoomConfigurations] ([ConfigID]),
    CONSTRAINT [FK_Bookings_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[Users] ([UserID]),
    CONSTRAINT [FK_Bookings_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserID]),
    CONSTRAINT [FK_Bookings_Rooms] FOREIGN KEY ([RoomID]) REFERENCES [dbo].[Rooms] ([RoomID]),
    CONSTRAINT [FK_Bookings_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([UserID]),
    UNIQUE NONCLUSTERED ([BookingReference] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_Bookings_UserStatus]
    ON [dbo].[Bookings]([UserID] ASC, [Status] ASC, [StartDateTime] ASC)
    INCLUDE([RoomID], [TotalAmount], [BookingReference]);


GO
CREATE NONCLUSTERED INDEX [IX_Bookings_RoomDateTime]
    ON [dbo].[Bookings]([RoomID] ASC, [StartDateTime] ASC, [EndDateTime] ASC)
    INCLUDE([Status], [UserID]);


GO
CREATE NONCLUSTERED INDEX [IX_Bookings_CreatedBy]
    ON [dbo].[Bookings]([CreatedBy] ASC, [CreatedDate] ASC)
    INCLUDE([BookingID], [Status]);


GO
CREATE NONCLUSTERED INDEX [IX_Bookings_ModifiedBy]
    ON [dbo].[Bookings]([ModifiedBy] ASC, [ModifiedDate] ASC)
    INCLUDE([BookingID], [Status]);

