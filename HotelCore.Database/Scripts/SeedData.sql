/*
 * HotelCore Database Seed Data Script
 * This script populates essential tables with initial data for the hotel management system
 */

-- Enable IDENTITY_INSERT for seeding data with specific IDs
SET IDENTITY_INSERT [dbo].[Roles] ON;

-- 1. Seed Roles (must match CHECK constraint: Admin, Manager, Housekeeping, FrontDesk, Guest)
IF NOT EXISTS (SELECT 1 FROM [dbo].[Roles] WHERE [RoleName] = 'Admin')
BEGIN
    INSERT INTO [dbo].[Roles] ([RoleID], [RoleName], [Description], [CreatedDate])
    VALUES 
        (1, 'Admin', 'System administrator with full access', GETUTCDATE()),
        (2, 'Manager', 'Hotel manager with management access', GETUTCDATE()),
        (3, 'FrontDesk', 'Front desk staff for guest services', GETUTCDATE()),
        (4, 'Housekeeping', 'Housekeeping staff for room maintenance', GETUTCDATE()),
        (5, 'Guest', 'Hotel guest with booking capabilities', GETUTCDATE());
END

SET IDENTITY_INSERT [dbo].[Roles] OFF;

-- 2. Seed Users (At least one admin user for initial login)
-- Password: Admin@123 (hashed with a simple salt for demo purposes)
-- Note: In production, use proper password hashing with BCrypt or similar
SET IDENTITY_INSERT [dbo].[Users] ON;

IF NOT EXISTS (SELECT 1 FROM [dbo].[Users] WHERE [Email] = 'admin@hotelcore.com')
BEGIN
    INSERT INTO [dbo].[Users] ([UserID], [Email], [PasswordHash], [PasswordSalt], [FirstName], [LastName], [PhoneNumber], [RoleID], [IsActive], [CreatedDate], [ModifiedDate])
    VALUES 
        (1, 'admin@hotelcore.com', 'AQAAAAIAAYagAAAAEKNZ3LwK5P0gP5xY8z+1234567890abcdef1234567890abcdef1234567890abcdef', 'SaltValue123', 'System', 'Admin', '+1-555-0001', 1, 1, GETUTCDATE(), GETUTCDATE()),
        (2, 'manager@hotelcore.com', 'AQAAAAIAAYagAAAAEKNZ3LwK5P0gP5xY8z+1234567890abcdef1234567890abcdef1234567890abcdef', 'SaltValue456', 'John', 'Smith', '+1-555-0002', 2, 1, GETUTCDATE(), GETUTCDATE()),
        (3, 'frontdesk@hotelcore.com', 'AQAAAAIAAYagAAAAEKNZ3LwK5P0gP5xY8z+1234567890abcdef1234567890abcdef1234567890abcdef', 'SaltValue789', 'Emily', 'Johnson', '+1-555-0003', 3, 1, GETUTCDATE(), GETUTCDATE()),
        (4, 'housekeeping@hotelcore.com', 'AQAAAAIAAYagAAAAEKNZ3LwK5P0gP5xY8z+1234567890abcdef1234567890abcdef1234567890abcdef', 'SaltValue012', 'Maria', 'Garcia', '+1-555-0004', 4, 1, GETUTCDATE(), GETUTCDATE()),
        (5, 'guest@hotelcore.com', 'AQAAAAIAAYagAAAAEKNZ3LwK5P0gP5xY8z+1234567890abcdef1234567890abcdef1234567890abcdef', 'SaltValue345', 'Michael', 'Brown', '+1-555-0005', 5, 1, GETUTCDATE(), GETUTCDATE());
END

SET IDENTITY_INSERT [dbo].[Users] OFF;

-- 3. Seed RoomTypes (Standard, Deluxe, Suite, Executive Suite)
SET IDENTITY_INSERT [dbo].[RoomTypes] ON;

IF NOT EXISTS (SELECT 1 FROM [dbo].[RoomTypes] WHERE [TypeName] = 'Standard')
BEGIN
    INSERT INTO [dbo].[RoomTypes] ([RoomTypeID], [TypeName], [Description], [BaseHourlyRate], [BaseDailyRate], [MaxOccupancy], [SquareFeet], [BedConfiguration], [IsActive], [CreatedBy], [CreatedDate], [ModifiedDate])
    VALUES 
        (1, 'Standard', 'Comfortable standard room with essential amenities', 25.00, 120.00, 2, 250, '1 Queen Bed', 1, 1, GETUTCDATE(), GETUTCDATE()),
        (2, 'Deluxe', 'Spacious deluxe room with premium amenities', 35.00, 180.00, 3, 350, '1 King Bed or 2 Queen Beds', 1, 1, GETUTCDATE(), GETUTCDATE()),
        (3, 'Suite', 'Luxurious suite with separate living area', 50.00, 280.00, 4, 550, '1 King Bed + Sofa Bed', 1, 1, GETUTCDATE(), GETUTCDATE()),
        (4, 'Executive Suite', 'Premium executive suite with panoramic views', 75.00, 450.00, 6, 800, '2 King Beds + Living Room', 1, 1, GETUTCDATE(), GETUTCDATE());
