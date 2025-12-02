# HotelCore
HotelCore is a single-hotel booking and management system built on ASP.NET WebForms(VB.NET), SQL Server, and Bootstrap 4. The system introduces "Flexible Stays & Smart Ops" - Supporting micro-stays(hourly bookings), configurable room setups, integrated housekeeping scheduling, and intelligent upsell suggestions.

## Prerequisites

- **Visual Studio 2019 or later** (with ASP.NET and web development workload)
- **SQL Server 2019 or later** (Express edition is sufficient)
- **SQL Server Management Studio (SSMS)** (optional, for database management)
- **.NET Framework 4.8**

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/mdnayanmia31/HotelCore.git
cd HotelCore
```

### 2. Database Setup

1. Open SQL Server Management Studio (SSMS)
2. Create a new database named `HotelCore`
3. Execute the stored procedures from `HotelCore.Database/dbo/Stored Procedures/` folder
4. Execute the table scripts from `HotelCore.Database/dbo/Tables/` folder

### 3. Configure Connection String

Update the connection string in `HotelCore.Web/Web.config`:

```xml
<connectionStrings>
    <add name="HotelCoreDB" 
         connectionString="Server=YOUR_SERVER;Database=HotelCoreDB;Trusted_Connection=True;MultipleActiveResultSets=true" 
         providerName="System.Data.SqlClient" />
</connectionStrings>
```

Replace `YOUR_SERVER` with your SQL Server instance name (e.g., `localhost`, `.\SQLEXPRESS`, etc.)

### 4. Build and Run

1. Open `HotelCore.sln` in Visual Studio
2. Restore NuGet packages (right-click solution > Restore NuGet Packages)
3. Build the solution (Ctrl + Shift + B)
4. Set `HotelCore.Web` as the startup project
5. Press F5 to run the application

## Default Credentials

For testing purposes:

**Admin User:**
- Email: admin@hotelcore.com
- Password: Admin@123
- Role: Admin

**Guest User:**
- Email: guest@hotelcore.com
- Password: Guest@123
- Role: Guest

## Project Structure

```
HotelCore/
├── HotelCore.Web/          # Presentation Layer (ASP.NET WebForms)
│   ├── Account/            # User authentication pages
│   ├── Admin/              # Admin management pages
│   ├── App_Start/          # Configuration files
│   ├── Booking/            # Booking-related pages
│   ├── Content/            # CSS, images, fonts
│   ├── Scripts/            # JavaScript files
│   └── Shared/             # Master pages, shared components
├── HotelCore.BLL/          # Business Logic Layer
│   ├── Models/             # Data Transfer Objects
│   ├── Services/           # Business services
│   └── Common/             # Shared utilities
├── HotelCore.DAL/          # Data Access Layer
│   ├── Interface/          # Repository interfaces
│   └── Repositories/       # Repository implementations
└── HotelCore.Database/     # SQL Server Database Project
    └── dbo/
        ├── Stored Procedures/
        └── Tables/
```

## Features

### Public Pages
- **Home Page** - Hero section with booking form, featured rooms, services
- **Room Search** - Filter and search available rooms
- **Room Details** - View room information and pricing
- **Facilities** - Hotel amenities and services showcase
- **Contact** - Contact form and information

### User Features
- User registration and authentication
- Profile management
- Booking history
- Booking cancellation

### Admin Features
- Dashboard with statistics
- Booking management (check-in/check-out)
- Room status management
- Booking search and filters

## Design System

- **Primary Color:** Sage Green (#7fa185)
- **Text on Primary:** Cream (#efe8dd)
- **Dark Text:** #333333
- **Font:** Montserrat (Google Fonts)

## Technology Stack

| Layer | Technology | Version |
|-------|-----------|---------|
| Server Framework | ASP.NET WebForms | 4.8.1 |
| Database | SQL Server | 2022 |
| Data Access | ADO.NET | Native |
| UI Framework | Bootstrap | 4.6.2 |
| Client Scripting | jQuery | 3.6.0 |

**System flow and Entity Relationship Diagram (ERD):**
https://lucid.app/lucidchart/9a1762ff-58c7-4bc7-8b02-398f0f4fd30d/view

**System Design:***
https://app.eraser.io/workspace/vCjBrquzEDEyJMkqBQhr?origin=share

**UI Figma Design:**
https://www.figma.com/design/MUxH6I2aHMisNaZ6bjgxcX/HotelCore-Website-Wireframe-Design?node-id=0-1&t=iqkPuq0J2S7GC3Hy-1

**Project Planning:**
https://github.com/users/mdnayanmia31/projects/2

## License

This project is licensed under the MIT License - see the LICENSE file for details.


