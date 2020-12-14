#! /usr/bin/env bash
# gen-local-cert.sh
#
# uses mitmproxy CA for local testing only
#

openssl genrsa -out server.key 2048

openssl req -new -sha256 -key server.key \
    -reqexts v3_req -config certificate.conf \
    -out server.csr -subj "/C=US/ST=CA/O=Freepn/CN=localhost"

openssl x509 -sha256 -req -extfile certificate.conf -days 120 -in server.csr \
    -CA ~/.mitmproxy/mitmproxy-ca.pem \
    -CAkey ~/.mitmproxy/mitmproxy-ca.pem \
    -CAcreateserial -out server.crt

cat server.key server.crt >> server.pem
