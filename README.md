# Forge Dance

Forge Dance is a gamified dance-training app built with Flutter, Riverpod,
Firebase, and a feature-first architecture. Users follow lesson paths, run
daily workout sessions, and earn XP, belts, streaks, diamonds, and achievements.

## Current architecture

- Product code lives under `lib/features/<feature>/` with `model/`,
  `repository/`, and `ui/` or `presentation/` layers.
- Widgets render Riverpod view-model state and send user intents. Firebase SDK
  usage stays behind repositories/data sources.
- Generated Riverpod/freezed/json and localization outputs are gitignored.
  Regenerate them after cloning and after changing models, providers, states, or
  translations.
- Lesson and workout content ships in code:
  - `lib/features/learn/repository/lesson_catalog.dart`
  - `lib/features/workout/repository/workout_catalog.dart`
- User state is persisted in Firebase:
  - `users/{uid}` for profile plus denormalized gamification stats.
  - `users/{uid}/progress/{lessonId}` for lesson progress.
  - `users/{uid}/sessions/{date}_{workoutId}` for completed workouts.
- XP and streak display rules are derived in
  `lib/features/stats/model/stats_rules.dart`; the `xp` field on the user doc is
  a mirror, not the source of truth.

## Local setup

Flutter is pinned to **3.35.5** by `.fvmrc` and CI uses the same version.

```bash
dart pub global activate fvm   # one-time, if fvm is not installed
fvm install
fvm use
bash tool/checks.sh
```

`tool/checks.sh` is the single "done" command. It runs:

1. `pub get`
2. localization key generation
3. Riverpod/freezed/json code generation
4. `custom_lint`
5. `flutter analyze`
6. `flutter test`

The script uses `fvm flutter` when FVM is available and falls back to `flutter`
otherwise.

## Useful commands

| Task | Command |
| --- | --- |
| Full verification | `bash tool/checks.sh` |
| Generate localization keys | `fvm flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir assets/translations` |
| Generate Riverpod/freezed/json code | `fvm flutter pub run build_runner build --delete-conflicting-outputs` |
| Watch code generation | `fvm flutter pub run build_runner watch --delete-conflicting-outputs` |
| Riverpod lints | `fvm flutter pub run custom_lint` |
| Analyze | `fvm flutter analyze` |
| Tests | `fvm flutter test` |
| Run web app | `fvm flutter run -d chrome` |
| Web release build | `fvm flutter build web --release` |

## VS Code and Cursor

Workspace settings are committed so the editor uses the pinned Flutter SDK and
keeps generated files out of search/watchers.

- Recommended extensions are in `.vscode/extensions.json`.
- Launch configs cover Chrome, Linux desktop, Android, profile/release web, all
  tests, current test file, and Firebase-emulator web runs.
- Tasks include `forge: checks (CI pipeline)`, `forge: codegen`,
  `forge: build_runner watch`, `forge: firebase emulators`, and
  `forge: deploy firestore rules`.
- Cursor and VS Code can use the Dart MCP server after `fvm use` creates
  `.fvm/flutter_sdk`; Cursor reads `.cursor/mcp.json`, while VS Code enables it
  through `dart.mcpServer`.

## Firebase

Firebase project:

- Display name: `forge-dance`
- Project ID: `forge-dance-1bcc7`

FlutterFire configuration exists for Android, iOS, macOS, web, and Windows.
Linux desktop is a local development target that skips Firebase initialization;
nullable Firebase providers then let the app run in guest/local mode.

Enable these services before using auth/profile/progress/session persistence:

1. **Authentication > Sign-in method > Email/Password**
2. **Firestore Database**, then deploy `firestore.rules`

Useful Firebase commands:

```bash
firebase login
flutterfire configure --project=forge-dance-1bcc7
firebase deploy --only firestore:rules
```

For local auth and Firestore testing:

```bash
firebase emulators:start --only auth,firestore
fvm flutter run --dart-define=USE_FIREBASE_EMULATOR=true
```

The app reads `USE_FIREBASE_EMULATOR` in
`lib/features/firebase/repository/firebase_bootstrap.dart` and connects Auth to
`:9099` and Firestore to `:8080`, matching `firebase.json`.

## Project structure

```text
lib/
├── constants/
├── design_system/
├── extensions/
├── features/
│   ├── authentication/
│   ├── firebase/
│   ├── learn/
│   ├── profile/
│   ├── stats/
│   ├── workout/
│   └── <feature>/
│       ├── model/
│       ├── repository/
│       └── ui/ or presentation/
├── generated/
├── routing/
└── utils/
```

Read `AGENTS.md` before making changes. `CLAUDE.md` has the deeper architecture
notes and feature-specific constraints used by coding agents.
