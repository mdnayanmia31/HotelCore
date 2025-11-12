/*
	HotelCore Database Schema 
	Date: 09/11/2025 - 12/11/2025
	Tables and Indexes (SQL Server)
*/

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

/* CORE ENTITIES */

-- Roles
CREATE Table Roles (
	RoleID INT PRIMARY KEY IDENTITY(1,1),
	RoleName NVARCHAR(50) NOT NULL UNIQUE,
	Description NVARCHAR(255),
	CreatedDate DATETIME2 DEFAULT GETUTCDATE(),
	CONSTRAINT CHK_Roles_RoleName CHECK (RoleName IN ('Guest', 'FrontDesk', 'Housekeeping', 'Manager', 'Admin'))
);

-- Users
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
	CreatedBy INT NULL,
	CreatedDate DATETIME2 DEFAULT GETUTCDATE(),
	ModifiedBy INT NULL,
	ModifiedDate DATETIME2 DEFAULT GETUTCDATE(),
	CONSTRAINT FK_Users_Roles FOREIGN KEY (RoleID) REFERENCES Roles(RoleID),
	CONSTRAINT FK_Users_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES Users(UserID),
	CONSTRAINT FK_Users_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES Users(UserID)
);
	
-- Room Types
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
	CreatedBy INT NULL,
	CreatedDate DATETIME2 DEFAULT GETUTCDATE(),
	ModifiedBy INT NULL,
	ModifiedDate DATETIME2 DEFAULT GETUTCDATE(),
	CONSTRAINT FK_RoomTypes_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES Users(UserID),
	CONSTRAINT FK_RoomTypes_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES Users(UserID),
	CONSTRAINT CHK_RoomTypes_Rates CHECK (BaseHourlyRate > 0 AND BaseDailyRate > 0),
	CONSTRAINT CHK_RoomTypes_Occupancy CHECK (MaxOccupancy >0),
);

-- Rooms
CREATE Table Rooms (
	RoomID INT PRIMARY KEY IDENTITY(1,1),
	RoomNumber NVARCHAR(10) NOT NULL UNIQUE,
	RoomTypeID INT NOT NULL,
	FloorNumber INT NOT NULL,
	Status NVARCHAR(20) NOT NULL DEFAULT 'Available',
	LastCleanedDate DATETIME2,
	Notes NVARCHAR(1000),
	IsActive BIT DEFAULT 1,
	CreatedBy INT NULL,
	CreatedDate DATETIME2 DEFAULT GETUTCDATE(),
	ModifiedBy INT NULL,
	ModifiedDate DATETIME2 DEFAULT GETUTCDATE(),
	CONSTRAINT FK_Rooms_RoomTypes FOREIGN KEY (RoomTypeID) REFERENCES RoomTypes(RoomTypeID),
	CONSTRAINT FK_Rooms_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES Users(UserID),
	CONSTRAINT FK_Rooms_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES Users(UserID),
	CONSTRAINT CHK_Rooms_Status CHECK (Status IN ('Available', 'Occupied', 'Cleaning', 'Maintenance', 'OutOfOrder' )),
	CONSTRAINT CHK_Rooms_Floor CHECK (FloorNumber>0)
);

-- Room configurations
CREATE Table RoomConfigurations(
	ConfigID INT PRIMARY KEY IDENTITY(1,1),
	ConfigName NVARCHAR(100) NOT NULL UNIQUE,
	Description NVARCHAR(500),
	SetupTimeMinutes INT NOT NULL DEFAULT 30,
	TeardownTimeMinutes INT NOT NULL DEFAULT 15,
	IsActive BIT DEFAULT 1,
	CreatedBy INT NULL,
	CreatedDate DATETIME2 DEFAULT GETUTCDATE(),
	ModifiedBy INT NULL,
	ModifiedDate DATETIME2 DEFAULT GETUTCDATE(),
	CONSTRAINT FK_RoomConfigurations_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES Users(UserID),
	CONSTRAINT FK_RoomConfigurations_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES Users(UserID),
	CONSTRAINT CHK_Config_Time CHECK (SetupTimeMinutes >= 0 AND TeardownTimeMinutes >= 0)
);

