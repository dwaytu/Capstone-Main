# SENTINEL System - Comprehensive Gemini AI Context Prompt

## CRITICAL INSTRUCTIONS FOR GEMINI AI

You are assisting with development, debugging, and feature enhancement of **SENTINEL**, a production-ready Integrated Security Operations Management Platform for Davao Security & Investigation Agency, Inc. This document provides complete system context down to the last architectural and implementation detail. Reference this whenever responding to questions about the system.

---

## TABLE OF CONTENTS
1. Executive Summary
2. Regulatory & Business Context
3. Architecture & Technology Stack
4. Complete Data Model & Schema
5. API Endpoints (All 100+)
6. Frontend Component Architecture
7. User Roles, Permissions & Access Control
8. Business Workflows & Logic
9. Known Issues & Recent Fixes
10. Deployment & Configuration
11. Development Guidelines

---

## 1. EXECUTIVE SUMMARY

### System Purpose
SENTINEL unifies guard personnel management, equipment allocation, vehicle operations, and access control into a single integrated web-based platform. The system ensures real-time compliance with Philippine Private Security Services Industry Act (RA 11917) and eliminates operational gaps in asset accountability and workforce management.

### Key Statistics
- **Lines of Backend Code**: ~5,000+ Rust code
- **Frontend Components**: 32 React/TypeScript components
- **API Endpoints**: 100+ REST endpoints
- **Database Tables**: 20+ relational tables
- **User Roles**: 4 (User, Admin, Superadmin, System)
- **Operational Scenarios Tested**: 24 distinct business scenarios
- **Production Issues Resolved**: 15+ bugs through 24-day operational simulation

### Core Modules
1. **Guard Management** - Personnel profiles, scheduling, attendance, performance analytics, replacement coordination
2. **Equipment Management** - Firearm inventory, allocation workflows, permit tracking, maintenance history
3. **Vehicle Operations** - Armored car assets, driver assignments, trip tracking
4. **Access Control** - Role-based permissions, authentication, audit logging

---

## 2. REGULATORY & BUSINESS CONTEXT

### Philippine Legal Framework
- **RA 11917** (Private Security Services Industry Act, 2022): Repealed RA 5487; mandates "strict liability" for compliance violations
- **Regulatory Body**: PNP-SOSIA (Philippine National Police - Supervisory Office for Security and Investigation Agencies)
- **Key Compliances**:
  - License to Exercise Security Profession (LESP) validation
  - License to Operate (LTO) preservation
  - Firearm custody tracking with serial numbers
  - Neuro-psychiatric clearance verification
  - Real-time asset movement transparency

### Davao City Context
- "Culture of Security" initiative expects zero-fail operations
- High-value asset management (armored cars, extensive firearm inventory)
- Regional security standards mandate seamless integration with public law enforcement

### Financial Stakes
- **Non-compliance Fine**: Up to ₱5,000,000
- **Maximum Penalty**: Revocation of License to Operate (LTO)
- **Business Impact**: Total loss of agency operation capability

### Critical Business Problems SENTINEL Solves
1. **Transparency Gap**: Manual paper-based logs lack real-time synchronization
2. **Data Drift**: Vehicle and weapon deployments not reconciled with active rosters
3. **Discovery Lag**: Supervisors unaware of personnel no-shows until client site unguarded
4. **Double-Booking**: Assets logically booked for multiple deployments simultaneously
5. **Unauthorized Deployment**: Guards with expired clearances issued firearms

---

## 3. ARCHITECTURE & TECHNOLOGY STACK

### Backend
- **Framework**: Axum 0.7 (Tokio async/await runtime)
- **Language**: Rust 1.70+
- **Memory Safety**: Memory-safe, zero-cost abstractions preventing buffer overflows and data races
- **Performance**: Multi-threaded, high-concurrency architecture for 24/7 operations
- **Key Dependencies**:
  - `sqlx` - Compile-time verified SQL queries
  - `tokio` - Async runtime with full feature set
  - `serde_json` - JSON serialization/deserialization
  - `bcrypt` - Password hashing (10-round salt)
  - `uuid` - UUID v4 generation for all record IDs
  - `chrono` - Timestamp and timezone handling
  - `lettre` - SMTP email for verification codes
  - `regex` - Email validation
  - `tower-http` - CORS, tracing, middleware

### Database
- **System**: PostgreSQL 12+
- **Connection Pool**: 5 default connections (configurable)
- **Query Verification**: sqlx compile-time query verification
- **Timezone**: UTC (Coordinated Universal Time)
- **Transactions**: ACID compliance for all critical operations

### Frontend
- **Framework**: React 18.2 + TypeScript 5.9
- **Styling**: Tailwind CSS 4.2 with custom components
- **Build Tool**: Vite 7.3
- **Icons**: Lucide React
- **Testing**: Jest 30.2 + Testing Library
- **State Management**: React hooks (useState, useEffect)
- **API Communication**: Fetch API with proper error handling

### Deployment
- **Containerization**: Docker + Docker Compose
- **Backend Container**: Rust 1.70+ compilation + binary execution
- **Frontend Container**: Node.js build → static assets serving
- **Orchestration**: Docker Compose for local development
- **Cloud Integration**: Railway deployment configuration available

---

## 4. COMPLETE DATA MODEL & SCHEMA

### Core Tables & Relationships

#### Users Table
```
users
├── id (UUID) ← Primary Key
├── email (VARCHAR 255, UNIQUE) ← Gmail only
├── username (VARCHAR 255, UNIQUE)
├── password (VARCHAR 255, bcrypt-hashed)
├── role (VARCHAR 50) ← 'user' | 'admin' | 'superadmin'
├── full_name (VARCHAR 255)
├── phone_number (VARCHAR 20)
├── license_number (VARCHAR 50, NULLABLE) ← LESP number
├── license_expiry_date (TIMESTAMP) ← RA 11917 compliance
├── profile_photo (VARCHAR, NULLABLE) ← URL or blob reference
├── verified (BOOLEAN) ← Email verification flag
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)

Foreign Key Dependencies:
├── Verifications (1:Many) → one user can have multiple verification codes
├── Shifts (1:Many) → one user assigned to multiple shifts
├── Firearm Allocations (1:Many) → one user issued multiple firearms
├── Car Allocations (1:Many) → one user assigned to multiple vehicles
├── Support Tickets (1:Many) → one user may create multiple tickets
└── Training Records (1:Many) → one user may have multiple training certifications
```

