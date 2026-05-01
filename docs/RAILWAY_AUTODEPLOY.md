# Railway Native Autodeploy Setup

This repository now uses **Railway-native GitHub autodeploy** (recommended path), not a GitHub Actions deploy workflow.

## Why this path

- Token authentication and deploy execution are handled directly inside Railway.
- Avoids CI auth mismatch issues seen in GitHub-hosted runners.
- Keeps deploy state and build logs centralized in Railway services.

## 1) Connect each service to GitHub repo in Railway

In Railway project `SENTINEL`:

1. Open service **Backend** (`9ad1e8f5-fb2f-4636-9dfd-a494b87ad0f6`)
2. Go to service **Settings > Source**
3. Connect GitHub repo: `dwaytu/Capstone-Main`
4. Set:
   - Branch: `main`
   - Root Directory: `DasiaAIO-Backend`
5. Enable automatic deploy on push

Repeat for service **Frontend** (`84f3c619-05ff-43aa-90c4-b524339fd1b3`) with:

- Branch: `main`
- Root Directory: `DasiaAIO-Frontend`

## 2) Keep build/deploy contracts in repo

Railway uses each service directory's `railway.json` + `Dockerfile`:

- Backend config: `DasiaAIO-Backend/railway.json`
- Frontend config: `DasiaAIO-Frontend/railway.json`

## 3) Optional manual deploy fallback (local)

If you need to force a deploy from terminal:

```powershell
npm run deploy:railway
```

This uses `scripts/railway-deploy.ps1` and Railway CLI.

## 4) Verification checklist

After push to `main`:

1. Railway project activity shows a new deployment for Backend and Frontend
2. Frontend service healthcheck passes (`/`)
3. Backend service healthcheck passes (`/api/health`)
4. Live URL smoke check confirms login and dashboard load

## 5) Token guidance

- For local CLI automation, use `RAILWAY_API_TOKEN` (account token).
- Avoid setting a conflicting `RAILWAY_TOKEN` in the same shell unless intentionally required.
