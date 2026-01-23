import sys, time
from http.server import BaseHTTPRequestHandler, HTTPServer

port = int(sys.argv[1]) if len(sys.argv) > 1 else 8081
# Simulate latency if provided as 2nd argument (in seconds)
delay = float(sys.argv[2]) if len(sys.argv) > 2 else 0

class SimpleHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if delay > 0:
            time.sleep(delay)
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        response = f"Hello from Backend PORT {port}! (Simulated Latency: {delay}s)\n"
        self.wfile.write(response.encode())

server_address = ('', port)
httpd = HTTPServer(server_address, SimpleHandler)
print(f"Backend running on port {port} with delay {delay}s...")
httpd.serve_forever()