#### Verifications Table
```
verifications
├── id (UUID) ← Primary Key
├── user_id (UUID) ← Foreign Key → users(id) ON DELETE CASCADE
├── code (VARCHAR 6) ← 6-digit verification code
├── expires_at (TIMESTAMP) ← 10-minute expiry window
└── created_at (TIMESTAMP)
```

#### Firearms Table
```
firearms
├── id (UUID) ← Primary Key
├── model (VARCHAR 255)
├── caliber (VARCHAR 50)
├── serial_number (VARCHAR 100, UNIQUE) ← Critical for chain of custody
├── acquisition_date (DATE)
├── status (VARCHAR 50) ← 'available' | 'allocated' | 'maintenance' | 'decommissioned'
├── last_maintenance_date (DATE)
├── next_maintenance_due (DATE)
├── condition (VARCHAR 100)
├── location (VARCHAR 255) ← Current storage location
└── created_at (TIMESTAMP)

Chain of Custody: Every status change logged in firearm_allocations & firearm_maintenance
```

#### Firearm Allocations Table
```
firearm_allocations
├── id (UUID) ← Primary Key
├── firearm_id (UUID, FK) → firearms(id)
├── guard_id (UUID, FK) → users(id)
├── issued_at (TIMESTAMP)
├── returned_at (TIMESTAMP, NULLABLE) ← NULL if currently allocated
├── status (VARCHAR 50) ← 'allocated' | 'returned' | 'lost' | 'damaged'
├── condition_on_issue (VARCHAR 100)
├── condition_on_return (VARCHAR 100, NULLABLE)
└── notes (TEXT, NULLABLE)

Critical Business Logic:
- Guard's license_expiry_date must be valid at allocation time
- Guard must have passed neuro-psychiatric clearance
- Guard's training certification must be current
- No duplicate allocations (one firearm to one guard at a time)
- Overdue returns trigger automated alerts
```

#### Guard Firearm Permits Table
```
guard_firearm_permits
├── id (UUID) ← Primary Key
├── guard_id (UUID, FK) → users(id)
├── firearm_id (UUID, FK) → firearms(id)
├── permit_number (VARCHAR 100, UNIQUE)
├── issued_date (DATE)
├── expiry_date (DATE)
├── status (VARCHAR 50) ← 'active' | 'expired' | 'revoked'
├── neuro_psychiatric_clearance_date (DATE)
├── neuro_psychiatric_clearance_expiry (DATE)
├── training_certificate_date (DATE)
├── training_certificate_expiry (DATE)
└── notes (TEXT, NULLABLE)

Regulatory Compliance:
- Permits expire automatically if neuro-psychiatric clearance expires
- Training certificate must be renewed annually
- Zero tolerance for deployment with expired permits
```

#### Shifts Table
```
shifts
├── id (UUID) ← Primary Key
├── guard_id (UUID, FK) → users(id) ON DELETE CASCADE
├── client_site (VARCHAR 255)
├── start_time (TIMESTAMP)
├── end_time (TIMESTAMP)
├── status (VARCHAR 50) ← 'scheduled' | 'completed' | 'no_show' | 'cancelled'
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)

Attendance Workflow:
1. Shift created (scheduled)
2. Guard checks in at start_time
3. Guard checks out at end_time
4. Status auto-transitioned based on check-in/out records
5. No-show detection runs if no check-in by threshold time
```

#### Attendance Table
```
attendance
├── id (UUID) ← Primary Key
├── guard_id (UUID, FK) → users(id) ON DELETE CASCADE
├── shift_id (UUID, FK, NULLABLE) → shifts(id)
├── check_in_time (TIMESTAMP)
├── check_out_time (TIMESTAMP, NULLABLE)
├── status (VARCHAR 50) ← 'present' | 'absent' | 'early_out'
└── created_at (TIMESTAMP)

No-Show Detection:
- If shift.start_time + threshold (30 min) passed with no check-in → auto-flag no-show
- Trigger replacement request automation
- Alert supervisor and client site
```

#### Armored Cars Table
```
armored_cars
├── id (UUID) ← Primary Key
├── model (VARCHAR 255)
├── license_plate (VARCHAR 50, UNIQUE) ← Critical for vehicle registry
├── color (VARCHAR 50)
├── acquisition_date (DATE)
├── status (VARCHAR 50) ← 'available' | 'allocated' | 'maintenance' | 'decommissioned'
├── last_maintenance_date (DATE)
├── next_maintenance_due (DATE)
├── condition (VARCHAR 100)
├── current_location (VARCHAR 255)
└── created_at (TIMESTAMP)
```

#### Car Allocations Table
```
car_allocations
├── id (UUID) ← Primary Key
├── car_id (UUID, FK) → armored_cars(id)
├── driver_id (UUID, FK) → users(id)
├── assigned_at (TIMESTAMP)
├── returned_at (TIMESTAMP, NULLABLE)
├── status (VARCHAR 50) ← 'assigned' | 'returned' | 'maintenance'
├── mileage_on_assignment (INT)
├── mileage_on_return (INT, NULLABLE)
├── fuel_on_assignment (VARCHAR 50)
├── fuel_on_return (VARCHAR 50, NULLABLE)
└── notes (TEXT, NULLABLE)

Business Rules:
- Driver must have valid license and security clearance
- One car to one driver assignment at a time
- Overdue returns trigger alert escalation
- Mileage and fuel tracked for maintenance scheduling
```

#### Armored Car Trips Table
```
armored_car_trips
├── id (UUID) ← Primary Key
├── car_id (UUID, FK) → armored_cars(id)
├── driver_id (UUID, FK) → users(id)
├── pickup_location (VARCHAR 255)
├── destination (VARCHAR 255)
├── start_time (TIMESTAMP)
├── end_time (TIMESTAMP, NULLABLE)
├── status (VARCHAR 50) ← 'active' | 'completed' | 'in_transit'
├── cargo_description (TEXT)
├── cargo_value (DECIMAL, NULLABLE)
├── route_taken (TEXT, NULLABLE)
└── notes (TEXT, NULLABLE)
```

