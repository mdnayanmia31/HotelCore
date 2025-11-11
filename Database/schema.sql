/*HotelCore Database Schema 09/11/2025*/

USE master;
GO

-- Create database if not exists
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'HotelCore')
BEGIN
	CREATE DATABASE HotelCore;
END
GO

USE HotelCore;
GO

/*CORE ENTITIES*/

--Roles
CREATE Table Roles (
	RoleID INT PRIMARY KEY IDENTITY(1,1),
	RoleName NVARCHAR(50) NOT NULL UNIQUE,
	Description NVARCHAR(255),
	CreatedDate DATETIME2 DEFAULT GETUTCDATE(),
	CONSTRAINT CHK_Roles_RoleName CHECK (RoleName IN ('Guest', 'FrontDesk', 'Housekeeping', 'Manager', 'Admin'))
);

--Users
CREATE Table Users (
	UserID INT PRIMARY KEY IDENTITY(1,1),
	Email NVARCHAR(255) NOT NULL UNIQUE,
	PasswordHash NVARCHAR(500) NOT NULL,
	PasswordSalt NVARCHAR(100) NOT NULL,
	FirstName NVARCHAR(100) NOT NULL,
	LastName NVARCHAR(100) NOT NULL,
	PhoneNumber NVARCHAR(20),
	RoleID INT NOT NULL,
	IsActive BIT DEFAULT 1,
	LastLoginDate DATETIME2,
	CreatedDate DATETIME2 DEFAULT GETUTCDATE(),
	ModifiedDate DATETIME2 DEFAULT GETUTCDATE(),
	constraint FK_Users_Roles FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
);
-- from here need to verify and run on DB
--Room Types
CREATE Table RoomTypes (
	RoomTypeID INT PRIMARY KEY IDENTITY(1,1),
	TypeName NVARCHAR(100) NOT NULL UNIQUE,
	Description NVARCHAR(500),
	BaseHourlyRate DECIMAL(10,2) NOT NULL,
	BaseDailyRate DECIMAL(10,2) NOT NULL,
	MaxOccupancy INT NOT NULL,
	SquareFeet INT,
	BedConfiguration NVARCHAR(100),
	IsActive BIT DEFAULT 1,
	CreatedDate DATETIME2 DEFAULT GETUTCDATE(),
	CONSTRAINT CHK_RoomTypes_Rates CHECK (BaseHourlyRate > 0 AND BaseDailyRate > 0),
	CONSTRAINT CHK_RoomTypes_Occupancy CHECK (MaxOccupancy >0)
);

--Rooms
CREATE Table Rooms (
	RoomID INT PRIMARY KEY IDENTITY(1,1),
	RoomNumber NVARCHAR(10) NOT NULL UNIQUE,
	RoomTypeID INT NOT NULL,
	FloorNumber INT NOT NULL,
	Status NVARCHAR(20) NOT NULL DEFAULT 'Available',
	LastCleanedDate DATETIME2,
	Notes NVARCHAR(1000),
	IsActive BIT DEFAULT 1,
	CreatedDate DATETIME2 DEFAULT GETUTCDATE(),
	ModifiedDate DATETIME2 DEFAULT GETUTCDATE(),
	CONSTRAINT FK_Rooms_RoomTypes FOREIGN KEY (RoomTypeID) REFERENCES RoomTypes(RoomTypeID),
	CONSTRAINT CHK_Rooms_Status CHECK (Status IN ('Availble', 'Occupied', 'Cleaning', 'Maintenance', 'OutOfOrder' )),
	CONSTRAINT CHK_Rooms_Floor CHECK (FloorNumber>0)
);

--Room configurations
CREATE Table RoomConfigurations(
	ConfigID INT PRIMARY KEY IDENTITY(1,1),
	ConfigName NVARCHAR(100) NOT NULL UNIQUE,
	Description NVARCHAR(500),
	SetupTimeMinutes INT NOT NULL DEFAULT 30,
	TeardownTimeMinutes INT NOT NULL DEFAULT 15,
	IsActive BIT DEFAULT 1,
	CreatedDate DATETIME2 DEFAULT GETUTCDATE(),
	CONSTRAINT CHK_Config_Time CHECK (SetupTimeMinutes >= 0 AND TeardownTimeMinutes >= 0)
);