END

SET IDENTITY_INSERT [dbo].[RoomTypes] OFF;

-- 4. Seed Rooms (Sample rooms across different floors)
SET IDENTITY_INSERT [dbo].[Rooms] ON;

IF NOT EXISTS (SELECT 1 FROM [dbo].[Rooms] WHERE [RoomNumber] = '101')
BEGIN
    INSERT INTO [dbo].[Rooms] ([RoomID], [RoomNumber], [RoomTypeID], [FloorNumber], [Status], [LastCleanedDate], [Notes], [IsActive], [CreatedBy], [CreatedDate], [ModifiedDate])
    VALUES 
        -- Floor 1 - Standard Rooms
        (1, '101', 1, 1, 'Available', GETUTCDATE(), 'Ground floor, accessible room', 1, 1, GETUTCDATE(), GETUTCDATE()),
        (2, '102', 1, 1, 'Available', GETUTCDATE(), NULL, 1, 1, GETUTCDATE(), GETUTCDATE()),
        (3, '103', 1, 1, 'Available', GETUTCDATE(), NULL, 1, 1, GETUTCDATE(), GETUTCDATE()),
        (4, '104', 2, 1, 'Available', GETUTCDATE(), 'Corner room with extra windows', 1, 1, GETUTCDATE(), GETUTCDATE()),
        
        -- Floor 2 - Mix of Standard and Deluxe
        (5, '201', 1, 2, 'Available', GETUTCDATE(), NULL, 1, 1, GETUTCDATE(), GETUTCDATE()),
        (6, '202', 1, 2, 'Occupied', GETUTCDATE(), NULL, 1, 1, GETUTCDATE(), GETUTCDATE()),
        (7, '203', 2, 2, 'Available', GETUTCDATE(), NULL, 1, 1, GETUTCDATE(), GETUTCDATE()),
        (8, '204', 2, 2, 'Available', GETUTCDATE(), NULL, 1, 1, GETUTCDATE(), GETUTCDATE()),
        (9, '205', 2, 2, 'Cleaning', GETUTCDATE(), NULL, 1, 1, GETUTCDATE(), GETUTCDATE()),
        
        -- Floor 3 - Deluxe and Suites
        (10, '301', 2, 3, 'Available', GETUTCDATE(), NULL, 1, 1, GETUTCDATE(), GETUTCDATE()),
        (11, '302', 2, 3, 'Available', GETUTCDATE(), NULL, 1, 1, GETUTCDATE(), GETUTCDATE()),
        (12, '303', 3, 3, 'Available', GETUTCDATE(), 'Suite with balcony', 1, 1, GETUTCDATE(), GETUTCDATE()),
        (13, '304', 3, 3, 'Available', GETUTCDATE(), 'Suite with city view', 1, 1, GETUTCDATE(), GETUTCDATE()),
        
        -- Floor 4 - Premium Suites
        (14, '401', 3, 4, 'Available', GETUTCDATE(), NULL, 1, 1, GETUTCDATE(), GETUTCDATE()),
        (15, '402', 4, 4, 'Available', GETUTCDATE(), 'Executive suite with terrace', 1, 1, GETUTCDATE(), GETUTCDATE()),
        (16, '403', 4, 4, 'Maintenance', DATEADD(day, -2, GETUTCDATE()), 'Scheduled maintenance', 1, 1, GETUTCDATE(), GETUTCDATE());
END

SET IDENTITY_INSERT [dbo].[Rooms] OFF;

-- 5. Seed RoomConfigurations (Standard, Meeting, Event)
SET IDENTITY_INSERT [dbo].[RoomConfigurations] ON;