-- Amenities
CREATE Table Amenities (
	AmenityID INT PRIMARY KEY IDENTITY(1,1),
	AmenityName NVARCHAR(100) NOT NULL UNIQUE,
	Category NVARCHAR(50) NOT NULL,
	IconClass NVARCHAR(50),
	IsActive BIT DEFAULT 1,
	CreatedBy INT NULL,
	CreatedDate DATETIME2 DEFAULT GETUTCDATE(),
	ModifiedBy INT NULL,
	ModifiedDate DATETIME2 DEFAULT GETUTCDATE(),
	CONSTRAINT FK_Amenities_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES Users(UserID),
	CONSTRAINT FK_Amenities_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES Users(UserID),
	CONSTRAINT CHK_Amenities_Catagory CHECK (Category IN('Technology', 'Furniture', 'Service', 'Entertainment', 'Accessibility'))
);

-- Configuration-Amenity junction 
CREATE Table ConfigurationAmenities (
	ConfigAmenityID INT PRIMARY KEY IDENTITY(1,1),
	ConfigID INT NOT NULL,
	AmenityID INT NOT NULL,
	Quantity INT DEFAULT 1,
	CONSTRAINT FK_ConfigAmenities_Config FOREIGN KEY (ConfigID) REFERENCES RoomConfigurations(ConfigID),
	CONSTRAINT FK_ConfigAmenities_Amenity FOREIGN KEY (AmenityID) REFERENCES Amenities(AmenityID),
	CONSTRAINT UQ_ConfigAmenity UNIQUE (ConfigID, AmenityID)
);

/* BOOKING & PRICING */

-- Bookings
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
	CreatedBy INT NULL,
	CreatedDate DATETIME2 DEFAULT GETUTCDATE(),
	ModifiedBy INT NULL,
	ModifiedDate DATETIME2 DEFAULT GETUTCDATE(),
	CancelledDate DATETIME2,
	CancellationReason NVARCHAR(500),
	CONSTRAINT FK_Bookings_Users FOREIGN KEY (UserID) References Users(UserID),
	CONSTRAINT FK_Bookings_Rooms FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID),
	CONSTRAINT FK_Bookings_Config FOREIGN KEY (ConfigID) REFERENCES RoomConfigurations (ConfigID),
	CONSTRAINT FK_Bookings_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES Users(UserID),
	CONSTRAINT FK_Bookings_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES Users(UserID),
	CONSTRAINT CHK_Bookings_DateTime CHECK (EndDateTime > StartDateTime), 
	CONSTRAINT CHK_Bookings_Status CHECK (Status IN ('Pending', 'Confirmed', 'CheckedIn', 'CheckedOut', 'Cancelled', 'NoShow')),
	CONSTRAINT CHK_Bookings_Amount CHECK (TotalAmount >= 0 AND DepositAmount >= 0)
);

-- Booking Slots
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

-- Booking Guests
CREATE TABLE BookingGuests (
    GuestID INT PRIMARY KEY IDENTITY(1,1),
    BookingID INT NOT NULL, 
    GuestType NVARCHAR(20) NOT NULL, -- Primary, Additional
    FullName NVARCHAR(200) NOT NULL, 
    Email NVARCHAR(255),
    Phone NVARCHAR(20),
    AgeCategory NVARCHAR(20) NOT NULL DEFAULT 'Adult',
    DateOfBirth DATE,
    IDType NVARCHAR(50), -- Passport, DriverLicense, NationalID
    IDNumber NVARCHAR(100), 
    IDExpiryDate DATE,
    Nationality NVARCHAR(100),
    IsCheckedIn BIT DEFAULT 0, 
    CheckedInDateTime DATETIME2,
    Notes NVARCHAR(1000),
	CreatedBy INT NULL,
    CreatedDate DATETIME2 DEFAULT GETUTCDATE(),
    CONSTRAINT FK_BookingGuests_Booking FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID) ON DELETE CASCADE,
	CONSTRAINT FK_BookingGuests_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES Users(UserID),
    CONSTRAINT CHK_Guests_Type CHECK (GuestType IN('Primary', 'Additional')),
    CONSTRAINT CHK_Guests_Age CHECK (AgeCategory IN ('Adult', 'Child', 'Infant'))
);

