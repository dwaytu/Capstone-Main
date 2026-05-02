param(
  [string]$Password = "password123",
  [string]$ContainerName = "guard-firearm-postgres",
  [string]$Database = "guard_firearm_system",
  [string]$DbUser = "postgres"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$check = & docker ps --format "{{.Names}}" | Where-Object { $_ -eq $ContainerName }
if (-not $check) {
  throw "Container '$ContainerName' is not running. Start postgres first."
}

$sql = @'
CREATE EXTENSION IF NOT EXISTS pgcrypto;

WITH seed_accounts(role, email, username, full_name, phone_number) AS (
  VALUES
    ('superadmin', 'superadmin@sentinel.local', 'superadmin', 'Super Admin', '+639000000001'),
    ('admin', 'admin@sentinel.local', 'admin', 'Administrator', '+639000000002'),
    ('supervisor', 'supervisor@sentinel.local', 'supervisor', 'Supervisor', '+639000000003'),
    ('guard', 'guard@sentinel.local', 'guard', 'Guard Local', '+639000000004')
),
updated AS (
  UPDATE users u
  SET
    email = s.email,
    username = s.username,
    password = crypt(:'pwd', gen_salt('bf')),
    role = s.role,
    full_name = s.full_name,
    phone_number = s.phone_number,
    verified = true,
    approval_status = 'approved',
    approval_date = NOW(),
    consent_accepted_at = COALESCE(u.consent_accepted_at, NOW()),
    consent_version = COALESCE(u.consent_version, 'capstone-local-v1'),
    consent_ip = COALESCE(u.consent_ip, '127.0.0.1'),
    consent_user_agent = COALESCE(u.consent_user_agent, 'capstone-provisioner'),
    location_tracking_consent = CASE WHEN s.role IN ('guard', 'supervisor') THEN true ELSE u.location_tracking_consent END,
    location_tracking_consent_granted_at = CASE
      WHEN s.role IN ('guard', 'supervisor') THEN COALESCE(u.location_tracking_consent_granted_at, NOW())
      ELSE u.location_tracking_consent_granted_at
    END,
    location_tracking_consent_updated_at = NOW(),
    updated_at = NOW()
  FROM seed_accounts s
  WHERE LOWER(u.username) = LOWER(s.username) OR LOWER(u.email) = LOWER(s.email)
  RETURNING u.id
),
missing_accounts AS (
  SELECT s.*
  FROM seed_accounts s
  LEFT JOIN users u
    ON LOWER(u.username) = LOWER(s.username)
    OR LOWER(u.email) = LOWER(s.email)
  WHERE u.id IS NULL
)
INSERT INTO users (
  id,
  email,
  username,
  password,
  role,
  full_name,
  phone_number,
  verified,
  approval_status,
  approval_date,
  consent_accepted_at,
  consent_version,
  consent_ip,
  consent_user_agent,
  location_tracking_consent,
  location_tracking_consent_granted_at,
  location_tracking_consent_updated_at,
  created_at,
  updated_at
)
SELECT
  gen_random_uuid()::text,
  m.email,
  m.username,
  crypt(:'pwd', gen_salt('bf')),
  m.role,
  m.full_name,
  m.phone_number,
  true,
  'approved',
  NOW(),
  NOW(),
  'capstone-local-v1',
  '127.0.0.1',
  'capstone-provisioner',
  CASE WHEN m.role IN ('guard', 'supervisor') THEN true ELSE false END,
  CASE WHEN m.role IN ('guard', 'supervisor') THEN NOW() ELSE NULL END,
  NOW(),
  NOW(),
  NOW()
FROM missing_accounts m;

SELECT role, email, username, verified, approval_status
FROM users
WHERE LOWER(username) IN ('superadmin', 'admin', 'supervisor', 'guard')
ORDER BY
  CASE role
    WHEN 'superadmin' THEN 1
    WHEN 'admin' THEN 2
    WHEN 'supervisor' THEN 3
    WHEN 'guard' THEN 4
    ELSE 5
  END;
'@

$sql | docker exec -i $ContainerName psql -U $DbUser -d $Database -v ON_ERROR_STOP=1 -v "pwd=$Password"
if ($LASTEXITCODE -ne 0) {
  throw "Account provisioning failed with exit code $LASTEXITCODE"
}
Write-Host "Provisioned capstone role accounts (superadmin/admin/supervisor/guard)." -ForegroundColor Green
