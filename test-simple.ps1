# Simple simulation test
$API_BASE = "http://localhost:5000"

Write-Host "`n=== GUARD REPLACEMENT SYSTEM TEST ===`n" -ForegroundColor Cyan

# Get users
Write-Host "[1] Fetching users..." -ForegroundColor Yellow
$users = Invoke-RestMethod -Uri "$API_BASE/api/users" -Method GET
Write-Host "   Found $($users.Count) users" -ForegroundColor Green

if ($users.Count -lt 2) {
    Write-Host "   Need at least 2 users!" -ForegroundColor Red
    exit
}

$originalGuard = $users[0]
$replacementGuard = $users[1]

Write-Host "   Original: $($originalGuard.username) ($($originalGuard.id))" -ForegroundColor Cyan
Write-Host "   Replacement: $($replacementGuard.username) ($($replacementGuard.id))" -ForegroundColor Cyan

# Create past shift
Write-Host "`n[2] Creating test shift (20 min ago)..." -ForegroundColor Yellow
$startTime = (Get-Date).AddMinutes(-20).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
$endTime = (Get-Date).AddHours(8).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")

$shiftBody = @{
    guardId = $originalGuard.id
    startTime = $startTime
    endTime = $endTime
    clientSite = "Test Site"
} | ConvertTo-Json

$shift = Invoke-RestMethod -Uri "$API_BASE/api/guard-replacement/shifts" -Method POST -ContentType "application/json" -Body $shiftBody
$shiftId = $shift.shiftId
Write-Host "   Shift created: $shiftId" -ForegroundColor Green

# Set available
Write-Host "`n[3] Setting guard as available..." -ForegroundColor Yellow
$availBody = @{
    guardId = $replacementGuard.id
    available = $true
} | ConvertTo-Json

Invoke-RestMethod -Uri "$API_BASE/api/guard-replacement/set-availability" -Method POST -ContentType "application/json" -Body $availBody | Out-Null
Write-Host "   Available set" -ForegroundColor Green

# Detect no-shows
Write-Host "`n[4] Detecting no-shows..." -ForegroundColor Yellow
$noShows = Invoke-RestMethod -Uri "$API_BASE/api/guard-replacement/detect-no-shows" -Method POST -ContentType "application/json"
Write-Host "   No-shows: $($noShows.noShowsCount)" -ForegroundColor Green
Write-Host "   Notified: $($noShows.notifiedGuards.Count)" -ForegroundColor Green

# Check notifications
Write-Host "`n[5] Checking notifications..." -ForegroundColor Yellow
$notifs = Invoke-RestMethod -Uri "$API_BASE/api/users/$($replacementGuard.id)/notifications" -Method GET
Write-Host "   Total: $($notifs.total)" -ForegroundColor Green
Write-Host "   Unread: $($notifs.unreadCount)" -ForegroundColor Green

if ($notifs.notifications.Count -gt 0) {
    Write-Host "`n   Recent notifications:" -ForegroundColor White
    foreach ($n in $notifs.notifications | Select-Object -First 3) {
        Write-Host "   - $($n.title)" -ForegroundColor Yellow
        Write-Host "     $($n.message)" -ForegroundColor Gray
    }
    
    # Accept replacement
    $replacementNotif = $notifs.notifications | Where-Object { $_.type -eq "replacement_request" -and $_.relatedShiftId -eq $shiftId } | Select-Object -First 1
    
    if ($replacementNotif) {
        Write-Host "`n[6] Accepting replacement..." -ForegroundColor Yellow
        $acceptBody = @{
            guardId = $replacementGuard.id
            shiftId = $replacementNotif.relatedShiftId
            notificationId = $replacementNotif.id
        } | ConvertTo-Json
        
        $accept = Invoke-RestMethod -Uri "$API_BASE/api/guard-replacement/accept-replacement" -Method POST -ContentType "application/json" -Body $acceptBody
        Write-Host "   $($accept.message)" -ForegroundColor Green
    }
}

Write-Host "`n=== TEST COMPLETE ===`n" -ForegroundColor Cyan
Write-Host "Open http://192.168.1.8:5175" -ForegroundColor Gray
Write-Host "Login as: $($replacementGuard.username)" -ForegroundColor Gray
