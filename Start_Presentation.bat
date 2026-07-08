@echo off
setlocal
cd /d "%~dp0"

echo ===================================================
echo   HikariSnowbell Presentation Launcher (USB Fix)
echo ===================================================

:: 1. Check if uv.exe is here
if not exist "uv.exe" (
    echo [ERROR] uv.exe not found in USB! 
    pause
    exit
)

:: 2. Force install extra tools to USB environment
echo [PROCESS] Preparing presentation tools (keyboard, requests)...
.\uv.exe add keyboard requests
.\uv.exe sync

:: 3. Launch Backend in another window
echo [PROCESS] Starting VTuber Backend...
start "Hikari_Backend" .\uv.exe run run_server.py

:: 4. Wait for server
echo [PROCESS] Waiting 15 seconds...
timeout /t 15

:: 5. Launch Controller
echo [PROCESS] Starting Controller...
echo.
echo ---------------------------------------------------
echo  PRESS [F8] to speak next line.
echo ---------------------------------------------------
echo.

.\uv.exe run present_hikari.py

pause