-- Temporary Booking Reservations
CREATE TABLE BookingReservations (
    ReservationID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    RoomID INT NOT NULL,
    StartDateTime DATETIME2 NOT NULL,
    EndDateTime DATETIME2 NOT NULL, 
    Status NVARCHAR(20) NOT NULL DEFAULT 'RESERVED',
    ExpiresAt DATETIME2 NOT NULL,
    ReservedAmount DECIMAL(10,2) NOT NULL, 
    BookingID INT NULL, -- linked after conversion
    CreatedBy INT NULL,
	CreatedDate DATETIME2 DEFAULT GETUTCDATE(),
	ModifiedBy INT NULL,
	ModifiedDate DATETIME2 DEFAULT GETUTCDATE(),
    CONSTRAINT FK_Reservations_Users FOREIGN KEY (UserID) REFERENCES Users(UserID),
    CONSTRAINT FK_Reservations_Rooms FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID),
    CONSTRAINT FK_Reservations_Booking FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID),
	CONSTRAINT FK_Reservations_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES Users(UserID),
	CONSTRAINT FK_Reservations_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES Users(UserID),
    CONSTRAINT CHK_Reservations_Status CHECK(Status IN ('RESERVED', 'CONVERTED', 'EXPIRED', 'CANCELLED')),
    CONSTRAINT CHK_Reservations_DateTime CHECK(EndDateTime > StartDateTime),
    CONSTRAINT CHK_Reservations_Expiry CHECK ( ExpiresAt > CreatedDate)
);

-- Pricing Rules
CREATE TABLE DynamicPricingStrategies(
    StrategyID INT PRIMARY KEY IDENTITY(1,1),
    StrategyName NVARCHAR(100) NOT NULL UNIQUE,
    StrategyType NVARCHAR(50) NOT NULL,
    Description NVARCHAR(500),
    Priority INT NOT NULL DEFAULT 10,
    IsActive BIT DEFAULT 1,
    
    -- Occupancy strategy
    OccupancyThreshold DECIMAL(5,2), -- e.g., 0.80 for 80%
    OccupancyAdjustmentType NVARCHAR(20), -- Percentage, or FixedAmount
    OccupancyAdjustmentValue DECIMAL(10,2),
    
    -- Urgency strategy
    UrgencyDaysThreshold INT, -- e.g., 7 days
    UrgencyAdjustmentType NVARCHAR(20),
    UrgencyAdjustmentValue DECIMAL(10,2),
    
    -- Holiday strategy
    HolidayName NVARCHAR(100),
    HolidayStartDate DATE,
    HolidayEndDate DATE,
    HolidayAdjustmentType NVARCHAR(20),
    HolidayAdjustmentValue DECIMAL(10,2),
    
    -- Discount strategy
    DiscountCode NVARCHAR(50),
    DiscountStartDate DATE,
    DiscountEndDate DATE,
    DiscountAdjustmentType NVARCHAR(20),
    DiscountAdjustmentValue DECIMAL(10,2),
    DiscountMinimumStay INT,
    DiscountBookingTimeStart TIME,
    DiscountBookingTimeEnd TIME,
    
    CreatedBy INT NULL,
	CreatedDate DATETIME2 DEFAULT GETUTCDATE(),
	ModifiedBy INT NULL,
	ModifiedDate DATETIME2 DEFAULT GETUTCDATE(),
	CONSTRAINT FK_DynamicPricingStrategies_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES Users(UserID),
	CONSTRAINT FK_DynamicPricingStrategies_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES Users(UserID),
    CONSTRAINT CHK_Strategy_Type CHECK (StrategyType IN ('Occupancy', 'Urgency', 'Holiday', 'Discount', 'Base'))    
);

