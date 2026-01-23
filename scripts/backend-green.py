import sys
from http.server import BaseHTTPRequestHandler, HTTPServer

port = int(sys.argv[1]) if len(sys.argv) > 1 else 8084

class SimpleHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.send_header('X-Environment', 'Green')
        self.end_headers()
        response = f"Hello from the GREEN Environment running on PORT {port}!\n"
        self.wfile.write(response.encode())

server_address = ('', port)
httpd = HTTPServer(server_address, SimpleHandler)
print(f"Green Backend running on port {port}...")
httpd.serve_forever()

