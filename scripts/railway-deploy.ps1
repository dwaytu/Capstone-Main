param(
  [ValidateSet("backend", "frontend", "both")]
  [string]$Target = "both",

  [string]$ProjectId = $env:RAILWAY_PROJECT_ID,
  [string]$Environment = $env:RAILWAY_ENVIRONMENT,
  [string]$BackendService = $env:RAILWAY_BACKEND_SERVICE,
  [string]$FrontendService = $env:RAILWAY_FRONTEND_SERVICE
)

$ErrorActionPreference = "Stop"

if (-not [string]::IsNullOrWhiteSpace($env:RAILWAY_TOKEN) -and -not [string]::IsNullOrWhiteSpace($env:RAILWAY_API_TOKEN)) {
  throw "Set only one Railway token: RAILWAY_TOKEN or RAILWAY_API_TOKEN."
}

$RailwayToken = if (-not [string]::IsNullOrWhiteSpace($env:RAILWAY_TOKEN)) {
  $env:RAILWAY_TOKEN
} else {
  $env:RAILWAY_API_TOKEN
}

function Require-Value {
  param(
    [string]$Name,
    [string]$Value
  )
  if ([string]::IsNullOrWhiteSpace($Value)) {
    throw "Missing required value: $Name"
  }
}

Require-Value -Name "RAILWAY_TOKEN or RAILWAY_API_TOKEN" -Value $RailwayToken
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
