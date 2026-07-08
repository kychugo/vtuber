@echo off
TITLE HikariSnowbell-Direct-TTS
SETLOCAL EnableDelayedExpansion
cd /d "%~dp0"

echo [1/4] Switching to Direct-TTS (Mirror) Config...
copy /y "direct_tts.yaml" "conf.yaml" >nul

echo [2/4] Checking environment...
where uv >nul 2>nul
if %ERRORLEVEL% neq 0 (
    powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.sh | iex"
    set "PATH=%USERPROFILE%\.local\bin;%PATH%"
)
uv sync

echo [3/4] Launching Echo AI Brain in background...
start /b uv run python direct_tts_server.py

echo [4/4] Starting HikariSnowbell (English-Maisie Mode)...
echo.
echo ====================================================
echo  DIRECT TTS MODE ENABLED
echo  Anything you type in the chat will be repeated!
echo  URL: http://127.0.0.1:12393
echo ====================================================
echo.

uv run run_server.py
pause
