param(
  [ValidateSet('bootstrap','start','spawn-heads','status','stop','send-cto')]
  [string]$Action = 'bootstrap',
  [string]$ProjectId = 'capstone-main',
  [switch]$NoDashboard
)

$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$promptDir = Join-Path $repoRoot 'docs/ao-team/prompts'
$ctoSession = 'cm-orchestrator-1'

$headPrompts = @(
  'planner-head.md',
  'backend-head.md',
  'frontend-head.md',
  'designer-head.md',
  'qa-head.md',
  'security-head.md',
  'release-head.md',
  'capstone-documenter-head.md'
)

function Invoke-Ao {
  param([Parameter(Mandatory = $true)][string[]]$Args)
  Write-Host "ao $($Args -join ' ')" -ForegroundColor Cyan
  & ao @Args
}

function Ensure-AoWindowsCompat {
  if (-not $IsWindows) {
    return
  }

  $fixScript = Join-Path $repoRoot 'scripts/ao-windows-runtime-fix.ps1'
  if (-not (Test-Path $fixScript)) {
    Write-Warning "AO Windows runtime fix script not found: $fixScript"
    return
  }

  Write-Host "Applying AO Windows runtime compatibility patch..." -ForegroundColor DarkYellow
  & powershell -ExecutionPolicy Bypass -File $fixScript -Apply -Quiet
}

function Assert-Prompts {
  $required = @('cto-orchestrator.md') + $headPrompts
  foreach ($file in $required) {
    $path = Join-Path $promptDir $file
    if (-not (Test-Path $path)) {
      throw "Missing prompt file: $path"
    }
  }
}

function Start-AoProject {
  if ($NoDashboard) {
    Invoke-Ao -Args @('start','--no-dashboard',$ProjectId)
  } else {
    Invoke-Ao -Args @('start',$ProjectId)
  }
}

function Send-CtoPrompt {
  $promptPath = Join-Path $promptDir 'cto-orchestrator.md'
  Invoke-Ao -Args @('send',$ctoSession,'-f',$promptPath)
}

function Spawn-HeadSessions {
  foreach ($file in $headPrompts) {
    $promptPath = Join-Path $promptDir $file
    $prompt = Get-Content -Raw $promptPath
    Invoke-Ao -Args @('spawn','--prompt',$prompt)
  }
}

Assert-Prompts
Ensure-AoWindowsCompat

switch ($Action) {
  'start' {
    Start-AoProject
  }
  'send-cto' {
    Send-CtoPrompt
  }
  'spawn-heads' {
    Spawn-HeadSessions
  }
  'status' {
    Invoke-Ao -Args @('status','--include-terminated')
  }
  'stop' {
    Invoke-Ao -Args @('stop',$ProjectId)
  }
  'bootstrap' {
    Start-AoProject
    Send-CtoPrompt
    Spawn-HeadSessions
    Invoke-Ao -Args @('status','--include-terminated')
  }
}
