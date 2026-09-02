---
name: quality-checks
description: Run Forge Dance verification gates (code generation, analysis, tests, emulator checks, and web quality) and fix common generated-code failures. Use before committing or handing off, after pulling changes, or when CI and generated symbols fail.
---

# Quality Checks & Codegen Pipeline

**Fast Flutter gate:**

```bash
bash tool/checks.sh
```

It runs, fail-fast and in order: `pub get` → localization keygen → `build_runner` → `analyze` (including `riverpod_lint`) → unit/widget tests. Never hand off without it passing.

Run the relevant slower gate as well:

- `bash tool/check_firebase_rules.sh` after `firestore.rules` changes.
- `bash tool/check_integration.sh` after authentication, onboarding, profile persistence, or routing changes.
- `bash tool/check_web_quality.sh` after web startup, routing, assets, metadata, Firebase bootstrap, or major UI composition changes.

CI runs these gates in separate jobs. The web-quality gate audits a Wasm release build (including its JavaScript fallback) against Firebase emulators, checks Lighthouse score and transfer floors, and rejects console errors or failed HTTP requests; inspect `build/lighthouse/` when it fails.

## Why this exact pipeline

- `*.g.dart`, `*.freezed.dart`, and `lib/generated/locale_keys.g.dart` are **gitignored** — every fresh checkout starts broken until codegen runs.
- `riverpod_lint` is registered through Dart's analyzer plugin system in `analysis_options.yaml`, so `flutter analyze` enforces Riverpod diagnostics in local checks and CI.
- `analysis_options.yaml` excludes generated files from analysis and ignores `invalid_annotation_target` (needed for json_annotation on freezed classes) — don't "fix" these.
- During iteration, prefer `dart run build_runner watch`.

## Common failures → fixes

| Symptom | Fix |
|---|---|
| `Target of URI hasn't been generated: '*.g.dart'` / missing `part` file | Run build_runner (and the localization generate for `locale_keys.g.dart`) |
| Build script references removed `build_runner_core` APIs | Remove `.dart_tool/build`, then rerun `dart run build_runner build` |
| `Undefined name 'LocaleKeys'` or missing key getter | Regenerate LocaleKeys; check the key exists in `assets/translations/en.json` |
| Freezed: `Missing concrete implementation` / mixin errors | Freezed 4 requires `abstract class X with _$X` for immutable models — the old non-abstract syntax does not compile |
| Riverpod: provider name not found after adding `@riverpod` | The generated provider is `<functionName>Provider` / `<className>Provider` — rerun build_runner, check the `part '<file>.g.dart';` directive matches the filename |
| Weird stale-codegen behavior after refactors/renames | `flutter clean && flutter pub get`, then rerun both generators |
| `permission-denied` from Firestore at runtime | Rules not deployed — `firebase deploy --only firestore:rules` (see firebase-data skill) |
| CI green locally but failing on web build | Run `flutter build web --release --wasm` locally; usually a web-incompatible import or Wasm-unsafe package |
| Lighthouse score, console, or request regression | Run `bash tool/check_web_quality.sh`, then inspect `build/lighthouse/forge-dance.report.html` |

## Commit hygiene

- Never commit generated files (`git status` should show none; `.gitignore` covers them).
- Never commit secrets — `.env*` is gitignored; Firebase client config (`firebase_options.dart`, `google-services.json`) is intentionally committed and is not secret.
- Keep `main` green: the required checks above are non-negotiable before any push (per `AGENTS.md`).