-- Pricing History (Audit Trail)
CREATE TABLE PricingHistory (
    HistoryID INT PRIMARY KEY IDENTITY(1,1),
    BookingID INT NOT NULL, 
    CalculationDateTime DATETIME2 DEFAULT GETUTCDATE(),
    BasePrice DECIMAL(10,2) NOT NULL,
    
    -- Applied strategies
    OccupancyAdjustment DECIMAL(10,2) DEFAULT 0,
    UrgencyAdjustment DECIMAL(10,2) DEFAULT 0,
    HolidayAdjustment DECIMAL(10,2) DEFAULT 0, 
    DiscountAdjustment DECIMAL(10,2) DEFAULT 0,
    
    -- Metadata
    CurrentOccupancyRate DECIMAL(5,2),
    DaysUntilCheckIn INT,
    IsHolidayPeriod BIT,
    AppliedDiscountCode NVARCHAR(50),
    
    FinalPrice DECIMAL(10,2) NOT NULL,
    CalculationDetails NVARCHAR(MAX), -- JSON/XML breakdown
    CONSTRAINT FK_PricingHistory_Booking FOREIGN KEY(BookingID) REFERENCES Bookings(BookingID) ON DELETE CASCADE
);

/* UPSELL */

-- Upsell Rules
CREATE TABLE UpsellRules(
    RuleID INT PRIMARY KEY IDENTITY(1,1),
    RuleName NVARCHAR(100) NOT NULL UNIQUE,
    Description NVARCHAR(500),
    TriggerType NVARCHAR(50) NOT NULL,
    TriggerCondition NVARCHAR(500),
    UpsellTitle NVARCHAR(200) NOT NULL,
    UpsellDescription NVARCHAR(1000),
    UpsellAmount DECIMAL(10,2) NOT NULL,
    DiscountPercent DECIMAL(5,2) DEFAULT 0,
    Priority INT DEFAULT 10,
    IsActive BIT DEFAULT 1,
    CreatedBy INT NULL,
	CreatedDate DATETIME2 DEFAULT GETUTCDATE(),
	ModifiedBy INT NULL,
	ModifiedDate DATETIME2 DEFAULT GETUTCDATE(),
	CONSTRAINT FK_UpsellRules_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES Users(UserID),
	CONSTRAINT FK_UpsellRules_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES Users(UserID),
    CONSTRAINT CHK_Upsell_TriggerType CHECK (TriggerType IN ('BookingTime', 'RoomType', 'StayDuration', 'Occupancy', 'DayOfWeek')),
    CONSTRAINT CHK_Upsell_Amount CHECK (UpsellAmount >= 0),
    CONSTRAINT CHK_Upsell_Discount CHECK (DiscountPercent >= 0 AND DiscountPercent <= 100)
);

-- Upsell Offers (tracking offered)
CREATE TABLE UpsellOffers (
    OfferID INT PRIMARY KEY IDENTITY(1,1),
    BookingID INT NOT NULL,
    RuleID INT NOT NULL,
    OfferAmount DECIMAL(10,2) NOT NULL,
    Status NVARCHAR(20) NOT NULL DEFAULT 'Offered',
    OfferedDate DATETIME2 DEFAULT GETUTCDATE(),
    ResponseDate DATETIME2,
    CONSTRAINT FK_UpsellOffers_Booking FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID),
    CONSTRAINT FK_UpsellOffers_Rule FOREIGN KEY (RuleID) REFERENCES UpsellRules(RuleID),
    CONSTRAINT CHK_Upsell_Status CHECK ( Status IN ('Offered', 'Accepted', 'Declined', 'Expired') )
);

