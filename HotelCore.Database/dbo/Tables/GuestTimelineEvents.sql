CREATE TABLE [dbo].[GuestTimelineEvents] (
    [EventID]       INT             IDENTITY (1, 1) NOT NULL,
    [BookingID]     INT             NOT NULL,
    [EventType]     NVARCHAR (50)   NOT NULL,
    [EventDateTime] DATETIME2 (7)   NOT NULL,
    [Title]         NVARCHAR (200)  NOT NULL,
    [Description]   NVARCHAR (1000) NULL,
    [Status]        NVARCHAR (20)   DEFAULT ('Pending') NOT NULL,
    [ActionURL]     NVARCHAR (500)  NULL,
    [IsVisible]     BIT             DEFAULT ((1)) NULL,
    [CreatedDate]   DATETIME2 (7)   DEFAULT (getutcdate()) NULL,
    PRIMARY KEY CLUSTERED ([EventID] ASC),
    CONSTRAINT [CHK_Timeline_EventType] CHECK ([EventType]='LoyaltyReward' OR [EventType]='PostStayFeedback' OR [EventType]='CheckoutReminder' OR [EventType]='ServiceRequest' OR [EventType]='RoomReady' OR [EventType]='MobileCheckIn' OR [EventType]='PreArrivalEmail'),
    CONSTRAINT [CHK_Timeline_Status] CHECK ([Status]='Failed' OR [Status]='Completed' OR [Status]='Opened' OR [Status]='Delivered' OR [Status]='Sent' OR [Status]='Pending'),
    CONSTRAINT [FK_TimelineEvents_Booking] FOREIGN KEY ([BookingID]) REFERENCES [dbo].[Bookings] ([BookingID])
);


GO
CREATE NONCLUSTERED INDEX [IX_TimelineEvents_BookingType]
    ON [dbo].[GuestTimelineEvents]([BookingID] ASC, [EventType] ASC, [Status] ASC)
    INCLUDE([EventDateTime], [Title]);

