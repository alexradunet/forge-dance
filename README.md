# Forge Dance

Forge Dance is a Flutter app built with Riverpod, Firebase, and a
feature-first architecture. Users sign in, follow lesson paths, complete daily
workouts, and earn XP, streaks, belts, and diamonds.

## Backend and persistence

Firebase is the selected MVP backend for fastest path to market.

Firebase project:

- Display name: `forge-dance`
- Project ID: `forge-dance-1bcc7`

Current stack:

- Firebase Auth for email/password accounts.
- Cloud Firestore for owner-only user data:
  - `users/{uid}` stores the profile plus denormalized gamification fields.
  - `users/{uid}/progress/{lessonId}` stores lesson progress.
  - `users/{uid}/sessions/{date}_{workoutId}` stores completed workout
    sessions; the deterministic document id caps workout XP at one award per
    workout per day.
- SharedPreferences caches profile data locally. Local, non-URL avatar file
  paths intentionally stay local and are not synced to Firestore.

Firebase SDK usage should stay behind repositories/data sources. Widgets should
call Riverpod view models, not Firebase APIs directly.

## Developer setup

Flutter is pinned to `3.35.5` through FVM (`.fvmrc`):

```bash
dart pub global activate fvm
fvm install
fvm use
```

Then install dependencies and generate the gitignored code:

```bash
fvm flutter pub get
fvm flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir assets/translations
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

Generated files (`*.g.dart`, `*.freezed.dart`, and
`lib/generated/locale_keys.g.dart`) are intentionally not committed. Regenerate
after changing models, Riverpod providers, state classes, or translations.

If you do not use FVM, `tool/checks.sh` falls back to `flutter` on `PATH`, but
the checked-in VS Code and Cursor tools expect `fvm use` to have created the
local `.fvm/flutter_sdk` symlink.

## Daily workflow

Run the local verification pipeline before handing off:

```bash
bash tool/checks.sh
```

The script runs dependency install, localization generation, build_runner,
Riverpod custom lints, `flutter analyze`, and `flutter test`. The GitHub
workflow runs the same sequence and then builds the web release.

VS Code users get checked-in tasks and launch configurations:

- `forge: checks (CI pipeline)` runs `bash tool/checks.sh`.
- `forge: codegen` runs localization generation followed by build_runner.
- `forge: firebase emulators` starts Auth and Firestore emulators.
- Launch configs cover Chrome, Linux desktop, Android, all tests, current test
  file, and Chrome with `USE_FIREBASE_EMULATOR=true`.

Cursor's Dart MCP configuration lives in `.cursor/mcp.json` and uses
`.fvm/flutter_sdk/bin/dart`, so run `fvm use` after cloning and restart the
editor if MCP tools do not appear.

## Firebase setup and local development

FlutterFire has generated app configuration for Android, iOS, macOS, web, and
Windows. Linux desktop is kept as a local development target; Firebase
initialization is skipped there because FlutterFire did not generate Linux
options, so repositories return empty/no-op Firebase behavior and routing enters
the app as a guest.

Enable these services in Firebase Console before using auth or Firestore
persistence:

1. **Authentication > Sign-in method > Email/Password**
2. **Firestore Database** in production mode or test mode, then deploy
   `firestore.rules`

Useful Firebase commands:

```bash
firebase login
flutterfire configure --project=forge-dance-1bcc7
firebase deploy --only firestore:rules
```

Run against local Firebase emulators when exercising auth or Firestore behavior:

```bash
firebase emulators:start --only auth,firestore
fvm flutter run --dart-define=USE_FIREBASE_EMULATOR=true
```

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
└── utils/
```

See `AGENTS.md` before making changes.
