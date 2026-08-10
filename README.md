# Forge Dance

Forge Dance is a gamified dance-training app built with Flutter, Riverpod,
Firebase Auth, Cloud Firestore, and a feature-first MVVM architecture.

The app ships lesson and workout content in code, persists per-user progress in
Firestore, and derives XP/streak stats from completed lessons and workouts.

## Backend

Firebase is the selected MVP backend for fastest path to market. Keep Firebase
SDK usage behind repositories/data sources; widgets should call Riverpod view
models, not Firebase APIs directly.

Firebase project:

- Display name: `forge-dance`
- Project ID: `forge-dance-1bcc7`

Current stack and data model:

- Firebase Auth for email/password accounts
- Cloud Firestore under `users/{uid}`:
  - profile fields plus denormalized `xp`, `streakCount`, and
    `lastActivityDate`
  - `progress/{lessonId}` for per-lesson status and completion progress
  - `sessions/{date}_{workoutId}` for completed workouts; the deterministic
    document id caps XP at one award per workout per day
- SharedPreferences as the local-first profile cache

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

For local auth/Firestore testing:

```bash
firebase emulators:start --only auth,firestore
fvm flutter run --dart-define=USE_FIREBASE_EMULATOR=true
```

Linux desktop is kept as a local development target; Firebase initialization is
skipped there because FlutterFire did not generate Linux options. In that mode,
nullable Firebase providers return `null`, repositories no-op writes, and the
router enters `/main` as a guest.

## Local development

Flutter is pinned to `3.35.5` with FVM (`.fvmrc`). After cloning:

```bash
dart pub global activate fvm   # one-time, if fvm is not installed
fvm install
fvm use
```

VS Code is configured to use `.fvm/versions/3.35.5`, run build_runner with
`--delete-conflicting-outputs`, and expose common tasks in `.vscode/tasks.json`.
Cursor and VS Code both enable the Dart/Flutter MCP server after `fvm use`
creates `.fvm/flutter_sdk`.

Do not run `flutter upgrade` for this repository without an intentional Flutter
version bump.

## Commands

One command regenerates code, runs Riverpod lints, analyzes, and tests:

```bash
bash tool/checks.sh
```

Run it before handing off changes. CI mirrors these steps and then runs a web
release build.

Useful individual commands:

```bash
fvm flutter pub get
fvm flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir assets/translations
fvm flutter pub run build_runner build --delete-conflicting-outputs
fvm flutter pub run custom_lint
fvm flutter analyze
fvm flutter test
```

Generated files (`*.g.dart`, `*.freezed.dart`, and
`lib/generated/locale_keys.g.dart`) are intentionally gitignored. Regenerate
after editing models, providers, states, or translations; never commit the
generated outputs.

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

Feature data flow follows:

```text
Widget -> ViewModel (Riverpod AsyncNotifier) -> Repository -> Firebase/cache
```

Important current codepaths:

- Auth state and route guarding: `lib/routing/app_redirect.dart`
- Lesson catalog and progress: `lib/features/learn/`
- Workout catalog and session tracking: `lib/features/workout/`
- XP, belts, and streak rules: `lib/features/stats/`
- Firestore security rules: `firestore.rules`

See `AGENTS.md` before making changes.
