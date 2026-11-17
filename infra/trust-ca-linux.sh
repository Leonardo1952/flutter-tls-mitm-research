#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_CRT="$SCRIPT_DIR/certs/root-ca.crt"
DEST="/usr/local/share/ca-certificates/poc-root-ca.crt"

if [[ ! -f "$ROOT_CRT" ]]; then
  echo "root-ca.crt not found. Run ./generate-ca.sh first." >&2
  exit 1
fi

if ! command -v update-ca-certificates >/dev/null 2>&1; then
  echo "This script assumes Debian/Ubuntu (update-ca-certificates)." >&2
  echo "On other distros, install manually using your local CA manager." >&2
  exit 1
fi

echo "==> Copying root-ca.crt to $DEST (requires sudo)"
sudo cp "$ROOT_CRT" "$DEST"

echo "==> Updating the system trust store"
sudo update-ca-certificates

echo
echo "Quick check (should say 'OK' once mitmproxy is running and traffic"
echo "is routed through it):"
echo "  curl -v https://your-test-host.local/ 2>&1 | grep -i 'certificate\\|SSL'"
echo
echo "To revert: ./untrust-ca-linux.sh"
