# DASIA System - Full Authentication Audit Report

## Executive Summary
The current authentication system has **critical architectural gaps** that must be addressed before implementing the forgot password feature. This audit identifies:
- ❌ No JWT/bearer token generation or validation
- ❌ No authentication middleware on protected routes
- ❌ Inconsistent token handling (frontend expects tokens, backend doesn't create them)
- ❌ Authentication state lost on page refresh (logout-on-refresh bug)
- ❌ No password reset mechanism

---

## 1. CRITICAL FINDINGS

### 1.1 Authentication Flow Gap
**Current State:**
- Backend `login` endpoint returns user data but NO token
- Frontend expects token in localStorage (`localStorage.getItem('token')`)
- Token is sent in XHR requests as `Authorization: Bearer {token}`
- Backend has NO middleware validating this token
- Routes are completely open with no authentication checks

**Affected Files:**
- Backend: `DasiaAIO-Backend/src/handlers/auth.rs` (lines 281-351) - No token generation
- Backend: `DasiaAIO-Backend/src/main.rs` - No authentication middleware
- Frontend: `DasiaAIO-Frontend/src/components/TripManagement.tsx` - Uses token
- Frontend: `DasiaAIO-Frontend/src/components/SuperadminDashboard.tsx` - Uses token
- Frontend: `DasiaAIO-Frontend/src/components/EditScheduleModal.tsx` - Uses token

**Risk Level:** 🔴 CRITICAL

---

### 1.2 Session Persistence Issue
**Current State:**
- `App.tsx` uses `useState` for authentication with no persistence
- No `useEffect` to restore auth from localStorage on app load
- Page refresh (`window.location.reload()`) destroys React state
- User is logged out when they refresh the page

**Affected Files:**
- `DasiaAIO-Frontend/src/App.tsx` (lines 23-25)
- `DasiaAIO-Frontend/src/components/AccountManager.tsx` (line 56)

**Root Cause:** 
```tsx
// Current (BAD)
const [isLoggedIn, setIsLoggedIn] = useState<boolean>(false)
const [user, setUser] = useState<User | null>(null)
// No useEffect to restore from localStorage
```

**Risk Level:** 🟠 HIGH

---

## 2. ARCHITECTURE ISSUES

### Issue 1: Missing Token Generation
**Location:** `DasiaAIO-Backend/src/handlers/auth.rs:login()`

**Current Code Returns:**
```json
{
  "message": "Login successful",
  "user": {
    "id": "user123",
    "email": "user@example.com",
    ...
  }
}
```

**Should Return:**
```json
{
  "message": "Login successful",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": { ... }
}
```

**Action Required:** Add JWT generation to login endpoint

---

### Issue 2: No Authentication Middleware
**Location:** `DasiaAIO-Backend/src/main.rs`

**Current State:**
```rust
let app = Router::new()
    .route("/api/missions/assign", post(handlers::missions::assign_mission))
    .route("/api/guard-firearm-permits", post(handlers::permits::create_guard_permit))
    // ALL ROUTES ARE COMPLETELY OPEN
```

**Action Required:** Implement authentication middleware to validate Bearer token on protected routes

---

### Issue 3: Token Mismatch
**Location:** Frontend components expecting tokens

**Files Sending Tokens:**
- `TripManagement.tsx` (line 48)
- `SuperadminDashboard.tsx` (line 186)
- `AnalyticsDashboard.tsx` (line 53)
- `EditScheduleModal.tsx` (line 48)

**Example:**
```tsx
const token = localStorage.getItem('token')
const headers = { Authorization: `Bearer ${token}` }
```

**Problem:** Token never gets stored in localStorage (backend doesn't create it)

---

## 3. LOGOUT-ON-REFRESH BUG

### Root Cause
`AccountManager.tsx:handleRefresh()` calls `window.location.reload()`

```tsx
const handleRefresh = () => {
  window.location.reload()  // ❌ Destroys React state
  setIsOpen(false)
}
```

### Impact
1. Full page refresh destroys all React state
2. `isLoggedIn` and `user` revert to initial state (false/null)
3. App immediately shows LoginPage
4. User appears logged out

### Solution
Replace full page reload with localStorage restoration:

```tsx
const handleRefresh = () => {
  // Instead of window.location.reload(), trigger React re-render
  // that pulls auth from localStorage
  window.location.href = window.location.pathname
  setIsOpen(false)
}
```

Or better: Implement soft refresh without losing session

---

## 4. FORGOT PASSWORD FEATURE REQUIREMENTS

### 4.1 Complete Flow
```
User → Forgot Password Link → Enter Email → 
Send Reset Code → 
Verify Code + New Password → 
Update Database → 
Show Success
```

### 4.2 Database Schema Needed

**Table: password_reset_tokens**
```sql
CREATE TABLE password_reset_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token VARCHAR(6) NOT NULL UNIQUE,
    expires_at TIMESTAMP NOT NULL,
    is_used BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 4.3 Backend Endpoints Needed

**1. POST `/api/auth/forgot-password`**
- Input: `{ email: string }`
- Output: `{ message: "Reset code sent to email" }`
- Action: Generate random 6-digit code, send via email, store in DB

**2. POST `/api/auth/verify-reset-code`**
- Input: `{ email: string, code: string }`
- Output: `{ message: "Code verified" }`
- Action: Verify code exists and not expired

**3. POST `/api/auth/reset-password`**
- Input: `{ email: string, code: string, newPassword: string }`
- Output: `{ message: "Password reset successful" }`
- Action: Update user password, mark token as used

### 4.4 Frontend Components Needed

**Updates to `LoginPage.tsx`:**
- Add "Forgot your password?" link below login form
- Add `forgotPasswordMode` state
- Add email input, code verification, new password input
- Add submit handler to call `/api/auth/forgot-password`

**Updates to `App.tsx`:**
- No changes needed if keeping forgot password in LoginPage

---

## 5. IMPLEMENTATION ROADMAP

### Phase 1: Fix Authentication Architecture ⭐ DO FIRST
**Priority:** CRITICAL - Required before forgot password

1. **Generate JWT Tokens in Backend**
   - File: `DasiaAIO-Backend/src/handlers/auth.rs`
   - Add `jsonwebtoken` crate to `Cargo.toml`
   - Modify `login()` to return JWT token
   - Modify `register()` to return JWT token for verified users

2. **Persist Authentication in Frontend**
   - File: `DasiaAIO-Frontend/src/App.tsx`
   - Add `useEffect` to restore auth from localStorage on mount
   - Modify `handleLogin` to store token in localStorage
   - Modify `handleLogout` to clear localStorage

3. **Fix LoginPage Token Storage**
   - File: `DasiaAIO-Frontend/src/components/LoginPage.tsx`
   - Extract token from API response
   - Pass token to parent via callback or handle storage directly

4. **Fix Logout-on-Refresh Bug**
   - File: `DasiaAIO-Frontend/src/components/AccountManager.tsx`
   - Replace `window.location.reload()` with proper navigation/refresh

### Phase 2: Add Forgot Password Feature
**Priority:** HIGH - Add after Phase 1

1. **Database Migration**
   - Add password_reset_tokens table
   - Add migration file to migrations/ folder

2. **Backend Endpoints**
   - Implement `/api/auth/forgot-password`
   - Implement `/api/auth/verify-reset-code`
   - Implement `/api/auth/reset-password`

3. **Frontend UI**
   - Add forgot password UI to LoginPage
   - Add form state management
   - Add submit handlers

---

## 6. AFFECTED COMPONENTS SUMMARY

### Backend Files (30+ files using tokens)
- `DasiaAIO-Backend/src/handlers/auth.rs` - NO token generation
- `DasiaAIO-Backend/src/handlers/missions.rs` - NO auth check
- `DasiaAIO-Backend/src/handlers/permits.rs` - NO auth check
- All other handlers - NO auth checks

### Frontend Files (4+ files expecting tokens)
- `DasiaAIO-Frontend/src/App.tsx` - NO token restoration
- `DasiaAIO-Frontend/src/components/LoginPage.tsx` - NO token storage
- `DasiaAIO-Frontend/src/components/AccountManager.tsx` - Causes logout-on-refresh
- `DasiaAIO-Frontend/src/components/TripManagement.tsx` - Sends invalid token
- `DasiaAIO-Frontend/src/components/SuperadminDashboard.tsx` - Sends invalid token
- `DasiaAIO-Frontend/src/components/EditScheduleModal.tsx` - Sends invalid token
- `DasiaAIO-Frontend/src/components/AnalyticsDashboard.tsx` - Sends invalid token

---

## 7. SECURITY IMPLICATIONS

⚠️ **Current State:** NO authentication on ANY endpoint
- All routes are completely open
- No protection against unauthorized access
- No user isolation (one user could modify another's data)

✅ **After Fix:** Proper authentication with JWT tokens
- Protected routes validate Bearer token
- User isolation enforced
- Token expiration implemented

---

## 8. DEPENDENCIES TO ADD

### Rust Backend
```toml
[dependencies]
jsonwebtoken = "9"
serde_json = "1"
chrono = "0.4"  # Already present
```

### Frontend
No new dependencies needed (using native fetch API)

---

## 9. TESTING CHECKLIST

- [ ] Login creates and returns token
- [ ] Token stored in localStorage
- [ ] App.tsx restores auth from localStorage on load
- [ ] Page refresh preserves authentication
- [ ] AccountManager.tsx refresh doesn't log out user
- [ ] POST requests include Bearer token
- [ ] Forgot password flow works end-to-end
- [ ] Reset code expires after time limit
- [ ] Invalid/expired codes are rejected
- [ ] New password is properly hashed

---

## 10. TIMELINE ESTIMATE

| Phase | Task | Est. Time |
|-------|------|-----------|
| 1a | Backend JWT generation | 30 min |
| 1b | Frontend token storage | 30 min |
| 1c | Fix refresh logout bug | 15 min |
| 1d | Testing & debugging | 30 min |
| **Phase 1 Total** | **Authentication Fix** | **~2 hrs** |
| 2a | Database migration | 15 min |
| 2b | Backend endpoints | 45 min |
| 2c | Frontend UI | 45 min |
| 2d | Testing & debugging | 30 min |
| **Phase 2 Total** | **Forgot Password** | **~2.5 hrs** |
| **TOTAL** | **Full Implementation** | **~4.5 hrs** |

---

## Recommendations

1. **Start with Phase 1** - Fix authentication first
2. **Then implement Phase 2** - Add forgot password on solid foundation
3. **Add authentication middleware** - Protect all routes after token generation works
4. **Implement token expiration** - Standard JWT practice (e.g., 24 hours)
5. **Add refresh token rotation** - For enhanced security

