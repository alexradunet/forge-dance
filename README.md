# Forge Dance

Forge Dance is a Flutter app built with Riverpod, Firebase, and a
feature-first architecture. Users sign in, follow structured lesson paths,
complete daily workout sessions, and earn XP, belts, streaks, and diamonds.

## Backend

Firebase is the selected MVP backend for fastest path to market.

Firebase project:

- Display name: `forge-dance`
- Project ID: `forge-dance-1bcc7`

Current stack:

- Firebase Auth for email/password accounts
- Cloud Firestore for profile, lesson progress, workout sessions, and
  denormalized gamification data

Firebase SDK usage should stay behind repositories/data sources. Widgets should call Riverpod view models, not Firebase APIs directly.

## Training data model

Content ships with the app; user state is the only data persisted to Firebase.

| Data | Source of truth | Notes |
| --- | --- | --- |
| Lesson catalog | `lib/features/learn/repository/lesson_catalog.dart` | Static modules, lessons, movement nodes, and boss nodes. Lesson IDs are globally unique and stable. |
| Workout catalog | `lib/features/workout/repository/workout_catalog.dart` | Static workout list plus deterministic WOD rotation by day-of-year. |
| Lesson progress | `users/{uid}/progress/{lessonId}` | Written through `ProgressRepository`; document ID must match `lessonId`. |
| Workout sessions | `users/{uid}/sessions/{date}_{workoutId}` | Written through `SessionRepository`; deterministic IDs make one workout completion per day idempotent for XP. |
| Profile stats | `users/{uid}` fields `xp`, `streakCount`, `lastActivityDate` | Written by `StatsCoordinator` after lesson or workout activity. XP is a denormalized mirror derived from completed lessons plus workout sessions. |

`firestore.rules` keeps all user data owner-only and validates the key
invariants above: profile `id` must match the auth UID, progress statuses must
match the `LessonStatus` enum names, and session document IDs must equal
`date + '_' + workoutId`.

Gamification rules are pure functions in
`lib/features/stats/model/stats_rules.dart`. Belt thresholds are calibrated so
completing the lesson catalog reaches Black Belt; workout XP accelerates
progress but is priced from the workout catalog.

## Firebase setup

FlutterFire has generated app configuration for Android, iOS, macOS, web, and Windows.

Enable these services in Firebase Console before using auth and Firestore
persistence:

1. **Authentication > Sign-in method > Email/Password**
2. **Firestore Database** in production mode or test mode, then deploy `firestore.rules`

Useful Firebase commands:

```bash
firebase login
flutterfire configure --project=forge-dance-1bcc7
firebase deploy --only firestore:rules
```

Linux desktop is kept as a local development target; Firebase initialization is skipped there because FlutterFire did not generate Linux options.

Run against local emulators when exercising auth or Firestore behavior:

```bash
firebase emulators:start
flutter run --dart-define=USE_FIREBASE_EMULATOR=true
```

When Firebase is unconfigured or the user is signed out, repositories degrade
gracefully: reads return empty/local state and writes no-op. This keeps Linux
development usable without production Firebase access.

## Commands

Run the same verification pipeline as CI:

```bash
bash tool/checks.sh
```

That script installs packages, regenerates localization/Riverpod/freezed/json
code, runs Riverpod custom lints, analyzes, and tests.

Individual commands:

```bash
flutter pub get
flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir assets/translations
flutter pub run build_runner build --delete-conflicting-outputs
flutter pub run custom_lint
flutter analyze
flutter test
```

Generated files (`*.g.dart`, `*.freezed.dart`, and
`lib/generated/locale_keys.g.dart`) are gitignored. Regenerate after changing
models, providers, state classes, or translations; do not commit generated
outputs.

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

Feature data flow follows MVVM with generated Riverpod providers:

```text
Widget -> ViewModel (AsyncNotifier) -> Repository -> Firebase / local cache
```

Use the learn, workout, profile, and stats features as current examples of
typed repositories, nullable Firebase dependencies, and source-backed view
models. The legacy prototype screens called out in `CLAUDE.md` are dead code;
the live home, explore, collection, and training screens render from real
feature state.

See `AGENTS.md` before making changes.
