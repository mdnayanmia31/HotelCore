CREATE TABLE [dbo].[BookingReservations] (
    [ReservationID]  INT             IDENTITY (1, 1) NOT NULL,
    [UserID]         INT             NOT NULL,
    [RoomID]         INT             NOT NULL,
    [StartDateTime]  DATETIME2 (7)   NOT NULL,
    [EndDateTime]    DATETIME2 (7)   NOT NULL,
    [Status]         NVARCHAR (20)   DEFAULT ('RESERVED') NOT NULL,
    [ExpiresAt]      DATETIME2 (7)   NOT NULL,
    [ReservedAmount] DECIMAL (10, 2) NOT NULL,
    [BookingID]      INT             NULL,
    [CreatedBy]      INT             NULL,
    [CreatedDate]    DATETIME2 (7)   DEFAULT (getutcdate()) NULL,
    [ModifiedBy]     INT             NULL,
    [ModifiedDate]   DATETIME2 (7)   DEFAULT (getutcdate()) NULL,
    PRIMARY KEY CLUSTERED ([ReservationID] ASC),
    CONSTRAINT [CHK_Reservations_DateTime] CHECK ([EndDateTime]>[StartDateTime]),
    CONSTRAINT [CHK_Reservations_Expiry] CHECK ([ExpiresAt]>[CreatedDate]),
    CONSTRAINT [CHK_Reservations_Status] CHECK ([Status]='CANCELLED' OR [Status]='EXPIRED' OR [Status]='CONVERTED' OR [Status]='RESERVED'),
    CONSTRAINT [FK_Reservations_Booking] FOREIGN KEY ([BookingID]) REFERENCES [dbo].[Bookings] ([BookingID]),
    CONSTRAINT [FK_Reservations_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[Users] ([UserID]),
    CONSTRAINT [FK_Reservations_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserID]),
    CONSTRAINT [FK_Reservations_Rooms] FOREIGN KEY ([RoomID]) REFERENCES [dbo].[Rooms] ([RoomID]),
    CONSTRAINT [FK_Reservations_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([UserID])
);


GO
CREATE NONCLUSTERED INDEX [IX_Reservations_ExpiresAt]
    ON [dbo].[BookingReservations]([ExpiresAt] ASC, [Status] ASC)
    INCLUDE([ReservationID]);


GO
CREATE NONCLUSTERED INDEX [IX_Reservations_RoomDateTime]
    ON [dbo].[BookingReservations]([RoomID] ASC, [StartDateTime] ASC, [EndDateTime] ASC, [Status] ASC);