/* STAFF & HOUSEKEEPING */

-- Staff
CREATE TABLE Staff (
    StaffID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL UNIQUE,
    EmployeeNumber NVARCHAR(20) NOT NULL UNIQUE,
    Department NVARCHAR(50) NOT NULL,
    Position NVARCHAR(50) NOT NULL,
    HireDate DATE NOT NULL,
    IsActive BIT DEFAULT 1,
    CreatedBy INT NULL,
	CreatedDate DATETIME2 DEFAULT GETUTCDATE(),
	ModifiedBy INT NULL,
	ModifiedDate DATETIME2 DEFAULT GETUTCDATE(),
    CONSTRAINT FK_Staff_Users FOREIGN KEY (UserID) REFERENCES Users(UserID),
	CONSTRAINT FK_Staff_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES Users(UserID),
	CONSTRAINT FK_Staff_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES Users(UserID),
    CONSTRAINT CHK_Staff_Department CHECK ( Department IN ('FrontDesk', 'Housekeeping', 'Management', 'Maintenance') )
);

-- Staff Schedule 
CREATE TABLE StaffSchedule (
    ScheduleID INT PRIMARY KEY IDENTITY(1,1),
    StaffID INT NOT NULL,
    ShiftDate DATE NOT NULL,
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    Status NVARCHAR(20) NOT NULL DEFAULT 'Scheduled',
    Notes NVARCHAR(500),
    CreatedBy INT NULL,
	CreatedDate DATETIME2 DEFAULT GETUTCDATE(),
	ModifiedBy INT NULL,
	ModifiedDate DATETIME2 DEFAULT GETUTCDATE(),
    CONSTRAINT FK_StaffSchedule_Staff FOREIGN KEY (StaffID) REFERENCES Staff(StaffID),
	CONSTRAINT FK_StaffSchedule_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES Users(UserID),
	CONSTRAINT FK_StaffSchedule_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES Users(UserID),
    CONSTRAINT CHK_Schedule_Status CHECK( Status IN ('Scheduled', 'Active', 'Completed', 'Absent','Cancelled')),
    CONSTRAINT CHK_Schedule_Time CHECK ( EndTime > StartTime)
);

-- Housekeeping Tasks
CREATE TABLE HousekeepingTasks (
    TaskID INT PRIMARY KEY IDENTITY(1,1),
    RoomID INT NOT NULL,
    BookingID INT,
    AssignedStaffID INT,
    TaskType NVARCHAR(50) NOT NULL, 
    Priority NVARCHAR(20) NOT NULL DEFAULT 'Normal',
    Status NVARCHAR(20) NOT NULL DEFAULT 'Pending',
    DueDateTime DATETIME2 NOT NULL,
    StartedDateTime DATETIME2,
    CompletedDateTime DATETIME2,
    EstimatedMinutes INT NOT NULL DEFAULT 30,
    ActualMinutes INT,
    Notes NVARCHAR(1000),
    CreatedBy INT NULL,
	CreatedDate DATETIME2 DEFAULT GETUTCDATE(),
	ModifiedBy INT NULL,
	ModifiedDate DATETIME2 DEFAULT GETUTCDATE(),
    CONSTRAINT FK_HousekeepingTasks_Room FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID),
    CONSTRAINT FK_HousekeepingTasks_Booking FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID),
    CONSTRAINT FK_HousekeepingTasks_Staff FOREIGN KEY (AssignedStaffID) REFERENCES Staff(StaffID),
	CONSTRAINT FK_HousekeepingTasks_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES Users(UserID),
	CONSTRAINT FK_HousekeepingTasks_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES Users(UserID),
    CONSTRAINT CHK_Tasks_Type CHECK (TaskType IN ('Checkout', 'Turnover', 'DeepClean', 'ConfigChange', 'Maintenance', 'Inspection')),
    CONSTRAINT CHK_Tasks_Priority CHECK ( Priority IN ('Low', 'Normal', 'High', 'Urgent') ),
    CONSTRAINT CHK_Tasks_Status CHECK (Status IN ('Pending', 'Assigned', 'InProgress', 'Completed', 'Cancelled', 'Failed'))     
);

