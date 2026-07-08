@echo off
TITLE HikariSnowbell VTuber Launcher
SETLOCAL EnableDelayedExpansion

:: 1. Auto detect current directory
cd /d "%~dp0"
echo ====================================================
echo  HikariSnowbell  Launcher
echo ====================================================
echo Current Path: %~dp0

:: 2. Check if uv is installed
echo [PROCESS] Checking for 'uv' package manager...
where uv >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo [INFO] 'uv' not found. Installing 'uv' now...
    powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
    :: Add uv to current session PATH
    set "PATH=%USERPROFILE%\.local\bin;%PATH%"
) else (
    echo [SUCCESS] 'uv' is already installed.
)

:: 3. Synchronize Python environment
echo.
echo [PROCESS] Synchronizing dependencies... This may take a moment...
uv sync
if %ERRORLEVEL% neq 0 (
    echo [ERROR] uv sync failed. Please check your internet connection.
    pause
    exit /b
)

:: 4. Final instructions and Launch
echo.
echo ====================================================
echo  Everything is ready! 
echo.
echo  1. Wait for the server to start below.
echo  2. Open Chrome browser.
echo  3. Go to the following URL:
echo.
echo  URL: http://127.0.0.1:12393
echo.
echo ====================================================
echo.

:: Run the server
uv run run_server.py

:: If the server stops, keep the window open to show error messages
echo.
echo [INFO] Server has stopped.
pause
