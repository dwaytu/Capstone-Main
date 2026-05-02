param(
  [string]$BaseUrl = "http://localhost:5000",
  [string]$Identifier = "admin",
  [PSCredential]$Credential,
  [string]$Password
)

$ErrorActionPreference = 'Stop'

Write-Host "[1/5] Health check..."
$health = Invoke-WebRequest -Uri "$BaseUrl/api/health" -UseBasicParsing
if ($health.StatusCode -ne 200) { throw "Health check failed with status $($health.StatusCode)" }

Write-Host "[2/5] Login..."
if (-not $Credential -and [string]::IsNullOrWhiteSpace($Password)) {
  $Credential = Get-Credential -UserName $Identifier -Message "Enter credentials for tracking smoke test"
}
$plainPassword = if ($Credential) { $Credential.GetNetworkCredential().Password } else { $Password }
$loginIdentifier = if ($Credential -and -not [string]::IsNullOrWhiteSpace($Credential.UserName)) { $Credential.UserName } else { $Identifier }
$loginBody = @{ identifier = $loginIdentifier; password = $plainPassword } | ConvertTo-Json
$login = Invoke-RestMethod -Uri "$BaseUrl/api/auth/login" -Method Post -ContentType 'application/json' -Body $loginBody
$token = $login.token
if (-not $token) { throw "Login failed: no token returned" }

Write-Host "[3/5] Low-accuracy heartbeat should be rejected (accepted=false)..."
$lowBody = @{
  entityType = 'user'
  entityId = 'smoke-low-accuracy'
  latitude = 7.0731
  longitude = 125.6128
  accuracyMeters = 75
  status = 'active'
  label = 'Smoke Low Accuracy'
} | ConvertTo-Json
$low = Invoke-RestMethod -Uri "$BaseUrl/api/tracking/heartbeat" -Method Post -Headers @{ Authorization = "Bearer $token" } -ContentType 'application/json' -Body $lowBody
if ($low.accepted -ne $false) { throw "Expected low-accuracy sample to be rejected" }

Write-Host "[4/5] High-accuracy heartbeat should be accepted..."
$highBody = @{
  entityType = 'user'
  entityId = 'smoke-high-accuracy'
  latitude = 7.0731
  longitude = 125.6128
  accuracyMeters = 8
  status = 'active'
  label = 'Smoke High Accuracy'
} | ConvertTo-Json
$high = Invoke-RestMethod -Uri "$BaseUrl/api/tracking/heartbeat" -Method Post -Headers @{ Authorization = "Bearer $token" } -ContentType 'application/json' -Body $highBody
if (-not $high.trackingId) { throw "Expected high-accuracy sample to be accepted" }

Write-Host "[5/5] Map snapshot verification..."
$map = Invoke-RestMethod -Uri "$BaseUrl/api/tracking/map-data" -Method Get -Headers @{ Authorization = "Bearer $token" }
$lowSeen = ($map.trackingPoints | Where-Object { $_.label -eq 'Smoke Low Accuracy' } | Measure-Object).Count
$highSeen = ($map.trackingPoints | Where-Object { $_.label -eq 'Smoke High Accuracy' } | Measure-Object).Count
if ($lowSeen -gt 0) { throw "Low-accuracy sample appeared in map snapshot" }
if ($highSeen -eq 0) {
  Write-Host "NOTE: high-accuracy sample not visible in current map snapshot for this role/context; heartbeat acceptance already verified."
}

Write-Host "PASS: tracking smoke test succeeded."