-- Guest Timeline Events
CREATE TABLE GuestTimelineEvents (
    EventID INT PRIMARY KEY IDENTITY(1,1),
    BookingID INT NOT NULL,
    EventType NVARCHAR(50) NOT NULL,
    EventDateTime DATETIME2 NOT NULL,
    Title NVARCHAR(200) NOT NULL,
    Description NVARCHAR(1000),
    Status NVARCHAR(20) NOT NULL DEFAULT 'Pending',
    ActionURL NVARCHAR(500),
    IsVisible BIT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETUTCDATE(),
    CONSTRAINT FK_TimelineEvents_Booking FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID),
    CONSTRAINT CHK_Timeline_EventType CHECK(EventType IN ('PreArrivalEmail', 'MobileCheckIn', 'RoomReady', 'ServiceRequest', 'CheckoutReminder', 'PostStayFeedback', 'LoyaltyReward')),
    CONSTRAINT CHK_Timeline_Status CHECK (Status IN ('Pending', 'Sent', 'Delivered', 'Opened', 'Completed', 'Failed'))
);

/* PAYMENTS & AUDIT */

-- Payments
CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY IDENTITY(1,1),
    BookingID INT NOT NULL,
    PaymentReference NVARCHAR(100) NOT NULL UNIQUE,
    PaymentMethod NVARCHAR(50) NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    Currency NVARCHAR(3) DEFAULT 'USD',
    Status NVARCHAR(20) NOT NULL DEFAULT 'Pending',
    ProcessorTransactionID NVARCHAR(200),
    ProcessorResponse NVARCHAR(MAX),
    PaymentDate DATETIME2 DEFAULT GETUTCDATE(),
    RefundedAmount DECIMAL(10,2) DEFAULT 0,
    RefundedDate DATETIME2,
	CreatedBy INT NULL,
    CreatedDate DATETIME2 DEFAULT GETUTCDATE(),
    CONSTRAINT FK_Payments_Booking FOREIGN KEY (BookingID) REFERENCES  Bookings(BookingID),
	CONSTRAINT FK_Payments_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES Users(UserID),
    CONSTRAINT CHK_Payment_Method CHECK (PaymentMethod IN ('CreditCard', 'DebitCard', 'Cash', 'BankTransfer', 'Wallet')),
    CONSTRAINT CHK_Payment_Status CHECK(Status IN ('Pending', 'Authorized', 'Captured', 'Failed', 'Refunded', 'PartialRefund')),
    CONSTRAINT CHK_Payment_Amount CHECK ( Amount > 0 AND RefundedAmount >= 0 )
);

-- Audit Log
CREATE TABLE AuditLog (
    AuditID BIGINT PRIMARY KEY IDENTITY(1,1),
    UserID INT,
    TableName NVARCHAR(100) NOT NULL,
    RecordID INT NOT NULL, 
    ActionType NVARCHAR(20) NOT NULL,
    OldValues NVARCHAR(MAX),
    NewValues NVARCHAR(MAX),
    IPAddress NVARCHAR(50),
    UserAgent NVARCHAR(500),
    CreatedDate DATETIME2 DEFAULT GETUTCDATE(),
    CONSTRAINT FK_AuditLog_Users FOREIGN KEY (UserID) REFERENCES Users(UserID),
    CONSTRAINT CHK_Audit_ActionType CHECK ( ActionType IN ('INSERT', 'UPDATE', 'DELETE', 'LOGIN', 'LOGOUT') )
);

