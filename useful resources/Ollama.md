Open-LLM-VTuber 系統 Ollama 本地 API 技術文件與 cURL 示範
本技術文件專門說明如何將本地運行的 Ollama (localhost:11434) 作為 LLM 推理網關，並透過 ollama.hugow.dev 網址提供標準的 RESTful API，供前端介面或後端程式進行文本生成與對話互動。
 * Base URL: [https://ollama.hugow.dev](https://ollama.hugow.dev)
 * Request Header: Content-Type: application/json
1. 取得現有模型列表 (List Local Models)
此接口用於檢查目前主機上已經下載及安裝好的所有本地模型資訊。
 * HTTP Method: GET
 * Path: /api/tags
 * cURL 示範：
curl -X GET https://ollama.hugow.dev/api/tags

2. 多輪對話生成 (Chat Completion)
此接口支援多輪對話與上下文记忆，同時支援流式（Streaming）及非流式（Non-Streaming）的 JSON 回應模式。
 * HTTP Method: POST
 * Path: /api/chat
cURL 示範 (非流式回應 Non-Streaming)：
curl -X POST https://ollama.hugow.dev/api/chat \
  -H "Content-Type: application/json" \
  -d '{
    "model": "qwen2.5:7b",
    "messages": [
      {
        "role": "system",
        "content": "你是一個熱心且有禮貌的 AI 助手。"
      },
      {
        "role": "user",
        "content": "你好！請用一封短句介紹你自己。"
      }
    ],
    "stream": false
  }'

cURL 示範 (流式回應 Streaming)：
curl -X POST https://ollama.hugow.dev/api/chat \
  -H "Content-Type: application/json" \
  -d '{
    "model": "qwen2.5:7b",
    "messages": [
      {
        "role": "user",
        "content": "請寫一個關於程式開發的短篇故事。"
      }
    ],
    "stream": true
  }'

3. 單次 Prompt 文字生成 (Generate Completion)
此接口適用於單次提示詞的純文字補全與生成任務，無須維護複雜的對話歷史紀錄。
 * HTTP Method: POST
 * Path: /api/generate
 * cURL 示範：
curl -X POST https://ollama.hugow.dev/api/generate \
  -H "Content-Type: application/json" \
  -d '{
    "model": "qwen2.5:7b",
    "prompt": "為什麼天空是藍色的？",
    "stream": false
  }'

