#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CERTS_DIR="$SCRIPT_DIR/certs"
CONFDIR="$SCRIPT_DIR/.mitmproxy-confdir"
PORT="${1:-8080}"

if [[ ! -f "$CERTS_DIR/mitmproxy-ca.pem" ]]; then
  echo "mitmproxy-ca.pem not found. Run ./generate-ca.sh first." >&2
  exit 1
fi

VENV_DIR="$SCRIPT_DIR/.venv"
if [[ ! -x "$VENV_DIR/bin/mitmdump" ]]; then
  echo "==> mitmproxy not found, creating isolated venv at $VENV_DIR"
  python3 -m venv "$VENV_DIR"
  "$VENV_DIR/bin/pip" install --upgrade pip >/dev/null
  "$VENV_DIR/bin/pip" install mitmproxy
  "$VENV_DIR/bin/pip" install "werkzeug==2.0.3" "itsdangerous==2.0.1"
fi
MITMDUMP="$VENV_DIR/bin/mitmdump"

mkdir -p "$CONFDIR"
cp "$CERTS_DIR/mitmproxy-ca.pem" "$CONFDIR/mitmproxy-ca.pem"

echo
echo "==> Starting mitmdump on port $PORT, using our intermediate CA"
echo "    confdir: $CONFDIR"
echo
echo "    Point the test app/emulator/OS at this host on port $PORT"
echo "    (e.g. on the Android emulator, 10.0.2.2:$PORT is the host machine)."
echo
echo "    Ctrl+C to stop."
echo

exec "$MITMDUMP" --set confdir="$CONFDIR" -p "$PORT"
