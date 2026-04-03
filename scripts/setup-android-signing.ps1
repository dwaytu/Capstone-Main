#Requires -Version 5.1
<#
.SYNOPSIS
    Generates an Android release signing keystore for SENTINEL and outputs
    the values needed to configure GitHub Actions secrets.

.DESCRIPTION
    This script creates a release signing keystore (JKS format), base64-encodes it,
    and prints the exact secret values you need to add to your GitHub repository.

    Required GitHub Secrets (Settings → Secrets → Actions → New repository secret):
        SENTINEL_ANDROID_KEYSTORE_BASE64   — base64-encoded keystore file
        SENTINEL_UPLOAD_STORE_PASSWORD     — keystore password
        SENTINEL_UPLOAD_KEY_ALIAS          — key alias
        SENTINEL_UPLOAD_KEY_PASSWORD       — key password

.PARAMETER KeystoreFile
    Output path for the generated keystore. Defaults to sentinel-release.keystore
    in the current directory. Store this file in a secure location — do NOT commit it.

.PARAMETER StorePassword
    Password for the keystore. Prompted securely if not provided.

.PARAMETER KeyAlias
    Alias for the signing key. Defaults to "sentinel".

.PARAMETER KeyPassword
    Password for the key. Prompted securely if not provided.

.PARAMETER Validity
    Key validity in days. Defaults to 10000 (~27 years), matching Play Store guidance.

.EXAMPLE
    .\setup-android-signing.ps1
    .\setup-android-signing.ps1 -KeyAlias "sentinel-upload" -KeystoreFile ".\keystore\sentinel.jks"

.NOTES
    Requires Java (keytool) to be installed and available on PATH.
    Download JDK: https://adoptium.net/
