# ============================================
# DASIA System - Workspace Debloat Script
# ============================================
# This script safely deletes 54 unnecessary files
# Run this from: d:\Capstone Main
# ============================================

$ErrorActionPreference = "Stop"
$deletedCount = 0
$failedCount = 0

Write-Host "`n╔════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  DASIA Workspace Cleanup & Debloat        ║" -ForegroundColor Cyan
Write-Host "║  Safe Deletion Script                      ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════╝`n" -ForegroundColor Cyan

Write-Host "📋 Files to be deleted: 54" -ForegroundColor Yellow
Write-Host "📊 Estimated space saved: ~1-2 MB`n" -ForegroundColor Yellow

# Verify we're in the right location
if (-not (Test-Path ".\DasiaAIO-Backend\src\main.rs")) {
    Write-Host "❌ ERROR: Not in correct directory!" -ForegroundColor Red
    Write-Host "   Run this script from: d:\Capstone Main" -ForegroundColor Red
    exit 1
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
# SECTION 1: Capstone Options (1-4)
# ============================================
Write-Host "🗂️  SECTION 1: Capstone Options (Delete 1-4, Keep 5)" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

Remove-File ".\Capstone_Option_1_Guard_Management.md" "Capstone Option 1"
Remove-File ".\Capstone_Option_2_Equipment_Management.md" "Capstone Option 2"
Remove-File ".\Capstone_Option_3_Authentication_AccessControl.md" "Capstone Option 3"
Remove-File ".\Capstone_Option_4_Integrated_Security_Operations.md" "Capstone Option 4"
Remove-File ".\Capstone_Option_5_DASIA_Implemented_System_INTRO_FINAL.md" "Capstone Option 5 (Draft)"

# ============================================
# SECTION 2: Debug Output Files
# ============================================
Write-Host "`n📝 SECTION 2: Debug & Temporary Output (7 files)" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

Remove-File ".\creation_result.txt" "creation_result.txt"
Remove-File ".\debug_result.json" "debug_result.json"
Remove-File ".\user_creation_output.txt" "user_creation_output.txt"
Remove-File ".\user_creation.txt" "user_creation.txt"
Remove-File ".\user_output.txt" "user_output.txt"
Remove-File ".\user_result.txt" "user_result.txt"
Remove-File ".\npm_install.txt" "npm_install.txt"
Remove-File ".\npm_local_install.txt" "npm_local_install.txt"

# ============================================
# SECTION 3: Historical Documentation
# ============================================
Write-Host "`n📚 SECTION 3: Historical Docs (13 files)" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

Remove-File ".\CHECK_IN_OUT_FLOW_TEST.md" "CHECK_IN_OUT_FLOW_TEST.md"
Remove-File ".\QUICK_FIX_GUIDE.md" "QUICK_FIX_GUIDE.md"
Remove-File ".\QUICK_REFERENCE.md" "QUICK_REFERENCE.md"
Remove-File ".\TEST_RESULTS_FINAL.md" "TEST_RESULTS_FINAL.md"
Remove-File ".\SIMULATION_RESULTS.md" "SIMULATION_RESULTS.md"
Remove-File ".\PARAMETER_CONTRACTS.md" "PARAMETER_CONTRACTS.md"
Remove-File ".\Academic_Citations_Guide.md" "Academic_Citations_Guide.md"
Remove-File ".\ERGONOMIC_REFACTOR_SUMMARY.md" "ERGONOMIC_REFACTOR_SUMMARY.md"
Remove-File ".\AUDIT_EXECUTIVE_SUMMARY.md" "AUDIT_EXECUTIVE_SUMMARY.md"
Remove-File ".\API_AUDIT_REPORT.md" "API_AUDIT_REPORT.md"
Remove-File ".\AUDIT_SUMMARY_AND_GEMINI_DOCS.md" "AUDIT_SUMMARY_AND_GEMINI_DOCS.md"
Remove-File ".\DasiaAIO-Frontend\THEME_FIX_SUMMARY.md" "DasiaAIO-Frontend/THEME_FIX_SUMMARY.md"
Remove-File ".\DasiaAIO-Frontend\THEME_IMPLEMENTATION_GUIDE.md" "DasiaAIO-Frontend/THEME_IMPLEMENTATION_GUIDE.md"

# ============================================
# SECTION 4: Gemini Development Aids
# ============================================
Write-Host "`n🤖 SECTION 4: Gemini Development Scripts (4 files)" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

Remove-File ".\GEMINI_PROMPT_TEMPLATE.md" "GEMINI_PROMPT_TEMPLATE.md"
Remove-File ".\GEMINI_QUICK_REFERENCE.md" "GEMINI_QUICK_REFERENCE.md"
Remove-File ".\GEMINI_SYSTEM_CONTEXT_PROMPT.md" "GEMINI_SYSTEM_CONTEXT_PROMPT.md"
Remove-File ".\GEMINI_SYSTEM_REFERENCE_THEME_SYSTEM.md" "GEMINI_SYSTEM_REFERENCE_THEME_SYSTEM.md"

# ============================================
# SECTION 5: Backend Database Cleanup Scripts
# ============================================
Write-Host "`n🗄️  SECTION 5: DB Cleanup Scripts (9 files)" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

Remove-File ".\DasiaAIO-Backend\cleanup_corrupted_users.sql" "DasiaAIO-Backend/cleanup_corrupted_users.sql"
Remove-File ".\DasiaAIO-Backend\cleanup_direct.js" "DasiaAIO-Backend/cleanup_direct.js"
Remove-File ".\DasiaAIO-Backend\cleanup_simple.js" "DasiaAIO-Backend/cleanup_simple.js"
Remove-File ".\DasiaAIO-Backend\cleanup_users.js" "DasiaAIO-Backend/cleanup_users.js"
Remove-File ".\DasiaAIO-Backend\cleanup_users.sql" "DasiaAIO-Backend/cleanup_users.sql"
Remove-File ".\DasiaAIO-Backend\fix_password_hashes.sql" "DasiaAIO-Backend/fix_password_hashes.sql"
Remove-File ".\DasiaAIO-Backend\fix_passwords.js" "DasiaAIO-Backend/fix_passwords.js"
Remove-File ".\DasiaAIO-Backend\fix_user_password.sql" "DasiaAIO-Backend/fix_user_password.sql"
Remove-File ".\DasiaAIO-Backend\generate_hash.js" "DasiaAIO-Backend/generate_hash.js"

# ============================================
# SECTION 6: Old Seed/Setup Database Scripts
# ============================================
Write-Host "`n🌱 SECTION 6: Old Seed/Setup Scripts (6 files)" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

Remove-File ".\DasiaAIO-Backend\add_profile_photo.sql" "DasiaAIO-Backend/add_profile_photo.sql"
Remove-File ".\DasiaAIO-Backend\restore_accounts.sql" "DasiaAIO-Backend/restore_accounts.sql"
Remove-File ".\DasiaAIO-Backend\setup_credentials.sql" "DasiaAIO-Backend/setup_credentials.sql"
Remove-File ".\DasiaAIO-Backend\seed_existing_tables.sql" "DasiaAIO-Backend/seed_existing_tables.sql"
Remove-File ".\DasiaAIO-Backend\seed_guards.sql" "DasiaAIO-Backend/seed_guards.sql"
Remove-File ".\DasiaAIO-Backend\seed_users.sql" "DasiaAIO-Backend/seed_users.sql"
Remove-File ".\DasiaAIO-Backend\seed_dashboard.sql" "DasiaAIO-Backend/seed_dashboard.sql"

# ============================================
# SECTION 7: Old Test Scripts
# ============================================
Write-Host "`n🧪 SECTION 7: Old Test Scripts (9 files)" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

Remove-File ".\test-admin.ps1" "test-admin.ps1"
Remove-File ".\test-firearm-auth.ps1" "test-firearm-auth.ps1"
Remove-File ".\test-notification-system.ps1" "test-notification-system.ps1"
Remove-File ".\test-simple.ps1" "test-simple.ps1"
Remove-File ".\test-user.ps1" "test-user.ps1"
Remove-File ".\DasiaAIO-Backend\test-calendar.ps1" "DasiaAIO-Backend/test-calendar.ps1"
Remove-File ".\DasiaAIO-Backend\test-daily-operations.ps1" "DasiaAIO-Backend/test-daily-operations.ps1"
Remove-File ".\DasiaAIO-Backend\test-merit.ps1" "DasiaAIO-Backend/test-merit.ps1"
Remove-File ".\DasiaAIO-Backend\test_connection.js" "DasiaAIO-Backend/test_connection.js"

# ============================================
# SECTION 8: Miscellaneous Files
# ============================================
Write-Host "`n🎯 SECTION 8: Miscellaneous (3 files)" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

Remove-File ".\start-local.ps1" "start-local.ps1"
Remove-File ".\Group5-InkRewards.pdf" "Group5-InkRewards.pdf"
Remove-File ".\SENTINEL_Logo_Design_Specification.md" "SENTINEL_Logo_Design_Specification.md"

# ============================================
# FINAL SUMMARY
# ============================================
Write-Host "`n╔════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  🎉 CLEANUP COMPLETE!                     ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Cyan

Write-Host "`n📊 RESULTS:" -ForegroundColor Yellow
Write-Host "   ✅ Files deleted: $deletedCount" -ForegroundColor Green
Write-Host "   ⚠️  Files failed:  $failedCount" -ForegroundColor $(if ($failedCount -gt 0) { "Red" } else { "Green" })

Write-Host "`n📝 KEPT CONSCIOUSLY:" -ForegroundColor Cyan
Write-Host "   ✅ Capstone_Option_5_DASIA_Implemented_System.md" -ForegroundColor Green
Write-Host "   ✅ SENTINEL_Logo.svg & SENTINEL_Logo_HighRes.svg" -ForegroundColor Green
Write-Host "   ✅ LICENSE file" -ForegroundColor Green
Write-Host "   ✅ !startlocalhost.txt (startup instructions)" -ForegroundColor Green
Write-Host "   ✅ All source code (src/, frontend/, etc.)" -ForegroundColor Green
Write-Host "   ✅ All config files (Cargo.toml, package.json, etc.)" -ForegroundColor Green

Write-Host "`n🚀 NEXT STEPS:" -ForegroundColor Cyan
Write-Host "   1. Verify the system still works: npm run dev (frontend)" -ForegroundColor White
Write-Host "   2. Verify backend: cargo run (backend)" -ForegroundColor White
Write-Host "   3. Commit changes to git: git add -A && git commit -m 'Workspace cleanup'" -ForegroundColor White
Write-Host "   4. Push to repository: git push" -ForegroundColor White

Write-Host "`n💾 Estimated space saved: ~1-2 MB" -ForegroundColor Yellow
Write-Host "⏱️  Cleanup duration: $(if ($failedCount -eq 0) { 'Successful!' } else { 'Completed with warnings' })`n" -ForegroundColor Cyan
