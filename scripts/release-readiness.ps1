param(
  [string]$FrontendUrl = "http://localhost:5173",
  [string]$BaseUrl = "http://localhost:5000",
  [switch]$RunBrowserSmoke,
  [switch]$RequireApi,
  [switch]$SkipClippy,
  [switch]$SkipAudit
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$frontendDir = Join-Path $repoRoot "DasiaAIO-Frontend"
$backendDir = Join-Path $repoRoot "DasiaAIO-Backend"
$failures = @()

function Step([string]$Message) {
  Write-Host ""
  Write-Host "==> $Message" -ForegroundColor Cyan
}

function Run-Check([string]$Name, [scriptblock]$Action) {
  Step $Name
  try {
    & $Action
    if ($LASTEXITCODE -ne 0) {
      throw "$Name failed with exit code $LASTEXITCODE"
    }
    Write-Host "PASS: $Name" -ForegroundColor Green
  } catch {
    Write-Host "FAIL: $Name - $($_.Exception.Message)" -ForegroundColor Red
    $script:failures += $Name
  }
}

Run-Check "Frontend TypeScript" {
  Push-Location $frontendDir
  try { npx --no-install tsc --noEmit } finally { Pop-Location }
}

Run-Check "Frontend tests" {
  Push-Location $frontendDir
  try { npm test -- --runInBand } finally { Pop-Location }
}

Run-Check "Frontend production build" {
  Push-Location $frontendDir
  try { npm run build } finally { Pop-Location }
}

if (-not $SkipAudit) {
  Run-Check "Frontend dependency audit" {
    Push-Location $frontendDir
    try { npm audit --audit-level=high } finally { Pop-Location }
  }
}

Run-Check "Backend compile check" {
  Push-Location $backendDir
  try { cargo check } finally { Pop-Location }
}

Run-Check "Backend tests" {
  Push-Location $backendDir
  try { cargo test } finally { Pop-Location }
}

if (-not $SkipClippy) {
  Run-Check "Backend Clippy" {
    Push-Location $backendDir
    try { cargo clippy --all-targets } finally { Pop-Location }
  }
}

if ($RequireApi) {
  Run-Check "API health" {
    $health = Invoke-RestMethod -Uri "$BaseUrl/api/health" -Method Get
    if ($health.status -ne "ok") { throw "Expected API status ok, received '$($health.status)'" }
    Write-Host ("API status: {0}" -f $health.status)
  }
} else {
  Write-Host ""
  Write-Host "API health: SKIPPED (use -RequireApi when the backend is running)" -ForegroundColor Yellow
}

if ($RunBrowserSmoke) {
  Run-Check "Browser smoke" {
    Push-Location $frontendDir
    try {
      $env:AUDIT_BASE_URL = $FrontendUrl
      npm run audit:smoke
    } finally {
      Pop-Location
    }
  }
} else {
  Write-Host "Browser smoke: SKIPPED (use -RunBrowserSmoke with Vite running)" -ForegroundColor Yellow
}

Write-Host ""
if ($failures.Count -gt 0) {
  Write-Host ("Release readiness FAILED: {0}" -f ($failures -join ", ")) -ForegroundColor Red
  exit 1
}

Write-Host "Release readiness PASSED." -ForegroundColor Green
