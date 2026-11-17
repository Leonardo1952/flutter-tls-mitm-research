#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CERTS_DIR="$SCRIPT_DIR/certs"
CONFDIR="$SCRIPT_DIR/.mitmproxy-confdir"
ADDON="$SCRIPT_DIR/addons/tamper_quote.py"
PORT="${1:-8080}"

if [[ ! -f "$CERTS_DIR/mitmproxy-ca.pem" ]]; then
  echo "mitmproxy-ca.pem not found. Run ./generate-ca.sh first." >&2
  exit 1
fi

VENV_DIR="$SCRIPT_DIR/.venv"
if [[ ! -x "$VENV_DIR/bin/mitmdump" ]]; then
  echo "mitmproxy venv not found. Run ./setup-mitmproxy.sh once first (it creates the venv)." >&2
  exit 1
fi

mkdir -p "$CONFDIR"
cp "$CERTS_DIR/mitmproxy-ca.pem" "$CONFDIR/mitmproxy-ca.pem"

echo
echo "==> Starting mitmdump on port $PORT WITH the tampering addon"
echo "    (addons/tamper_quote.py — swaps the real quote for R\$ 1.00)"
echo
echo "    In the 'Rate Today' app, any of the 3 tabs will show the"
echo "    forged value, even though the real API is returning the"
echo "    correct value behind the scenes — the attacker decides what"
echo "    the app displays."
echo
echo "    Ctrl+C to stop."
echo

exec "$VENV_DIR/bin/mitmdump" --set confdir="$CONFDIR" -p "$PORT" -s "$ADDON"
