# SENTINEL Quick Start Guide

This guide covers the fastest path to running SENTINEL for each platform.

## Web

1. Open https://dasiasentinel.xyz/
2. Sign in with your provisioned account credentials.
3. If you are a new guard, register via the login page and wait for admin approval.

## Desktop (Windows)

1. Download the latest `.msi` or `.exe` installer from [GitHub Releases](https://github.com/dwaytu/Capstone-Main/releases/latest).
2. Run the installer and launch SENTINEL.
3. Sign in with the same credentials used on the web.

## Android

1. Download the latest APK from [GitHub Releases](https://github.com/dwaytu/Capstone-Main/releases/latest).
2. Enable sideloading on the device if not already enabled.
3. Install and launch the app.
4. Sign in with your account credentials.

## Local Development

### Prerequisites

- Node.js 20+
- Rust toolchain (rustup)
- PostgreSQL (or Docker)
- `DATABASE_URL` environment variable pointing to a PostgreSQL instance

### Backend

```bash
cd DasiaAIO-Backend
# Option A: Docker
docker compose up -d --build

# Option B: Native
cargo run --bin server
```

Health check: `curl http://localhost:5000/api/health`

### Frontend

```bash
cd DasiaAIO-Frontend
npm install
npm run dev
```

Opens at http://localhost:5173. Requires the backend running at `localhost:5000`.

### Cross-Platform Builds

From repository root:

```bash
npm run build:web        # Web production bundle
npm run build:desktop    # Tauri MSI/EXE
npm run build:android    # Capacitor APK
```

Release builds require `VITE_API_BASE_URL` (HTTPS production URL) and `VITE_APP_VERSION`.

## Environment Variables

### Backend (required)

| Variable | Purpose |
|----------|---------|
| `DATABASE_URL` | PostgreSQL connection string |
| `JWT_SECRET` | Token signing key (must be strong in production) |
| `ADMIN_CODE` | Internal account creation code (must be non-default in production) |
| `CORS_ORIGINS` | Comma-separated allowed origins |

### Backend (optional)

| Variable | Purpose |
|----------|---------|
| `RESEND_API_KEY` | Email provider key for verification and password reset |
| `APP_ENV` | Set to `production` for strict startup validation |
| `REQUEST_TIMEOUT_SECS` | API request timeout (default: 30) |
| `JWT_EXPIRY_HOURS` | Access token lifetime |

### Frontend (build-time)

| Variable | Purpose |
|----------|---------|
| `VITE_API_BASE_URL` | Backend API URL (must be HTTPS in production) |
| `VITE_APP_VERSION` | Semantic version for release identity |

## Account Provisioning

- **Guards**: Self-register via the login page. Accounts start as `pending` and require approval from an admin or supervisor.
- **Admin/Supervisor**: Created by a superadmin through the user management interface.
- **Superadmin**: Promoted via direct database update. See `DasiaAIO-Backend/scripts/railway_live_account_provision.sql`.

## Roles

| Role | Access |
|------|--------|
| `superadmin` | Full platform management, audit logs, user creation |
| `admin` | User management, operational dashboards, approvals |
| `supervisor` | Operational visibility, guard approvals, tracking |
| `guard` | Personal workspace, check-in/out, incident reporting |

## Troubleshooting

- **Logged out on refresh**: Clear `localStorage` and sign in again.
- **Password reset code not received**: Check spam folder. Verify `RESEND_API_KEY` is configured.
- **403 errors on dashboard load**: Verify your role has permission for the requested resource.
- **CORS errors in browser**: Ensure `CORS_ORIGINS` includes your frontend domain.
- **Backend won't start in production**: Check that `JWT_SECRET`, `ADMIN_CODE`, and `CORS_ORIGINS` are set to non-default values.

## Further Reading

- [PRODUCTION_ROLLOUT.md](PRODUCTION_ROLLOUT.md) — Multi-platform deployment and release workflow
- [CHATGPT_SYSTEM_GUIDE.md](CHATGPT_SYSTEM_GUIDE.md) — Full system architecture reference
- [COPILOT.md](COPILOT.md) — Technical stack conventions and API routes

