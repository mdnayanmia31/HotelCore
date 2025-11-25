CREATE TABLE [dbo].[PricingHistory] (
    [HistoryID]            INT             IDENTITY (1, 1) NOT NULL,
    [BookingID]            INT             NOT NULL,
    [CalculationDateTime]  DATETIME2 (7)   DEFAULT (getutcdate()) NULL,
    [BasePrice]            DECIMAL (10, 2) NOT NULL,
    [OccupancyAdjustment]  DECIMAL (10, 2) DEFAULT ((0)) NULL,
    [UrgencyAdjustment]    DECIMAL (10, 2) DEFAULT ((0)) NULL,
    [HolidayAdjustment]    DECIMAL (10, 2) DEFAULT ((0)) NULL,
    [DiscountAdjustment]   DECIMAL (10, 2) DEFAULT ((0)) NULL,
    [CurrentOccupancyRate] DECIMAL (5, 2)  NULL,
    [DaysUntilCheckIn]     INT             NULL,
    [IsHolidayPeriod]      BIT             NULL,
    [AppliedDiscountCode]  NVARCHAR (50)   NULL,
    [FinalPrice]           DECIMAL (10, 2) NOT NULL,
    [CalculationDetails]   NVARCHAR (MAX)  NULL,
    PRIMARY KEY CLUSTERED ([HistoryID] ASC),
    CONSTRAINT [FK_PricingHistory_Booking] FOREIGN KEY ([BookingID]) REFERENCES [dbo].[Bookings] ([BookingID]) ON DELETE CASCADE
);