#### Training Records Table
```
training_records
├── id (UUID) ← Primary Key
├── guard_id (UUID, FK) → users(id) ON DELETE CASCADE
├── training_type (VARCHAR 100) ← 'firearms' | 'security' | 'first_aid' etc.
├── training_date (DATE)
├── expiry_date (DATE)
├── certification_number (VARCHAR 100)
├── provider_name (VARCHAR 255)
├── status (VARCHAR 50) ← 'current' | 'expired' | 'pending_renewal'
└── notes (TEXT, NULLABLE)

Compliance:
- Annual renewal required for all certifications
- Expired training locks guard from duty assignments
- Automated alerts 30 days before expiry
```

#### Firearm Maintenance Table
```
firearm_maintenance
├── id (UUID) ← Primary Key
├── firearm_id (UUID, FK) → firearms(id)
├── scheduled_date (DATE)
├── completed_date (DATE, NULLABLE)
├── maintenance_type (VARCHAR 100) ← 'inspection' | 'repair' | 'cleaning' | 'ballistics_test'
├── performed_by (VARCHAR 255)
├── status (VARCHAR 50) ← 'scheduled' | 'completed' | 'overdue'
├── findings (TEXT)
├── parts_replaced (TEXT, NULLABLE)
├── cost (DECIMAL)
└── notes (TEXT, NULLABLE)

Business Logic:
- Overdue maintenance prevents firearm allocation
- Maintenance history creates full chain of custody audit trail
- Cost tracking for budget planning
```

#### Car Maintenance Table
```
car_maintenance
├── id (UUID) ← Primary Key
├── car_id (UUID, FK) → armored_cars(id)
├── scheduled_date (DATE)
├── completed_date (DATE, NULLABLE)
├── maintenance_type (VARCHAR 100) ← 'oil_change' | 'inspection' | 'repair' | 'tire_rotation'
├── performed_by (VARCHAR 255)
├── status (VARCHAR 50) ← 'scheduled' | 'completed' | 'overdue'
├── findings (TEXT)
├── parts_replaced (TEXT, NULLABLE)
├── cost (DECIMAL)
└── notes (TEXT, NULLABLE)
```

#### Merit Score Table
```
merit_scores
├── id (UUID) ← Primary Key
├── guard_id (UUID, FK) → users(id) ON DELETE CASCADE
├── attendance_score (INT, 0-100) ← Based on no-show history
├── performance_score (INT, 0-100) ← Based on client evaluations
├── compliance_score (INT, 0-100) ← Based on permit/training/equipment compliance
├── overall_score (DECIMAL, 0-100) ← Weighted average: 40% attendance, 35% performance, 25% compliance
├── last_calculated (TIMESTAMP)
└── notes (TEXT, NULLABLE)

Overtime Eligibility:
- Overall score ≥ 85: Tier A (premium overtime candidates)
- Overall score 70-84: Tier B (standard overtime candidates)
- Overall score < 70: Tier C (overtime not recommended)
```

#### Notifications Table
```
notifications
├── id (UUID) ← Primary Key
├── user_id (UUID, FK) → users(id) ON DELETE CASCADE
├── title (VARCHAR 255)
├── message (TEXT)
├── type (VARCHAR 50) ← 'alert' | 'info' | 'warning' | 'error'
├── related_entity_id (VARCHAR 36, NULLABLE) ← Links to firearms, shifts, etc.
├── read (BOOLEAN, DEFAULT FALSE)
├── created_at (TIMESTAMP)
└── expires_at (TIMESTAMP)

Real-Time Alerts:
- Attendance: No-show detection, late check-in
- Compliance: Permit expiry (30, 14, 7, 1 days)
- Equipment: Maintenance overdue, allocation overdue
- Operations: Replacement requests, trip status changes
```

#### Support Tickets Table
```
support_tickets
├── id (UUID) ← Primary Key
├── guard_id (UUID, FK) → users(id) ON DELETE CASCADE
├── subject (VARCHAR 255)
├── message (TEXT)
├── status (VARCHAR 50) ← 'open' | 'in_progress' | 'resolved' | 'closed'
├── priority (VARCHAR 50) ← 'low' | 'medium' | 'high'
├── assigned_to (VARCHAR 36, FK, NULLABLE) → users(id)
├── created_at (TIMESTAMP)
├── updated_at (TIMESTAMP)
└── resolved_at (TIMESTAMP, NULLABLE)
```

#### Analytics Table
```
analytics
├── id (UUID) ← Primary Key
├── metric_name (VARCHAR 255)
├── metric_value (JSON) ← Flexible for different metric types
├── time_period (VARCHAR 50) ← 'daily' | 'weekly' | 'monthly'
├── recorded_at (TIMESTAMP)
└── details (JSON, NULLABLE)

Tracked Metrics:
- Guard availability percentage
- Firearm allocation rate
- No-show frequency by site
- Training compliance rate
- Equipment maintenance timeliness
- Merit score distributions
- Revenue per guard assignment
```

#### Mission Assignments Table
```
missions
├── id (UUID) ← Primary Key
├── client_id (VARCHAR 36) ← Can reference users table for client contacts
├── assigned_guard_id (UUID, FK) → users(id)
├── mission_type (VARCHAR 100) ← 'collection' | 'delivery' | 'patrol' | 'investigation'
├── location (VARCHAR 255)
├── scheduled_start (TIMESTAMP)
├── scheduled_end (TIMESTAMP)
├── actual_start (TIMESTAMP, NULLABLE)
├── actual_end (TIMESTAMP, NULLABLE)
├── status (VARCHAR 50) ← 'assigned' | 'active' | 'completed' | 'cancelled'
├── priority (VARCHAR 50) ← 'low' | 'medium' | 'high' | 'critical'
├── description (TEXT)
├── client_contact_info (VARCHAR 255)
└── notes (TEXT, NULLABLE)
```

