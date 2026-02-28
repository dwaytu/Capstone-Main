# SENTINEL Quick Reference Guide for Gemini AI

## System at a Glance

**Project**: SENTINEL - Integrated Security Operations Management Platform
**Organization**: Davao Security & Investigation Agency, Inc.
**Current Date**: February 27, 2026
**Status**: Production-Ready (24-day operational simulation completed)

---

## 🏗️ ARCHITECTURE

### Backend Stack
- **Language**: Rust 1.70+
- **Framework**: Axum 0.7 (async web framework)
- **Runtime**: Tokio (async/concurrency)
- **Database**: PostgreSQL 12+ (5 default connection pool)
- **Authentication**: bcrypt (10-round salt) + Gmail verification

### Frontend Stack
- **Framework**: React 18.2 + TypeScript 5.9
- **Styling**: Tailwind CSS 4.2
- **Build**: Vite 7.3
- **Components**: 32 React components across 6 main dashboards
- **Responsive**: Mobile-first design with `lg:` breakpoints

### Storage
- **Database**: PostgreSQL 12+ (20+ relational tables)
- **Session**: localStorage (token-based)
- **Files**: Profile photos (URL references)

---

## 📊 QUICK DATA MODEL

| Table | Purpose | Key Fields |
|-------|---------|-----------|
| `users` | Personnel & authentication | id, email, role, license_number, verified |
| `firearms` | Equipment inventory | id, serial_number, status (allocated/available) |
| `firearm_allocations` | Chain of custody | firearm_id, guard_id, issued_at, returned_at |
| `guard_firearm_permits` | Compliance tracking | guard_id, firearm_id, expiry_date, clearance_date |
| `shifts` | Shift assignments | guard_id, client_site, start_time, status |
| `attendance` | Check-in/out records | guard_id, check_in_time, check_out_time |
| `armored_cars` | Vehicle fleet | id, license_plate, status |
| `car_allocations` | Vehicle assignments | car_id, driver_id, assigned_at |
| `armored_car_trips` | Trip records | car_id, driver_id, start_time, cargo_description |
| `training_records` | Certifications | guard_id, training_type, expiry_date |
| `merit_scores` | Performance ranking | guard_id, attendance_score, performance_score, overall_score |
| `notifications` | Alerts | user_id, type, message, read |

---

## 👥 USER ROLES & PERMISSIONS

```
Superadmin (Full access) ═══ System-wide analytics, compliance, settings
    ↓
Admin (Operational) ═════ Guard/shift/equipment management
    ↓
User/Guard (Limited) ══ Personal records only
```

**Key Endpoint Examples**:
- `POST /api/register` - Anyone (Gmail, must verify email)
- `POST /api/firearm-allocation/issue` - Admin+ only
- `GET /api/analytics` - Admin+ only
- `GET /api/user/:id` - Own profile or admin access

---

## 🔑 CRITICAL BUSINESS LOGIC

### No-Show Detection (Hourly)
```
Shift scheduled but no check-in after 30 min
    ↓ Auto-trigger ↓
Create replacement request → Send to available guards
    ↓ If accepted ↓
Auto-assign replacement → Notify admin & site
    ↓ If not accepted ↓
Escalate to admin (manual intervention)
```

### Permit Expiry Checks (Daily)
```
Query all permits → Check expiry dates
If expired: Block guard from duty
If within 30 days: Alert notification
If neuro-psych expired: Force permit expiration
```

### Merit Score Calculation (Weekly)
```
For each guard:
  Attendance Score (40% weight): 100 - (no_shows / total_shifts * 100)
  Performance Score (35% weight): Average of client ratings
  Compliance Score (25% weight): License/training/permit status
  Overall = (A * 0.40) + (P * 0.35) + (C * 0.25)
  
Tier A ≥85: Premium overtime candidate
Tier B 70-84: Standard overtime candidate
Tier C <70: Not recommended
```

