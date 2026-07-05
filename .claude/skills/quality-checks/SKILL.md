---
name: quality-checks
description: Run the full Forge Dance verification pipeline (code generation, custom_lint, analyze, test, web build) and fix common failures like missing part files, stale generated code, or freezed/riverpod codegen errors. Use before committing or handing off, after pulling changes, or when builds fail with unresolved generated symbols.
---

# Quality Checks & Codegen Pipeline

**One command, one definition of done:**

```bash
bash tool/checks.sh
```

It runs, fail-fast and in order: `pub get` → localization keygen → `build_runner` → `custom_lint` → `analyze` → `test`. CI (`.github/workflows/flutter.yml`, Flutter **3.35.5**) runs exactly this script on every push to `main` — and commits land directly on `main` — so local green == CI green. Never hand off without it passing.

For risky changes, also confirm the release target CI builds: `flutter build web --release`.

## Why this exact pipeline

- `*.g.dart`, `*.freezed.dart`, and `lib/generated/locale_keys.g.dart` are **gitignored** — every fresh checkout starts broken until codegen runs.
- `custom_lint` (riverpod_lint) is NOT registered as an analyzer plugin in `analysis_options.yaml`, so `flutter analyze` does not include Riverpod lints — the CLI run is the only local way to see them, and CI enforces them.
- `analysis_options.yaml` excludes generated files from analysis and ignores `invalid_annotation_target` (needed for json_annotation on freezed classes) — don't "fix" these.
- During iteration, prefer `flutter pub run build_runner watch --delete-conflicting-outputs`.

## Common failures → fixes

| Symptom | Fix |
|---|---|
| `Target of URI hasn't been generated: '*.g.dart'` / missing `part` file | Run build_runner (and the localization generate for `locale_keys.g.dart`) |
| `Conflicting outputs were detected` | You forgot `--delete-conflicting-outputs` |
| `Undefined name 'LocaleKeys'` or missing key getter | Regenerate LocaleKeys; check the key exists in `assets/translations/en.json` AND `vi.json` |
| Freezed: `Missing concrete implementation` / mixin errors | freezed 3 requires `abstract class X with _$X` — the old non-abstract syntax no longer compiles |
| Riverpod: provider name not found after adding `@riverpod` | The generated provider is `<functionName>Provider` / `<className>Provider` — rerun build_runner, check the `part '<file>.g.dart';` directive matches the filename |
| Weird stale-codegen behavior after refactors/renames | `flutter clean && flutter pub get`, then rerun both generators |
| `permission-denied` from Firestore at runtime | Rules not deployed — `firebase deploy --only firestore:rules` (see firebase-data skill) |
| CI green locally but failing on web build | Run `flutter build web --release` locally; usually a web-incompatible import (e.g. `dart:io` outside guarded paths) |

## Commit hygiene

- Never commit generated files (`git status` should show none; `.gitignore` covers them).
- Never commit secrets — `.env*` is gitignored; Firebase client config (`firebase_options.dart`, `google-services.json`) is intentionally committed and is not secret.
- Keep `main` green: the required checks above are non-negotiable before any push (per `AGENTS.md`).
