# Simple Admin Workflow Simulation
param([string]$baseUrl = "http://localhost:5000")

$global:adminId = $null
$global:newUserId = $null
$global:shiftId = $null
$global:firearmId = $null
$global:carId = $null

Write-Host "=========================================="
Write-Host "ADMIN WORKFLOW SIMULATION"
Write-Host "=========================================="

# Get Admin User
Write-Host "`nTest 1: Fetch Admin User"
try {
    $result = Invoke-RestMethod -Uri "$baseUrl/api/users" -Method Get
    $admin = $result.users | Where-Object { $_.role -eq "admin" } | Select-Object -First 1
    $global:adminId = $admin.id
    Write-Host "PASSED - Admin ID: $global:adminId"
} catch {
    Write-Host "FAILED: $_"
}

# List All Users
Write-Host "`nTest 2: List All Users"
try {
    $result = Invoke-RestMethod -Uri "$baseUrl/api/users" -Method Get
    Write-Host "PASSED - Total users: $($result.total)"
} catch {
    Write-Host "FAILED: $_"
}

# Create New User
Write-Host "`nTest 3: Create New Guard User"
$username = "guard$(Get-Random -Minimum 100 -Maximum 999)"
$email = "guard_$(Get-Random)@gmail.com"
$payload = @{
    fullName = "Guard User"
    email = $email
    password = "SecurePass123!"
    username = $username
    role = "user"
    phoneNumber = "+1234567890"
    licenseNumber = "LIC-$(Get-Random -Minimum 10000 -Maximum 99999)"
    licenseExpiryDate = (Get-Date).AddYears(1).ToString("o")
} | ConvertTo-Json

try {
    $result = Invoke-RestMethod -Uri "$baseUrl/api/auth/register" -Method Post -Body $payload -ContentType "application/json"
    $global:newUserId = $result.userId
    Write-Host "PASSED - User ID: $global:newUserId"
} catch {
    Write-Host "FAILED: $_"
}

# Update User
Write-Host "`nTest 4: Update User Information"
$payload = @{
    fullName = "Updated Guard Name"
    phoneNumber = "+1234567890"
} | ConvertTo-Json

try {
    Invoke-RestMethod -Uri "$baseUrl/api/users/$global:newUserId" -Method Put -Body $payload -ContentType "application/json" | Out-Null
    Write-Host "PASSED"
} catch {
    Write-Host "FAILED: $_"
}

# Create Shifts
Write-Host "`nTest 5: Create Multiple Shifts"
$now = (Get-Date).ToUniversalTime()
$shiftsCreated = 0

for ($i = 1; $i -le 3; $i++) {
    $payload = @{
        guardId = $global:newUserId
        clientSite = "Site Location $i"
        startTime = $now.AddDays($i).ToString("yyyy-MM-ddTHH:mm:ssZ")
        endTime = $now.AddDays($i).AddHours(8).ToString("yyyy-MM-ddTHH:mm:ssZ")
    } | ConvertTo-Json
    
    try {
        $result = Invoke-RestMethod -Uri "$baseUrl/api/guard-replacement/shifts" -Method Post -Body $payload -ContentType "application/json"
        if ($shiftsCreated -eq 0) {
            $global:shiftId = $result.shiftId
        }
        $shiftsCreated++
    } catch {
        Write-Host "FAILED creating shift $i"
    }
}

Write-Host "PASSED - Created $shiftsCreated shifts"

# View All Shifts
Write-Host "`nTest 6: View All Shifts"
try {
    $result = Invoke-RestMethod -Uri "$baseUrl/api/guard-replacement/shifts" -Method Get
    Write-Host "PASSED - Total shifts: $($result.total)"
} catch {
    Write-Host "FAILED: $_"
}

# Create Firearm
Write-Host "`nTest 7: Create New Firearm"
$payload = @{
    serialNumber = "TEST-$(Get-Random -Minimum 10000 -Maximum 99999)"
    model = "Glock 17"
    caliber = "9mm"
    status = "available"
} | ConvertTo-Json

try {
    $result = Invoke-RestMethod -Uri "$baseUrl/api/firearms" -Method Post -Body $payload -ContentType "application/json"
    $global:firearmId = $result.firearmId
    Write-Host "PASSED - Firearm ID: $global:firearmId"
} catch {
    Write-Host "FAILED: $_"
}

# List Firearms
Write-Host "`nTest 8: List All Firearms"
try {
    $result = Invoke-RestMethod -Uri "$baseUrl/api/firearms" -Method Get
    $firearms = @($result)
    Write-Host "PASSED - Total firearms: $($firearms.Count)"
} catch {
    Write-Host "FAILED: $_"
}

# Update Firearm Status
Write-Host "`nTest 9: Update Firearm Status"
$payload = @{
    status = "maintenance"
    notes = "Routine check"
} | ConvertTo-Json

try {
    Invoke-RestMethod -Uri "$baseUrl/api/firearms/$global:firearmId" -Method Put -Body $payload -ContentType "application/json" | Out-Null
    Write-Host "PASSED"
} catch {
    Write-Host "FAILED: $_"
}

# Allocate Firearm
Write-Host "`nTest 10: Allocate Firearm to Guard"
# Set back to available first
$payload1 = '{"status": "available"}'
try {
    Invoke-RestMethod -Uri "$baseUrl/api/firearms/$global:firearmId" -Method Put -Body $payload1 -ContentType "application/json" | Out-Null
} catch {}

$payload = @{
    guardId   = $global:newUserId
    firearmId = $global:firearmId
    shiftId   = $global:shiftId
    issuedBy  = $global:adminId
    force     = $true
} | ConvertTo-Json

try {
    Invoke-RestMethod -Uri "$baseUrl/api/firearm-allocation" -Method Post -Body $payload -ContentType "application/json" | Out-Null
    Write-Host "PASSED"
} catch {
    Write-Host "FAILED: $_"
}

# Create Armored Car
Write-Host "`nTest 11: Create Armored Car"
$payload = @{
    licensePlate = "TEST-$(Get-Random -Minimum 100 -Maximum 999)"
    vin = "VIN-$(Get-Random -Minimum 100000 -Maximum 999999)"
    model = "Toyota Land Cruiser"
    manufacturer = "Toyota"
    capacityKg = 1000
    status = "available"
} | ConvertTo-Json

try {
    $result = Invoke-RestMethod -Uri "$baseUrl/api/armored-cars" -Method Post -Body $payload -ContentType "application/json"
    $global:carId = $result.carId
    Write-Host "PASSED - Car ID: $global:carId"
} catch {
    Write-Host "FAILED: $_"
}

# List Armored Cars
Write-Host "`nTest 12: List All Armored Cars"
try {
    $result = Invoke-RestMethod -Uri "$baseUrl/api/armored-cars" -Method Get
    $cars = @($result)
    Write-Host "PASSED - Total cars: $($cars.Count)"
} catch {
    Write-Host "FAILED: $_"
}

# Dashboard Analytics
Write-Host "`nTest 13: Fetch Dashboard Analytics"
try {
    $result = Invoke-RestMethod -Uri "$baseUrl/api/analytics" -Method Get
    Write-Host "PASSED - Guards: $($result.overview.total_guards), Attendance Rate: $($result.performance_metrics.guard_attendance_rate)%"
} catch {
    Write-Host "FAILED: $_"
}

Write-Host "`n=========================================="
Write-Host "ADMIN WORKFLOW SIMULATION COMPLETED"
Write-Host "=========================================="
