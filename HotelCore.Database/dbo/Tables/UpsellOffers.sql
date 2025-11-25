CREATE TABLE [dbo].[UpsellOffers] (
    [OfferID]      INT             IDENTITY (1, 1) NOT NULL,
    [BookingID]    INT             NOT NULL,
    [RuleID]       INT             NOT NULL,
    [OfferAmount]  DECIMAL (10, 2) NOT NULL,
    [Status]       NVARCHAR (20)   DEFAULT ('Offered') NOT NULL,
    [OfferedDate]  DATETIME2 (7)   DEFAULT (getutcdate()) NULL,
    [ResponseDate] DATETIME2 (7)   NULL,
    PRIMARY KEY CLUSTERED ([OfferID] ASC),
    CONSTRAINT [CHK_Upsell_Status] CHECK ([Status]='Expired' OR [Status]='Declined' OR [Status]='Accepted' OR [Status]='Offered'),
    CONSTRAINT [FK_UpsellOffers_Booking] FOREIGN KEY ([BookingID]) REFERENCES [dbo].[Bookings] ([BookingID]),
    CONSTRAINT [FK_UpsellOffers_Rule] FOREIGN KEY ([RuleID]) REFERENCES [dbo].[UpsellRules] ([RuleID])
);


GO
CREATE NONCLUSTERED INDEX [IX_UpsellOffers_BookingStatus]
    ON [dbo].[UpsellOffers]([BookingID] ASC, [Status] ASC)
    INCLUDE([RuleID], [OfferAmount]);

