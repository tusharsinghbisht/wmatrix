# Contributing to wmatrix

Thanks for helping out. Bug reports, feature ideas and pull requests are welcome.

## Reporting bugs

Open an issue and include:

- your OS and terminal (for example Windows 11 + Windows Terminal, or Ubuntu 24.04 + GNOME Terminal)
- how you built it (`build.ps1`, `Makefile.win`, autotools or CMake)
- the exact command you ran and what you saw

## Pull requests

1. Fork the repo and create a branch from `main`.
2. Keep changes working on **both** Windows and Linux. Put platform-specific code
   behind `#ifdef _WIN32`.
3. Build it locally:
   - Windows: `powershell -ExecutionPolicy Bypass -File build.ps1`
   - Linux: `autoreconf -i && ./configure && make` or CMake
4. If you change flags or behavior, update `README.md` and `wmatrix.1`.
5. Open the PR. CI builds on Linux (autotools + CMake) and Windows (MSYS2) must pass.
