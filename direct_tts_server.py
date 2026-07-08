import json
import time
from http.server import BaseHTTPRequestHandler, HTTPServer

class EchoAIHandler(BaseHTTPRequestHandler):
    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length)
        data = json.loads(post_data)
        
        # Get the text you typed in the chat box
        user_input = data['messages'][-1]['content']
        print(f"[REPEATING]: {user_input}")

        # Wrap it in Fake OpenAI Response
        response = {
            "id": "chatcmpl-fake",
            "object": "chat.completion",
            "created": int(time.time()),
            "model": "echo-mirror-model",
            "choices": [{
                "index": 0,
                "message": {"role": "assistant", "content": user_input},
                "finish_reason": "stop"
            }]
        }

        self.send_response(200)
        self.send_header('Content-Type', 'application/json')
        self.end_headers()
        self.wfile.write(json.dumps(response).encode('utf-8'))

    def do_OPTIONS(self): # Handle CORS
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type, Authorization')
        self.end_headers()

if __name__ == '__main__':
    print("Direct TTS Echo Server started at http://127.0.0.1:5000")
    print("HikariSnowbell will repeat whatever you type!")
    HTTPServer(('127.0.0.1', 5000), EchoAIHandler).serve_forever()
