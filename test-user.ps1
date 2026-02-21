# Simple User Workflow Simulation
param([string]$baseUrl = "http://localhost:5000")

# Use pre-seeded admin account for testing (should be verified)
$testEmail = "admin@test.local"
$testPassword = "admin123"

$global:userId = $null
$global:token = $null
$global:shiftId = $null
$global:attendanceId = $null

Write-Host "=========================================="
Write-Host "USER WORKFLOW SIMULATION"
Write-Host "=========================================="
Write-Host "Using pre-seeded test account: $testEmail"
Write-Host "==========================================="

# Test 1: Fetch User Profile (using pre-seeded account)
Write-Host "`nTest 1: Fetch User Profile"
try {
    # First, get the user ID from login
    $loginPayload = @{
        identifier = $testEmail
        password = $testPassword
    } | ConvertTo-Json
    
    $loginResult = Invoke-RestMethod -Uri "$baseUrl/api/auth/login" -Method Post -Body $loginPayload -ContentType "application/json"
    $global:userId = $loginResult.user.id
    Write-Host "PASSED - User ID: $global:userId"
} catch {
    Write-Host "FAILED: $_"
}

# Test 2: User Login
Write-Host "`nTest 2: User Login"
$payload = @{
    identifier = $testEmail
    password = $testPassword
} | ConvertTo-Json

try {
    $result = Invoke-RestMethod -Uri "$baseUrl/api/auth/login" -Method Post -Body $payload -ContentType "application/json"
    Write-Host "PASSED - Login successful"
} catch {
    Write-Host "FAILED: $_"
}

# Fetch Profile
Write-Host "`nTest 3: Fetch User Profile"
try {
    $result = Invoke-RestMethod -Uri "$baseUrl/api/users/$global:userId" -Method Get
    Write-Host "PASSED - Name: $($result.fullName)"
} catch {
    Write-Host "FAILED: $_"
}

# Update Profile Photo
Write-Host "`nTest 4: Update Profile Photo"
$payload = '{"profilePhoto": "test_data"}'
try {
    Invoke-RestMethod -Uri "$baseUrl/api/users/$global:userId/profile-photo" -Method Put -Body $payload -ContentType "application/json" | Out-Null
    Write-Host "PASSED"
} catch {
    Write-Host "FAILED: $_"
}

# Create Shift
Write-Host "`nTest 5: Create Shift"
$now = (Get-Date).ToUniversalTime()
$payload = @{
    guardId = $global:userId
    clientSite = "Test Bank"
    startTime = $now.AddHours(2).ToString("yyyy-MM-ddTHH:mm:ssZ")
    endTime = $now.AddHours(10).ToString("yyyy-MM-ddTHH:mm:ssZ")
} | ConvertTo-Json

try {
    $result = Invoke-RestMethod -Uri "$baseUrl/api/guard-replacement/shifts" -Method Post -Body $payload -ContentType "application/json"
    $global:shiftId = $result.shiftId
    Write-Host "PASSED - Shift ID: $global:shiftId"
} catch {
    Write-Host "FAILED: $_"
}

# Fetch Shifts
Write-Host "`nTest 6: Fetch Shifts"
try {
    $result = Invoke-RestMethod -Uri "$baseUrl/api/guard-replacement/shifts" -Method Get
    $userShifts = $result.shifts | Where-Object { $_.guard_id -eq $global:userId }
    Write-Host "PASSED - Shifts found: $($userShifts.Count)"
} catch {
    Write-Host "FAILED: $_"
}

# Check-in
Write-Host "`nTest 7: Check-in to Shift"
$payload = @{
    guardId = $global:userId
    shiftId = $global:shiftId
} | ConvertTo-Json

try {
    $result = Invoke-RestMethod -Uri "$baseUrl/api/guard-replacement/check-in" -Method Post -Body $payload -ContentType "application/json"
    $global:attendanceId = $result.attendanceId
    Write-Host "PASSED - Attendance ID: $global:attendanceId"
} catch {
    Write-Host "FAILED: $_"
}

# Set Availability
Write-Host "`nTest 8: Set Availability"
$now = (Get-Date).ToUniversalTime()
$payload = @{
    guardId = $global:userId
    isAvailable = $true
    availableFrom = $now.ToString("yyyy-MM-ddTHH:mm:ssZ")
    availableUntil = $now.AddDays(7).ToString("yyyy-MM-ddTHH:mm:ssZ")
} | ConvertTo-Json

try {
    Invoke-RestMethod -Uri "$baseUrl/api/guard-replacement/set-availability" -Method Post -Body $payload -ContentType "application/json" | Out-Null
    Write-Host "PASSED"
} catch {
    Write-Host "FAILED: $_"
}

# Check Notifications
Write-Host "`nTest 9: Fetch Notifications"
try {
    $result = Invoke-RestMethod -Uri "$baseUrl/api/users/$global:userId/notifications" -Method Get
    Write-Host "PASSED - Notifications: $($result.total), Unread: $($result.unreadCount)"
} catch {
    Write-Host "FAILED: $_"
}

# View Firearms
Write-Host "`nTest 10: View Firearms"
try {
    $result =  Invoke-RestMethod -Uri "$baseUrl/api/firearms" -Method Get
    Write-Host "PASSED - Total firearms: $($result.total)"
} catch {
    Write-Host "FAILED: $_"
}

# Check-out
Write-Host "`nTest 11: Check-out from Shift"
if ($global:attendanceId) {
    $payload = @{
        attendanceId = $global:attendanceId
    } | ConvertTo-Json
    
    try {
        Invoke-RestMethod -Uri "$baseUrl/api/guard-replacement/check-out" -Method Post -Body $payload -ContentType "application/json" | Out-Null
        Write-Host "PASSED"
    } catch {
        Write-Host "FAILED: $_"
    }
} else {
    Write-Host "SKIPPED - No attendance ID"
}

Write-Host "`n=========================================="
Write-Host "USER WORKFLOW SIMULATION COMPLETED"
Write-Host "=========================================="
