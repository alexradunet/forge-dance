# Forge Dance

Forge Dance is a Flutter dance-training app built with Riverpod, Firebase,
and a feature-first architecture. Users sign in, follow module lesson paths,
complete the daily workout of the day (WOD), and earn XP, streaks, diamonds,
and belt levels.

The app is intentionally local-first for content: lesson and workout catalogs
ship in Dart code, while user state is stored under the signed-in user's
Firestore document.

## Developer setup

Flutter is pinned with FVM:

```bash
dart pub global activate fvm
fvm install
fvm use
```

VS Code/Cursor picks up `.fvm/flutter_sdk` from `.vscode/settings.json`.
Without FVM, the scripts fall back to `flutter` on `PATH`.

Generated files are gitignored (`*.g.dart`, `*.freezed.dart`,
`lib/generated/locale_keys.g.dart`). Regenerate them after cloning and after
editing models, providers, state classes, or translations:

```bash
flutter pub get
flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir assets/translations
flutter pub run build_runner build --delete-conflicting-outputs
```

Before handing off changes, run the local check script that mirrors CI's
analyze/test steps:

```bash
bash tool/checks.sh
```

This runs dependency resolution, localization generation, Riverpod/freezed/json
code generation, `custom_lint`, `flutter analyze`, and `flutter test`. CI also
builds the web release with `flutter build web --release --no-pub`.

## Firebase and local emulators

Firebase is the MVP backend.

- Display name: `forge-dance`
- Project ID: `forge-dance-1bcc7`
- Services: Firebase Auth (email/password) and Cloud Firestore
- Generated platforms: Android, iOS, macOS, web, and Windows

Firebase SDK calls stay behind repositories/data sources. Widgets render
Riverpod view-model state and send user intents; they do not call Firebase
APIs directly.

Useful commands:

```bash
firebase login
flutterfire configure --project=forge-dance-1bcc7
firebase deploy --only firestore:rules
```

For auth/Firestore development without production data:

```bash
firebase emulators:start
flutter run --dart-define=USE_FIREBASE_EMULATOR=true
```

Emulator ports are defined in `firebase.json`: Auth `9099`, Firestore `8080`.
Linux desktop skips Firebase initialization because no FlutterFire Linux
options exist; nullable Firebase providers make repositories read empty and
write no-op in that mode.

## Current data model

Firestore is owner-only, validated in `firestore.rules`.

```text
users/{uid}
├── id, email, name, job, avatar, diamond, createdAt, updatedAt
├── xp, streakCount, lastActivityDate
├── progress/{lessonId}
│   └── lessonId, status, progress, updatedAt
└── sessions/{date}_{workoutId}
    └── workoutId, date, completedAt
```

Important constraints:

- `users/{uid}.id` must equal the authenticated uid.
- Lesson progress document ids must equal `lessonId`.
- Lesson status values must match `LessonStatus`: `notStarted`,
  `inProgress`, or `completed`.
- Workout session ids are deterministic (`yyyy-MM-dd_workoutId`) so repeating
  the same workout on the same day overwrites instead of double-counting XP.
- `xp` on the user document is a denormalized mirror, not the source of truth.

## Learn, workout, and stats flow

The live training surface is built from these codepaths:

- Lesson catalog: `lib/features/learn/repository/lesson_catalog.dart`
- Lesson progress repository:
  `lib/features/learn/repository/progress_repository.dart`
- Workout catalog and WOD rotation:
  `lib/features/workout/repository/workout_catalog.dart`
- Workout session repository:
  `lib/features/workout/repository/session_repository.dart`
- Gamification rules: `lib/features/stats/model/stats_rules.dart`
- Cross-feature stats sync:
  `lib/features/stats/application/stats_coordinator.dart`

Content rules:

- Lesson content ships in the app. Only per-user progress is persisted.
- Lesson ids are stable public identifiers for progress documents; do not
  rename shipped ids.
- Every module ends with a boss lesson.
- Workout content also ships in the app. The daily WOD is deterministic:
  `wodFor(date)` rotates through `allWorkouts` by day-of-year.

XP and streak rules:

- Completed lessons earn XP by lesson type: theory `20`, drill `30`,
  movement `40`, experiment `50`, boss `100`.
- Completed workout sessions earn the workout's catalog XP, capped by the
  one-session-per-workout-per-day document key.
- Total displayed XP = completed lesson XP + completed workout session XP.
- Belt thresholds live in `stats_rules.dart`; completing the whole lesson
  catalog is calibrated to Black Belt and enforced by `test/stats_test.dart`.
- Any successful training activity (lesson or workout) advances the streak.
  Same-day activity keeps the streak, consecutive-day activity increments it,
  and gaps reset it to `1`.
- `StatsCoordinator` writes the derived XP/streak mirror back to the profile
  after training events. Sync is best-effort and must not fail the training
  flow itself.

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

Feature code follows MVVM with Riverpod code generation:

```text
Widget -> ViewModel (AsyncNotifier) -> Repository -> Firebase / local data
```

See `AGENTS.md` before making changes. See `CLAUDE.md` for the fuller agent
playbook and feature-specific caveats.
