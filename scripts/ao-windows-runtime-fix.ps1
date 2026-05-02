param(
  [switch]$Apply,
  [switch]$Quiet
)

$ErrorActionPreference = 'Stop'

$runtimePath = Join-Path $env:APPDATA 'npm\node_modules\@aoagents\ao\node_modules\@aoagents\ao-plugin-runtime-process\dist\index.js'

if (-not (Test-Path $runtimePath)) {
  throw "AO runtime plugin not found: $runtimePath"
}

$current = Get-Content $runtimePath -Raw

$alreadyPatched = $current.Contains('usePowershellBridge') -and $current.Contains('Windows compatibility: AO agent plugins emit POSIX-quoted launch commands.')
if ($alreadyPatched) {
  if (-not $Quiet) {
    Write-Host 'AO runtime-process plugin is already Windows-compatible.'
  }
  exit 0
}

$target = @'
                child = spawn(config.launchCommand, {
                    cwd: config.workspacePath,
                    env: { ...process.env, ...config.environment },
                    stdio: ["pipe", "pipe", "pipe"],
                    shell: true,
                    detached: true, // Own process group so destroy() can kill child commands
                });
'@

$replacement = @'
                const isWin = process.platform === "win32";
                const usePowershellBridge = isWin;
                if (usePowershellBridge) {
                    // Windows compatibility: AO agent plugins emit POSIX-quoted launch commands.
                    // cmd.exe cannot execute tokens like `'codex' ...`, so route through PowerShell
                    // and explicitly invoke the command with call operator `&`.
                    child = spawn("powershell.exe", ["-NoLogo", "-NoProfile", "-Command", "& " + config.launchCommand], {
                        cwd: config.workspacePath,
                        env: { ...process.env, ...config.environment },
                        stdio: ["pipe", "pipe", "pipe"],
                        shell: false,
                        detached: true,
                        windowsHide: true,
                    });
                }
                else {
                    child = spawn(config.launchCommand, {
                        cwd: config.workspacePath,
                        env: { ...process.env, ...config.environment },
                        stdio: ["pipe", "pipe", "pipe"],
                        shell: true,
                        detached: true, // Own process group so destroy() can kill child commands
                    });
                }
'@

if (-not $current.Contains($target)) {
  throw 'Expected AO runtime spawn block not found. AO version may have changed; re-validate patch.'
}

if (-not $Apply) {
  if (-not $Quiet) {
    Write-Host 'Patch is needed. Re-run with -Apply to modify AO runtime plugin.'
  }
  exit 2
}

$backup = "$runtimePath.bak-$(Get-Date -Format yyyyMMddHHmmss)"
Copy-Item -Path $runtimePath -Destination $backup -Force

$updated = $current.Replace($target, $replacement)
Set-Content -Path $runtimePath -Value $updated -NoNewline

if (-not $Quiet) {
  Write-Host "AO runtime Windows fix applied. Backup: $backup"
}