### Firearm Allocation Workflow
```
Admin selects guard + firearm
    ↓ Validate ↓
Guard LESP current? ✓
Neuro-psych clearance current? ✓
Permit exists for this firearm? ✓
Firearm has no maintenance? ✓
No duplicate allocation? ✓
    ↓ If all pass ↓
Create allocation record → Log to audit trail
    ↓ Return process ↓
Guard returns firearm → Record condition
    ↓ Close ↓
Update allocation.returned_at → Firearm status = available
```

---

## 🔌 TOP 20 API ENDPOINTS

### Authentication (4)
- `POST /api/register` - Create account
- `POST /api/login` - Authenticate (email/username/phone)
- `POST /api/verify` - Verify email code
- `POST /api/resend-code` - Resend verification

### Users (5)
- `GET /api/users` - All users (admin+)
- `GET /api/user/:id` - Get profile
- `PUT /api/user/:id` - Update profile
- `DELETE /api/user/:id` - Delete account
- `PUT /api/user/:id/profile-photo` - Upload photo

### Firearm Management (10)
- `POST /api/firearms` - Add firearm
- `GET /api/firearms` - List all firearms
- `POST /api/firearm-allocation/issue` - Issue to guard
- `POST /api/firearm-allocation/return` - Return from guard
- `GET /api/guard-allocations/:guard_id` - Get guard's firearms
- `POST /api/guard-firearm-permits` - Create permit
- `GET /api/guard-firearm-permits/:guard_id` - Get permits
- `GET /api/guard-firearm-permits/expiring` - Expiring permits
- `POST /api/firearm-maintenance/schedule` - Schedule maintenance
- `POST /api/firearm-maintenance/:id/complete` - Complete maintenance

### Guard Scheduling (8)
- `POST /api/guard-replacement/shifts` - Create shift
- `GET /api/guard-replacement/shifts` - List all shifts
- `GET /api/guard-replacement/guard/:id/shifts` - Guard's shifts
- `POST /api/guard-replacement/attendance/check-in` - Clock in
- `POST /api/guard-replacement/attendance/check-out` - Clock out
- `GET /api/attendance/:guard_id` - Attendance history
- `POST /api/guard-replacement/detect-no-shows` - Run detection
- `POST /api/guard-replacement/request-replacement` - Create replacement request

### Vehicle Management (6)
- `POST /api/armored-cars` - Add vehicle
- `GET /api/armored-cars` - List vehicles
- `POST /api/car-allocation/issue` - Assign to driver
- `POST /api/trips` - Create trip record
- `POST /api/trips/end` - End trip
- `POST /api/car-maintenance/schedule` - Schedule maintenance

### Analytics & Performance (4)
- `POST /api/merit/calculate` - Recalculate all scores
- `GET /api/merit/:guard_id` - Get guard's score
- `GET /api/merit/rankings/all` - Full rankings
- `GET /api/analytics` - System metrics

---

## 🎨 FRONTEND COMPONENTS

### Main Dashboard Routes
- `/login` → LoginPage + ParticleBackground
- `/dashboard` → Superadmin/Admin/User based on role
- `/calendar` → CalendarDashboard (Schedule view)
- `/profile` → ProfileDashboard (Personal profile)
- `/performance` → PerformanceDashboard (Metrics)
- `/merit` → MeritScoreDashboard (Rankings)
- `/analytics` → AnalyticsDashboard (Reports)
- `/firearms` → FirearmInventory (Equipment)
- `/permits` → GuardFirearmPermits (Compliance)
- `/trips` → TripManagement (Vehicle ops)
- `/armored-cars` → ArmoredCarDashboard (Fleet)

### Common Patterns
Every dashboard includes:
- `Sidebar` - Mobile-responsive navigation (hamburger on sm/md)
- `Header` - Profile menu, notifications, mobile hamburger
- Mobile state: `const [mobileMenuOpen, setMobileMenuOpen] = useState(false)`

