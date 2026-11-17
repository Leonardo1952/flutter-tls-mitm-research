#!/usr/bin/env bash
set -euo pipefail

INSTALLED="/usr/local/share/ca-certificates/poc-root-ca.crt"

echo "==> Removing $INSTALLED (requires sudo)"
sudo rm -f "$INSTALLED"
sudo update-ca-certificates --fresh

echo
echo "Verify with: curl -v https://your-test-host.local/"
echo "(should fail with an untrusted certificate, routed through mitmproxy)"
