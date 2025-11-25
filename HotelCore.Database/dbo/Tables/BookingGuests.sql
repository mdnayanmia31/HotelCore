CREATE TABLE [dbo].[BookingGuests] (
    [GuestID]           INT             IDENTITY (1, 1) NOT NULL,
    [BookingID]         INT             NOT NULL,
    [GuestType]         NVARCHAR (20)   NOT NULL,
    [FullName]          NVARCHAR (200)  NOT NULL,
    [Email]             NVARCHAR (255)  NULL,
    [Phone]             NVARCHAR (20)   NULL,
    [AgeCategory]       NVARCHAR (20)   DEFAULT ('Adult') NOT NULL,
    [DateOfBirth]       DATE            NULL,
    [IDType]            NVARCHAR (50)   NULL,
    [IDNumber]          NVARCHAR (100)  NULL,
    [IDExpiryDate]      DATE            NULL,
    [Nationality]       NVARCHAR (100)  NULL,
    [IsCheckedIn]       BIT             DEFAULT ((0)) NULL,
    [CheckedInDateTime] DATETIME2 (7)   NULL,
    [Notes]             NVARCHAR (1000) NULL,
    [CreatedBy]         INT             NULL,
    [CreatedDate]       DATETIME2 (7)   DEFAULT (getutcdate()) NULL,
    PRIMARY KEY CLUSTERED ([GuestID] ASC),
    CONSTRAINT [CHK_Guests_Age] CHECK ([AgeCategory]='Infant' OR [AgeCategory]='Child' OR [AgeCategory]='Adult'),
    CONSTRAINT [CHK_Guests_Type] CHECK ([GuestType]='Additional' OR [GuestType]='Primary'),
    CONSTRAINT [FK_BookingGuests_Booking] FOREIGN KEY ([BookingID]) REFERENCES [dbo].[Bookings] ([BookingID]) ON DELETE CASCADE,
    CONSTRAINT [FK_BookingGuests_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[Users] ([UserID])
);


GO
CREATE NONCLUSTERED INDEX [IX_BookingGuests_BookingID]
    ON [dbo].[BookingGuests]([BookingID] ASC, [GuestType] ASC)
    INCLUDE([FullName], [Email], [AgeCategory]);


GO
CREATE NONCLUSTERED INDEX [IX_BookingGuests_Name]
    ON [dbo].[BookingGuests]([FullName] ASC, [Email] ASC)
    INCLUDE([BookingID], [Phone]);

