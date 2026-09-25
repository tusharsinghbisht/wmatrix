<h1 align="center">wmatrix</h1>

<p align="center"><b>The Matrix digital rain in your terminal. Works natively on Windows and Linux.</b></p>

<p align="center">
  <a href="https://github.com/tusharsinghbisht/wmatrix/actions/workflows/build.yml">
    <img src="https://github.com/tusharsinghbisht/wmatrix/actions/workflows/build.yml/badge.svg" alt="build">
  </a>
  <a href="./COPYING">
    <img src="https://img.shields.io/github/license/tusharsinghbisht/wmatrix?color=blue" alt="license">
  </a>
  <img src="https://img.shields.io/badge/platform-windows%20%7C%20linux-green" alt="platforms">
</p>

---

## Contents

- [About](#about)
- [Install on Windows](#install-on-windows)
- [Install on Linux](#install-on-linux)
- [Usage](#usage)
- [Project layout](#project-layout)
- [Credits and inspiration](#credits-and-inspiration)
- [License](#license)

## About

wmatrix fills your terminal with the falling green characters from *The Matrix*.
Lines can scroll at the same rate or out of sync, at a speed you choose, in
any color (or all of them at once).

wmatrix is a port of [cmatrix](https://github.com/abishekvashok/cmatrix) that
also builds and runs natively on Windows (Windows Terminal, PowerShell,
cmd), using MSYS2's ncursesw. You don't need WSL or Cygwin. The same source
still builds on Linux with autotools or CMake.

> Not affiliated with *The Matrix*, Warner Bros. or any of its affiliates. Just fans.

## Install on Windows

### 1. Install the toolchain (one time)

Install [MSYS2](https://www.msys2.org/), then in the **MSYS2 UCRT64** shell:

```sh
pacman -S --needed mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-ncurses
```

Add `C:\msys64\ucrt64\bin` to your `PATH` so `gcc` is available from PowerShell.

### 2. Build

```powershell
git clone https://github.com/tusharsinghbisht/wmatrix.git
cd wmatrix
powershell -ExecutionPolicy Bypass -File build.ps1
.\wmatrix.exe
```

`build.ps1` produces `wmatrix.exe` and copies `libncursesw6.dll` next to it, so
the folder can be moved anywhere. If you prefer make:

```powershell
mingw32-make -f Makefile.win
```

### 3. Install (optional)

```powershell
# System-wide, to C:\Program Files\wmatrix (asks for admin)
powershell -ExecutionPolicy Bypass -File install.ps1

# Current user only, to %LOCALAPPDATA%\Programs\wmatrix (no admin)
powershell -ExecutionPolicy Bypass -File install.ps1 -Scope User

# Uninstall
powershell -ExecutionPolicy Bypass -File install.ps1 -Uninstall
```

The installer adds the install folder to your `PATH`. Open a new terminal and
run `wmatrix`.

## Install on Linux

### 1. Dependencies

```sh
# Debian / Ubuntu
sudo apt install build-essential autoconf automake libncurses-dev
# Fedora
sudo dnf install gcc make autoconf automake ncurses-devel
# Arch
sudo pacman -S base-devel ncurses
```

### 2a. Build with autotools

```sh
git clone https://github.com/tusharsinghbisht/wmatrix.git
cd wmatrix
autoreconf -i
./configure
make
sudo make install
```

### 2b. Or build with CMake

```sh
mkdir -p build && cd build
cmake ..                              # installs to /usr/local
# cmake -DCMAKE_INSTALL_PREFIX=/usr ..  # or to /usr
make
sudo make install
```

Both methods also install the man page (`man wmatrix`) and the optional matrix
console/X11 fonts used by `-l` and `-x`.

## Usage

```sh
wmatrix [-abBcfhlsmVxkrL] [-u delay] [-C color] [-M message] [-t tty]
```

| Flag | Effect |
|------|--------|
| `-a` | Asynchronous scroll |
| `-b` / `-B` | Some bold characters / all bold characters |
| `-n` | No bold characters (default) |
| `-u 0-10` | Update delay: 0 is fastest, default 4 |
| `-C color` | `green` (default), `red`, `blue`, `white`, `yellow`, `cyan`, `magenta`, `black` |
| `-r` | Rainbow mode |
| `-m` | Lambda mode |
| `-k` | Characters change while scrolling |
| `-o` | Old-style scrolling |
| `-c` | Japanese characters (needs a font that has them) |
| `-s` | Screensaver mode: exits on the first keystroke |
| `-L` | Lock mode |
| `-M text` | Show a message in the center of the screen |
| `-l` / `-x` | Linux console font / X11 `mtx.pcf` font mode (Linux only) |
| `-V` / `-h` | Version / help |

**Keys while running:** `a` toggle async, `b` / `B` / `n` bold modes,
`0`-`9` speed, `! @ # $ % ^ & )` switch color (red, green, yellow, blue,
magenta, cyan, white, black), `q` quit.

Some combinations to try:

```sh
wmatrix -ba -u 2 -C red   # fast red rain, async, with bold
wmatrix -lba              # closest to the movie (Linux console)
wmatrix -r                # rainbow
wmatrix -s                # screensaver
```

## Project layout

| Path | Purpose |
|------|---------|
| `wmatrix.c` | The whole program |
| `getopt.c` | Minimal `getopt` for Windows builds |
| `build.ps1`, `install.ps1`, `Makefile.win` | Windows build and install |
| `configure.ac`, `Makefile.am`, `CMakeLists.txt` | Linux build systems |
| `wmatrix.1` | Man page |
| `matrix.fnt`, `matrix.psf.gz`, `mtx.pcf` | Matrix console and X11 fonts |

## Credits and inspiration

wmatrix is inspired by and built on
**[cmatrix](https://github.com/abishekvashok/cmatrix)**, created by
**Chris Allegretta** and maintained by **Abishek V Ashok** and its
contributors. The core rain effect, fonts and man page come from cmatrix. wmatrix
adds native Windows support, Windows build and install scripts, and the
rebranding. Thanks also to everyone credited in the original cmatrix project.

## Contributing

Issues and pull requests are welcome. See [CONTRIBUTING.md](./CONTRIBUTING.md).

## License

GNU General Public License v3.0 or later. See [COPYING](./COPYING).