---

## 🐛 RECENT FIXES

### #1 CalendarDashboard (Feb 27, 2026)
- **Problem**: Dashboard items disappeared on mobile
- **Root Cause**: Missing `mobileMenuOpen` state and Header/Sidebar props
- **Fixed**: Added state variable, updated Sidebar props (isOpen, onClose), updated Header props (onMenuClick), expanded user nav items 3→6
- **Status**: ✓ Verified no TypeScript errors

### #2 Backend Error Handling (Feb 27, 2026)
- **Problem**: 10 `.unwrap()` calls in auth.rs could panic
- **Fixed**: Replaced all with proper `.map_err()` error handling
- **Status**: ✓ All 10 instances replaced, verified compilation

---

## ⚙️ ENVIRONMENT SETUP

```bash
# Backend
DATABASE_URL=postgresql://user:password@localhost:5432/guard_firearm_system
SERVER_HOST=0.0.0.0
SERVER_PORT=5000
GMAIL_USER=your@gmail.com
GMAIL_PASSWORD=app_password
ADMIN_CODE=122601

# Frontend
VITE_API_BASE_URL=http://localhost:5000
```

**Start System**:
```bash
cd DasiaAIO-Backend && docker compose up -d
cd DasiaAIO-Frontend && npm run dev -- --host
```

---

## 📋 KEY WORKFLOWS AT A GLANCE

| Workflow | Trigger | Auto/Manual | System Changes |
|----------|---------|------------|-----------------|
| No-show detection | Hourly | Auto | Shift status → no_show, replacement request created |
| Permit expiry | Daily | Auto | Permit status → expired, guard blocked from duty |
| Merit recalculation | Weekly | Auto | Scores updated, tiers assigned, OT candidates listed |
| Firearm allocation | On-demand | Manual | Allocation record created, audit trail logged |
| Guard check-in | On-demand | Manual | Attendance record created, shift status updated |
| Trip completion | On-demand | Manual | Trip status → completed, car status → available |

---

## 🎯 SYSTEM STATISTICS

- **Backend Code**: ~5,000+ Rust LOC
- **Frontend Components**: 32 React/TypeScript
- **API Endpoints**: 100+
- **Database Tables**: 20+
- **User Roles**: 4 (User, Admin, Superadmin, System)
- **Business Scenarios Tested**: 24
- **Production Issues Resolved**: 15+
- **Regulatory Compliance**: RA 11917 (Philippine security law)

---

## 🚨 CRITICAL COMPLIANCE RULES

1. **Guard Deployment**: Guard must have current LESP license + neuro-psych clearance + firearm permit
2. **Firearm Allocation**: Firearm can only be allocated to ONE guard at a time
3. **Equipment Returns**: Overdue returns trigger automated alerts and governance escalation
4. **Permit Expiry**: Any expired permit immediately revokes guard duty rights
5. **No-Show Threshold**: 30 minutes without check-in = automatic no-show flag + replacement automation
6. **Audit Trail**: Every material change logged with timestamp and user ID

---

## 🔍 WHAT GEMINI SHOULD KNOW

1. **This is production code** - Already tested through 24-day simulation, used by real security agency
2. **Compliance is critical** - Every feature must align with RA 11917 (Philippine security law)
3. **Real-time matters** - System runs 24/7, handles high concurrency with Rust/Tokio
4. **Mobile first** - All dashboards responsive, field personnel need phone access
5. **Data integrity** - Every record immutable, audit trails permanent
6. **Local + Global** - Built for Philippine regulations but uses global best practices (TrackTik, Guardhouse patterns)
7. **User-centric** - Guards, admins, clients all use this system daily
8. **Recent fixes** - CalendarDashboard mobile and backend error handling fixed Feb 27, 2026

---

**When asking Gemini for help**: Link to the full context document (GEMINI_SYSTEM_CONTEXT_PROMPT.md) and reference this quick guide for fast lookups.
