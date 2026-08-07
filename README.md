# Forge Dance

Forge Dance is a Flutter app built with Riverpod, Firebase, and a
feature-first architecture.

## Local toolchain

Flutter is pinned to **3.35.5** via FVM (`.fvmrc`) to match CI. After cloning:

```bash
dart pub global activate fvm   # one-time, if FVM is not installed
fvm install
fvm use
```

Use `fvm flutter ...` in a plain terminal. The repository also includes VS Code
settings, launch configs, and tasks that target the FVM SDK paths created by
`fvm use`.

Do not run `flutter upgrade` in this repository unless the pinned Flutter
version is being deliberately changed.

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

For local auth/Firestore testing, start the emulators and run with the emulator
define:

```bash
firebase emulators:start --only auth,firestore
fvm flutter run --dart-define=USE_FIREBASE_EMULATOR=true
```

VS Code also has launch profiles for Chrome with the emulator define, including
one that starts the emulator task first.

## Commands

Run the full verification pipeline before handing off changes:

```bash
bash tool/checks.sh
```

The script runs `pub get`, localization key generation, Riverpod/freezed/json
code generation, `custom_lint`, `flutter analyze`, and `flutter test`. CI uses
the same sequence and then builds the web release.

Individual commands:

```bash
fvm flutter pub get
fvm flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir assets/translations
fvm flutter pub run build_runner build --delete-conflicting-outputs
fvm flutter pub run custom_lint
fvm flutter analyze
fvm flutter test
```

Generated files (`*.g.dart`, `*.freezed.dart`, and
`lib/generated/locale_keys.g.dart`) are gitignored. Regenerate them after editing
models, providers, states, or translations, but do not commit them.

## Editor support

- `.vscode/tasks.json` exposes tasks for checks, codegen, custom lint, analyze,
  tests, web release builds, Firebase emulators, and Firestore rules deploys.
- `.vscode/launch.json` contains Chrome, Linux, Android, profile/release, test,
  and Firebase emulator launch profiles.
- `.cursor/mcp.json` configures the official Dart MCP server through the local
  FVM SDK. Run `fvm use`, then restart Cursor and enable the `dart` MCP server if
  it is not already active.

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
