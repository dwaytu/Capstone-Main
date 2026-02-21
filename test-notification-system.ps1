# Simulation script for automated guard replacement notification system
# This script tests the complete workflow

$API_BASE = "http://localhost:5000"
$ErrorActionPreference = "Continue"

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  GUARD REPLACEMENT SYSTEM SIMULATION" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Step 1: Get list of users
Write-Host "[1] Fetching users from database..." -ForegroundColor Yellow
try {
    $users = Invoke-RestMethod -Uri "$API_BASE/api/users" -Method GET
    Write-Host "   ✓ Found $($users.Count) users" -ForegroundColor Green
    
    if ($users.Count -lt 2) {
        Write-Host "   ✗ Need at least 2 users for simulation. Please register more users." -ForegroundColor Red
        exit 1
    }
    
    # Pick two different users - one for original shift, one as replacement candidate
    $originalGuard = $users[0]
    $replacementGuard = $users[1]
    
    Write-Host "   Original Guard: $($originalGuard.username) (ID: $($originalGuard.id))" -ForegroundColor Cyan
    Write-Host "   Replacement Candidate: $($replacementGuard.username) (ID: $($replacementGuard.id))" -ForegroundColor Cyan
} catch {
    Write-Host "   ✗ Failed to fetch users: $_" -ForegroundColor Red
    exit 1
}

# Step 2: Create a shift scheduled in the past (simulate no-show)
Write-Host "`n[2] Creating test shift (scheduled 20 minutes ago)..." -ForegroundColor Yellow
$startTime = (Get-Date).AddMinutes(-20).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
$endTime = (Get-Date).AddHours(8).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")

$shiftPayload = @{
    guardId = $originalGuard.id
    startTime = $startTime
    endTime = $endTime
    clientSite = "Test Site - Simulation"
} | ConvertTo-Json

