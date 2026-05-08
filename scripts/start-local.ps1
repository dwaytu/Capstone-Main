param(
  [switch]$SkipInstall
)

$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$backendDir = Join-Path $repoRoot 'DasiaAIO-Backend'
$frontendDir = Join-Path $repoRoot 'DasiaAIO-Frontend'

if (!(Test-Path $backendDir)) {
  throw "Backend folder not found: $backendDir"
}

if (!(Test-Path $frontendDir)) {
  throw "Frontend folder not found: $frontendDir"
}

function Test-PortListening {
  param(
    [Parameter(Mandatory = $true)]
    [int]$Port
  )

  $matches = netstat -ano | Select-String -Pattern ":$Port\s+.*LISTENING"
  return ($null -ne $matches -and $matches.Count -gt 0)
}

$backendEnv = Join-Path $backendDir '.env'
$backendEnvExample = Join-Path $backendDir '.env.example'
if (!(Test-Path $backendEnv) -and (Test-Path $backendEnvExample)) {
  Copy-Item $backendEnvExample $backendEnv
}

if (Test-Path $backendEnv) {
  $backendEnvContent = Get-Content -Raw $backendEnv
  $adminCodeMatch = [regex]::Match($backendEnvContent, '(?m)^ADMIN_CODE=(.*)$')
  $adminCodeValue = if ($adminCodeMatch.Success) { $adminCodeMatch.Groups[1].Value.Trim() } else { '' }
  $databaseUrlMatch = [regex]::Match($backendEnvContent, '(?m)^DATABASE_URL=(.*)$')
  $databaseUrlValue = if ($databaseUrlMatch.Success) { $databaseUrlMatch.Groups[1].Value.Trim() } else { '' }

  if ([string]::IsNullOrWhiteSpace($adminCodeValue) -or $adminCodeValue -eq '122601') {
    $newAdminCode = "LOCAL-" + (Get-Random -Minimum 100000 -Maximum 999999)
    if ($adminCodeMatch.Success) {
      $backendEnvContent = [regex]::Replace($backendEnvContent, '(?m)^ADMIN_CODE=.*$', "ADMIN_CODE=$newAdminCode")
    } else {
      if (-not $backendEnvContent.EndsWith("`n")) {
        $backendEnvContent += "`r`n"
      }
      $backendEnvContent += "ADMIN_CODE=$newAdminCode`r`n"
    }
    Set-Content -Path $backendEnv -Value $backendEnvContent -NoNewline
    Write-Host "Updated backend .env ADMIN_CODE to a safe local value: $newAdminCode"
  }

  if ($databaseUrlValue -eq 'postgresql://postgres:password@localhost:5432/guard_firearm_system') {
    $backendEnvContent = [regex]::Replace(
      $backendEnvContent,
      '(?m)^DATABASE_URL=.*$',
      'DATABASE_URL=postgresql://postgres:postgres@localhost:5432/guard_firearm_system'
    )
    Set-Content -Path $backendEnv -Value $backendEnvContent -NoNewline
    Write-Host 'Updated backend .env DATABASE_URL to match local docker-compose Postgres credentials.'
  }
}

$frontendEnvLocal = Join-Path $frontendDir '.env.local'
if (!(Test-Path $frontendEnvLocal)) {
  Set-Content -Path $frontendEnvLocal -Value "VITE_API_BASE_URL=http://localhost:5000`r`n"
}

$backendCmd = @(
  "Set-Location -LiteralPath '$backendDir'"
  "if (!(Test-Path '.env') -and (Test-Path '.env.example')) { Copy-Item '.env.example' '.env' }"
  "cargo run --bin server"
) -join '; '

$frontendCmdParts = @(
  "Set-Location -LiteralPath '$frontendDir'"
  "if (!(Test-Path '.env.local')) { Set-Content -Path '.env.local' -Value 'VITE_API_BASE_URL=http://localhost:5000`r`n' }"
)

if (-not $SkipInstall) {
  $frontendCmdParts += "if (!(Test-Path 'node_modules')) { npm install }"
}

$frontendCmdParts += "npm run dev"
$frontendCmd = $frontendCmdParts -join '; '

if (Test-PortListening -Port 5000) {
  Write-Host "Backend already listening on port 5000. Skipping duplicate backend launch."
} else {
  Start-Process -FilePath "powershell" -WorkingDirectory $backendDir -ArgumentList @("-NoExit", "-ExecutionPolicy", "Bypass", "-Command", $backendCmd)
}

if (Test-PortListening -Port 5173) {
  Write-Host "Frontend already listening on port 5173. Skipping duplicate frontend launch."
} else {
  Start-Process -FilePath "powershell" -WorkingDirectory $frontendDir -ArgumentList @("-NoExit", "-ExecutionPolicy", "Bypass", "-Command", $frontendCmd)
}

Write-Host "Started backend and frontend in separate terminals."
Write-Host "Frontend URL: http://localhost:5173"
Write-Host "Backend health: http://localhost:5000/api/health"