---

## 5. API ENDPOINTS (100+ Complete List)

### Authentication Endpoints (4)
```
POST /api/register                    → Register new user (email must be Gmail)
POST /api/login                       → Login user (identifier: email|username|phone)
POST /api/verify                      → Verify email with confirmation code
POST /api/resend-code                 → Resend verification code
Alternative: /api/auth/*              → Same endpoints with /auth prefix
```

### User Management Endpoints (5)
```
GET /api/users                        → Get all users (admin only)
GET /api/user/:id                     → Get user profile by ID
PUT /api/user/:id                     → Update user profile
DELETE /api/user/:id                  → Delete user account
PUT /api/user/:id/profile-photo       → Upload profile photo
DELETE /api/user/:id/profile-photo    → Delete profile photo
Alternative: /api/users/*             → Same endpoints with /users prefix
```

### Firearm Management Endpoints (5)
```
POST /api/firearms                    → Add new firearm to inventory
GET /api/firearms                     → Get all firearms (paginated)
GET /api/firearms/:id                 → Get firearm by ID with full history
PUT /api/firearms/:id                 → Update firearm details
DELETE /api/firearms/:id              → Decommission firearm (soft delete)
```

### Firearm Allocation Endpoints (5)
```
POST /api/firearm-allocation/issue    → Issue firearm to guard (validates LESP, clearances)
POST /api/firearm-allocation/return   → Return firearm from guard
GET /api/guard-allocations/:guard_id  → Get all active allocations for guard
GET /api/firearm-allocations/active   → Get all active allocations system-wide
GET /api/firearm-allocations/overdue  → Get overdue allocations requiring return
Alias: /api/firearm-allocation        → POST for issue (alternative)
```

### Guard Firearm Permits Endpoints (4)
```
POST /api/guard-firearm-permits       → Create permit for guard+firearm
GET /api/guard-firearm-permits        → Get all permits (admin only)
GET /api/guard-firearm-permits/:guard_id             → Get guard's permits
GET /api/guard-firearm-permits/expiring              → Get permits expiring within 30 days
PUT /api/guard-firearm-permits/:permit_id/revoke    → Revoke permit immediately
POST /api/guard-firearm-permits/auto-expire         → Run auto-expiry for overdue certifications
```

### Guard Replacement (Shift Management) Endpoints (10)
```
POST /api/guard-replacement/shifts    → Create shift
GET /api/guard-replacement/shifts     → Get all shifts (paginated)
PUT /api/guard-replacement/shifts/:shift_id         → Update shift details
DELETE /api/guard-replacement/shifts/:shift_id      → Delete shift
GET /api/guard-replacement/guard/:guard_id/shifts   → Get guard's assigned shifts
GET /api/attendance/:guard_id         → Get guard's full attendance history
POST /api/guard-replacement/attendance/check-in     → Guard check-in
POST /api/guard-replacement/attendance/check-out    → Guard check-out
Alias: /api/guard-replacement/check-in              → POST check-in (alternative)
Alias: /api/guard-replacement/check-out             → POST check-out (alternative)
POST /api/guard-replacement/detect-no-shows         → Run scheduled no-show detection
POST /api/guard-replacement/request-replacement     → Create replacement request
POST /api/guard-replacement/accept-replacement      → Accept replacement offer
POST /api/guard-replacement/set-availability        → Set guard availability window
GET /api/guard-replacement/availability/:guard_id   → Get guard's availability
```

### Firearm Maintenance Endpoints (4)
```
POST /api/firearm-maintenance/schedule               → Schedule maintenance for firearm
GET /api/firearm-maintenance/pending                 → Get all pending maintenance
POST /api/firearm-maintenance/:maintenance_id/complete → Mark maintenance complete
GET /api/firearm-maintenance/:firearm_id            → Get maintenance history for firearm
Alias: /api/firearm-maintenance                     → GET all records
```

### Training Records Endpoints (3)
```
POST /api/training-records           → Create training record for guard
GET /api/training-records/expiring   → Get guards with expiring training (30 days)
GET /api/training-records/:guard_id  → Get guard's training history
```

### Armored Car Management Endpoints (5)
```
POST /api/armored-cars               → Add new armored car to fleet
GET /api/armored-cars                → Get all armored cars
GET /api/armored-cars/:id            → Get car details by ID
PUT /api/armored-cars/:id            → Update car information
DELETE /api/armored-cars/:id         → Decommission car (soft delete)
```

### Car Allocation Endpoints (5)
```
POST /api/car-allocation/issue       → Assign car to driver
POST /api/car-allocation/return      → Return car from driver
GET /api/car-allocations/:car_id     → Get allocation history for car
GET /api/car-allocations/active      → Get all active car allocations
Alias: /api/car-allocation           → POST issue (alternative)
```

### Car Maintenance Endpoints (4)
```
POST /api/car-maintenance/schedule    → Schedule maintenance for vehicle
POST /api/car-maintenance/:maintenance_id/complete  → Complete maintenance task
GET /api/car-maintenance/:car_id     → Get maintenance history for car
```

### Driver Assignment Endpoints (3)
```
POST /api/driver-assignment/assign    → Assign driver to car
POST /api/driver-assignment/:assignment_id/unassign → Remove driver from car
GET /api/car-drivers/:car_id         → Get list of drivers assigned to car
```

### Trip Management Endpoints (7)
```
POST /api/trips                      → Create armored car trip record
POST /api/trips/end                  → End trip and record completion
GET /api/trips/car/:car_id           → Get trips for specific car
GET /api/trips                       → Get all trips (paginated)
GET /api/trip-management/active      → Get active trips across fleet
GET /api/trip-management/:trip_id    → Get detailed trip information
PUT /api/trip-management/:trip_id/status           → Update trip status
POST /api/trip-management/assign-driver            → Assign driver to trip
GET /api/trip-management/driver-assignments      → Get driver assignment records
```

