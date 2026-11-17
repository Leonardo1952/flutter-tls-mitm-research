# flutter-tls-mitm-research

<img width="640" height="338" alt="image" src="https://github.com/user-attachments/assets/52e0bc86-ef7f-4b86-a3d4-40ea606ab1bf" />


Research lab for [GHSA-frr6-h895-5pxp](https://github.com/dart-lang/sdk/security/advisories/GHSA-frr6-h895-5pxp):
Flutter's `dart:io` validates TLS certificates with its own bundled
BoringSSL and, before Dart 3.13.7/Flutter 3.47.8, didn't block 8
compromised eMudhra intermediate CAs that the operating system already
distrusted.

## Structure

```
flutter-tls-mitm-research/
├── tls_mitm_poc/   "victim" Flutter app (Rate Today) — see tls_mitm_poc/README.md
└── infra/          "attacker" tooling (CA, mitmproxy, exploit) — see infra/README.md
```

The two folders only talk over the network (proxy), never through a
code import or build dependency — on purpose, to reflect the real
separation between an app and a network attacker.

## Where to start

1. [`infra/README.md`](infra/README.md) — how to set up the lab (CA, mitmproxy, attack, forensic verification)
2. [`tls_mitm_poc/README.md`](tls_mitm_poc/README.md) — the target app
