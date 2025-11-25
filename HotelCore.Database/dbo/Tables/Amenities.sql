CREATE TABLE [dbo].[Amenities] (
    [AmenityID]    INT            IDENTITY (1, 1) NOT NULL,
    [AmenityName]  NVARCHAR (100) NOT NULL,
    [Category]     NVARCHAR (50)  NOT NULL,
    [IconClass]    NVARCHAR (50)  NULL,
    [IsActive]     BIT            DEFAULT ((1)) NULL,
    [CreatedBy]    INT            NULL,
    [CreatedDate]  DATETIME2 (7)  DEFAULT (getutcdate()) NULL,
    [ModifiedBy]   INT            NULL,
    [ModifiedDate] DATETIME2 (7)  DEFAULT (getutcdate()) NULL,
    PRIMARY KEY CLUSTERED ([AmenityID] ASC),
    CONSTRAINT [CHK_Amenities_Catagory] CHECK ([Category]='Accessibility' OR [Category]='Entertainment' OR [Category]='Service' OR [Category]='Furniture' OR [Category]='Technology'),
    CONSTRAINT [FK_Amenities_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[Users] ([UserID]),
    CONSTRAINT [FK_Amenities_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserID]),
    UNIQUE NONCLUSTERED ([AmenityName] ASC)
);