### Merit Score System Endpoints (6)
```
POST /api/merit/calculate             → Trigger merit score calculation for all guards
GET /api/merit/:guard_id              → Get guard's current merit score breakdown
GET /api/merit/rankings/all           → Get ranked list of all guards by score
GET /api/merit/overtime-candidates    → Get guards eligible for overtime (score ≥ 85)
POST /api/merit/evaluations/submit    → Submit client evaluation for guard
GET /api/merit/evaluations/:guard_id  → Get evaluations for guard
```

### Mission Management Endpoints (2)
```
POST /api/missions/assign             → Assign mission to guard
GET /api/missions                     → Get all missions (filterable by status)
```

### Notification Endpoints (5)
```
POST /api/notifications               → Create system notification
GET /api/users/:user_id/notifications             → Get user's notification list
GET /api/users/:user_id/notifications/unread-count → Get unread notification count
PUT /api/users/:user_id/notifications/mark-all-read → Mark all notifications as read
PUT /api/notifications/:notification_id/read      → Mark single notification as read
DELETE /api/notifications/:notification_id        → Delete notification
```

### Support Tickets Endpoints (2)
```
POST /api/support-tickets            → Create support ticket
GET /api/support-tickets/:guard_id   → Get tickets created by guard
```

### Analytics Endpoints (3)
```
GET /api/analytics                   → Get system-wide analytics dashboard data
GET /api/analytics/trends            → Get performance trends over time
PUT /api/analytics/mission-status    → Update mission status in analytics
```

### Health Check Endpoint (1)
```
GET /api/health                      → System health check (for load balancers)
```

---

## 6. FRONTEND COMPONENT ARCHITECTURE

### Core Layout Components
```
App.tsx (Main Router)
├── LoginPage.tsx
│   ├── Logo.tsx
│   ├── ParticleBackground.tsx (Interactive particle animation)
│   └── Form inputs (email, password, register logic)
│
├── User Dashboard Flow
│   ├── UserDashboard.tsx (User role entry point)
│   │   ├── Sidebar.tsx (Navigation with mobile overlay)
│   │   ├── Header.tsx (Profile, notifications, hamburger)
│   │   └── Sections:
│   │       ├── Overview (Attendance records)
│   │       ├── Schedule (Shift management)
│   │       ├── Firearms (Equipment allocations)
│   │       ├── Permits (LESP & certifications)
│   │       └── Support (Contact forms)
│   │
│   └── CalendarDashboard.tsx (User/Admin calendar view)
│       ├── Sidebar.tsx (Mobile-responsive nav)
│       ├── Header.tsx (Mobile hamburger menu)
│       ├── Calendar grid (Month/Day view)
│       ├── Event filter (By type: Shift, Trip, Mission, Maintenance)
│       ├── Event detail modal
│       └── Fixed bugs:
│           ├── State: mobileMenuOpen added ✓
│           ├── Props: isOpen, onClose passed to Sidebar ✓
│           ├── Props: onMenuClick, onNavigateToProfile passed to Header ✓
│           └── User nav items expanded from 3 to 6 items ✓
│
├── Admin Dashboard Flow
│   ├── AdminDashboard.tsx (Admin role entry point)
│   │   ├── Sidebar.tsx (Admin-specific menu)
│   │   ├── Header.tsx
│   │   └── Sections:
│   │       ├── Dashboard (System overview)
│   │       ├── User Management (CRUD users)
│   │       ├── Guard Schedules
│   │       ├── Mission Assignment
│   │       ├── Firearm Management
│   │       ├── Vehicle Management
│   │       ├── Reports & Analytics
│   │       └── System Settings
│   │
│   └── ArmoredCarDashboard.tsx
│       ├── Car inventory management
│       ├── Allocation tracking
│       ├── Maintenance scheduling
│       ├── Trip monitoring
│       └── Driver assignments
│
├── Superadmin Dashboard Flow
│   └── SuperadminDashboard.tsx (Full system access)
│       ├── All admin features +
│       ├── System-wide analytics
│       ├── Compliance monitoring
│       ├── Audit logs
│       └── Configuration management
│
├── Performance & Analytics
│   ├── PerformanceDashboard.tsx (Guard performance metrics)
│   ├── MeritScoreDashboard.tsx (Score breakdown & rankings)
│   ├── AnalyticsDashboard.tsx (System-wide metrics)
│   └── ReportsAnalytics.tsx (Custom report generation)
│
├── Specialized Views
│   ├── ProfileDashboard.tsx (User profile editing)
│   ├── FirearmInventory.tsx (Equipment management)
│   ├── FirearmAllocation.tsx (Issue/return workflow)
│   ├── FirearmMaintenance.tsx (Maintenance scheduling)
│   ├── GuardFirearmPermits.tsx (Permit tracking)
│   ├── TripManagement.tsx (Trip monitoring)
│   ├── EditScheduleModal.tsx (Shift editing)
│   ├── EditUserModal.tsx (User profile editing)
│   ├── AccountManager.tsx (User account management)
│   ├── NotificationCenter.tsx (Notification hub)
│   ├── NotificationPanel.tsx (Notification sidebar)
│   ├── AlertsCenter.tsx (System alerts)
│   └── ReplacementNotification.tsx (Replacement requests UI)
│
└── Layout & UI Components
    ├── Sidebar.tsx (Main navigation - mobile responsive)
    ├── Header.tsx (Top bar with profile, notifications)
    ├── Logo.tsx (SENTINEL logo component)
    ├── SectionBadge.tsx (Status badges)
    └── ParticleBackground.tsx (Login page animation)
```

### Component State Patterns

All dashboard components follow this pattern:
```typescript
const [mobileMenuOpen, setMobileMenuOpen] = useState<boolean>(false)
// Passed to Sidebar: isOpen={mobileMenuOpen}, onClose={() => setMobileMenuOpen(false)}
// Passed to Header: onMenuClick={() => setMobileMenuOpen(true)}

// Data fetching pattern
const [data, setData] = useState<DataType[]>([])
const [loading, setLoading] = useState(true)
const [error, setError] = useState('')

useEffect(() => {
  fetchData()
}, [dependency])
```

### Mobile Responsive Breakpoints
- `sm:` 640px (tablets)
- `lg:` 1024px (desktops, hides sidebar toggle)
- Sidebar: `fixed` on mobile, `lg:relative` on desktop
- Hamburger menu: Visible on mobile/tablet, hidden on desktop