try {
    $shiftResponse = Invoke-RestMethod -Uri "$API_BASE/api/guard-replacement/shifts" `
        -Method POST `
        -ContentType "application/json" `
        -Body $shiftPayload
    
    $shiftId = $shiftResponse.shiftId
    Write-Host "   ✓ Shift created: $shiftId" -ForegroundColor Green
    Write-Host "   Start time: $startTime" -ForegroundColor Gray
} catch {
    Write-Host "   ✗ Failed to create shift: $_" -ForegroundColor Red
    Write-Host "   Response: $($_.Exception.Response)" -ForegroundColor Red
    exit 1
}

# Step 3: Set replacement guard as available
Write-Host "`n[3] Setting replacement guard as available..." -ForegroundColor Yellow
$availabilityPayload = @{
    guardId = $replacementGuard.id
    available = $true
} | ConvertTo-Json

try {
    $availResponse = Invoke-RestMethod -Uri "$API_BASE/api/guard-replacement/set-availability" `
        -Method POST `
        -ContentType "application/json" `
        -Body $availabilityPayload
    
    Write-Host "   ✓ $($replacementGuard.username) is now available for replacements" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Failed to set availability: $_" -ForegroundColor Red
}

# Step 4: Trigger no-show detection
Write-Host "`n[4] Triggering automated no-show detection..." -ForegroundColor Yellow
Start-Sleep -Seconds 2

try {
    $noShowResponse = Invoke-RestMethod -Uri "$API_BASE/api/guard-replacement/detect-no-shows" `
        -Method POST `
        -ContentType "application/json"
    
    Write-Host "   ✓ No-show detection completed" -ForegroundColor Green
    Write-Host "   No-shows detected: $($noShowResponse.noShowsCount)" -ForegroundColor Cyan
    Write-Host "   Guards notified: $($noShowResponse.notifiedGuards.Count)" -ForegroundColor Cyan
    
    if ($noShowResponse.notifiedGuards.Count -gt 0) {
        Write-Host "`n   Notified Guards:" -ForegroundColor White
        foreach ($guard in $noShowResponse.notifiedGuards) {
            Write-Host "   - $($guard.guardName) (ID: $($guard.guardId))" -ForegroundColor Gray
        }
    }
} catch {
    Write-Host "   ✗ Failed to detect no-shows: $_" -ForegroundColor Red
    Write-Host "   Error details: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 5: Check notifications for replacement guard
Write-Host "`n[5] Checking notifications for replacement guard..." -ForegroundColor Yellow
Start-Sleep -Seconds 1

try {
    $notifications = Invoke-RestMethod -Uri "$API_BASE/api/users/$($replacementGuard.id)/notifications" `
        -Method GET
    
    Write-Host "   ✓ Total notifications: $($notifications.total)" -ForegroundColor Green
    Write-Host "   Unread notifications: $($notifications.unreadCount)" -ForegroundColor Cyan
    
    if ($notifications.notifications.Count -gt 0) {
        Write-Host "`n   Recent Notifications:" -ForegroundColor White
        foreach ($notif in $notifications.notifications | Select-Object -First 3) {
            $readStatus = if ($notif.read) { "[READ]" } else { "[UNREAD]" }
            Write-Host "   $readStatus $($notif.title)" -ForegroundColor $(if ($notif.read) { "Gray" } else { "Yellow" })
            Write-Host "     Message: $($notif.message)" -ForegroundColor Gray
            Write-Host "     Type: $($notif.type)" -ForegroundColor Gray
            if ($notif.relatedShiftId) {
                Write-Host "     Related Shift: $($notif.relatedShiftId)" -ForegroundColor Gray
            }
            Write-Host ""
        }
        
        # Find the replacement request notification
        $replacementNotif = $notifications.notifications | Where-Object { $_.type -eq "replacement_request" -and $_.relatedShiftId -eq $shiftId } | Select-Object -First 1
        
        if ($replacementNotif) {
            Write-Host "[6] Testing replacement acceptance..." -ForegroundColor Yellow
            $acceptPayload = @{
                guardId = $replacementGuard.id
                shiftId = $replacementNotif.relatedShiftId
                notificationId = $replacementNotif.id
            } | ConvertTo-Json
            
            try {
                $acceptResponse = Invoke-RestMethod -Uri "$API_BASE/api/guard-replacement/accept-replacement" `
                    -Method POST `
                    -ContentType "application/json" `
                    -Body $acceptPayload
                
                Write-Host "   ✓ Replacement accepted successfully!" -ForegroundColor Green
                Write-Host "   Message: $($acceptResponse.message)" -ForegroundColor Cyan
                
                # Verify shift was updated
                Write-Host "`n[7] Verifying shift assignment..." -ForegroundColor Yellow
                $allShifts = Invoke-RestMethod -Uri "$API_BASE/api/guard-replacement/shifts" -Method GET
                $updatedShift = $allShifts.shifts | Where-Object { $_.id -eq $shiftId } | Select-Object -First 1
                
                if ($updatedShift) {
                    Write-Host "   ✓ Shift updated successfully" -ForegroundColor Green
                    Write-Host "   Previous Guard: $($originalGuard.username)" -ForegroundColor Gray
                    Write-Host "   New Guard: $($updatedShift.guard_name)" -ForegroundColor Cyan
                    Write-Host "   Status: $($updatedShift.status)" -ForegroundColor Gray
                }
            } catch {
                Write-Host "   ✗ Failed to accept replacement: $_" -ForegroundColor Red
                Write-Host "   Details: $($_.Exception.Message)" -ForegroundColor Red
            }
        } else {
            Write-Host "   ! No replacement request notification found for this shift" -ForegroundColor Yellow
        }
    } else {
        Write-Host "   ! No notifications found. System may need debugging." -ForegroundColor Yellow
    }
} catch {
    Write-Host "   ✗ Failed to fetch notifications: $_" -ForegroundColor Red
    Write-Host "   Details: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 8: Check unread count
Write-Host "`n[8] Checking final unread count..." -ForegroundColor Yellow
try {
    $unreadCount = Invoke-RestMethod -Uri "$API_BASE/api/users/$($replacementGuard.id)/notifications/unread-count" -Method GET
    Write-Host "   ✓ Unread notifications: $($unreadCount.unreadCount)" -ForegroundColor $(if ($unreadCount.unreadCount -gt 0) { "Cyan" } else { "Green" })
} catch {
    Write-Host "   ✗ Failed to fetch unread count: $_" -ForegroundColor Red
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  SIMULATION COMPLETE" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "Next steps:" -ForegroundColor White
Write-Host "1. Open http://192.168.1.8:5175 in your browser" -ForegroundColor Gray
Write-Host "2. Login as: $($replacementGuard.username)" -ForegroundColor Gray
Write-Host "3. Check the notification bell icon in the header" -ForegroundColor Gray
Write-Host "4. You should see the replacement request notification" -ForegroundColor Gray
Write-Host ""
