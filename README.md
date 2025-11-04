# HotelCore
HotelCore is a single-hotel booking and management system built on ASP.NET WebForms(VB.NET), SQL Server, and Bootstrap 4. The system introduces "Flexible Stays & Smart Ops" - Supporting micro-stays(hourly bookings), configurable room setups, integrated housekeeping scheduling, and intelligent upsell suggestions.

# Architectural Layers
Will use System Design: eraser.io (system flow - will be added to a diagram)

PRESENTATION LAYER -> BUSINESS LOGIC LAYER (BLL) -> DATA ACCESS LAYER (DAL) -> SQL SERVER DATABASE

# Technology Stack Constraints

| Layer | Technology | Version | Notes |
|-------|-----------|---------|-------|
| Server Framework | ASP.NET WebForms | 4.8.1 | VB.NET |
| Database | SQL Server | 2022 | All access via **stored procedures** |
| Data Access | ADO.NET | Native | SqlConnection, SqlCommand, SqlDataReader |
| UI Framework | Bootstrap | 4.6.2 | Mobile-first responsive design |
| Client Scripting | jQuery | 3.6.0 | AJAX, DOM manipulation, plugins |
| Hosting | IIS | 10.0 | Windows Server, Plesk |

# Entity Relationship Diagram (ERD)
Core Domain Entities
I will create an ERD diagram via Lucidchart -> Entities (tables - DB) Design

# Project Structure

# Key Design Decisions


