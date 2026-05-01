# Railway Autodeploy Setup

This repository now includes a dedicated workflow:

- `.github/workflows/railway-deploy.yml`

It deploys backend and frontend services to Railway on:
- push to `main` (when backend/frontend files change)
- manual trigger (`workflow_dispatch`)

## 1) Required GitHub Secret

Create this repository secret:

- `RAILWAY_TOKEN`

Use a **Railway Project Token** scoped to the target Railway environment.

## 2) Required GitHub Repository Variables

Create these repository variables:

- `RAILWAY_PROJECT_ID` - Railway project ID
- `RAILWAY_ENVIRONMENT` - environment name or ID (example: `production`)
- `RAILWAY_BACKEND_SERVICE` - backend service name or ID
- `RAILWAY_FRONTEND_SERVICE` - frontend service name or ID

## 3) Manual Run

From GitHub Actions:

1. Open **Railway Deploy**
2. Click **Run workflow**
3. Choose whether to deploy backend/frontend
4. Optionally override environment via `railway_environment`

## 4) Notes

- Deployment command uses Railway CLI `railway up` in CI mode.
- Backend and frontend are deployed from subpaths using `--path-as-root`.
- If a variable/secret is missing, the workflow fails early with actionable errors.

## 5) Optional Hardening

- In Railway service settings, enable **Wait for CI** for GitHub autodeploy coordination.
- Keep Railway service root directories aligned with:
  - `DasiaAIO-Backend/`
  - `DasiaAIO-Frontend/`
