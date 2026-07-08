@echo off
TITLE Hikari Presentation Master
SETLOCAL EnableDelayedExpansion

:: 1. Detect Path
cd /d "%~dp0"
echo [INFO] Working Directory: %~dp0

:: 2. Check/Install uv
where uv >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo [INFO] Installing UV manager...
    powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
    set "PATH=%USERPROFILE%\.local\bin;%PATH%"
)

:: 3. Prepare Config (Use English Config)
echo [INFO] Setting up English Configuration...
if exist "conf-eng.yaml" (
    copy /y "conf-eng.yaml" "conf.yaml"
) else (
    echo [WARNING] conf-eng.yaml not found! Using default conf.yaml
)

:: 4. Sync Dependencies
echo [INFO] Syncing Python environment...
uv sync
:: Install extra presentation libraries
uv pip install keyboard requests

:: 5. Launch VTuber Server (in a new minimized window)
echo [INFO] Starting VTuber Server...
start /min "Hikari Server" uv run run_server.py

:: 6. Wait for server to warm up
echo [PROCESS] Waiting 15 seconds for AI to wake up...
timeout /t 15

:: 7. Launch Presentation Controller
echo [SUCCESS] Everything is ready!
echo.
echo ===================================================
echo   HIKARI SNOWBELL PRESENTATION MODE
echo ===================================================
echo   1. VTuber is running in the background.
echo   2. Switch to Chrome and enable PET MODE (桌寵模式).
echo   3. Open your PowerPoint Fullscreen.
echo   4. PRESS [F8] to play the next part of the script.
echo   5. You can see the current line below.
echo ===================================================
echo.

uv run present_hikari.py

pause