@echo off
TITLE HikariSnowbell Ultimate Portable Launcher
SETLOCAL EnableDelayedExpansion

:: 1. Auto detect path
cd /d "%~dp0"
echo [1/4] Detecting USB Environment...
set "UV_EXE=%~dp0uv.exe"

if not exist "!UV_EXE!" (
    echo [ERROR] uv.exe not found in %~dp0
    echo Please put uv.exe into the folder first!
    pause
    exit
)

:: 2. Sync VTuber Dependencies
echo [2/4] Checking VTuber Dependencies (uv sync)...
"!UV_EXE!" sync

:: 3. Install Presentation Script Libraries (if missing)
echo [3/4] Ensuring Presentation Libraries (keyboard, requests)...
"!UV_EXE!" pip install keyboard requests

:: 4. Start Everything
echo.
echo ====================================================
echo  HIKARI SNOWBELL IS READY!
echo.
echo  - VTuber Server will run in a NEW window.
echo  - Presentation Controller will run in THIS window.
echo.
echo  HOTKEYS:
echo  [F9]  : Speak Next Presentation Line
echo  [ESC] : Stop Controller
echo ====================================================
echo.

:: Start the VTuber Backend in another window
start "Hikari VTuber Backend" "!UV_EXE!" run run_server.py

:: Give the server some time to wake up
echo Waiting for server to initialize...
timeout /t 5

:: Start the Presentation Controller in current window
"!UV_EXE!" run present_hikari.py

pause