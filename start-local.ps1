Param(
    [switch]$Frontend,
    [switch]$Backend,
    [switch]$Install
)

if (-not ($Frontend -or $Backend)) { $Frontend = $true }

$root = Split-Path -Parent $MyInvocation.MyCommand.Definition
$frontendDir = Join-Path $root "DasiaAIO-Frontend"
$backendDir = Join-Path $root "DasiaAIO-Backend"

function Test-CommandExists {
    param([string]$cmd)
    $null -ne (Get-Command $cmd -ErrorAction SilentlyContinue)
}

Write-Host "Workspace root: $root"

if ($Install -and $Frontend) {
    if (-not (Test-CommandExists npm)) {
        Write-Error "npm not found in PATH. Install Node.js (includes npm) first."; exit 1
    }
    Write-Host "Installing frontend dependencies..."
    Push-Location $frontendDir
    if (Test-Path package-lock.json) { npm ci } else { npm install }
    Pop-Location
}

if ($Frontend) {
    if (-not (Test-CommandExists npm)) {
        Write-Error "npm not found in PATH. Install Node.js (includes npm) first."; exit 1
    }
    $cmd = "npm run dev"
    Start-Process -FilePath "powershell.exe" -ArgumentList '-NoExit','-Command', "Set-Location -LiteralPath '$frontendDir'; $cmd" -WorkingDirectory $frontendDir
    Write-Host "Frontend: started in new PowerShell window (folder: $frontendDir)."
    Write-Host "Open http://localhost:5173 in your browser (default Vite port)."
}

if ($Backend) {
    if (-not (Test-CommandExists cargo)) {
        Write-Warning "cargo not found in PATH. Install Rust if you want to run the backend.";
    }
    Start-Process -FilePath "powershell.exe" -ArgumentList '-NoExit','-Command', "Set-Location -LiteralPath '$backendDir'; cargo run" -WorkingDirectory $backendDir
    Write-Host "Backend: started in new PowerShell window (folder: $backendDir)."
    Write-Host "Backend API default: http://localhost:5000"
}

Write-Host "Done. Use Ctrl+C in each PowerShell window to stop the servers." 
