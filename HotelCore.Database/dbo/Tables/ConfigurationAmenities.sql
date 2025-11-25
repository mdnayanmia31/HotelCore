CREATE TABLE [dbo].[ConfigurationAmenities] (
    [ConfigAmenityID] INT IDENTITY (1, 1) NOT NULL,
    [ConfigID]        INT NOT NULL,
    [AmenityID]       INT NOT NULL,
    [Quantity]        INT DEFAULT ((1)) NULL,
    PRIMARY KEY CLUSTERED ([ConfigAmenityID] ASC),
    CONSTRAINT [FK_ConfigAmenities_Amenity] FOREIGN KEY ([AmenityID]) REFERENCES [dbo].[Amenities] ([AmenityID]),
    CONSTRAINT [FK_ConfigAmenities_Config] FOREIGN KEY ([ConfigID]) REFERENCES [dbo].[RoomConfigurations] ([ConfigID]),
    CONSTRAINT [UQ_ConfigAmenity] UNIQUE NONCLUSTERED ([ConfigID] ASC, [AmenityID] ASC)
);

