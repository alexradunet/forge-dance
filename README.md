# Forge Dance

Forge Dance is a gamified dance-training app built with Flutter, Riverpod
codegen, Firebase Auth, and Cloud Firestore. Users sign in, follow module-based
lesson paths, complete the daily workout of the day (WOD), and earn XP, streaks,
diamonds, and belt levels.

## Quick start

Flutter is pinned to 3.35.5 with FVM (`.fvmrc`):

```bash
dart pub global activate fvm
fvm install
fvm use
bash tool/checks.sh
```

`tool/checks.sh` is the single definition of done. It runs dependency install,
localization key generation, Riverpod/freezed/json code generation,
`custom_lint`, `flutter analyze`, and `flutter test`. Generated files
(`*.g.dart`, `*.freezed.dart`, `lib/generated/locale_keys.g.dart`) are
gitignored and must not be committed.

## Product data model

Content ships with the app; user state is stored separately:

- **Lessons:** `lib/features/learn/repository/lesson_catalog.dart` contains 10
  ordered modules. Lesson IDs are stable because Firestore progress documents
  reference them.
- **Lesson progress:** `users/{uid}/progress/{lessonId}` stores status and
  progress. Lessons unlock sequentially inside a module; modules are freely
  browsable.
- **Workouts/WOD:** `lib/features/workout/repository/workout_catalog.dart`
  contains seven workouts. `wodFor(date)` deterministically rotates the daily
  WOD by day-of-year, with no backend scheduler.
- **Workout sessions:** `users/{uid}/sessions/{date}_{workoutId}` records a
  completed workout once per workout per day. Repeating the same WOD on the same
  date does not award duplicate XP.
- **Stats:** XP is derived from completed lessons plus completed workout
  sessions. The profile document mirrors `xp`, `streakCount`, and
  `lastActivityDate` for convenient display, but derived stats remain the source
  of truth.

## Architecture

Feature code follows MVVM with generated Riverpod providers:

```text
Widget -> ViewModel (AsyncNotifier) -> Repository -> Firebase / local cache
```

Widgets render `AsyncValue` state and send user intents to view models. Firebase
SDKs stay inside repositories; widgets and view models should not import
`FirebaseAuth` or `FirebaseFirestore`.

## Backend and local development

Firebase project:

- Display name: `forge-dance`
- Project ID: `forge-dance-1bcc7`

Configured services:

- Firebase Auth for email/password accounts
- Cloud Firestore for profile, progress, and workout-session data

FlutterFire configuration exists for Android, iOS, macOS, web, and Windows.
Linux desktop runs locally but skips Firebase initialization because there is no
Linux FlutterFire config; repositories degrade gracefully when Firebase is
unconfigured.

Enable these services in Firebase Console before using auth/Firestore persistence:

1. **Authentication > Sign-in method > Email/Password**
2. **Firestore Database**, then deploy `firestore.rules`

Useful commands:

```bash
firebase login
flutterfire configure --project=forge-dance-1bcc7
firebase deploy --only firestore:rules
firebase emulators:start
flutter run --dart-define=USE_FIREBASE_EMULATOR=true
```

Use the emulator flag whenever exercising Auth or Firestore locally.

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

The live app shell is `/main`: bottom tabs are managed by
`lib/features/main/presentation/pages/main_screen.dart`, while auth redirects
and other top-level routes live in `lib/routing/`.

See `AGENTS.md` before making changes. `CLAUDE.md` has the full architecture
map and operational notes for AI-assisted development.
