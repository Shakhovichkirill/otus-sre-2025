from http.server import HTTPServer, BaseHTTPRequestHandler
import requests
import json
import time

class ISSExporterHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/metrics':
            try:
                data = self.get_iss_data()
                metrics = self.format_metrics(data)
                
                self.send_response(200)
                self.send_header('Content-Type', 'text/plain; version=0.0.4')
                self.end_headers()
                self.wfile.write(metrics.encode())
            except Exception as e:
                self.send_error(500, f"Error: {str(e)}")
        else:
            self.send_error(404, "Not Found")
    
    def get_iss_data(self):
        response = requests.get("http://api.open-notify.org/iss-now.json", timeout=10)
        response.raise_for_status()
        return response.json()
    
    def format_metrics(self, obj):
        timestamp = obj['timestamp']
        latitude = float(obj['iss_position']['latitude'])
        longitude = float(obj['iss_position']['longitude'])
        
        metrics = [
            f"# HELP iss_timestamp UNIX timestamp of ISS position data",
            f"# TYPE iss_timestamp gauge",
            f"iss_timestamp {timestamp}",
            f"# HELP iss_latitude Latitude coordinate of ISS",
            f"# TYPE iss_latitude gauge", 
            f"iss_latitude {latitude}",
            f"# HELP iss_longitude Longitude coordinate of ISS",
            f"# TYPE iss_longitude gauge",
            f"iss_longitude {longitude}"
        ]
        
        return "\n".join(metrics)

def run_server(port=8000):
    server = HTTPServer(('0.0.0.0', port), ISSExporterHandler)
    print(f"Starting ISS exporter on port {port}...")
    server.serve_forever()

if __name__ == "__main__":
    run_server()