param(
  [ValidateSet("quick", "full")]
  [string]$Mode = "quick",
  [string]$BaseUrl = "http://127.0.0.1:5000",
  [string]$Identifier = "superadmin",
  [string]$Password = "password123",
  [string]$TrackingIdentifier = "supervisor",
  [string]$TrackingPassword = "password123",
  [switch]$SkipFrontendBuild,
  [switch]$SkipBackendCheck,
  [switch]$SkipApiChecks,
  [switch]$RequireApi
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Step([string]$Message) {
  Write-Host ""
  Write-Host "==> $Message" -ForegroundColor Cyan
}

function New-CheckResult([string]$Name, [string]$Status, [string]$Message, [object]$Data, [bool]$Required) {
  return [ordered]@{
    name = $Name
    status = $Status
    passed = ($Status -ne "fail")
    required = $Required
    message = $Message
    data = $Data
    checkedAt = (Get-Date).ToString("o")
  }
}

function Add-Check {
  param(
    [ref]$Checks,
    [string]$Name,
    [bool]$Required = $true,
    [scriptblock]$Action
  )

  try {
    $data = & $Action
    $result = New-CheckResult -Name $Name -Status "pass" -Message "ok" -Data $data -Required $Required
    $Checks.Value += ,$result
    return $result
  } catch {
    if ($Required) {
      $result = New-CheckResult -Name $Name -Status "fail" -Message $_.Exception.Message -Data $null -Required $Required
    } else {
      $result = New-CheckResult -Name $Name -Status "warn" -Message ("optional check failed: " + $_.Exception.Message) -Data $null -Required $Required
    }
    $Checks.Value += ,$result
    return $result
  }
}

function Invoke-JsonPost {
  param(
    [string]$Url,
    [hashtable]$Body,
    [hashtable]$Headers = @{}
  )
  $json = $Body | ConvertTo-Json -Depth 10
  return Invoke-RestMethod -Uri $Url -Method Post -ContentType "application/json" -Body $json -Headers $Headers
}

function Get-TokenFromResponse {
  param([object]$Response)
  if (-not $Response) { return $null }
  $props = $Response.PSObject.Properties
  foreach ($key in @("accessToken", "token", "access_token")) {
    $prop = $props[$key]
    if ($prop -and -not [string]::IsNullOrWhiteSpace([string]$prop.Value)) {
      return [string]$prop.Value
    }
  }
  return $null
}

function Get-CollectionCount {
  param(
    [object]$Object,
    [string[]]$CandidateNames
  )
  if (-not $Object) { return 0 }
  $props = $Object.PSObject.Properties
  foreach ($name in $CandidateNames) {
    $prop = $props[$name]
    if ($prop) {
      return @($prop.Value).Count
    }
  }
  return 0
}

$repoRoot = Split-Path -Parent $PSScriptRoot
$frontendDir = Join-Path $repoRoot "DasiaAIO-Frontend"
$backendDir = Join-Path $repoRoot "DasiaAIO-Backend"
$evidenceDir = Join-Path $repoRoot "docs\plan\capstone-readiness-20260502\evidence"
$jsonReportPath = Join-Path $evidenceDir "latest-readiness-report.json"
$mdReportPath = Join-Path $evidenceDir "latest-readiness-report.md"

if (-not (Test-Path $evidenceDir)) {
  New-Item -ItemType Directory -Force -Path $evidenceDir | Out-Null
}

$checks = @()

Step "Mode: $Mode"

if (-not $SkipFrontendBuild) {
  $null = Add-Check -Checks ([ref]$checks) -Name "frontend_build" -Action {
    Push-Location $frontendDir
    try {
      $null = & npm run build
      if ($LASTEXITCODE -ne 0) {
        throw "npm run build failed with exit code $LASTEXITCODE"
      }
      return @{ command = "npm run build"; directory = $frontendDir }
    } finally {
      Pop-Location
    }
  }
}

if (-not $SkipBackendCheck) {
  $null = Add-Check -Checks ([ref]$checks) -Name "backend_cargo_check" -Action {
    Push-Location $backendDir
    try {
      $null = & cargo check
      if ($LASTEXITCODE -ne 0) {
        throw "cargo check failed with exit code $LASTEXITCODE"
      }
      return @{ command = "cargo check"; directory = $backendDir }
    } finally {
      Pop-Location
    }
  }
}

if ($Mode -eq "full") {
  $null = Add-Check -Checks ([ref]$checks) -Name "backend_cargo_test" -Action {
    Push-Location $backendDir
    try {
      $null = & cargo test
      if ($LASTEXITCODE -ne 0) {
        throw "cargo test failed with exit code $LASTEXITCODE"
      }
      return @{ command = "cargo test"; directory = $backendDir }
    } finally {
      Pop-Location
    }
  }
}

$token = $null
$apiAvailable = $false
if (-not $SkipApiChecks) {
  $apiHealthRequired = $RequireApi.IsPresent
  $healthResult = Add-Check -Checks ([ref]$checks) -Name "api_health" -Required $apiHealthRequired -Action {
    $health = Invoke-RestMethod -Uri "$BaseUrl/api/health" -Method Get
    if (-not $health.status) { throw "health response missing status" }
    return $health
  }

  $apiAvailable = $healthResult.status -eq "pass"
  if ($apiAvailable) {
    $null = Add-Check -Checks ([ref]$checks) -Name "api_login" -Required $apiHealthRequired -Action {
      try {
        $login = Invoke-JsonPost -Url "$BaseUrl/api/login" -Body @{
          identifier = $Identifier
          password = $Password
        }
        $resolvedToken = Get-TokenFromResponse -Response $login
        if (-not $resolvedToken) { throw "No token from /api/login" }
        $script:token = $resolvedToken
        return @{ endpoint = "/api/login"; tokenIssued = $true }
      } catch {
        $login = Invoke-JsonPost -Url "$BaseUrl/api/auth/login" -Body @{
          identifier = $Identifier
          password = $Password
        }
        $resolvedToken = Get-TokenFromResponse -Response $login
        if (-not $resolvedToken) { throw "No token from /api/auth/login" }
        $script:token = $resolvedToken
        return @{ endpoint = "/api/auth/login"; tokenIssued = $true }
      }
    }

    $null = Add-Check -Checks ([ref]$checks) -Name "api_mdr_ops_health" -Required $apiHealthRequired -Action {
      if (-not $token) { throw "Token missing" }
      $headers = @{ Authorization = "Bearer $token" }
      $ops = Invoke-RestMethod -Uri "$BaseUrl/api/mdr/ops-health" -Method Get -Headers $headers
      return $ops
    }

    $null = Add-Check -Checks ([ref]$checks) -Name "api_tracking_map_data" -Required $apiHealthRequired -Action {
      if (-not $token) { throw "Token missing" }
      $headers = @{ Authorization = "Bearer $token" }
      $map = Invoke-RestMethod -Uri "$BaseUrl/api/tracking/map-data" -Method Get -Headers $headers
      return @{
        trackingPoints = Get-CollectionCount -Object $map -CandidateNames @("trackingPoints", "tracking_points")
        clientSites = Get-CollectionCount -Object $map -CandidateNames @("clientSites", "client_sites")
        activeTrips = Get-CollectionCount -Object $map -CandidateNames @("activeTrips", "active_trips")
      }
    }
  } else {
    $checks += ,(New-CheckResult -Name "api_login" -Status "warn" -Message "optional check skipped: API unavailable" -Data $null -Required $false)
    $checks += ,(New-CheckResult -Name "api_mdr_ops_health" -Status "warn" -Message "optional check skipped: API unavailable" -Data $null -Required $false)
    $checks += ,(New-CheckResult -Name "api_tracking_map_data" -Status "warn" -Message "optional check skipped: API unavailable" -Data $null -Required $false)
  }
}

if ($Mode -eq "full" -and -not $SkipApiChecks) {
  if ($apiAvailable) {
    $null = Add-Check -Checks ([ref]$checks) -Name "tracking_smoke_script" -Required $apiHealthRequired -Action {
      & powershell -ExecutionPolicy Bypass -File (Join-Path $repoRoot "scripts\tracking_smoke_test.ps1") -BaseUrl $BaseUrl -Identifier $TrackingIdentifier -Password $TrackingPassword
      if ($LASTEXITCODE -ne 0) {
        throw "tracking_smoke_test.ps1 failed with exit code $LASTEXITCODE"
      }
      return @{
        command = "tracking_smoke_test.ps1"
        baseUrl = $BaseUrl
        trackingIdentifier = $TrackingIdentifier
      }
    }
  } else {
    $checks += ,(New-CheckResult -Name "tracking_smoke_script" -Status "warn" -Message "optional check skipped: API unavailable" -Data $null -Required $false)
  }
}

$passed = @($checks | Where-Object { $_.status -eq "pass" }).Count
$warnings = @($checks | Where-Object { $_.status -eq "warn" }).Count
$failed = @($checks | Where-Object { $_.status -eq "fail" }).Count

$report = [ordered]@{
  checkedAt = (Get-Date).ToString("o")
  mode = $Mode
  baseUrl = $BaseUrl
  summary = @{
    total = @($checks).Count
    passed = $passed
    warnings = $warnings
    failed = $failed
    status = if ($failed -eq 0) { "PASS" } else { "FAIL" }
  }
  checks = $checks
}

$report | ConvertTo-Json -Depth 10 | Set-Content -Path $jsonReportPath

$lines = @()
$lines += "# Capstone Readiness Report"
$lines += ""
$lines += "- Checked At: $($report.checkedAt)"
$lines += "- Mode: $($report.mode)"
$lines += "- Base URL: $($report.baseUrl)"
$lines += "- Overall: $($report.summary.status) (passed: $passed, warnings: $warnings, failed: $failed)"
$lines += ""
$lines += "| Check | Result | Message |"
$lines += "|---|---|---|"
foreach ($check in $checks) {
  $result = $check.status.ToUpperInvariant()
  $msg = ($check.message -replace "\|", "/")
  $lines += "| $($check.name) | $result | $msg |"
}
$lines -join "`r`n" | Set-Content -Path $mdReportPath

Step "Readiness report generated"
Write-Host $jsonReportPath -ForegroundColor Green
Write-Host $mdReportPath -ForegroundColor Green

if ($failed -gt 0) {
  exit 1
}
