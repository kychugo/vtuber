@echo off
title HikariSnowbell 雪鈴緋光 - 全自動啟動工具
setlocal enabledelayedexpansion

:: 1. 自動偵測目前路徑
set "BASE_DIR=%~dp0"
cd /d "%BASE_DIR%"

echo ========================================
echo   HikariSnowbell 雪鈴緋光 正在準備中喵...
echo ========================================
echo 目前路徑: %BASE_DIR%

:: 2. 自動檢查 uv 是否存在，唔存在就幫主人裝埋佢
where uv >nul 2>nul
if %errorlevel% neq 0 (
    echo [!] 搵唔到 uv，雪鈴緋光而家幫主人裝埋佢喵！
    echo 正在從網上抓取 uv 安裝程式...
    powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
    
    :: 安裝完之後要手動將 uv 加入臨時路徑，否則呢個視窗會認唔到
    set "PATH=%USERPROFILE%\.local\bin;%PATH%"
    echo [OK] uv 安裝完成喵！
) else (
    echo [OK] 偵測到 uv 已經準備好喇喵。
)

:: 3. 自動載入 USB 入面嘅 Portable Git
:: 假設 git 資料夾同 Open-LLM-VTuber 資料夾係並排擺放
set "GIT_PATH=%BASE_DIR%..\git\bin"
if exist "%GIT_PATH%\git.exe" (
    set "PATH=%GIT_PATH%;%PATH%"
    echo [OK] 已偵測並載入隨身 Git
) else (
    echo [!] 警告: 搵唔到隨身 Git，可能導致前端下載失敗喵。
)

:: 4. 解決之前嘅 Git 安全權限問題
if exist "%GIT_PATH%\git.exe" (
    "%GIT_PATH%\git.exe" config --global --add safe.directory "%BASE_DIR:\=/%" >nul 2>&1
)

:: 5. 執行環境同步
echo 正在幫主人檢查零件 (uv sync)...
call uv sync

:: 6. 正式啟動
echo ========================================
echo   啟動成功喵！主人請打開 Chrome 瀏覽器:
echo   http://127.0.0.1:12393
echo ========================================
call uv run run_server.py

pause
