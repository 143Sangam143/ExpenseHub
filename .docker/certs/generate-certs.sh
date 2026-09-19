#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CERT_DIR="$SCRIPT_DIR/generated"
mkdir -p "$CERT_DIR"

LAN_IP="${1:-}"

CA_KEY="$CERT_DIR/ca.key"
CA_CRT="$CERT_DIR/ca.crt"
SERVER_KEY="$CERT_DIR/server.key"
SERVER_CRT="$CERT_DIR/server.crt"
SERVER_CSR="$CERT_DIR/server.csr"
SAN_CONF="$CERT_DIR/san.cnf"

if [ ! -f "$CA_KEY" ] || [ ! -f "$CA_CRT" ]; then
    echo "==> Creating local Certificate Authority (valid 5 years)"
    openssl genrsa -out "$CA_KEY" 2048
    openssl req -x509 -new -nodes -key "$CA_KEY" -sha256 -days 1825 \
        -out "$CA_CRT" \
        -subj "/C=NP/ST=Bagmati/L=Patan/O=ExpenseHub/CN=ExpenseHub Local CA"
else
    echo "==> Reusing existing CA (delete ca.key/ca.crt in .docker/certs/generated to rotate)"
fi

echo "==> Issuing server certificate (localhost, 127.0.0.1${LAN_IP:+, $LAN_IP})"

{
    echo "[req]"
    echo "distinguished_name=req_distinguished_name"
    echo "prompt=no"
    echo "req_extensions=v3_req"
    echo "[req_distinguished_name]"
    echo "CN=localhost"
    echo "[v3_req]"
    echo "subjectAltName=@alt_names"
    echo "[alt_names]"
    echo "DNS.1=localhost"
    echo "IP.1=127.0.0.1"
    if [ -n "$LAN_IP" ]; then
        echo "IP.2=$LAN_IP"
    fi
} > "$SAN_CONF"

openssl genrsa -out "$SERVER_KEY" 2048
openssl req -new -key "$SERVER_KEY" -out "$SERVER_CSR" -config "$SAN_CONF"
openssl x509 -req -in "$SERVER_CSR" -CA "$CA_CRT" -CAkey "$CA_KEY" -CAcreateserial \
    -out "$SERVER_CRT" -days 397 -sha256 -extensions v3_req -extfile "$SAN_CONF"

rm -f "$SERVER_CSR" "$SAN_CONF"

echo ""
echo "Done. Certs in: $CERT_DIR"
echo "  Import ONCE into your browser/OS trust store: ca.crt"
echo "  Used automatically by nginx: server.crt, server.key"