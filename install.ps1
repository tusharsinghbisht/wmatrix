# install.ps1 - Install wmatrix.exe system-wide on Windows
# Installs to: C:\Program Files\wmatrix\  (or %LOCALAPPDATA%\Programs\wmatrix with -Scope User)
# Adds install dir to PATH automatically.
#
# Usage:
#   powershell -ExecutionPolicy Bypass -File install.ps1                  (system-wide, needs admin)
#   powershell -ExecutionPolicy Bypass -File install.ps1 -Scope User      (current user, no admin)
#   powershell -ExecutionPolicy Bypass -File install.ps1 -Uninstall       (remove)

param(
    [ValidateSet("Machine","User")]
    [string]$Scope = "Machine",
    [switch]$Uninstall
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path $MyInvocation.MyCommand.Path

$INSTALL_DIR = if ($Scope -eq "Machine") {
    "$env:ProgramFiles\wmatrix"
} else {
    "$env:LOCALAPPDATA\Programs\wmatrix"
}

# ---- Uninstall ---------------------------------------------------------------
if ($Uninstall) {
    if (Test-Path $INSTALL_DIR) {
        Remove-Item $INSTALL_DIR -Recurse -Force
        Write-Host "Removed: $INSTALL_DIR" -ForegroundColor Yellow
    }
    $pathTarget = [System.EnvironmentVariableTarget]::$Scope
    $currentPath = [System.Environment]::GetEnvironmentVariable("PATH", $pathTarget)
    $newPath = ($currentPath -split ";" | Where-Object { $_ -ne $INSTALL_DIR }) -join ";"
    [System.Environment]::SetEnvironmentVariable("PATH", $newPath, $pathTarget)
    Write-Host "wmatrix uninstalled. Restart your terminal." -ForegroundColor Green
    exit 0
}

# ---- Build if needed ---------------------------------------------------------
$EXE = "$ScriptDir\wmatrix.exe"
if (-not (Test-Path $EXE)) {
    Write-Host "wmatrix.exe not found. Building first..." -ForegroundColor Cyan
    & powershell -ExecutionPolicy Bypass -File "$ScriptDir\build.ps1"
    if ($LASTEXITCODE -ne 0) { Write-Error "Build failed."; exit 1 }
}

# ---- Elevation check for Machine scope ---------------------------------------
if ($Scope -eq "Machine") {
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
                [Security.Principal.WindowsBuiltInRole]::Administrator)
    if (-not $isAdmin) {
        Write-Host "Re-launching as Administrator for system-wide install..." -ForegroundColor Yellow
        $argList = "-ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`" -Scope Machine"
        Start-Process powershell -ArgumentList $argList -Verb RunAs -Wait
        exit $LASTEXITCODE
    }
}

# ---- Install files -----------------------------------------------------------
New-Item -ItemType Directory -Force -Path $INSTALL_DIR | Out-Null
Copy-Item "$ScriptDir\wmatrix.exe" "$INSTALL_DIR\wmatrix.exe" -Force
Write-Host "  Installed: $INSTALL_DIR\wmatrix.exe" -ForegroundColor DarkGray

# Bundle the DLL
$DLL = "$ScriptDir\libncursesw6.dll"
if (-not (Test-Path $DLL)) {
    # Try to locate from gcc
    $GCC = (Get-Command gcc -ErrorAction SilentlyContinue)
    if ($GCC) {
        $DLL = "$(Split-Path $GCC.Source)\libncursesw6.dll"
    }
}
if (Test-Path $DLL) {
    Copy-Item $DLL "$INSTALL_DIR\libncursesw6.dll" -Force
    Write-Host "  Installed: $INSTALL_DIR\libncursesw6.dll" -ForegroundColor DarkGray
} else {
    Write-Warning "libncursesw6.dll not found. wmatrix may fail to run unless MSYS2\ucrt64\bin is in PATH."
}

# ---- Update PATH -------------------------------------------------------------
$pathTarget = [System.EnvironmentVariableTarget]::$Scope
$currentPath = [System.Environment]::GetEnvironmentVariable("PATH", $pathTarget)
if ($currentPath -notlike "*$INSTALL_DIR*") {
    [System.Environment]::SetEnvironmentVariable("PATH", "$currentPath;$INSTALL_DIR", $pathTarget)
    Write-Host "  Added to $Scope PATH: $INSTALL_DIR" -ForegroundColor DarkGray
} else {
    Write-Host "  Already in PATH: $INSTALL_DIR" -ForegroundColor DarkGray
}

Write-Host ""
Write-Host "wmatrix installed successfully!" -ForegroundColor Green
Write-Host "Open a new terminal and run:  wmatrix" -ForegroundColor Cyan
Write-Host ""
Write-Host "Usage tips:"
Write-Host "  wmatrix              # classic green rain"
Write-Host "  wmatrix -C blue      # pick a color (red/blue/white/yellow/cyan/magenta)"
Write-Host "  wmatrix -b           # bold characters"
Write-Host "  wmatrix -B           # all bold"
Write-Host "  wmatrix -r           # rainbow mode"
Write-Host "  wmatrix -s           # screensaver (any key exits)"
Write-Host "  wmatrix -u 2         # speed (0=fast .. 10=slow)"
Write-Host "  wmatrix -h           # full help"
Write-Host ""
Write-Host "To uninstall:"
Write-Host "  powershell -ExecutionPolicy Bypass -File install.ps1 -Uninstall"
