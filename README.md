# Forge Dance

Forge Dance is a Flutter app built with Riverpod, Firebase, and a feature-first architecture.

## Backend

Firebase is the selected MVP backend for fastest path to market.

Firebase project:

- Display name: `forge-dance`
- Project ID: `forge-dance-1bcc7`

Current stack:

- Firebase Auth for email/password accounts
- Cloud Firestore for user/profile data

Firebase SDK usage should stay behind repositories/data sources. Widgets should call Riverpod view models, not Firebase APIs directly.

## Firebase setup

FlutterFire has generated app configuration for Android, iOS, macOS, web, and Windows.

Enable these services in Firebase Console before using auth/profile persistence:

1. **Authentication > Sign-in method > Email/Password**
2. **Firestore Database** in production mode or test mode, then deploy `firestore.rules`

Useful Firebase commands:

```bash
firebase login
flutterfire configure --project=forge-dance-1bcc7
firebase deploy --only firestore:rules
```

Linux desktop is kept as a local development target; Firebase initialization is skipped there because FlutterFire did not generate Linux options.

## Local development

Flutter is pinned to **3.35.5** with FVM (`.fvmrc`), matching CI.
After a fresh clone:

```bash
dart pub global activate fvm # one-time, if FVM is not installed
fvm install
fvm use
fvm flutter pub get
```

Use `fvm flutter ...` from a plain terminal. VS Code is configured to use
`.fvm/versions/3.35.5`, and the Cursor Dart MCP config uses
`.fvm/flutter_sdk/bin/dart`, so run `fvm use` after installing the SDK.

Generated files are intentionally gitignored:

- `*.g.dart`
- `*.freezed.dart`
- `lib/generated/locale_keys.g.dart`

Run code generation after cloning and after changing models, Riverpod providers,
states, or translations. Do not commit generated files.

## Commands

`tool/checks.sh` is the local definition of done. It uses `fvm flutter` when FVM
is installed, falls back to `flutter`, and runs dependency install,
localization keygen, `build_runner`, `custom_lint`, `analyze`, and tests in the
same order as CI. CI also performs a web release build.

```bash
bash tool/checks.sh
```

Useful focused commands:

| Task | Command |
| --- | --- |
| Install dependencies | `fvm flutter pub get` |
| Generate localization keys | `fvm flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir assets/translations` |
| Generate Riverpod/freezed/json code | `fvm flutter pub run build_runner build --delete-conflicting-outputs` |
| Watch code generation | `fvm flutter pub run build_runner watch --delete-conflicting-outputs` |
| Analyze | `fvm flutter analyze` |
| Test | `fvm flutter test` |
| Run Chrome | `fvm flutter run -d chrome` |
| Run with Firebase emulators | `firebase emulators:start --only auth,firestore` and `fvm flutter run --dart-define=USE_FIREBASE_EMULATOR=true` |
| Build web release | `fvm flutter build web --release` |
| Deploy Firestore rules | `firebase deploy --only firestore:rules` |

## VS Code workflow

The committed workspace settings include recommended Dart/Flutter extensions,
80-column Dart formatting, generated-file excludes, and task/launch shortcuts.

- Run **Tasks: Run Task** -> `forge: checks (CI pipeline)` before hand-off.
- Use `forge: codegen` or `forge: build_runner watch` while editing generated
  models/providers.
- Use `forge: firebase emulators` before exercising auth or Firestore locally.
- Launch configs cover Chrome, Chrome with emulator mode, Linux desktop,
  Android, all tests, and the current test file.

## Project structure

```text
lib/
├── constants/
├── design_system/
├── extensions/
├── features/
│   └── <feature>/
│       ├── model/
│       ├── repository/
│       └── ui/ or presentation/
├── generated/
├── routing/
├── theme/
└── utils/
```

See `AGENTS.md` before making changes.
