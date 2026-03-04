# ============================================
# DASIA Deep Workspace Cleanup Script
# ============================================
# Removes large build artifacts and dependencies
# Estimated cleanup: 2.6+ GB
# Run from: d:\Capstone Main
# ============================================

$ErrorActionPreference = "Stop"
$deletedCount = 0
$deletedSize = 0
$failedCount = 0

Write-Host "`n╔═══════════════════════════════════════════╗" -ForegroundColor Magenta
Write-Host "║  DASIA Deep Workspace Cleanup             ║" -ForegroundColor Magenta
Write-Host "║  Large Artifacts & Dependencies Removal   ║" -ForegroundColor Magenta
Write-Host "╚═══════════════════════════════════════════╝`n" -ForegroundColor Magenta

Write-Host "🔥 WARNING: This removes significant build artifacts" -ForegroundColor Yellow
Write-Host "📊 Estimated space freed: 2.6+ GB" -ForegroundColor Yellow
Write-Host "⏱️  Regeneration requires: cargo build + npm install + npm ci`n" -ForegroundColor Yellow

# Verify we're in the right location
if (-not (Test-Path ".\DasiaAIO-Backend\src\main.rs")) {
    Write-Host "❌ ERROR: Not in correct directory!" -ForegroundColor Red
    Write-Host "   Run this script from: d:\Capstone Main" -ForegroundColor Red
    exit 1
}

function Remove-Directory {
    param($Path, $Description)
    
    if (Test-Path $Path) {
        try {
            # Calculate size before deletion
            $size = (Get-ChildItem -Path $Path -Recurse -ErrorAction SilentlyContinue | Measure-Object -Sum -Property Length).Sum
            $mb = [math]::Round($size / 1MB, 2)
            
            Remove-Item -Path $Path -Recurse -Force -ErrorAction Stop
            Write-Host "   ✅ $Description [$mb MB]" -ForegroundColor Green
            $script:deletedCount++
            $script:deletedSize += $size
        } catch {
            Write-Host "   ❌ FAILED: $Description - $_" -ForegroundColor Red
            $script:failedCount++
        }
    }
}

function Remove-File {
    param($Path, $Description)
    
    if (Test-Path $Path) {
        try {
            Remove-Item -Path $Path -Force -ErrorAction Stop
            Write-Host "   ✅ $Description" -ForegroundColor Green
            $script:deletedCount++
        } catch {
            Write-Host "   ❌ FAILED: $Description - $_" -ForegroundColor Red
            $script:failedCount++
        }
    }
}

# ============================================
# TIER 1: Huge Build Artifacts (2.4+ GB)
# ============================================
Write-Host "🔥 TIER 1: Major Build Artifacts (2.4 GB)" -ForegroundColor Magenta
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

Remove-Directory ".\DasiaAIO-Backend\target" "Rust build cache (target/)"

# ============================================
# TIER 2: npm Dependencies (173 MB)
# ============================================
Write-Host "`n📦 TIER 2: npm Dependencies (173 MB)" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

Remove-Directory ".\DasiaAIO-Frontend\node_modules" "Frontend npm packages"
Remove-Directory ".\DasiaAIO-Backend\node_modules" "Backend npm packages"
Remove-Directory ".\node_modules" "Root npm packages (if any)"

# ============================================
# TIER 3: Build Outputs & Generated Files
# ============================================
Write-Host "`n🏗️  TIER 3: Build Outputs (2.3 MB)" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

Remove-Directory ".\DasiaAIO-Frontend\app-dist" "Frontend build output (app-dist/)"
Remove-Directory ".\DasiaAIO-Frontend\coverage" "Jest coverage reports"

# ============================================
# TIER 4: Unnecessary Config/Setup Files
# ============================================
Write-Host "`n🎯 TIER 4: Unnecessary Setup Files" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

Remove-File ".\DasiaAIO-Frontend\public\electron.js" "Unused Electron setup file"
Remove-Directory ".\DasiaAIO-Frontend\.github\workflows" "GitHub CI/CD workflows"

# ============================================
# FINAL SUMMARY
# ============================================
$gbSaved = [math]::Round($deletedSize / 1GB, 2)
$garbagePercent = [math]::Round(($deletedSize / 2.6GB) * 100, 1)

Write-Host "`n╔═══════════════════════════════════════════╗" -ForegroundColor Magenta
Write-Host "║  🎉 DEEP CLEANUP COMPLETE!               ║" -ForegroundColor Magenta
Write-Host "╚═══════════════════════════════════════════╝" -ForegroundColor Magenta

Write-Host "`n📊 RESULTS:" -ForegroundColor Yellow
Write-Host "   ✅ Items deleted: $deletedCount" -ForegroundColor Green
Write-Host "   📦 Space freed: $gbSaved GB / 2.6 GB (~$garbagePercent%)" -ForegroundColor Cyan
Write-Host "   ⚠️  Items failed:  $failedCount" -ForegroundColor $(if ($failedCount -gt 0) { "Red" } else { "Green" })

Write-Host "`n🔧 REGENERATION COMMANDS:" -ForegroundColor Yellow
Write-Host "   Backend:  cd DasiaAIO-Backend && cargo build --release" -ForegroundColor White
Write-Host "   Frontend: cd DasiaAIO-Frontend && npm ci && npm run build" -ForegroundColor White

Write-Host "`n📝 NEXT STEPS:" -ForegroundColor Cyan
Write-Host "   1. Restart the development servers to verify:" -ForegroundColor White
Write-Host "      - Frontend: npm run dev" -ForegroundColor Gray
Write-Host "      - Backend:  cargo run" -ForegroundColor Gray
Write-Host "   2. Commit cleanup: git add -A && git commit -m 'Deep cleanup'" -ForegroundColor White
Write-Host "   3. Push changes: git push" -ForegroundColor White

Write-Host "`n💾 Workspace is now optimized for source-only distribution!`n" -ForegroundColor Green
