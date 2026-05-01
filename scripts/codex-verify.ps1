Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Step([string]$Message) {
  Write-Host ""
  Write-Host "==> $Message" -ForegroundColor Cyan
}

function Run-Step([string]$Name, [scriptblock]$Action) {
  Step $Name
  & $Action
}

$repoRoot = Split-Path -Parent $PSScriptRoot
$frontendDir = Join-Path $repoRoot "DasiaAIO-Frontend"
$backendDir = Join-Path $repoRoot "DasiaAIO-Backend"

Run-Step "Frontend tests" {
  Push-Location $frontendDir
  try {
    npm test -- --runInBand
  } finally {
    Pop-Location
  }
}

Run-Step "Frontend production build" {
  Push-Location $frontendDir
  try {
    npm run build
  } finally {
    Pop-Location
  }
}

Run-Step "Backend tests" {
  Push-Location $backendDir
  try {
    cargo test
  } finally {
    Pop-Location
  }
}

Run-Step "Backend build" {
  Push-Location $backendDir
  try {
    cargo build
  } finally {
    Pop-Location
  }
}

Step "Verification complete"
Write-Host "Frontend and backend checks passed." -ForegroundColor Green