IF NOT EXISTS (SELECT 1 FROM [dbo].[RoomConfigurations] WHERE [ConfigName] = 'Standard')
BEGIN
    INSERT INTO [dbo].[RoomConfigurations] ([ConfigID], [ConfigName], [Description], [SetupTimeMinutes], [TeardownTimeMinutes], [IsActive], [CreatedBy], [CreatedDate], [ModifiedDate])
    VALUES 
        (1, 'Standard', 'Standard room configuration for regular guests', 30, 15, 1, 1, GETUTCDATE(), GETUTCDATE()),
        (2, 'Meeting', 'Conference room setup with meeting table and chairs', 60, 30, 1, 1, GETUTCDATE(), GETUTCDATE()),
        (3, 'Event', 'Event configuration with banquet-style seating', 90, 45, 1, 1, GETUTCDATE(), GETUTCDATE()),
        (4, 'Classroom', 'Classroom-style setup for training sessions', 45, 30, 1, 1, GETUTCDATE(), GETUTCDATE()),
        (5, 'Theater', 'Theater-style seating for presentations', 60, 30, 1, 1, GETUTCDATE(), GETUTCDATE());
END

SET IDENTITY_INSERT [dbo].[RoomConfigurations] OFF;

-- 6. Seed Amenities (Technology, Furniture, Service, Entertainment, Accessibility)
SET IDENTITY_INSERT [dbo].[Amenities] ON;

IF NOT EXISTS (SELECT 1 FROM [dbo].[Amenities] WHERE [AmenityName] = 'WiFi')
BEGIN
    INSERT INTO [dbo].[Amenities] ([AmenityID], [AmenityName], [Category], [IconClass], [IsActive], [CreatedBy], [CreatedDate], [ModifiedDate])
    VALUES 
        -- Technology Amenities
        (1, 'WiFi', 'Technology', 'fa-wifi', 1, 1, GETUTCDATE(), GETUTCDATE()),
        (2, 'Smart TV', 'Technology', 'fa-tv', 1, 1, GETUTCDATE(), GETUTCDATE()),
        (3, 'Laptop Safe', 'Technology', 'fa-lock', 1, 1, GETUTCDATE(), GETUTCDATE()),
        (4, 'USB Charging Ports', 'Technology', 'fa-charging-station', 1, 1, GETUTCDATE(), GETUTCDATE()),
        (5, 'Bluetooth Speaker', 'Technology', 'fa-volume-up', 1, 1, GETUTCDATE(), GETUTCDATE()),
        
        -- Furniture Amenities
        (6, 'King Size Bed', 'Furniture', 'fa-bed', 1, 1, GETUTCDATE(), GETUTCDATE()),
        (7, 'Work Desk', 'Furniture', 'fa-desk', 1, 1, GETUTCDATE(), GETUTCDATE()),
        (8, 'Sofa', 'Furniture', 'fa-couch', 1, 1, GETUTCDATE(), GETUTCDATE()),
        (9, 'Coffee Table', 'Furniture', 'fa-table', 1, 1, GETUTCDATE(), GETUTCDATE()),
        (10, 'Wardrobe', 'Furniture', 'fa-door-closed', 1, 1, GETUTCDATE(), GETUTCDATE()),
        
        -- Service Amenities
        (11, 'Room Service', 'Service', 'fa-concierge-bell', 1, 1, GETUTCDATE(), GETUTCDATE()),
        (12, 'Daily Housekeeping', 'Service', 'fa-broom', 1, 1, GETUTCDATE(), GETUTCDATE()),
        (13, 'Laundry Service', 'Service', 'fa-tshirt', 1, 1, GETUTCDATE(), GETUTCDATE()),
        (14, 'Minibar', 'Service', 'fa-glass-martini', 1, 1, GETUTCDATE(), GETUTCDATE()),
        (15, 'Breakfast Included', 'Service', 'fa-coffee', 1, 1, GETUTCDATE(), GETUTCDATE()),
        
        -- Entertainment Amenities
        (16, 'Cable TV', 'Entertainment', 'fa-tv', 1, 1, GETUTCDATE(), GETUTCDATE()),
        (17, 'Streaming Services', 'Entertainment', 'fa-film', 1, 1, GETUTCDATE(), GETUTCDATE()),
        (18, 'In-Room Movies', 'Entertainment', 'fa-video', 1, 1, GETUTCDATE(), GETUTCDATE()),
        (19, 'Game Console', 'Entertainment', 'fa-gamepad', 1, 1, GETUTCDATE(), GETUTCDATE()),
        (20, 'Reading Light', 'Entertainment', 'fa-book-reader', 1, 1, GETUTCDATE(), GETUTCDATE()),
        
        -- Accessibility Amenities
        (21, 'Wheelchair Accessible', 'Accessibility', 'fa-wheelchair', 1, 1, GETUTCDATE(), GETUTCDATE()),
        (22, 'Grab Bars', 'Accessibility', 'fa-hand-holding', 1, 1, GETUTCDATE(), GETUTCDATE()),
        (23, 'Lower Light Switches', 'Accessibility', 'fa-lightbulb', 1, 1, GETUTCDATE(), GETUTCDATE()),
        (24, 'Visual Alarms', 'Accessibility', 'fa-bell', 1, 1, GETUTCDATE(), GETUTCDATE()),
        (25, 'Roll-in Shower', 'Accessibility', 'fa-shower', 1, 1, GETUTCDATE(), GETUTCDATE());