---

## 7. USER ROLES, PERMISSIONS & ACCESS CONTROL

### Role Hierarchy
```
System Administrator
    ├── Superadmin (Access: Full system)
    │
    ├── Admin (Access: Agency operations)
    │
    └── User (Access: Personal + team operations)
```

### Role-Based Access Control (RBAC) Matrix

#### Superadmin Role
- **Create/Read/Update/Delete**: Users, Guards, Firearm Inventory, Armored Cars, Shifts, Missions
- **View**: All analytics, audit logs, compliance reports, system settings
- **Perform**: System-wide merit calculations, automated compliance checks, admin account management
- **Cannot**: Be deleted or demoted by non-superadmin
- Dashboard: SuperadminDashboard (full access)

#### Admin Role
- **Create/Read/Update/Delete**: Guards, Shifts, Missions, Firearm allocations, Car allocations
- **View**: Department-level analytics, team performance metrics
- **Perform**: Approve/reject replacement requests, schedule maintenance, assign training
- **Cannot**: Create other admin accounts, modify system settings, delete users
- Dashboard: AdminDashboard (operational control)

#### User (Guard) Role
- **Read/Update Own**: Personal profile, my schedule, my assignments
- **Read**: 
  - Own attendance records
  - Own performance metrics
  - Own training certifications
  - General system announcements
- **Cannot**: View other guards' personal data, create shifts, manage inventory
- Dashboard: UserDashboard (personal records), CalendarDashboard (schedule view)

#### System Role (Internal)
- Used for automated tasks: no-show detection, permit expiry checks, maintenance scheduling
- Cannot login or authenticate
- Functions: Scheduled tasks, notifications generation, compliance checks

### Permission Matrix by Endpoint

| Endpoint | Public | User | Admin | Superadmin |
|----------|--------|------|-------|-----------|
| GET /api/users | ✗ | ✗ | ✗ | ✓ |
| GET /api/user/:id | ✓* | ✓** | ✓ | ✓ |
| PUT /api/user/:id | ✓* | ✓** | ✓ | ✓ |
| POST /api/firearms | ✗ | ✗ | ✓ | ✓ |
| GET /api/firearms | ✗ | ✓ | ✓ | ✓ |
| POST /api/firearm-allocation/issue | ✗ | ✗ | ✓ | ✓ |
| GET /api/guard-allocations/:id | ✓* | ✓** | ✓ | ✓ |
| POST /api/guard-replacement/shifts | ✗ | ✗ | ✓ | ✓ |
| GET /api/guard-replacement/guard/:id/shifts | ✓* | ✓** | ✓ | ✓ |
| POST /api/guard-replacement/attendance/check-in | ✓ | ✓ | ✓ | ✓ |
| GET /api/analytics | ✗ | ✗ | ✓ | ✓ |
| POST /api/merit/calculate | ✗ | ✗ | ✗ | ✓ |

*Can only access own record
**Can only access own record + team if admin

### Authentication & Session Management
- **Method**: HTTP POST with JSON credentials (email|username|phone + password)
- **Session Storage**: localStorage token storage on client
- **Token Type**: Not explicitly JWT (but recommended for production)
- **Expiry**: No explicit timeout (should implement 24-hour expiry in production)
- **Password Hashing**: bcrypt (10-round salt)
- **Email Verification**: Required before login (6-digit code, 10-minute expiry)

---

## 8. BUSINESS WORKFLOWS & LOGIC

### Workflow 1: Guard Hiring & Onboarding
```
1. Admin creates user account (email must be Gmail)
2. System sends verification email with 6-digit code
3. User verifies email at login
4. Admin uploads LESP license and training certificates
5. System validates license expiry date against current date
6. System validates training certificate expiry
7. Guard can now be assigned to shifts
8. System generates initial merit score (baseline: 75)
```

### Workflow 2: Firearm Allocation & Chain of Custody
```
1. Admin selects guard and firearm from inventory
2. System validates:
   - Guard's LESP license is current
   - Guard's neuro-psychiatric clearance is current
   - Guard's firearm permit for this specific firearm is current
   - Firearm has no pending maintenance
   - No duplicate allocation exists
3. System creates allocation record:
   - issued_at (current timestamp)
   - status: 'allocated'
   - firearm moved to 'allocated' status
4. System logs entry to firearm_allocations table
5. Admin provides firearm serial number receipt to guard
6. Guard signs digital or paper receipt
7. Admin initiates return process:
   - Check returned firearm condition
   - Record condition_on_return
   - Update allocation: returned_at = current timestamp
   - Update firearm status: 'available'
8. System generates chain of custody log entry
```

### Workflow 3: No-Show Detection & Automated Replacement
```
Scheduled: Every hour trigger detection
1. Query all shifts with start_time in past 30 min
2. For each shift:
   - Check if check-in record exists
   - If NO check-in found:
     * Mark shift.status = 'no_show'
     * Create system notification: "Guard X no-show at [site]"
     * Alert admin dashboard
     * Auto-create replacement request
3. Replacement request workflow:
   - Query guards with matching availability
   - Send replacement offer to available guards
   - First guard to accept gets assignment
   - Admin notified of replacement coverage
   - Original site notified of replacement arrival
4. If no replacement accepted within 30 min:
   - Escalate to admin (manual intervention)
   - Create high-priority support ticket
   - Flag guard for performance review
```

### Workflow 4: Permit Expiry & Compliance Checks
```
Scheduled: Daily at 00:00 UTC
1. Query all guard_firearm_permits
2. For each permit:
   - Check expiry_date
   - If expiry_date <= today:
     * UPDATE permit.status = 'expired'
     * Create ALERT notification
     * Block guard from any firearm deployment
   - If expiry_date - 30 days <= today < expiry_date:
     * Create WARNING notification: "Permit expires in X days"
   - If neuro_psychiatric_clearance_expiry < today:
     * UPDATE permit.status = 'expired' (due to clearance)
     * Create CRITICAL notification
3. Query training_records:
   - If expiry_date <= today:
     * UPDATE status = 'expired'
     * Block guard from duty assignments
4. Generate compliance report for admin
```

