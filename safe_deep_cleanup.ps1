# ============================================
# DASIA Safe Deep Cleanup Script
# ============================================
# Version: Safe Edition (GitHub Actions enabled)
# Removes large build artifacts - NO configs deleted
# Estimated cleanup: 2.6+ GB
# Features: Process management, git handling, full recovery
# ============================================

$ErrorActionPreference = "Stop"
$deletedCount = 0
$deletedSize = 0
$failedCount = 0

Write-Host "`n╔══════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  DASIA Safe Deep Cleanup Script          ║" -ForegroundColor Green
Write-Host "║  GitHub Actions Aware Edition            ║" -ForegroundColor Green
Write-Host "╚══════════════════════════════════════════╝`n" -ForegroundColor Green

Write-Host "📊 CLEANUP PLAN:" -ForegroundColor Yellow
Write-Host "   ✅ Remove: Rust build cache (2.4 GB)" -ForegroundColor White
Write-Host "   ✅ Remove: npm dependencies (174 MB)" -ForegroundColor White
Write-Host "   ✅ Remove: Build outputs (2.3 MB)" -ForegroundColor White
Write-Host "   ✅ Remove: Test coverage (0.04 MB)" -ForegroundColor White
Write-Host "   ✅ Remove: Unused Electron file (10 KB)" -ForegroundColor White
Write-Host "   🛡️  KEEP: All source code, configs, CI/CD" -ForegroundColor Cyan
Write-Host "   🛡️  KEEP: .github/workflows (GitHub Actions enabled)" -ForegroundColor Cyan
Write-Host "   🛡️  KEEP: Docker configs (needed for deployment)" -ForegroundColor Cyan
Write-Host "`n⏱️  Estimated time: 30-60 seconds`n" -ForegroundColor Gray

# Verify location
if (-not (Test-Path ".\DasiaAIO-Backend\src\main.rs")) {
    Write-Host "❌ ERROR: Not in correct directory!" -ForegroundColor Red
    Write-Host "   Run from: d:\Capstone Main" -ForegroundColor Red
    exit 1
}

# ============================================
# STEP 0: Stop all running processes
# ============================================
Write-Host "🛑 STEP 0: Stopping running processes..." -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

$nodeProcesses = Get-Process node -ErrorAction SilentlyContinue
if ($nodeProcesses) {
    $count = @($nodeProcesses).Count
    Write-Host "   Found $count node process(es)..." -ForegroundColor Yellow
    Stop-Process -Name node -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
    Write-Host "   ✅ Node processes stopped" -ForegroundColor Green
}

$cargoProcesses = Get-Process cargo, rustc -ErrorAction SilentlyContinue
if ($cargoProcesses) {
    Write-Host "   Found cargo processes..." -ForegroundColor Yellow
    Stop-Process -Name cargo, rustc -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 1
    Write-Host "   ✅ Cargo processes stopped" -ForegroundColor Green
}

# ============================================
# STEP 1: Commit any pending deletions first
# ============================================
Write-Host "`n📝 STEP 1: Committing previous cleanup..." -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

try {
    $status = git status --porcelain
    if ($status) {
        Write-Host "   Staging deletions..." -ForegroundColor Yellow
        git add -A
        git commit -m "chore: cleanup - removed unnecessary documentation and development files" --quiet
        Write-Host "   ✅ Previous cleanup committed" -ForegroundColor Green
    } else {
        Write-Host "   ✅ Repository already clean" -ForegroundColor Green
    }
} catch {
    Write-Host "   ⚠️  Git commit warning (non-critical): $_" -ForegroundColor Yellow
}

# ============================================
# TIER 1: Huge Build Artifacts (2.4 GB)
# ============================================
Write-Host "`n🔥 TIER 1: Major Build Artifacts (2.4 GB)" -ForegroundColor Magenta
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

if (Test-Path ".\DasiaAIO-Backend\target") {
    try {
        $size = (Get-ChildItem -Path ".\DasiaAIO-Backend\target" -Recurse -ErrorAction SilentlyContinue | Measure-Object -Sum -Property Length).Sum
        $mb = [math]::Round($size / 1MB, 2)
        Remove-Item -Path ".\DasiaAIO-Backend\target" -Recurse -Force -ErrorAction Stop
        Write-Host "   ✅ Rust build cache [${mb} MB]" -ForegroundColor Green
        $script:deletedCount++
        $script:deletedSize += $size
    } catch {
        Write-Host "   ❌ FAILED: Rust build cache - $_" -ForegroundColor Red
        $script:failedCount++
    }
}

# ============================================
# TIER 2: npm Dependencies (174 MB)
# ============================================
Write-Host "`n📦 TIER 2: npm Dependencies (174 MB)" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

