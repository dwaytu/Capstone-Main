# Quick-Fix Guide: API Integration Issues

## 🔴 CRITICAL FIXES - DO FIRST

### Fix #1: FirearmAllocation.tsx - Line 122
**Issue:** Calling wrong endpoint `/allocate` instead of `/issue`

**File:** `DasiaAIO-Frontend/src/components/FirearmAllocation.tsx` (Line 122)

**BEFORE:**
```tsx
const response = await fetch(`${API_BASE_URL}/api/firearm-allocation/allocate`, {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    guardId: newAllocation.guardId,
    firearmId: newAllocation.firearmId,
  }),
})
```

**AFTER:**
```tsx
const response = await fetch(`${API_BASE_URL}/api/firearm-allocation/issue`, {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    firearm_id: newAllocation.firearmId,
    guard_id: newAllocation.guardId,
  }),
})
```

**Why:** 
- Backend route is `/issue`, not `/allocate` (which doesn't exist)
- Backend expects snake_case field names (serde will auto-convert from camelCase, so both work, but backend model uses snake_case)

---

### Fix #2: AdminDashboard.tsx - Lines 91 & 120
**Issue:** Hardcoded localhost URLs instead of API_BASE_URL

**File:** `DasiaAIO-Frontend/src/components/AdminDashboard.tsx` 

**INSTANCE 1 (Line 91 - handleSaveUser):**

**BEFORE:**
```tsx
const response = await fetch(`http://localhost:5000/api/user/${editingUser.id}`, {
  method: 'PUT',
  headers: {
    'Content-Type': 'application/json',
  },
  body: JSON.stringify(updatedData),
})
```

**AFTER:**
```tsx
const response = await fetch(`${API_BASE_URL}/api/user/${editingUser.id}`, {
  method: 'PUT',
  headers: {
    'Content-Type': 'application/json',
  },
  body: JSON.stringify(updatedData),
})
```

**INSTANCE 2 (Line 120 - handleDeleteUser):**

**BEFORE:**
```tsx
const response = await fetch(`http://localhost:5000/api/user/${userId}`, {
  method: 'DELETE',
})
```

**AFTER:**
```tsx
const response = await fetch(`${API_BASE_URL}/api/user/${userId}`, {
  method: 'DELETE',
})
```

**Why:** Hardcoded localhost breaks if backend runs on different port/server. Use the imported `API_BASE_URL` constant.

**Note:** Need to import API_BASE_URL at top of file if not already imported.

---

### Fix #3: test-merit.ps1 - Lines 21-27
**Issue:** Sending wrong field names that backend doesn't accept

**File:** `DasiaAIO-Backend/test-merit.ps1`

**BEFORE (Lines 21-27):**
```powershell
$evaluationPayload = @{
    guardId = $testGuardId
    rating = $ratings[$i]
    comments = "Excellent performance during mission $($i+1)"
    evaluatorName = "Client $($i+1)"
    evaluatorEmail = "client$($i+1)@company.com"
    missionDate = (Get-Date).AddDays(-$i).ToString("yyyy-MM-dd")
} | ConvertTo-Json
```

**AFTER:**
```powershell
$evaluationPayload = @{
    guardId = $testGuardId
    rating = $ratings[$i]
    comment = "Excellent performance during mission $($i+1)"
    evaluatorName = "Client $($i+1)"
    evaluatorRole = "Supervisor"
} | ConvertTo-Json
```

**Why:** 
- Backend field is `comment` (singular), not `comments`
- `evaluatorEmail` is not in backend model
- `missionDate` is not in backend model (use mission_id or shift_id for context)
- Need to include `evaluatorRole` (was missing)

**Backend model expects** (from CreateClientEvaluationRequest):
```rust
pub guard_id: String,
pub shift_id: Option<String>,
pub mission_id: Option<String>,
pub evaluator_name: String,
pub evaluator_role: Option<String>,
pub rating: f64,
pub comment: Option<String>,  // singular!
```

---

## 🟠 HIGH PRIORITY FIXES

### Fix #4: FirearmMaintenance.tsx - Line 52
**Issue:** Calling ambiguous endpoint that doesn't properly exist

**File:** `DasiaAIO-Frontend/src/components/FirearmMaintenance.tsx` (Line 52)

**BEFORE:**
```tsx
const fetchMaintenances = async () => {
  try {
    setLoading(true)
    const response = await fetch(`${API_BASE_URL}/api/firearm-maintenance`)
    if (response.ok) {
      const data = await response.json()
      setMaintenances(data.maintenances || [])
    }
  } catch (err) {
    console.error('Error fetching maintenance records:', err)
  } finally {
    setLoading(false)
  }
}
```

**AFTER:**
```tsx
const fetchMaintenances = async () => {
  try {
    setLoading(true)
    // Use /pending to get pending maintenance records specifically
    const response = await fetch(`${API_BASE_URL}/api/firearm-maintenance/pending`)
    if (response.ok) {
      const data = await response.json()
      // Backend returns array directly, not wrapped in object
      setMaintenances(Array.isArray(data) ? data : [])
    }
  } catch (err) {
    console.error('Error fetching maintenance records:', err)
  } finally {
    setLoading(false)
  }
}
```

**Why:**
- `/api/firearm-maintenance` without path parameter is ambiguous
- `/api/firearm-maintenance/pending` is the intended endpoint for pending maintenance
- Backend returns array directly, not wrapped

**OR** if you want all maintenance for a specific firearm:
```tsx
const response = await fetch(`${API_BASE_URL}/api/firearm-maintenance/${firearmId}`)
```

---

### Fix #5: Accept-replacement endpoint parameters - VERIFIED ✅

**Status:** ✅ **NO CHANGES NEEDED** - Parameters are correct

**Verified in:** `DasiaAIO-Backend/src/handlers/guard_replacement.rs` (Line 389)

Backend correctly accepts:
- `guardId` ✅
- `shiftId` ✅  
- `notificationId` ✅ (optional)

Frontend in [NotificationPanel.tsx line 95](DasiaAIO-Frontend/src/components/NotificationPanel.tsx#L95) is sending exactly these parameters. No fix needed!

---

## ⚠️ MEDIUM PRIORITY

### Fix #6: Make route naming consistent
**Issue:** Both `/api/user/:id` and `/api/users/:id` exist causing confusion

**Recommendation:** Keep only one pattern. Either:
- Option A: Keep `/api/users/:id` (plural - REST convention)
- Option B: Keep `/api/user/:id` (singular - current mixed usage)

**Audit recommendation:** Use `/api/users/:id` (plural) for REST consistency.

Then update frontend to use consistently:
- AdminDashboard.tsx ✓ (already uses `/api/user/:id`)
- ProfileDashboard.tsx ✓ (already uses `/api/user/:id`)
- All components consistent except AdminDashboard hardcoded URLs

---

## Testing Commands

After applying fixes, run these tests:

### Test 1: Firearm Allocation (verify endpoint works)
```powershell
$payload = @{
    firearm_id = "firearm-test-id"
    guard_id = "guard-test-id"
    issued_by = "admin"
} | ConvertTo-Json