### Workflow 5: Merit Score Calculation
```
Triggered: On-demand OR scheduled weekly
For each guard:
1. Calculate attendance_score (0-100):
   - Total shifts assigned in last 90 days: X
   - No-shows in last 90 days: Y
   - Score = 100 - (Y / X * 100)
   - Minimum 0, maximum 100

2. Calculate performance_score (0-100):
   - Query client evaluations in last 90 days
   - Average client rating (1-5 stars) → map to 20-100 scale
   - If no evaluations: default to 75

3. Calculate compliance_score (0-100):
   - LESP license expired? -25 points
   - Training certification expired? -15 points
   - Permit expired? -30 points
   - Overdue equipment return? -10 points
   - Perfect compliance: 100 points

4. Calculate overall_score:
   - overall = (attendance * 0.40) + (performance * 0.35) + (compliance * 0.25)
   - Round to 2 decimals
   - Update merit_scores table

5. Determine tier for overtime:
   - ≥ 85: Tier A (premium candidates)
   - 70-84: Tier B (standard candidates)
   - < 70: Tier C (overtime not recommended)
```

### Workflow 6: Armored Car Trip Execution
```
1. Admin schedules trip:
   - Select car, driver, location, destination, cargo description
   - Set scheduled_start and scheduled_end
   - Create trip record (status: 'assigned')

2. Driver accepts assignment:
   - Receives notification with trip details
   - Confirms vehicle condition and fuel level
   - Trip status → 'active'

3. During trip:
   - Driver can log status updates
   - System tracks trip duration
   - Real-time notifications to admin (optional feature)

4. Trip completion:
   - Driver marks trip as complete
   - Records actual_end timestamp
   - Signs digital delivery receipt
   - Confirms cargo delivered to destination

5. Post-trip:
   - Admin records mileage and fuel used
   - Car returned to inventory (status: 'available')
   - Auto-check if maintenance due
   - Generate trip report for client
```

### Workflow 7: System Audit & Compliance Reporting
```
Daily Automatic:
1. Query all active allocations (firearm + vehicle)
2. Cross-reference with active shifts
3. Alert if:
   - Guard assigned to shift with no firearm allocation
   - Guard allocated firearm with no active shift
   - Car assigned but driver has no valid license
   - Equipment deployed with expired permits

Monthly Reporting:
1. Generate compliance summary:
   - Total guards
   - Guards with current LESP: X%
   - Overdue training: Y guards
   - Overdue equipment returns: Z items
   - Performance metrics

2. Generate for PNP-SOSIA submission:
   - Guard roster with LESP numbers and expiry dates
   - Firearm inventory with serial numbers
   - Allocation history (custody chain)
   - Incident reports
```

---

## 9. KNOWN ISSUES & RECENT FIXES

### Issue #1: CalendarDashboard Mobile Navigation ✓ FIXED
**Reported**: Dashboard items disappear on calendar view for mobile users
**Root Cause**: Missing mobileMenuOpen state variable and incomplete Header/Sidebar props
**Comparison**: 8 other dashboards (UserDashboard, AdminDashboard, etc.) had complete implementation
**Fix Applied**:
```typescript
// 1. Added missing state variable
const [mobileMenuOpen, setMobileMenuOpen] = useState<boolean>(false)

// 2. Updated Sidebar props
<Sidebar
  items={navItems}
  activeView={activeView || 'calendar'}
  onNavigate={onViewChange || (() => {})}
  onLogoClick={() => onViewChange?.('dashboard')}
  onLogout={onLogout}
  isOpen={mobileMenuOpen}              // ✓ Added
  onClose={() => setMobileMenuOpen(false)}  // ✓ Added
/>

// 3. Updated Header props
<Header
  user={user}
  onLogout={onLogout}
  title={isAdmin ? 'Operations Calendar' : 'My Schedule Calendar'}
  onMenuClick={() => setMobileMenuOpen(true)}  // ✓ Added
  onNavigateToProfile={onViewChange ? () => onViewChange('profile') : undefined}  // ✓ Added
/>

// 4. Expanded user navItems from 3 to 6 items
const userNavItems = [
  { view: 'dashboard', label: 'Dashboard' },
  { view: 'calendar',  label: 'Calendar' },
  { view: 'schedule',  label: 'Schedule' },      // ✓ Added
  { view: 'firearms',  label: 'Firearms' },      // ✓ Added
  { view: 'permits',   label: 'My Permits' },   // ✓ Added
  { view: 'support',   label: 'Contacts' },     // ✓ Added
]
```

### Issue #2: Backend Error Handling (Unsafe unwrap() calls) ✓ FIXED
**Reported**: Multiple `.unwrap()` calls on database results will panic on malformed rows
**Affected File**: `src/handlers/auth.rs` (10 occurrences)
**Risk**: Database schema changes or corruption → server crash
**Fix Applied**: All `.unwrap()` replaced with proper error handling:
```rust
// BEFORE (unsafe):
let expires_at = verification.try_get::<chrono::DateTime<chrono::Utc>, _>("expires_at").unwrap();

// AFTER (safe):
let expires_at: chrono::DateTime<chrono::Utc> = verification.try_get("expires_at")
    .map_err(|e| AppError::DatabaseError(format!("Failed to parse verification expiry: {}", e)))?;
```
**Fix Coverage**: All 10 instances replaced
- Lines 175-176 (verify_email function)
- Lines 186 (verify_email function)
- Lines 196 (verify_email function)
- Lines 229 (resend_verification_code function)
- Lines 293, 299-302 (login function)

### Issue #3: UI Logo Visibility (Earlier Fix)
**Status**: ✓ Completed
**Changes**: Logo moved higher, made more prominent, SENTINEL text removed
**Impact**: Login page UI improved, logo now clearly visible at top-left

### Issue #4: Login Background Animation (Earlier Fix)
**Status**: ✓ Completed
**Changes**: Added interactive ParticleBackground component
**Impact**: Enhanced user experience with animated particles on login page

---

