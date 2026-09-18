# Ollama 本地 AI API 技術文件與 cURL 示範

本文件詳細說明如何透過主機上的 Ollama 本地服務（`localhost`），使用標準 RESTful API 進行模型查詢、多輪對話及文字生成。

---

## 1. 基礎設定與連線資訊

* **基礎連接網址 (Base URL)**: `http://localhost:11434`
* **請求標頭 (Headers)**: `Content-Type: application/json`

---

## 2. API 接口與 cURL 示範

### 2.1 檢查本機模型列表 (List Local Models)
* **請求方法 (Method)**: `GET`
* **路徑 (Path)**: `/api/tags`
* **說明**: 用於檢索當前 Ollama 服務中已經下載並隨時可用的 AI 模型清單。

**cURL 示範**:
```bash
curl -X GET http://localhost:11434/api/tags
```

---

### 2.2 多輪對話生成 (Chat Completion)
* **請求方法 (Method)**: `POST`
* **路徑 (Path)**: `/api/chat`
* **說明**: 支援系統提示詞（System Prompt）、歷史對話上下文（Messages）以及串流（Streaming）即時回應。

#### 示範 A：非流式完整回應 (Non-Streaming)
```bash
curl -X POST http://localhost:11434/api/chat \
  -H "Content-Type: application/json" \
  -d '{
    "model": "qwen2.5:7b",
    "messages": [
      {
        "role": "system",
        "content": "你是一個專業且親切的繁體中文 AI 助手。"
      },
      {
        "role": "user",
        "content": "你好！請用一句話介紹你自己。"
      }
    ],
    "stream": false
  }'
```

#### 示範 B：即時串流回應 (Streaming)
```bash
curl -X POST http://localhost:11434/api/chat \
  -H "Content-Type: application/json" \
  -d '{
    "model": "qwen2.5:7b",
    "messages": [
      {
        "role": "user",
        "content": "請寫一首關於人工智能的短詩。"
      }
    ],
    "stream": true
  }'
```

---

### 2.3 單次提示詞文字生成 (Generate Completion)
* **請求方法 (Method)**: `POST`
* **路徑 (Path)**: `/api/generate`
* **說明**: 適用於單次 Prompt 輸入的文字補全任務。

**cURL 示範**:
```bash
curl -X POST http://localhost:11434/api/generate \
  -H "Content-Type: application/json" \
  -d '{
    "model": "qwen2.5:7b",
    "prompt": "請解釋什麼是機器學習。",
    "stream": false
  }'
```

---

## 3. OpenAI 相容介面支援

Ollama 同時原生兼容 OpenAI 的 API 格式，若你要對接支援 OpenAI 的第三方軟件或客戶端，可直接使用以下設定：

* **API 基礎網址**: `http://localhost:11434/v1`
* **API 金鑰 (API Key)**: 可隨意填寫（例如 `ollama`）