$response = Invoke-RestMethod `
  -Uri "http://localhost:5000/api/firearm-allocation/issue" `
  -Method Post `
  -Headers @{"Content-Type"="application/json"} `
  -Body $payload

Write-Host ($response | ConvertTo-Json)
```

### Test 2: Merit Evaluation (correct parameters)
```powershell
$payload = @{
    guardId = "guard-id"
    evaluatorName = "John Supervisor"
    evaluatorRole = "Supervisor"
    rating = 4.5
    comment = "Great performance"
} | ConvertTo-Json

$response = Invoke-RestMethod `
  -Uri "http://localhost:5000/api/merit/evaluations/submit" `
  -Method Post `
  -Headers @{"Content-Type"="application/json"} `
  -Body $payload

Write-Host ($response | ConvertTo-Json)
```

### Test 3: Firearm Maintenance (pending)
```powershell
$response = Invoke-RestMethod `
  -Uri "http://localhost:5000/api/firearm-maintenance/pending" `
  -Method Get

Write-Host ($response | ConvertTo-Json)
```

---

## Validation Checklist

- [ ] Fix FirearmAllocation.tsx line 122 (endpoint + params)
- [ ] Fix AdminDashboard.tsx line 91 (hardcoded URL #1)
- [ ] Fix AdminDashboard.tsx line 120 (hardcoded URL #2)  
- [ ] Fix test-merit.ps1 lines 21-27 (field names)
- [ ] Fix FirearmMaintenance.tsx line 52 (endpoint)
- [ ] Verify accept-replacement parameters in guard_replacement.rs
- [ ] Run test commands above to validate
- [ ] Test full workflow in UI
- [ ] Update this checklist as complete

---

## Files That Will Need Changes

```
DasiaAIO-Frontend/src/components/
├── FirearmAllocation.tsx          ← FIX #1 (Line 122)
├── AdminDashboard.tsx             ← FIX #2 (Lines 91, 120)
├── FirearmMaintenance.tsx         ← FIX #4 (Line 52)
└── NotificationPanel.tsx          ← VERIFY (Line 95)

DasiaAIO-Backend/
├── test-merit.ps1                 ← FIX #3 (Lines 21-27)
└── src/handlers/
    └── guard_replacement.rs       ← VERIFY
```

---

**Last Updated:** 2026-02-22
**Priority:** Apply Phase 1 fixes immediately before next testing cycle
