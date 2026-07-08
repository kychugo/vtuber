@echo off
set "UV_EXE=%~dp0uv.exe"

echo [1/2] Installing TTS dependencies...
"!UV_EXE!" pip install edge-tts keyboard

echo [2/2] Starting Speech Engine...
echo Press F9 to speak line by line.
"!UV_EXE!" run speak_engine.py
pause