#>
[CmdletBinding()]
param(
    [string]$KeystoreFile  = ".\sentinel-release.keystore",
    [string]$StorePassword = "",
    [string]$KeyAlias      = "sentinel",
    [string]$KeyPassword   = "",
    [int]   $Validity      = 10000
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ─── helpers ──────────────────────────────────────────────────────────────────

function Write-Header([string]$text) {
    Write-Host ""
    Write-Host "══════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "  $text" -ForegroundColor Cyan
    Write-Host "══════════════════════════════════════════════════════" -ForegroundColor Cyan
}

function Write-Step([string]$text) {
    Write-Host "  ▶  $text" -ForegroundColor Yellow
}

function Write-Success([string]$text) {
    Write-Host "  ✔  $text" -ForegroundColor Green
}

function Write-Secret([string]$name, [string]$value) {
    Write-Host ""
    Write-Host "  Secret name : " -NoNewline -ForegroundColor DarkGray
    Write-Host $name -ForegroundColor White
    Write-Host "  Value       : " -NoNewline -ForegroundColor DarkGray
    Write-Host $value -ForegroundColor Magenta
}

# ─── verify keytool ───────────────────────────────────────────────────────────

Write-Header "SENTINEL Android Signing Setup"

$keytool = Get-Command keytool -ErrorAction SilentlyContinue
if (-not $keytool) {
    Write-Host ""
    Write-Host "  ERROR: 'keytool' was not found on PATH." -ForegroundColor Red
    Write-Host "  Install the JDK: https://adoptium.net/" -ForegroundColor Yellow
    exit 1
}
Write-Success "keytool found at: $($keytool.Source)"

# ─── collect credentials ──────────────────────────────────────────────────────

Write-Step "Collecting keystore credentials (passwords will not be echoed)"
Write-Host ""

if (-not $StorePassword) {
    $storePwdSecure = Read-Host "  Keystore password (min 6 chars)" -AsSecureString
    $StorePassword  = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
                          [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($storePwdSecure))
}

if ($StorePassword.Length -lt 6) {
    Write-Host "  ERROR: Keystore password must be at least 6 characters." -ForegroundColor Red
    exit 1
}

if (-not $KeyPassword) {
    $keyPwdSecure = Read-Host "  Key password (leave blank to reuse keystore password)" -AsSecureString
    $KeyPassword  = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
                        [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($keyPwdSecure))
    if (-not $KeyPassword) {
        $KeyPassword = $StorePassword
    }
}

# Distinguish store from key password in GitHub Secrets
if ($KeyPassword.Length -lt 6) {
    Write-Host "  ERROR: Key password must be at least 6 characters." -ForegroundColor Red
    exit 1
}

# ─── generate keystore ────────────────────────────────────────────────────────

Write-Step "Generating keystore at: $KeystoreFile"

$keystorePath = (Resolve-Path -LiteralPath (Split-Path $KeystoreFile -Parent) -ErrorAction SilentlyContinue)?.Path
if (-not $keystorePath) {
    New-Item -ItemType Directory -Force -Path (Split-Path $KeystoreFile -Parent) | Out-Null
}

$dname = "CN=SENTINEL App, OU=Mobile, O=DASIA, L=Tagum, ST=Davao del Norte, C=PH"

$keytoolArgs = @(
    "-genkeypair"
    "-keystore"       , $KeystoreFile
    "-storepass"      , $StorePassword
    "-alias"          , $KeyAlias
    "-keypass"        , $KeyPassword
    "-keyalg"         , "RSA"
    "-keysize"        , "2048"
    "-validity"       , $Validity.ToString()
    "-dname"          , $dname
    "-storetype"      , "JKS"
)

& keytool @keytoolArgs 2>&1 | ForEach-Object { Write-Host "    $_" -ForegroundColor DarkGray }

if ($LASTEXITCODE -ne 0) {
    Write-Host "  ERROR: keytool failed (exit $LASTEXITCODE)." -ForegroundColor Red
    exit 1
}

Write-Success "Keystore generated: $KeystoreFile"

# ─── base64 encode ────────────────────────────────────────────────────────────

Write-Step "Base64-encoding keystore for GitHub Secret..."

$keystoreBytes  = [System.IO.File]::ReadAllBytes((Resolve-Path $KeystoreFile).Path)
$keystoreBase64 = [System.Convert]::ToBase64String($keystoreBytes)

Write-Success "Base64 encoding complete (${$keystoreBase64.Length} chars)"

# ─── output GitHub Secrets ───────────────────────────────────────────────────

Write-Header "GitHub Actions Secrets"
Write-Host ""
Write-Host "  Add these secrets to your repository:" -ForegroundColor White
Write-Host "  GitHub → Settings → Secrets and variables → Actions → New repository secret" -ForegroundColor DarkGray
Write-Host ""

Write-Secret "SENTINEL_ANDROID_KEYSTORE_BASE64"  $keystoreBase64
Write-Secret "SENTINEL_UPLOAD_STORE_PASSWORD"    $StorePassword
Write-Secret "SENTINEL_UPLOAD_KEY_ALIAS"         $KeyAlias
Write-Secret "SENTINEL_UPLOAD_KEY_PASSWORD"      $KeyPassword

# ─── write secrets file (optional) ──────────────────────────────────────────

$secretsFile = ".\sentinel-android-secrets.txt"
Write-Host ""
Write-Step "Writing secrets to $secretsFile (KEEP SECURE — add to .gitignore)"

@"
# ============================================================
# SENTINEL Android Release Signing Secrets
# Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
#
# ADD TO GITHUB: Settings > Secrets and variables > Actions
# DO NOT COMMIT THIS FILE — it contains signing credentials.
# ============================================================

SENTINEL_ANDROID_KEYSTORE_BASE64=$keystoreBase64
SENTINEL_UPLOAD_STORE_PASSWORD=$StorePassword
SENTINEL_UPLOAD_KEY_ALIAS=$KeyAlias
SENTINEL_UPLOAD_KEY_PASSWORD=$KeyPassword
"@ | Set-Content -Path $secretsFile -Encoding UTF8

Write-Success "Secrets saved to: $secretsFile"

# ─── gitignore reminder ───────────────────────────────────────────────────────

Write-Header "Security Reminders"
Write-Host ""
Write-Host "  ⚠  Add these to .gitignore (never commit):" -ForegroundColor Yellow
Write-Host "     *.keystore" -ForegroundColor White
Write-Host "     *.jks" -ForegroundColor White
Write-Host "     sentinel-android-secrets.txt" -ForegroundColor White
Write-Host ""
Write-Host "  ⚠  Store your keystore file in a secure location." -ForegroundColor Yellow
Write-Host "     If it is lost, you CANNOT update your Play Store app." -ForegroundColor Yellow
Write-Host ""
Write-Host "  ✔  Once GitHub Secrets are set, re-run the release workflow." -ForegroundColor Green
Write-Host "     The 'Android release signing secrets are required' error will be resolved." -ForegroundColor DarkGray
Write-Host ""
