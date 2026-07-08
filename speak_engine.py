import asyncio
import edge_tts
import sys
import json
import os
import keyboard

# 設定你的語音 (廣東話)
VOICE = "zh-HK-HiuGaaiNeural"
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
SCRIPT_PATH = os.path.join(BASE_DIR, "script.json")

async def tts_speak(text):
    # 直接呼叫 edge-tts，生成並播放
    communicate = edge_tts.Communicate(text, VOICE)
    await communicate.save("temp.mp3")
    # 使用 windows 播放指令
    os.system("start /min wmplayer /play /close temp.mp3")

def load_script():
    with open(SCRIPT_PATH, 'r', encoding='utf-8') as f:
        return json.load(f)

script = load_script()
index = 0

def trigger():
    global index
    if index < len(script):
        print(f"Speaking: {script[index]}")
        asyncio.run(tts_speak(script[index]))
        index += 1

keyboard.add_hotkey('f9', trigger)
print("F9 ready to speak. Press ESC to exit.")
keyboard.wait('esc')