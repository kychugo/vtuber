@echo off
TITLE HikariSnowbell-Chinese
SETLOCAL EnableDelayedExpansion
cd /d "%~dp0"

echo [1/3] Switching to Chinese (HiuGaai) Config...
copy /y "conf-chin.yaml" "conf.yaml" >nul

echo [2/3] Checking uv environment...
where uv >nul 2>nul
if %ERRORLEVEL% neq 0 (
    powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
    set "PATH=%USERPROFILE%\.local\bin;%PATH%"
)
uv sync

echo [3/3] Starting HikariSnowbell (Chinese-HiuGaai)...
echo URL: http://127.0.0.1:12393
echo.
uv run run_server.py
pause