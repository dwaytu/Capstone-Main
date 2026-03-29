# SYSTEM FLOW DIAGRAMS

Updated: 2026-03-29

## 1. Authentication, Approval, and Legal Consent Flow

```mermaid
flowchart TD
    A[Guard submits registration] --> B[POST /api/register]
    B --> C[User created as pending + unverified]
    C --> D[Verification code issued]
    D --> E[POST /api/verify]
    E --> F[verified=true]
    F --> G[Reviewer approves user]
    G --> H[PUT /api/users/:id/approval]
    H --> I[approval_status=approved]
    I --> J[POST /api/login]
    J --> K[Access token + refresh token]
    K --> L{legal_consent_accepted?}
    L -- No --> M[POST /api/legal/consent]
    M --> N[Consent metadata persisted]
    N --> O[Protected routes allowed]
    L -- Yes --> O
```

## 2. Protected API Request Lifecycle

```mermaid
flowchart LR
    A[Frontend request with Bearer token] --> B[CORS layer]
    B --> C[Request timeout middleware]
    C --> D[Global API rate limiter]
    D --> E[AuthZ middleware]
    E --> F[Legal consent enforcement]
    F --> G[Handler execution]
    G --> H[(PostgreSQL)]
    H --> I[Structured JSON response]
    I --> J[Frontend state update]
```

## 3. Tracking and Command Map Data Flow

```mermaid
flowchart TD
    A[Client sends heartbeat] --> B[POST /api/tracking/heartbeat]
    B --> C[tracking_points insert]
    C --> D[Geofence transition evaluation]
    D --> E[geofence_events + notifications]
    E --> F[Broadcast map refresh event]

    G[Command dashboard] --> H[GET /api/tracking/map-data]
    G --> I[GET /api/tracking/ws?token=...]
    I --> J[WebSocket snapshot updates]
    J --> K[Map markers + alerts refresh]

    L[WebSocket unavailable] --> M[Polling fallback]
    M --> H
```

## 4. Cross-Platform Release Pipeline Flow

```mermaid
flowchart TD
    A[Tag push v* or workflow_dispatch] --> B[prepare job]
    B --> C[release-version + sync-release-version]
    C --> D[generate-release-notes]

    B --> E[web job]
    B --> F[desktop job]
    B --> G[android job]

    E --> H[sentinel-web-vX.Y.Z.tar.gz]
    F --> I[sentinel-desktop-windows-vX.Y.Z msi/exe]
    G --> J[sentinel-android-vX.Y.Z apk/aab]

    H --> K[publish job]
    I --> K
    J --> K
    K --> L[GitHub Release assets]
```

## 5. Validation Signals for These Flows

- Frontend tests/build pass (`npm test`, `npm run build` in `DasiaAIO-Frontend`).
- Backend tests/runtime pass (`cargo test`, `docker compose up -d`, `/api/health`).
- Release flow requires a live GitHub Actions run to validate repository secret availability.