--Amenities
CREATE Table Amenities (
	AmenityID INT PRIMARY KEY IDENTITY(1,1),
	AmenityName NVARCHAR(100) NOT NULL UNIQUE,
	Category NVARCHAR(50) NOT NULL,
	IconClass NVARCHAR(50),
	IsActive BIT DEFAULT 1,
	CreatedDate DATETIME2 DEFAULT GETUTCDATE(),
	CONSTRAINT CHK_Amenities_Catagory CHECK (Category IN('Technology', 'Furniture', 'Service', 'Entertainment', 'Accessibility'))
);

--Configuration-Amenity junction 
CREATE Table ConfigurationAmenities (
	ConfigAmenityID INT PRIMARY KEY IDENTITY(1,1),
	ConfigID INT NOT NULL,
	AmenityID INT NOT NULL,
	Quantity INT DEFAULT 1,
	CONSTRAINT FK_ConfigAmenities_Config FOREIGN KEY (ConfigID) REFERENCES RoomConfigurations(ConfigID),
	CONSTRAINT FK_ConfigAmenities_Amenity FOREIGN KEY (AmenityID) REFERENCES Amenities(AmenityID),
	CONSTRAINT UQ_ConfigAmenity UNIQUE (ConfigID, AmenityID)
);

/*BOOKING & PRICING*/

--Bookings
CREATE TABLE Bookings(
	BookingID INT PRIMARY KEY IDENTITY(1,1),
	BookingReference NVARCHAR(20) NOT NULL UNIQUE,
	UserID INT NOT NULL,
	RoomID INT NOT NULL,
	ConfigID INT,
	StartDateTime DATETIME2 NOT NULL,
	EndDateTime DATETIME2 NOT NULL,
	TotalAmount DECIMAL(10,2) NOT NULL,
	DepositAmount DECIMAL(10,2) DEFAULT 0,
	Status NVARCHAR(20) NOT NULL DEFAULT 'Pending',
	GuestCount INT DEFAULT 1,
	AdultCount INT DEFAULT 1,
	ChildCount INT DEFAULT 0,
	InfantCount INT DEFAULT 0,
	SpecialRequests NVARCHAR(1000),
	CheckInDateTime DATETIME2,
	CheckOutDateTime DATETIME2,
	CreateDate DATETIME2 DEFAULT GETUTCDATE(),
	ModifiedDate DATETIME2 DEFAULT GETUTCDATE(),
	CancelledDate DATETIME2,
	CancellationReason NVARCHAR(500),
	CONSTRAINT FK_Bookings_Users FOREIGN KEY (UserID) References Users(UserID),
	CONSTRAINT FK_Bookings_Rooms FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID),
	CONSTRAINT FK_Bookings_Config FOREIGN KEY (ConfigID) REFERENCES RoomConfigurations (ConfigID),
	CONSTRAINT CHK_Bookings_DateTime CHECK (EndDateTime > StartDateTime), 
	CONSTRAINT CHK_Bookings_Status CHECK (Status IN ('Pending', 'Confirmed', 'CheckedIn', 'CheckedOut', 'Cancelled', 'NoShow')),
	CONSTRAINT CHK_Bookings_Amount CHECK (TotalAmount >= 0 AND DepositAmount >= 0)
);

--Booking Slots
Create Table BookingSlots (
	SlotID  INT PRIMARY KEY IDENTITY(1,1),
	BookingID INT NOT NULL,
	RoomID INT NOT NULL,
	StartDateTime DATETIME2 NOT NULL,
	EndDateTime DATETIME2 NOT NULL,
	HourlyRate DECIMAL (10,2),
	DailyRate DECIMAL (10,2),
	SlotAmount DECIMAL (10,2) NOT NUll,
	CONSTRAINT FK_BookingSlots_Booking FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID) ON DELETE CASCADE,
	CONSTRAINT FK_BookingSlots_Room FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID),
	CONSTRAINT CHK_Slots_DateTime CHECK (EndDateTime > StartDateTime),
	CONSTRAINT CHK_Slots_Amount CHECK (SlotAmount >= 0)
);

--Booking Guests