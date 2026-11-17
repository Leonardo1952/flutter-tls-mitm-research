#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CERTS_DIR="$SCRIPT_DIR/certs"
mkdir -p "$CERTS_DIR"
cd "$CERTS_DIR"

echo "==> Generating test root CA (trust anchor)"
openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes \
  -keyout root-ca.key -out root-ca.crt \
  -subj "/C=BR/O=PoC Research/CN=PoC Root CA (lab)" \
  -addext "keyUsage=critical,keyCertSign,cRLSign"

echo "==> Generating test intermediate CA (stands in for the compromised CA)"
openssl req -newkey rsa:4096 -sha256 -nodes \
  -keyout intermediate-ca.key -out intermediate-ca.csr \
  -subj "/C=BR/O=PoC Research/CN=PoC Intermediate CA (simulates eMudhra, lab)"

cat > intermediate-ca.ext <<'EOF'
basicConstraints=critical,CA:TRUE,pathlen:0
keyUsage=critical,keyCertSign,cRLSign
EOF

openssl x509 -req -in intermediate-ca.csr \
  -CA root-ca.crt -CAkey root-ca.key -CAcreateserial \
  -days 1825 -sha256 -extfile intermediate-ca.ext \
  -out intermediate-ca.crt

rm -f intermediate-ca.csr intermediate-ca.ext

echo "==> Assembling mitmproxy-ca.pem (intermediate key + intermediate->root chain)"
cat intermediate-ca.key intermediate-ca.crt root-ca.crt > mitmproxy-ca.pem

echo
echo "Generated in: $CERTS_DIR"
ls -1 "$CERTS_DIR"
echo
echo "Next step: ./setup-mitmproxy.sh"
