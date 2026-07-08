from fastapi import FastAPI, Request
import uvicorn
import asyncio
from src.open_llm_vtuber.tts.edge_tts import EdgeTTS
import yaml

# 讀取你的設定
with open("conf.yaml", "r", encoding="utf-8") as f:
    config = yaml.safe_load(f)

# 初始化 EdgeTTS (從 conf.yaml 讀取 voice 設定)
tts_engine = EdgeTTS(config['character_config']['tts_config']['edge_tts']['voice'])

app = FastAPI()

@app.post("/speak")
async def speak(request: Request):
    data = await request.json()
    text = data.get("text", "")
    print(f"Direct TTS: {text}")
    
    # 執行 TTS
    await tts_engine.generate_audio(text)
    return {"status": "success"}

if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=9999)