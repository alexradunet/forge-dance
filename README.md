# Forge Dance

Forge Dance is a gamified dance-training app built with Flutter, Riverpod,
Firebase Auth, and Cloud Firestore. Users sign in, follow lesson paths, run
daily workouts, and progress through XP, streaks, diamonds, and belt levels.

- Package/import name: `forge_dance`
- Firebase project ID: `forge-dance-1bcc7`
- Flutter SDK: `3.35.5` via FVM (`.fvmrc`)
- Platforms with FlutterFire config: Android, iOS, macOS, web, Windows
- Linux desktop: runs in local development mode and skips Firebase

Read `AGENTS.md` before changing code. `CLAUDE.md` has the deeper architecture
playbook and agent-specific notes.

## Quick start

```bash
dart pub global activate fvm   # one-time, if fvm is missing
fvm install
fvm use
fvm flutter pub get
fvm flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir assets/translations
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

Generated files (`*.g.dart`, `*.freezed.dart`, and
`lib/generated/locale_keys.g.dart`) are intentionally gitignored. Regenerate
them after cloning and after editing models, providers, states, or translations.
Do not commit generated files.

## Verification

Run the same checks before every hand-off:

```bash
bash tool/checks.sh
```

The script runs dependency install, localization codegen, Riverpod/freezed/json
codegen, `custom_lint`, `flutter analyze`, and `flutter test`. CI mirrors these
steps and then runs a web release build:

```bash
flutter build web --release --no-pub
```

If `fvm` is installed, `tool/checks.sh` uses `fvm flutter`; otherwise it falls
back to `flutter`.

## App architecture

Forge Dance uses feature-first MVVM with Riverpod code generation:

```text
Widget -> ref.watch(xViewModelProvider) -> ViewModel (AsyncNotifier)
       -> Repository -> Firebase / SharedPreferences / static catalog
```

Feature directories follow this shape:

```text
lib/
├── constants/
├── design_system/        # tokens and Fg components
├── extensions/
├── features/
│   └── <feature>/
│       ├── model/        # freezed/json models
│       ├── repository/   # IO and static catalogs
│       └── ui/ or presentation/
├── generated/            # generated LocaleKeys, not committed
├── routing/              # go_router routes and redirect guard
└── utils/
```

Core constraints:

- Widgets never call Firebase SDKs directly. Use feature view models and
  repositories.
- Riverpod providers are code-generated (`@riverpod` or
  `@Riverpod(keepAlive: true)`), not hand-written `Provider(...)` declarations.
- Repositories accept nullable Firebase dependencies and degrade gracefully when
  Firebase is unavailable.
- UI styling should come from `lib/design_system/` tokens and Fg components.
- New user-facing strings should use `easy_localization` keys in both
  `assets/translations/en.json` and `assets/translations/vi.json`.

## Live feature workflows

### Authentication and routing

- `authStateChangesProvider` wraps `FirebaseAuth.authStateChanges()` and is the
  single source of truth for signed-in state.
- `lib/routing/app_redirect.dart` contains the pure `computeRedirect` guard.
  Tests in `test/app_redirect_test.dart` cover the redirect matrix.
- `routerProvider` listens to the authentication view model via
  `refreshListenable`; screens should not navigate imperatively based on auth.
- Boot flow: `/` splash -> signed-in users go to `/main`; signed-out users go
  to `/login` or `/register` based on the local existing-account flag.
- When Firebase is unconfigured, the redirect enters `/main` as a guest for
  local development.

### Profile

- Profile data is local-first through `SharedPreferences`, then merged with the
  signed-in user's Firestore document at `users/{uid}`.
- Local avatar file paths are intentionally kept local. Only URL avatars sync to
  Firestore.
- `SessionCoordinator` handles cross-feature auth/profile orchestration.

### Learn

- Lesson content ships in `lib/features/learn/repository/lesson_catalog.dart`.
  Only user progress is persisted.
- Progress lives at `users/{uid}/progress/{lessonId}` and is accessed through
  `ProgressRepository` with a typed Firestore converter.
- Lesson IDs are stable user-data keys. Do not rename existing IDs after
  release; existing progress documents reference them.
- Completing a lesson updates progress, unlocks the next node, and best-effort
  syncs XP/streaks through `StatsCoordinator`.

### Workout / daily WOD

- Workout content ships in `lib/features/workout/repository/workout_catalog.dart`.
- `wodFor(DateTime)` picks the workout of the day deterministically by
  day-of-year, with no backend lookup.
- Completed sessions live at `users/{uid}/sessions/{date}_{workoutId}`. The
  deterministic document ID caps workout XP at one award per workout per day.
- `WorkoutViewModel.completeWod()` returns whether XP was awarded for the first
  completion of today's WOD.

### Stats and gamification

- Pure rules live in `lib/features/stats/model/stats_rules.dart` and are covered
  by `test/stats_test.dart`.
- Total XP is derived from completed lessons plus completed workout sessions.
- The `xp` field on `users/{uid}` is a denormalized mirror written after
  training activity, not the source of truth.
- Belt thresholds are calibrated so completing the lesson catalog reaches Black
  Belt. If catalog XP changes, update thresholds deliberately and adjust tests.
- Streaks advance from any training activity. Display streak drops to zero after
  the streak is no longer active.

## Firebase setup and local emulators

FlutterFire options exist for Android, iOS, macOS, web, and Windows. Enable
these services in the Firebase Console before using real auth/profile
persistence:

1. Authentication > Sign-in method > Email/Password
2. Firestore Database

Useful Firebase commands:

```bash
firebase login
flutterfire configure --project=forge-dance-1bcc7
firebase deploy --only firestore:rules
```

For local auth/Firestore testing, run the emulator suite and start the app with
the emulator flag:

```bash
firebase emulators:start
fvm flutter run --dart-define=USE_FIREBASE_EMULATOR=true
```

Do not test against production data for development workflows.

## Firestore data model

Security rules are in `firestore.rules`. All user data is owner-only.

```text
users/{userId}
  id: must equal the Firebase Auth uid
  email, name, job, avatar, diamond
  xp, streakCount, lastActivityDate
  createdAt, updatedAt

users/{userId}/progress/{lessonId}
  lessonId: must equal the document id
  status: notStarted | inProgress | completed
  progress
  updatedAt

users/{userId}/sessions/{date}_{workoutId}
  workoutId
  date: yyyy-MM-dd
  completedAt
```

Repository converters normalize Firestore `Timestamp` values to ISO-8601
strings before model deserialization.

## Common pitfalls

- Missing generated files cause many analyzer errors. Run `bash tool/checks.sh`
  or the codegen commands in Quick start.
- `custom_lint` is required for Riverpod lint coverage; `flutter analyze` alone
  is not enough.
- Linux intentionally has no Firebase options. Repositories should return empty
  reads/no-op writes instead of throwing when Firebase dependencies are null.
- Firestore `permission-denied` usually means the rules were not deployed or the
  document shape does not match `firestore.rules`.
- The live home/explore/library screens are under `presentation/pages/`.
  Some older prototype screens remain in `ui/`; check imports before extending
  one.
