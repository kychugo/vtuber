import keyboard
import time
import json
import os

# 設定路徑
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
JSON_PATH = os.path.join(BASE_DIR, "script.json")

def load_script():
    with open(JSON_PATH, 'r', encoding='utf-8') as f:
        return json.load(f)

script_lines = load_script()
current_line = 0

def speak_next():
    global current_line
    if current_line < len(script_lines):
        text = script_lines[current_line]
        print(f"\n[ Sending Line {current_line + 1}/{len(script_lines)} ]")
        
        # 模擬輸入：先點擊一下，再輸入，再發送
        # keyboard.write 會極速打字，App 會收到
        keyboard.write(text)
        time.sleep(0.3) # 俾 App 嘅緩衝時間
        keyboard.press_and_release('enter')
        
        current_line += 1
    else:
        print("\n[ Finish ] End of script!")

print("=== Hikari Portable Presenter (App Mode) ===")
print("1. Open the VTuber App and click on the Input Box.")
print("2. Press [F9] to auto-type and send.")
print("============================================")

keyboard.add_hotkey('f9', speak_next)
keyboard.wait('esc')