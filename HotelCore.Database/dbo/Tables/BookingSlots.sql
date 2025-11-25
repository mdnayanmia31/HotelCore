CREATE TABLE [dbo].[BookingSlots] (
    [SlotID]        INT             IDENTITY (1, 1) NOT NULL,
    [BookingID]     INT             NOT NULL,
    [RoomID]        INT             NOT NULL,
    [StartDateTime] DATETIME2 (7)   NOT NULL,
    [EndDateTime]   DATETIME2 (7)   NOT NULL,
    [HourlyRate]    DECIMAL (10, 2) NULL,
    [DailyRate]     DECIMAL (10, 2) NULL,
    [SlotAmount]    DECIMAL (10, 2) NOT NULL,
    PRIMARY KEY CLUSTERED ([SlotID] ASC),
    CONSTRAINT [CHK_Slots_Amount] CHECK ([SlotAmount]>=(0)),
    CONSTRAINT [CHK_Slots_DateTime] CHECK ([EndDateTime]>[StartDateTime]),
    CONSTRAINT [FK_BookingSlots_Booking] FOREIGN KEY ([BookingID]) REFERENCES [dbo].[Bookings] ([BookingID]) ON DELETE CASCADE,
    CONSTRAINT [FK_BookingSlots_Room] FOREIGN KEY ([RoomID]) REFERENCES [dbo].[Rooms] ([RoomID])
);


GO
CREATE NONCLUSTERED INDEX [IX_BookingSlots_RoomDateTime]
    ON [dbo].[BookingSlots]([RoomID] ASC, [StartDateTime] ASC, [EndDateTime] ASC)
    INCLUDE([BookingID], [SlotAmount]);