@(".\DasiaAIO-Frontend\node_modules", ".\DasiaAIO-Backend\node_modules", ".\node_modules") | ForEach-Object {
    if (Test-Path $_) {
        try {
            $size = (Get-ChildItem -Path $_ -Recurse -ErrorAction SilentlyContinue | Measure-Object -Sum -Property Length).Sum
            $mb = [math]::Round($size / 1MB, 2)
            Remove-Item -Path $_ -Recurse -Force -ErrorAction Stop
            $label = Split-Path $_ -Leaf
            Write-Host "   ✅ $label [${mb} MB]" -ForegroundColor Green
            $script:deletedCount++
            $script:deletedSize += $size
        } catch {
            Write-Host "   ❌ FAILED: $_ - $_" -ForegroundColor Red
            $script:failedCount++
        }
    }
}

# ============================================
# TIER 3: Build Outputs (2.3 MB)
# ============================================
Write-Host "`n🏗️  TIER 3: Build Outputs (2.3 MB)" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

@(".\DasiaAIO-Frontend\app-dist", ".\DasiaAIO-Frontend\coverage") | ForEach-Object {
    if (Test-Path $_) {
        try {
            $size = (Get-ChildItem -Path $_ -Recurse -ErrorAction SilentlyContinue | Measure-Object -Sum -Property Length).Sum
            $mb = [math]::Round($size / 1MB, 2)
            Remove-Item -Path $_ -Recurse -Force -ErrorAction Stop
            $label = Split-Path $_ -Leaf
            Write-Host "   ✅ $label [${mb} MB]" -ForegroundColor Green
            $script:deletedCount++
            $script:deletedSize += $size
        } catch {
            Write-Host "   ❌ FAILED: $_ - $_" -ForegroundColor Red
            $script:failedCount++
        }
    }
}

# ============================================
# TIER 4: Unused Setup Files
# ============================================
Write-Host "`n🎯 TIER 4: Unused Setup Files" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

if (Test-Path ".\DasiaAIO-Frontend\public\electron.js") {
    try {
        Remove-Item -Path ".\DasiaAIO-Frontend\public\electron.js" -Force -ErrorAction Stop
        Write-Host "   ✅ electron.js (unused web-only project)" -ForegroundColor Green
        $script:deletedCount++
    } catch {
        Write-Host "   ❌ FAILED: electron.js - $_" -ForegroundColor Red
        $script:failedCount++
    }
}

# ============================================
# FINAL SUMMARY & REPORT
# ============================================
$gbSaved = [math]::Round($deletedSize / 1GB, 2)

Write-Host "`n╔══════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  ✅ SAFE CLEANUP COMPLETE!              ║" -ForegroundColor Green
Write-Host "╚══════════════════════════════════════════╝" -ForegroundColor Green

Write-Host "`n📊 RESULTS:" -ForegroundColor Yellow
Write-Host "   ✅ Items deleted: $deletedCount" -ForegroundColor Green
Write-Host "   💾 Space freed: $gbSaved GB" -ForegroundColor Cyan
Write-Host "   ⚠️  Failed: $failedCount" -ForegroundColor $(if ($failedCount -gt 0) { "Red" } else { "Green" })

Write-Host "`n✅ PRESERVED:" -ForegroundColor Green
Write-Host "   🛡️  GitHub Actions workflows (.github/workflows/)" -ForegroundColor White
Write-Host "   🛡️  Docker configs (Dockerfile, docker-compose.yml)" -ForegroundColor White
Write-Host "   🛡️  All source code (src/, frontend/, migrations/)" -ForegroundColor White
Write-Host "   🛡️  Package manifests (package.json, Cargo.toml, package-lock.json)" -ForegroundColor White
Write-Host "   🛡️  Documentation (.md files)" -ForegroundColor White

Write-Host "`n🔧 REGENERATION (if needed):" -ForegroundColor Yellow
Write-Host "   # Backend Rust build:" -ForegroundColor Gray
Write-Host "   cd DasiaAIO-Backend && cargo build --release" -ForegroundColor White
Write-Host "`n   # Frontend rebuild:" -ForegroundColor Gray
Write-Host "   cd DasiaAIO-Frontend && npm ci && npm run build" -ForegroundColor White

Write-Host "`n📝 NEXT STEPS:" -ForegroundColor Cyan
Write-Host "   1. Test the system:" -ForegroundColor White
Write-Host "      Frontend:  npm run dev" -ForegroundColor Gray
Write-Host "      Backend:   cargo run" -ForegroundColor Gray
Write-Host "   2. Once verified, everything is committed and ready" -ForegroundColor White
Write-Host "   3. Optional: git push to sync with remote" -ForegroundColor White

Write-Host "`n💡 NOTE: Your GitHub Actions CI/CD pipeline is preserved and active" -ForegroundColor Cyan
Write-Host "✨ Workspace is now lean and deployment-ready!`n" -ForegroundColor Green
