#!/usr/bin/python
#
# uses combined cert/key pem file:
#    openssl req -new -x509 -keyout server.pem -out server.pem -days 365 -nodes
# run as follows:
#    python simple-https-server.py
# then in your browser, visit:
#    https://localhost:8443
#

import os
import argparse
import http.server
import socketserver
import ssl

parser = argparse.ArgumentParser(description='')
parser.add_argument('--host', dest='host', default='127.0.0.1')
parser.add_argument('--port', dest='port', type=int, default=8443)
parser.add_argument('--doc-root', dest='root', default='.')
parser.add_argument('--cert-path', dest='cert', default='.')
args = parser.parse_args()

server_host = args.host
server_port = args.port
document_root = args.root
cert_path = args.cert
cert = os.path.join(cert_path, 'server.pem')

httpd = socketserver.TCPServer((server_host, server_port),
                               http.server.SimpleHTTPRequestHandler)

httpd.socket = ssl.wrap_socket(httpd.socket,
                               certfile=cert,
                               server_side=True,
                               ca_certs=None,
                               ssl_version=ssl.PROTOCOL_TLS)

if document_root != '.':
    os.chdir(document_root)

separator = "-" * 60
print(separator)
print("Server https://{}:{} serving content from {}".format(server_host,
                                                            server_port,
                                                            document_root))
print(separator)


try:
    httpd.serve_forever()
except KeyboardInterrupt:
    print("")
    print("Exiting ...")
    httpd.shutdown()
    httpd.socket.close()
