param(
  [ValidateSet("backend", "frontend", "both")]
  [string]$Target = "both",

  [string]$ProjectId = $env:RAILWAY_PROJECT_ID,
  [string]$Environment = $env:RAILWAY_ENVIRONMENT,
  [string]$BackendService = $env:RAILWAY_BACKEND_SERVICE,
  [string]$FrontendService = $env:RAILWAY_FRONTEND_SERVICE
)

$ErrorActionPreference = "Stop"

function Require-Value {
  param(
    [string]$Name,
    [string]$Value
  )
  if ([string]::IsNullOrWhiteSpace($Value)) {
    throw "Missing required value: $Name"
  }
}

Require-Value -Name "RAILWAY_TOKEN" -Value $env:RAILWAY_TOKEN
Require-Value -Name "RAILWAY_PROJECT_ID" -Value $ProjectId
Require-Value -Name "RAILWAY_ENVIRONMENT" -Value $Environment

if ($Target -in @("backend", "both")) {
  Require-Value -Name "RAILWAY_BACKEND_SERVICE" -Value $BackendService
}

if ($Target -in @("frontend", "both")) {
  Require-Value -Name "RAILWAY_FRONTEND_SERVICE" -Value $FrontendService
}

Write-Host "Railway CLI version:"
railway --version

if ($Target -in @("backend", "both")) {
  Write-Host "Deploying backend to Railway..."
  railway up DasiaAIO-Backend --path-as-root --ci --project $ProjectId --environment $Environment --service $BackendService
}

if ($Target -in @("frontend", "both")) {
  Write-Host "Deploying frontend to Railway..."
  railway up DasiaAIO-Frontend --path-as-root --ci --project $ProjectId --environment $Environment --service $FrontendService
}

Write-Host "Railway deploy script completed."
