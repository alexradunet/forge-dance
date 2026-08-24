# Forge Dance

Forge Dance is a gamified dance-training app built with Flutter, Riverpod,
Firebase Auth, and Cloud Firestore. The app uses a feature-first MVVM shape:
widgets render Riverpod view-model state, view models coordinate user intents,
and repositories own Firebase or local persistence.

Read `AGENTS.md` before making changes. It is the contributor contract; this
README is the short developer runbook.

## App workflows

- **Boot and auth:** `lib/features/firebase/repository/firebase_bootstrap.dart`
  initializes Firebase when FlutterFire options exist. Auth redirects are
  centralized in `lib/routing/app_redirect.dart`; screens should not redirect
  themselves based on auth state.
- **Main shell:** `/main` renders `MainScreen`, an `IndexedStack` with
  Collection, Explore, Home, Training, and Profile tabs. Lesson path, lesson
  player, and training overlays are local shell sub-pages, not go_router routes.
- **Lesson progress:** lesson content ships in
  `lib/features/learn/repository/lesson_catalog.dart`; per-user progress is
  stored at `users/{uid}/progress/{lessonId}` through `ProgressRepository`.
- **Workout sessions:** daily training uses
  `lib/features/workout/repository/workout_catalog.dart`; completed sessions
  are stored at `users/{uid}/sessions/{date}_{workoutId}`. The deterministic
  document id keeps same-day workout XP idempotent.
- **Stats:** `StatsCoordinator` derives XP and streaks from lesson progress plus
  workout sessions, then mirrors those values onto the user profile document.
  `userStatsProvider` is the read-side source for stats UI surfaces.

## Local development setup

Flutter is pinned to `3.35.5` in `.fvmrc`, and VS Code is configured to use the
local FVM SDK path.

```bash
dart pub global activate fvm
fvm install
fvm use
```

After `fvm use`, Cursor can start the Dart MCP server from
`.fvm/flutter_sdk/bin/dart` as configured in `.cursor/mcp.json`. Restart the
editor after creating the local FVM SDK link.

If you do not use FVM, make sure `flutter` on `PATH` is version `3.35.5`.
`tool/checks.sh` prefers `fvm flutter` when `fvm` exists and falls back to
`flutter`.

## Generated code

Generated Dart files are intentionally gitignored:

- `*.g.dart`
- `*.freezed.dart`
- `lib/generated/locale_keys.g.dart`

Regenerate after editing models, repositories, Riverpod providers, states, or
translations:

```bash
flutter pub get
flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir assets/translations
flutter pub run build_runner build --delete-conflicting-outputs
```

Never commit generated files.

## Verification

Run the single check script before handoff:

```bash
bash tool/checks.sh
```

It runs dependency installation, localization key generation, build_runner,
Riverpod custom lints, `flutter analyze`, and `flutter test`. GitHub Actions
runs the same verification steps on `main` and pull requests, then builds the
web release with `flutter build web --release --no-pub`.

Useful individual commands:

```bash
flutter pub get
flutter pub run custom_lint
flutter analyze
flutter test
flutter run -d chrome
```

## Firebase setup

Firebase is the selected MVP backend for fastest path to market.

Firebase project:

- Display name: `forge-dance`
- Project ID: `forge-dance-1bcc7`

Current stack:

- Firebase Auth for email/password accounts
- Cloud Firestore for user profile, lesson progress, and workout sessions

Firebase SDK usage must stay behind repositories/data sources. Widgets should
call Riverpod view models, not Firebase APIs directly.

FlutterFire has generated app configuration for Android, iOS, macOS, web, and
Windows. Linux desktop is a local development target; Firebase initialization is
skipped there because FlutterFire did not generate Linux options.

Enable these services in Firebase Console before using auth/profile persistence:

1. **Authentication > Sign-in method > Email/Password**
2. **Firestore Database** in production mode or test mode, then deploy
   `firestore.rules`

Useful Firebase commands:

```bash
firebase login
flutterfire configure --project=forge-dance-1bcc7
firebase deploy --only firestore:rules
```

Use the local emulator suite when exercising auth or Firestore behavior:

```bash
firebase emulators:start
flutter run --dart-define=USE_FIREBASE_EMULATOR=true
```

Configured emulator ports live in `firebase.json`: Auth `9099`, Firestore
`8080`, and the emulator UI is enabled.

## Troubleshooting

- **`flutter: command not found`:** install Flutter 3.35.5 or run the FVM setup
  above. In this repo, `tool/checks.sh` cannot proceed without either `fvm` or
  `flutter` on `PATH`.
- **Missing `part` files or `LocaleKeys`:** run the generated-code commands or
  `bash tool/checks.sh`. Generated files are not committed.
- **Cursor/Dart MCP does not start:** confirm `fvm use` created
  `.fvm/flutter_sdk/bin/dart`, then restart Cursor.
- **App enters `/main` as a guest on Linux:** expected local-dev behavior.
  Firebase providers return `null` when Firebase is not configured.
- **Firestore `permission-denied`:** check that `firestore.rules` matches the
  current schema and has been deployed or that the emulator is running for local
  tests.

## Project structure

```text
lib/
├── constants/
├── design_system/       # tokens and Fg-prefixed UI primitives
├── extensions/
├── features/
│   └── <feature>/
│       ├── model/
│       ├── repository/
│       └── ui/ or presentation/
├── generated/           # generated locale keys, not committed
├── routing/
└── utils/
```
