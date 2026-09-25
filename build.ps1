# build.ps1 - Build wmatrix for Windows using MinGW/MSYS2 gcc + ncursesw
# Run from the wmatrix project directory:
#   powershell -ExecutionPolicy Bypass -File build.ps1

$ErrorActionPreference = "Stop"

$GCC = (Get-Command gcc -ErrorAction SilentlyContinue)
if (-not $GCC) {
    Write-Error "gcc not found in PATH. Install MSYS2 and add ucrt64\bin to PATH."
    exit 1
}
$GCC = $GCC.Source

$MSYS2_BIN  = Split-Path $GCC
$MSYS2_ROOT = Split-Path $MSYS2_BIN
$CURSES_INC = "$MSYS2_ROOT\include\ncursesw"
$CURSES_LIB = "$MSYS2_ROOT\lib"
$CURSES_BIN = $MSYS2_BIN

if (-not (Test-Path "$CURSES_INC\ncurses.h")) {
    Write-Error "ncursesw headers not found at $CURSES_INC`nInstall with: pacman -S mingw-w64-ucrt-x86_64-ncurses"
    exit 1
}

$Version = "2.0"
Write-Host "Building wmatrix $Version for Windows..." -ForegroundColor Cyan

$ScriptDir = Split-Path $MyInvocation.MyCommand.Path

& gcc "-DEXCLUDE_CONFIG_H" "-DVERSION=`"$Version`"" "-D_WIN32" `
    "-I$CURSES_INC" "-Wall" "-O2" `
    "-o" "$ScriptDir\wmatrix.exe" `
    "$ScriptDir\wmatrix.c" "$ScriptDir\getopt.c" `
    "-L$CURSES_LIB" "-lncursesw"

if ($LASTEXITCODE -ne 0) {
    Write-Error "Build failed."
    exit 1
}

$DLL = "$CURSES_BIN\libncursesw6.dll"
if (Test-Path $DLL) {
    Copy-Item $DLL "$ScriptDir\libncursesw6.dll" -Force
    Write-Host "  Bundled: libncursesw6.dll" -ForegroundColor DarkGray
}

Write-Host "Build successful: wmatrix.exe" -ForegroundColor Green
Write-Host ""
Write-Host "Run it now:  .\wmatrix.exe"
Write-Host "Install it:  powershell -ExecutionPolicy Bypass -File install.ps1"
