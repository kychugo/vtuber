
# Hikari Snowbell X Open-LLM-VTuber 用家使用及技術指南

## 目錄
- [第一部分：用家操作指南](#第一部分用家操作指南)
  - [1. 平台開啟與設定教學](#1-平台開啟與設定教學)
  - [2. 用家操作與常見問題故障排除](#2-用家操作與常見問題故障排除)
- [第二部分：技術員操作指南](#第二部分技術員操作指南)
  - [1. Cloudflare Zero Trust (Public Hostnames) 設定教學](#1-cloudflare-zero-trust-public-hostnames-設定教學)
  - [2. AI API (利用Ollama localhost)技術文件與 cURL示範](#2-ai-api-利用ollama-localhost技術文件與-curl示範)
- [第三部分：其他資源](#第三部分其他資源)
- [第四部分：致謝](#第四部分致謝)
- [授權條款 (License)](#授權條款-license)

---

# 第一部分：用家操作指南

## 1. 平台開啟與設定教學

### 1.1 本地電腦使用 (Local Desktop Edition)

本地版本適用於在單機環境下直接執行，不需任何額外網絡或 API 設定。

1. **啟動後端服務**：雙擊打開 `Snowbell.bat` 檔以啟動平台後端服務。
2. **選擇語言**：在 Terminal 介面選擇語言（中文或英文），**建議選擇英文**以達致最佳運行效果。
3. **開啟前端應用程式**：等待後端載入，直至 Terminal 顯示以下提示字樣後，打開 `open-llm-vtuber-electron` 應用程式：
   ```text
   Uvicorn running on http://127.0.0.1:12393 (Press CTRL+C to quit)
   ```
   * **注意事項**：請務必檢查系統工作列（System Tray），確保**只開啟一個** `open-llm-vtuber-electron` 應用程式實例，否則會引發聲音重複問題。
4. **關閉咪高峰**：開啟程式後，請**立即點擊關閉咪高峰**，以免環境雜音引致 AI 意外觸發回應。

### 1.2 互聯網網絡使用 (vtuber.hugow.dev)

透過瀏覽器訪問網頁版時，需要配置 WebSocket 與 Base URL 連線參數。

* **網址**：[https://vtuber.hugow.dev](https://vtuber.hugow.dev)

#### 方法 A：Console Code 自動填寫設定（推薦）

1. 使用瀏覽器開啟 [https://vtuber.hugow.dev](https://vtuber.hugow.dev)
2. 按 `F12`（或右鍵點擊選擇「檢查 / Inspect」），切換至 **Console** 頁籤。
3. 貼上以下代碼並按 Enter 執行：
   * 連結：[Console Code 腳本](https://github.com/kychugo/vtuber/blob/f2805cc1a4db7ff3d627cca82d421b74cb2d34ff/useful%20resources/Console%20code)

#### 方法 B：人手輸入設定

若不使用自動腳本，請在頁面設定欄位手動填入以下內容並儲存：

* **WebSocket 地址 / WebSocket URL**：`wss://vtuber.hugow.dev/client-ws`
* **基礎 URL / Base URL**：`https://vtuber.hugow.dev`
* **動作**：填寫完成後點擊「保存」/「Save」按鈕。

---

## 2. 用家操作與常見問題故障排除
<img width="1020" height="540" alt="image" src="https://github.com/user-attachments/assets/ab2b07c0-c829-4a27-8ae7-4bb73e3661ca" />

### 2.1 介面常用功能

* **開關咪高峰**：控制是否進行語音輸入收聽。
* **暫停當前 AI 回應**：中斷 AI 目前正在進行的語音朗讀或文字生成。
* **模式切換**：可切換「普通模式」與「桌面寵物模式 (Pet Mode)」。

### 2.2 常見問題與解決方案

#### 1. 聲音重複 / 雙重語音問題
* **原因**：背景開啓了多個 Electron 實例。
* **解決方法**：按下工作列右下角 `^` (顯示隱藏圖示) 按鈕，檢查是否有多個 `open-llm-vtuber-Electron.exe` 在運行。若超過 1 個，請全部關閉，僅保留 1 個後重試。

#### 2. 桌面寵物模式 (Pet Mode) 出現嚴重延遲 / 影音不同步
* **步驟一：NVIDIA 控制面板設定**
  1. 開啟 NVIDIA 控制面板 → 進入「程式設定」 → 新增 `open-llm-vtuber-electron.exe`。
  2. 將「垂直同步」設為 **關閉**。
  3. 將「畫面播放速率上限」設為 **60 FPS**。
  4. 電源管理模式設為 **慣用最大效能**。
* **步驟二：Windows 圖形設定**
  1. 在 Windows 搜尋欄輸入並開啟「圖形設定」。
  2. 新增 `open-llm-vtuber-electron.exe`，並將效能偏好設為 **「高效能」(如 RTX 3060)**。

---

# 第二部分：技術員操作指南

## 1. Cloudflare Zero Trust (Public Hostnames) 設定教學

本指南說明如何透過 Cloudflare 的圖像化介面 (Dashboard)，以最簡單直接的方式穿透本地服務，無須於電腦輸入複雜指令。

### 1.1 了解 Cloudflare Zero Trust 架構優勢

| 比較項目 | 傳統方法 (Port Forwarding + DDNS) | Cloudflare Zero Trust (Public Hostnames) |
| :--- | :--- | :--- |
| **公網 IP 暴露** | 需要開放 Router Port (80/443)，公網 IP 完全暴露 | **無須開放任何 Inbound Port**，有效隱藏源站 IP |
| **設定方式** | 需手動於 Router 設定及配置憑證 | **全網頁圖像化介面 (Dashboard) 點擊設定** |
| **動態 IP 處理** | 依賴 DDNS 腳本，IP 變更時可能造成暫時性斷線 | **長連接隧道**，家用網絡 IP 變更不影響服務 |
| **網絡安全** | 直接面臨公網 Port 掃描與 DDoS 攻擊風險 | **內建 Cloudflare DDoS 防護、WAF 與 Zero Trust 存取控制** |
| **WebSocket 支持**| 需要手動配置 Nginx / Reverse Proxy Header | **原生支援 HTTP/2、HTTP/3 及 WebSocket (wss://)** |

### 1.2 設定 Public Hostnames

只要你在本機電腦已安裝並運行 `cloudflared`，便可直接登入 Cloudflare 網站進行以下圖形化設定，將本地服務暴露至互聯網。

1. **登入 Cloudflare 儀表板**：前往 Cloudflare Dashboard (dash.cloudflare.com) 並登入帳戶。
2. **進入 Zero Trust 頁面**：於左側選單點擊 **Zero Trust**。
3. **管理現有 Tunnel**：
   * 展開左側的 **Networks**，點擊 **Tunnels**。
   * 在列表中找到你正在運行的 Tunnel，點擊右側的 **Configure**。
4. **新增 Public Hostname**：
   * 切換至頂部的 **Public Hostname** 頁籤。
   * 點擊 **Add a public hostname** 按鈕。
5. **填寫路由設定 (Routing)**：於設定頁面，按需求填寫以下欄位以穿透不同服務：

   **(A) 設定 VTuber 前端 (vtuber.hugow.dev)**
   * **Subdomain**: `vtuber`
   * **Domain**: 選擇你的主網域 (例如 `hugow.dev`)
   * **Service Type**: `HTTP`
   * **Service URL**: `localhost:12393`
   * 點擊右下角 **Save hostname** 儲存。

   **(B) 設定 Ollama AI API (ollama.hugow.dev)**
   * **Subdomain**: `ollama`
   * **Domain**: 選擇你的主網域 (例如 `hugow.dev`)
   * **Service Type**: `HTTP`
   * **Service URL**: `localhost:11434`
   * 點擊右下角 **Save hostname** 儲存。

6. **完成設定**：儲存後，Cloudflare 會自動更新 DNS 紀錄並將外部流量安全地路由至你的本機端口。你現在可以在瀏覽器訪問 `https://vtuber.hugow.dev` 或呼叫 `https://ollama.hugow.dev` API。

---

## 2. AI API (利用Ollama localhost)技術文件與 cURL示範

`ollama.hugow.dev` 作為系統的 Ollama 網關，提供 RESTful API 以供前端或後端服務進行文本生成與對話互動。

* **Base URL**: `https://ollama.hugow.dev` (指向 `http://localhost:11434`)
* **Header**: `Content-Type: application/json`

詳細文檔：[Ollama API 說明文件](https://github.com/kychugo/vtuber/blob/main/useful%20resources/Ollama.md)

---

# 第三部分：其他資源

## 1. Nizima LIVE
* **功能簡介：** 一款專為 Live2D 模型設計的即時表情與動作追蹤應用程式，只需普通攝影機即可順暢驅動虛擬形象。
* **主要特點：**
  * 簡易追蹤：支援高精度的面部捕捉與動態對應，不需複雜的外設。
  * 內置豐富資源：搭載超過 100 種預設特效與道具。
  * 多人聯動：支援最多 8 人同時連線的聯動功能，適合協同直播或互動。

## 2. VTuber Studio
* **功能簡介：** 業界主流的 Live2D 虛擬主播（VTuber）即時動畫與追蹤軟體，提供全方位的虛擬形象管理方案。
* **主要特點：**
  * 跨平台與多樣化追蹤：支援電腦網絡攝影機、iOS 及 Android 裝置。
  * 即時唇音同步：可透過麥克風音量與語音頻率分析，自動讓模型的嘴型與聲音同步。
  * 強大的 API 支援：具備完善的 WebSocket API 擴充能力，便於與外部程式進行深度聯動與自訂插件開發。

## 3. OBS Studio (Open Broadcaster Software)
* **功能簡介：** 免費且開源的專業級視訊錄製與直播串流軟體，廣泛應用於各大平台的內容創作。
* **主要特點：**
  * 多來源畫面合成：支援同時捕捉多個來源，包含螢幕畫面、視窗、遊戲擷取、網頁來源及視訊鏡頭等。
  * 高品質直播與錄影：提供多種高效能編碼選項，確保直播與影片輸出流暢且畫質清晰。
  * 音訊混音器：內建強大的音訊處理與雜音抑制功能，可獨立調整各個音源的輸出。

---

# 第四部分：致謝

本項目的順利完成，要特別感謝以下單位、導師及夥伴的鼎力支持與協助：

**1. 技術架構與開源貢獻**
本系統基於開源專案 [Open-LLM-VTuber](https://github.com/Open-LLM-VTuber/Open-LLM-VTuber) 進行二次開發與優化，結合了人工智能與即時語音互動技術，建構出流暢的虛擬主播互動體驗。

**2. 指導老師與資源支援**
本專案有幸蒙受 李煒烈老師 的悉心指導，並在專案進行期間提供關鍵的資源與寶貴建議，讓團隊得以克服多項開發難關，使系統得以順利落地。

**3. 專案團隊與核心設計**
本專案由中華基督教會基元中學四位學生（黃子謙、黃樂謠、林晞彤、林恩昊）共同協力開發。

**4. 美術與模型**
專案的模型製作特別鳴謝來自台灣的 VTuber 模型師 Momo，為 Hikari Snowbell 打造出精緻且生動的外觀造型。

衷心感謝所有在過程中給予協助、啟發與支持的每一位師長與夥伴！

<img width="756" height="812" alt="image" src="https://github.com/user-attachments/assets/862434da-c5c4-4627-b679-f542a6d92fbb" />

---

# 授權條款 (License)

MIT License

Copyright (c) 2026 Hugo Wong

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
