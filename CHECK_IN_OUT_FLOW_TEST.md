# Check-In/Check-Out Flow Test Guide

## System Components
✅ **Backend Endpoints:**
- `POST /api/guard-replacement/attendance/check-in` → Creates attendance + punctuality record
- `POST /api/guard-replacement/attendance/check-out` → Updates attendance with check_out_time

✅ **Frontend Features:**
- Profile section displays user data (fullName, phoneNumber, licenseNumber)
- "Today's Shifts" section shows all shifts assigned for current date
- Real-time elapsed time tracking (HH:mm:ss format)
- Check-In button (creates attendance record)
- Check-Out button (completes attendance record)

---

## End-to-End Test Flow

### Step 1: User Registration & Login
1. Register new user:
   - Email: testguard@gmail.com
   - Password: SecurePass123!
   - Full Name: Test Guard
   - Phone: +63-900-000-0001
   - License Number: DL123456
   - License Expiry: 2026-12-31
   - Role: user

2. Verify email (check Gmail)
3. Login with credentials

### Step 2: Verify Profile Display
1. Navigate to UserDashboard (Overview tab)
2. Check "My Profile" section shows:
   - Full Name: Test Guard ✓
   - Email: testguard@gmail.com ✓
   - Phone: +63-900-000-0001 ✓
   - License Number: DL123456 ✓

3. Check "License Status" section shows:
   - Active status badge ✓
   - Days until expiry ✓

### Step 3: Create a Shift for Today
1. Use Admin dashboard or API to create shift:
   ```json
   {
     "guard_id": "{guardId}",
     "start_time": "2026-03-03T08:00:00Z",
     "end_time": "2026-03-03T17:00:00Z",
     "client_site": "Downtown Bank Branch"
   }
   ```

### Step 4: Check Today's Shifts Display
1. Refresh UserDashboard
2. Verify "Today's Shifts" section shows:
   - Client site: Downtown Bank Branch ✓
   - Time: 8:00 AM - 5:00 PM ✓
   - Status: Ready to Check In ✓
   - Check In button visible ✓

### Step 5: Test Check-In
1. Click "Check In" button
2. Verify:
   - Button changes to "Check Out" ✓
   - Status changes to "Checked In" ✓
   - Elapsed Time counter starts (0h 0m 1s, 0h 0m 2s, etc.) ✓
   - Attendance record created in DB ✓

### Step 6: Test Elapsed Time Tracking
1. Wait 30+ seconds
2. Verify elapsed time updates every second ✓
3. Format: HHh MMm SSs ✓

### Step 7: Test Check-Out
1. Click "Check Out" button
2. Verify:
   - Button changes back to "Check In" ✓
   - Status changes to "Ready to Check In" ✓
   - Elapsed time counter stopped ✓
   - "Recent Attendance" table updates with new record ✓
   - Hours worked calculated correctly ✓

### Step 8: Verify Attendance Records
1. Check "Recent Attendance" table:
   - Date: Today ✓
   - Check-In: 08:XX:XX ✓
   - Check-Out: 08:XX:XX ✓
   - Hours: ~8.0 hrs ✓
   - Status: checked_out ✓

---

## API Contract Verification

### Check-In Request/Response
**Request:**
```json
{
  "guard_id": "uuid",
  "shift_id": "uuid"
}
```

**Response:**
```json
{
  "message": "Check-in recorded successfully",
  "attendanceId": "uuid"
}
```

### Check-Out Request/Response
**Request:**
```json
{
  "attendance_id": "uuid"
}
```

**Response:**
```json
{
  "message": "Check-out recorded successfully"
}
```

---

## Known Behavior

### Filters & Edge Cases
- **Today's Shifts only:** Shifts for current date only shown
- **Multiple shifts:** All daily shifts displayed with independent timers
- **Real-time updates:** Requires page refresh to see DB changes from other sessions
- **Elapsed time:** Calculated client-side, stops on check-out

### Error Handling
- Invalid shift_id → Backend returns 404 "Shift not found"
- Missing attendance_id → Backend returns 400 "Attendance ID is required"
- Network errors → Logged to console, user sees disabled button feedback

---

## Success Criteria ✓

- [ ] Profile fields display correctly (not "N/A")
- [ ] Today's shifts visible in "Today's Shifts" section
- [ ] Check-In button creates attendance record
- [ ] Elapsed time counter updates in real-time
- [ ] Check-Out button updates database
- [ ] New attendance appears in "Recent Attendance" table
- [ ] Hours worked calculated correctly
- [ ] Multiple shifts can be checked in/out independently
