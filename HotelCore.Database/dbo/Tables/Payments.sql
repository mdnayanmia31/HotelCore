CREATE TABLE [dbo].[Payments] (
    [PaymentID]              INT             IDENTITY (1, 1) NOT NULL,
    [BookingID]              INT             NOT NULL,
    [PaymentReference]       NVARCHAR (100)  NOT NULL,
    [PaymentMethod]          NVARCHAR (50)   NOT NULL,
    [Amount]                 DECIMAL (10, 2) NOT NULL,
    [Currency]               NVARCHAR (3)    DEFAULT ('USD') NULL,
    [Status]                 NVARCHAR (20)   DEFAULT ('Pending') NOT NULL,
    [ProcessorTransactionID] NVARCHAR (200)  NULL,
    [ProcessorResponse]      NVARCHAR (MAX)  NULL,
    [PaymentDate]            DATETIME2 (7)   DEFAULT (getutcdate()) NULL,
    [RefundedAmount]         DECIMAL (10, 2) DEFAULT ((0)) NULL,
    [RefundedDate]           DATETIME2 (7)   NULL,
    [CreatedBy]              INT             NULL,
    [CreatedDate]            DATETIME2 (7)   DEFAULT (getutcdate()) NULL,
    PRIMARY KEY CLUSTERED ([PaymentID] ASC),
    CONSTRAINT [CHK_Payment_Amount] CHECK ([Amount]>(0) AND [RefundedAmount]>=(0)),
    CONSTRAINT [CHK_Payment_Method] CHECK ([PaymentMethod]='Wallet' OR [PaymentMethod]='BankTransfer' OR [PaymentMethod]='Cash' OR [PaymentMethod]='DebitCard' OR [PaymentMethod]='CreditCard'),
    CONSTRAINT [CHK_Payment_Status] CHECK ([Status]='PartialRefund' OR [Status]='Refunded' OR [Status]='Failed' OR [Status]='Captured' OR [Status]='Authorized' OR [Status]='Pending'),
    CONSTRAINT [FK_Payments_Booking] FOREIGN KEY ([BookingID]) REFERENCES [dbo].[Bookings] ([BookingID]),
    CONSTRAINT [FK_Payments_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[Users] ([UserID]),
    UNIQUE NONCLUSTERED ([PaymentReference] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_Payments_BookingStatus]
    ON [dbo].[Payments]([BookingID] ASC, [Status] ASC)
    INCLUDE([Amount], [PaymentDate]);