END

SET IDENTITY_INSERT [dbo].[Amenities] OFF;

-- 7. Seed ConfigurationAmenities (Link amenities to configurations)
SET IDENTITY_INSERT [dbo].[ConfigurationAmenities] ON;

IF NOT EXISTS (SELECT 1 FROM [dbo].[ConfigurationAmenities] WHERE [ConfigID] = 1 AND [AmenityID] = 1)
BEGIN
    INSERT INTO [dbo].[ConfigurationAmenities] ([ConfigAmenityID], [ConfigID], [AmenityID], [Quantity])
    VALUES 
        -- Standard Configuration Amenities
        (1, 1, 1, 1),   -- WiFi
        (2, 1, 2, 1),   -- Smart TV
        (3, 1, 6, 1),   -- King Size Bed
        (4, 1, 7, 1),   -- Work Desk
        (5, 1, 10, 1),  -- Wardrobe
        (6, 1, 11, 1),  -- Room Service
        (7, 1, 12, 1),  -- Daily Housekeeping
        (8, 1, 14, 1),  -- Minibar
        (9, 1, 16, 1),  -- Cable TV
        
        -- Meeting Configuration Amenities
        (10, 2, 1, 1),   -- WiFi
        (11, 2, 2, 1),   -- Smart TV
        (12, 2, 4, 6),   -- USB Charging Ports
        (13, 2, 5, 1),   -- Bluetooth Speaker
        (14, 2, 7, 6),   -- Work Desks
        (15, 2, 9, 2),   -- Coffee Tables
        (16, 2, 11, 1),  -- Room Service
        
        -- Event Configuration Amenities
        (17, 3, 1, 1),   -- WiFi
        (18, 3, 2, 2),   -- Smart TVs
        (19, 3, 4, 10),  -- USB Charging Ports
        (20, 3, 5, 2),   -- Bluetooth Speakers
        (21, 3, 8, 4),   -- Sofas
        (22, 3, 9, 4),   -- Coffee Tables
        (23, 3, 11, 1),  -- Room Service
        (24, 3, 15, 1),  -- Breakfast Included
        
        -- Classroom Configuration Amenities
        (25, 4, 1, 1),   -- WiFi
        (26, 4, 2, 1),   -- Smart TV
        (27, 4, 4, 8),   -- USB Charging Ports
        (28, 4, 7, 8),   -- Work Desks
        (29, 4, 20, 8),  -- Reading Lights
        
        -- Theater Configuration Amenities
        (30, 5, 1, 1),   -- WiFi
        (31, 5, 2, 1),   -- Smart TV
        (32, 5, 5, 2),   -- Bluetooth Speakers
        (33, 5, 17, 1),  -- Streaming Services
        (34, 5, 20, 10); -- Reading Lights
END

SET IDENTITY_INSERT [dbo].[ConfigurationAmenities] OFF;

-- 8. Seed Staff (Sample staff members)
SET IDENTITY_INSERT [dbo].[Staff] ON;

IF NOT EXISTS (SELECT 1 FROM [dbo].[Staff] WHERE [EmployeeNumber] = 'EMP001')
BEGIN
    INSERT INTO [dbo].[Staff] ([StaffID], [UserID], [EmployeeNumber], [Department], [Position], [HireDate], [IsActive], [CreatedBy], [CreatedDate], [ModifiedDate])
    VALUES 
        (1, 2, 'EMP001', 'Management', 'Hotel Manager', '2020-01-15', 1, 1, GETUTCDATE(), GETUTCDATE()),
        (2, 3, 'EMP002', 'FrontDesk', 'Front Desk Supervisor', '2021-03-20', 1, 1, GETUTCDATE(), GETUTCDATE()),
        (3, 4, 'EMP003', 'Housekeeping', 'Housekeeping Supervisor', '2021-06-10', 1, 1, GETUTCDATE(), GETUTCDATE());
END

SET IDENTITY_INSERT [dbo].[Staff] OFF;

PRINT 'Seed data inserted successfully!';
GO
