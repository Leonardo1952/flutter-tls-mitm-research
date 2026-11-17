# Rate Today

Flutter currency-quote app used as the target ("victim") in the
[GHSA-frr6-h895-5pxp](https://github.com/dart-lang/sdk/security/advisories/GHSA-frr6-h895-5pxp)
lab — see [`../infra`](../infra).

Three tabs, each fetching the same quote (AwesomeAPI) through a
different network stack, all using the SDK's **default** TLS
validation:

- **EasyFX** — `dart:io HttpClient`
- **DollarTrack** — `package:http`
- **FastFX** — `package:dio`

## Running

Managed via [FVM](https://fvm.app/) (`.fvmrc` pins the version to
3.47.7, the vulnerable one):

```bash
fvm flutter run
```

To test against the fixed version:

```bash
fvm use 3.47.9 --force
fvm flutter run
```