GO

/* INDEXES FOR PERFORMANCE */

-- Bookings
CREATE NONCLUSTERED INDEX IX_BookingSlots_RoomDateTime
       ON BookingSlots(RoomID, StartDateTime, EndDateTime)
       INCLUDE (BookingID, SlotAmount);

CREATE NONCLUSTERED INDEX IX_Bookings_UserStatus
       ON Bookings(UserID, Status, StartDateTime)
       INCLUDE (RoomID, TotalAmount, BookingReference);
CREATE NONCLUSTERED INDEX IX_Bookings_RoomDateTime
       ON Bookings(RoomID, StartDateTime, EndDateTime)
       INCLUDE (Status, UserID);
CREATE NONCLUSTERED INDEX IX_Bookings_CreatedBy
	   ON Bookings(CreatedBy, CreatedDate)
	   INCLUDE (BookingID, Status);
CREATE NONCLUSTERED INDEX IX_Bookings_ModifiedBy
	   ON Bookings(ModifiedBy, ModifiedDate)
	   INCLUDE (BookingID, Status);

CREATE NONCLUSTERED INDEX IX_Reservations_ExpiresAt 
        ON BookingReservations(ExpiresAt, Status) 
        INCLUDE (ReservationID);
CREATE NONCLUSTERED INDEX IX_Reservations_RoomDateTime 
        ON BookingReservations(RoomID, StartDateTime, EndDateTime, Status);

-- Guests
CREATE NONCLUSTERED INDEX IX_BookingGuests_BookingID
       ON BookingGuests(BookingID, GuestType)
       INCLUDE (FullName, Email, AgeCategory);
CREATE NONCLUSTERED INDEX IX_BookingGuests_Name
       ON BookingGuests(FullName, Email)
       INCLUDE (BookingID, Phone);

-- Rooms
CREATE NONCLUSTERED INDEX IX_Rooms_TypeStatus
       ON Rooms(RoomTypeID, Status)
       INCLUDE (RoomNumber, FloorNumber);

CREATE NONCLUSTERED INDEX IX_Rooms_Status
       ON Rooms(Status)
       INCLUDE (RoomID, RoomNumber, RoomTypeID);

-- Housekeeping
CREATE NONCLUSTERED INDEX IX_HousekeepingTasks_StaffStatus
       ON HousekeepingTasks(AssignedStaffID, Status, DueDateTime)
       INCLUDE (RoomID, TaskType, Priority);

CREATE NONCLUSTERED INDEX IX_HousekeepingTasks_RoomStatus
       ON HousekeepingTasks(RoomID, Status, DueDateTime);

-- Staff Scheduling
CREATE NONCLUSTERED INDEX IX_StaffSchedule_StaffDate
       ON StaffSchedule(StaffID, ShiftDate)
       INCLUDE (StartTime, EndTime, Status);
CREATE NONCLUSTERED INDEX IX_StaffSchedule_DateStatus
       ON StaffSchedule(ShiftDate, Status)
       INCLUDE (StaffID, StartTime, EndTime);

-- Timeline & Upsells
CREATE NONCLUSTERED INDEX IX_TimelineEvents_BookingType
       ON GuestTimelineEvents(BookingID, EventType, Status)
       INCLUDE (EventDateTime, Title);
CREATE NONCLUSTERED INDEX IX_UpsellOffers_BookingStatus
       ON UpsellOffers(BookingID, Status)
       INCLUDE (RuleID, OfferAmount);

-- Audit & Reporting
CREATE NONCLUSTERED INDEX IX_AuditLog_UserDate
       ON AuditLog(UserID, CreatedDate)
       INCLUDE (TableName, ActionType);
CREATE NONCLUSTERED INDEX IX_Payments_BookingStatus
       ON Payments(BookingID, Status)
       INCLUDE (Amount, PaymentDate);

GO