## 10. DEPLOYMENT & CONFIGURATION

### Environment Variables (.env file)
```bash
# Server Configuration
SERVER_HOST=0.0.0.0
SERVER_PORT=5000

# Database Configuration  
DATABASE_URL=postgresql://user:password@localhost:5432/guard_firearm_system

# Email Configuration (Gmail SMTP)
GMAIL_USER=your_email@gmail.com
GMAIL_PASSWORD=your_app_specific_password

# Admin Registration Code
ADMIN_CODE=122601

# Frontend Configuration (in frontend/.env)
VITE_API_BASE_URL=http://localhost:5000
```

### Docker Compose Setup
```yaml
version: '3.8'
services:
  backend:
    build: ./DasiaAIO-Backend
    ports:
      - "5000:5000"
    environment:
      DATABASE_URL: postgresql://postgres:password@db:5432/guard_firearm_system
      GMAIL_USER: ${GMAIL_USER}
      GMAIL_PASSWORD: ${GMAIL_PASSWORD}
    depends_on:
      - db

  frontend:
    build: ./DasiaAIO-Frontend
    ports:
      - "5173:5173"
    environment:
      VITE_API_BASE_URL: http://localhost:5000
    depends_on:
      - backend

  db:
    image: postgres:15
    environment:
      POSTGRES_PASSWORD: password
      POSTGRES_DB: guard_firearm_system
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

### Database Initialization
```sql
-- PostgreSQL 12+ required
CREATE DATABASE guard_firearm_system;

-- Migrations run automatically on backend startup
-- All tables created in src/db.rs::run_migrations()
-- Tables include indexes and foreign key constraints
-- UUID columns use uuid type
-- Timestamps use TIMESTAMP WITH TIME ZONE
```

### Production Deployment Checklist
- [ ] Use PostgreSQL 12+ with at least 10GB storage
- [ ] Set connection pool to 20+ for production (default: 5)
- [ ] Enable SSL/TLS for all API endpoints
- [ ] Implement JWT tokens with 24-hour expiry
- [ ] Set up automated database backups (daily)
- [ ] Configure cloudflare/nginx reverse proxy
- [ ] Enable CORS only for trusted domains
- [ ] Implement rate limiting (100 req/min per IP)
- [ ] Set up monitoring and alerting
- [ ] Enable audit logging for all critical operations
- [ ] Document API usage and rate limits
- [ ] Set up CI/CD pipeline with automated tests

---

## 11. DEVELOPMENT GUIDELINES

### Code Organization Principles
1. **Separation of Concerns**: Handlers don't contain database logic; handlers call db functions
2. **Error Handling**: All database operations use proper `.map_err()` instead of `.unwrap()`
3. **Type Safety**: Use strong typing; minimize string-based type casting
4. **Validation**: Validate all user inputs server-side
5. **Async/Await**: All I/O operations use async/await pattern
6. **Logging**: Use `tracing::` macros for all significant operations

### Adding New Features Checklist
1. **Database**: Add new table/column to `src/db.rs`
2. **Models**: Add new struct to `src/models.rs`
3. **Handler**: Create new handler in `src/handlers/`
4. **Routes**: Add route to `src/main.rs`
5. **Frontend**: Create React component
6. **API Integration**: Add fetch calls to API service
7. **Testing**: Write integration tests
8. **Documentation**: Update API docs and README

### Testing Guidelines
```bash
# Run backend tests
cargo test

# Run frontend tests
npm test

# Type checking
cargo build --release  # for Rust
npm run build          # for frontend (Vite)
```

### Git Workflow
- Branch naming: `feature/description` or `bugfix/issue-number`
- Commit messages: Start with action verb ("Add", "Fix", "Refactor")
- PR description: Include issue number, changes made, testing done
- Code review: At least one approval before merge

---

## SENTINEL SYSTEM CAPABILITIES SUMMARY

### Real-Time Compliance
✓ LESP license validation at allocation time
✓ Automatic permit expiry detection
✓ Training certification tracking
✓ Neuro-psychiatric clearance verification
✓ Firearm custody chain logging
✓ Audit trail for all critical operations

### Operational Efficiency
✓ Automated no-show detection within 30 minutes
✓ Instant replacement request automation
✓ Shift scheduling with conflict prevention
✓ Vehicle and equipment allocation tracking
✓ Merit-based overtime candidate ranking
✓ Real-time performance analytics

### Data Integrity
✓ Relational database with foreign key constraints
✓ ACID transaction handling
✓ UUID-based record identification
✓ Timestamp audit trails
✓ Role-based access control
✓ Input validation on all endpoints

### User Experience
✓ Mobile-responsive interface (React/Tailwind)
✓ Intuitive dashboard layouts
✓ Real-time notifications
✓ Interactive calendar views
✓ Performance metrics visualization
✓ Easy-to-use forms and modals

### Scalability
✓ Async Rust backend (Tokio runtime)
✓ Connection pooling (configurable)
✓ Efficient database queries with indexes
✓ Docker containerization for easy deployment
✓ PostgreSQL proven reliability
✓ Stateless API design supports horizontal scaling

---

## FINAL CONTEXT FOR GEMINI AI

When responding to questions about SENTINEL:

1. **Assume current date is February 27, 2026** - All regulations and requirements are based on 2026 standards
2. **Reference this document for all system details** - Don't guess about architecture or data models
3. **Remember the 4 user roles**: User (Guard), Admin, Superadmin, System
4. **Always consider compliance**: Every feature must align with RA 11917 requirements
5. **Performance matters**: System handles 24/7 operations with high concurrency
6. **Security first**: All passwords bcrypt-hashed, email verification required, RBAC enforced
7. **User experience counts**: Mobile-responsive, real-time updates, clear feedback
8. **Data matters**: Every event logged, audit trails maintained, chain of custody tracked
9. **Integration focus**: All modules work together (personnel ↔ equipment ↔ vehicles ↔ compliance)
10. **Production-ready**: System has been tested through 24-day operational simulation

---

**Document Version**: 1.0
**Last Updated**: February 27, 2026
**System Status**: Production-Ready with Recent Bug Fixes Applied
