import keyboard, requests, json, os, time
from urllib.parse import quote

# 讀取腳本
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
with open(os.path.join(BASE_DIR, "script.json"), 'r', encoding='utf-8') as f:
    script_lines = json.load(f)

current_line = 0

def speak_next():
    global current_line
    if current_line < len(script_lines):
        text = script_lines[current_line]
        print(f"Speaking: {text}")
        requests.post("http://127.0.0.1:9999/speak", json={"text": text})
        current_line += 1

keyboard.add_hotkey('f9', speak_next)
keyboard.wait('esc')