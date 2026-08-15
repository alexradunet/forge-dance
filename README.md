# Forge Dance

Forge Dance is a gamified dance-training app built with Flutter, Riverpod,
Firebase Auth, and Cloud Firestore. Users follow structured lesson paths,
complete daily workouts, and earn XP, streaks, belts, diamonds, and
achievements.

Read `AGENTS.md` before making changes. `CLAUDE.md` has the full contributor
playbook and points to task-specific skills in `.claude/skills/`.

## Quick start

Flutter is pinned to 3.35.5 via FVM (`.fvmrc`).

```bash
dart pub global activate fvm   # first time only
fvm install
fvm use
flutter pub get
bash tool/checks.sh
```

`tool/checks.sh` is the local definition of done. It runs dependency install,
localization codegen, Riverpod/freezed/json codegen, `custom_lint`,
`flutter analyze`, and `flutter test`. CI runs the same verification path plus
a web release build.

Generated files are intentionally gitignored:

- `*.g.dart`
- `*.freezed.dart`
- `lib/generated/locale_keys.g.dart`

Regenerate after editing models, providers, states, or translations:

```bash
flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir assets/translations
flutter pub run build_runner build --delete-conflicting-outputs
```

## Architecture

Forge Dance uses feature-first MVVM with Riverpod code generation:

```text
Widget -> ViewModel (AsyncNotifier) -> Repository -> Firebase / SharedPreferences
```

```text
lib/
|-- constants/
|-- design_system/          # tokens and Fg components
|-- extensions/
|-- features/
|   |-- authentication/     # Firebase Auth + authStateChanges stream
|   |-- profile/            # Firestore users/{uid} + local cache
|   |-- learn/              # static module catalog + progress persistence
|   |-- workout/            # daily WOD catalog + session persistence
|   |-- stats/              # XP, belts, streaks, derived user stats
|   |-- home/ explore/ library/ main/ onboarding/
|   `-- firebase/ session/ common/
|-- generated/
|-- routing/
`-- utils/
```

Feature folders usually contain:

```text
lib/features/<feature>/
|-- model/          # immutable models, usually freezed
|-- repository/     # IO and provider-exposed data access
|-- ui/             # state, view_model, widgets, screens
`-- application/    # only for cross-feature coordinators
```

Rules of thumb:

- Widgets render state and forward user intent to view models.
- Firebase SDKs stay inside repositories; widgets and view models do not call
  `FirebaseAuth` or `FirebaseFirestore` directly.
- Repositories take nullable Firebase dependencies and degrade gracefully when
  Firebase is unavailable.
- Design-system tokens/components (`lib/design_system/`) are the source for
  colors, typography, spacing, radii, shadows, and buttons.
- User-facing UI chrome uses `LocaleKeys.x.tr()` and keys in both
  `assets/translations/en.json` and `assets/translations/vi.json`.

## Navigation

Top-level navigation is handled by `go_router` in `lib/routing/`. Auth guarding
is centralized in the pure `computeRedirect` function
(`lib/routing/app_redirect.dart`) and covered by `test/app_redirect_test.dart`.
Screens should not imperatively redirect based on auth state.

The `/main` route is a stateful shell (`MainScreen`) with an `IndexedStack`:

0. Collection
1. Explore
2. Home
3. Training
4. Profile

Inside `/main`, overlays such as `training`, `lesson-path`, and `lesson-player`
are string-keyed shell state, not `go_router` sub-routes. The lesson player back
flow returns to the lesson path.

## Content model

Lesson and workout content ships with the app. Firestore stores user state, not
the catalog itself.

### Lessons

Static lesson content lives in
`lib/features/learn/repository/lesson_catalog.dart` and is rendered by the learn
feature screens.

When editing the catalog:

- Keep lesson ids globally unique. The original `hip-hop-foundations` lesson ids
  are legacy ids and must not change because user progress documents reference
  them.
- Every module ends with a boss lesson.
- Keep module numbering in each `subtitle` aligned with catalog order.
- `LessonStep` fields (`title`, `description`, `focus`, `breath`, `energy`)
  feed the lesson player's technique breakdown cards.
- If a lesson has no custom steps, `stepsFor()` supplies type-specific defaults.
- Lesson content vocabulary is currently English content, while UI chrome is
  localized.

Progress is stored at `users/{uid}/progress/{lessonId}`. The flat progress map
works because lesson ids are globally unique.

### Workouts and WODs

Workout content lives in
`lib/features/workout/repository/workout_catalog.dart`. `wodFor(DateTime)` uses
`dayOfYear % allWorkouts.length`, so every user sees the same deterministic WOD
for a date without backend scheduling.

Workout completion is stored at
`users/{uid}/sessions/{yyyy-MM-dd}_{workoutId}`. The deterministic document id
makes completion idempotent: repeating the same WOD on the same day does not
award XP twice.

## Gamification

Gamification rules are pure functions in
`lib/features/stats/model/stats_rules.dart` and are tested in
`test/stats_test.dart`.

- Lesson XP is awarded by `LessonType`.
- Workout XP comes from the workout catalog; a session for a missing workout
  earns 0 XP.
- Total XP is derived from completed lessons plus completed workout sessions.
- The `xp` field on the user document is a denormalized mirror written after
  training events, not the source of truth.
- Belt thresholds are calibrated so completing the lesson catalog reaches Black
  Belt; catalog changes require deliberate recalibration.
- Streaks advance from any training activity and use local `yyyy-MM-dd` date
  keys.

`StatsCoordinator` syncs XP and streaks after lesson and workout completion on a
best-effort basis. Training flows must continue even if stats sync fails.

## Firebase

Firebase project:

- Display name: `forge-dance`
- Project ID: `forge-dance-1bcc7`

Current stack:

- Firebase Auth for email/password accounts
- Cloud Firestore for profile, progress, sessions, and gamification mirrors

FlutterFire config exists for Android, iOS, macOS, web, and Windows. Linux is a
local development target that skips Firebase initialization because no Linux
options were generated.

Enable these services in Firebase Console before using auth/profile persistence:

1. Authentication > Sign-in method > Email/Password
2. Firestore Database, then deploy `firestore.rules`

Useful commands:

```bash
firebase login
flutterfire configure --project=forge-dance-1bcc7
firebase deploy --only firestore:rules
```

Firestore schema, all owner-only and validated by `firestore.rules`:

```text
users/{userId}
  id, email, name, job, avatar, diamond, createdAt, updatedAt,
  xp, streakCount, lastActivityDate

users/{userId}/progress/{lessonId}
  lessonId, status, progress, updatedAt

users/{userId}/sessions/{sessionId}
  workoutId, date, completedAt
```

Use typed Firestore references with `withConverter` inside repositories. Normalize
Firestore `Timestamp` values to ISO-8601 strings before `fromJson`.

For local auth/Firestore testing, use the emulator suite:

```bash
firebase emulators:start
flutter run --dart-define=USE_FIREBASE_EMULATOR=true
```

Unit tests should use fake repositories with nullable Firebase dependencies
instead of the emulator.
