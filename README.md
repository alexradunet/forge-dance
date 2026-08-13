# Forge Dance

Forge Dance is a gamified dance-training app built with Flutter, Riverpod
codegen, Firebase Auth, and Cloud Firestore. Users follow structured lesson
modules, complete daily workouts, and earn XP, streaks, belts, and diamonds.

The source of truth for contributor rules is `AGENTS.md`; `CLAUDE.md` adds a
deeper architecture map for AI-assisted development.

## Quick start

Flutter is pinned to 3.35.5 via FVM (`.fvmrc`).

```bash
dart pub global activate fvm   # one-time, if fvm is not installed
fvm install
fvm use
fvm flutter pub get
```

Generated files are gitignored (`*.g.dart`, `*.freezed.dart`, and
`lib/generated/locale_keys.g.dart`). Regenerate them after cloning and after
changing models, Riverpod providers, states, or translations:

```bash
fvm flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir assets/translations
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

Before handing off a change, run the single local verification pipeline:

```bash
bash tool/checks.sh
```

That script uses `fvm flutter` when FVM is available and falls back to
`flutter`. It runs dependency resolution, localization codegen, build_runner,
Riverpod custom lint, `flutter analyze`, and `flutter test`. CI mirrors those
steps and then runs a web release build.

VS Code users can run the same workflow through the default task
`forge: checks (CI pipeline)`. The workspace also includes FVM-aware tasks for
codegen, analyze, tests, web builds, Firebase emulators, and Firestore rules
deployment.

## Firebase and local development

Firebase project:

- Display name: `forge-dance`
- Project ID: `forge-dance-1bcc7`

FlutterFire configuration exists for Android, iOS, macOS, web, and Windows.
Linux desktop remains useful for local UI development, but Firebase
initialization is skipped there because no Linux FlutterFire options are
generated. Nullable Firebase providers then return `null`, repositories no-op
writes, and auth redirects enter the app as a guest.

Enable these services before exercising real auth or persistence:

1. **Authentication > Sign-in method > Email/Password**
2. **Firestore Database**, then deploy `firestore.rules`

Useful commands:

```bash
firebase login
flutterfire configure --project=forge-dance-1bcc7
firebase deploy --only firestore:rules
```

For local Firebase testing, start the emulator suite and run the app with the
emulator define:

```bash
firebase emulators:start --only auth,firestore
fvm flutter run --dart-define=USE_FIREBASE_EMULATOR=true
```

Emulator ports are defined in `firebase.json` and used by
`lib/features/firebase/repository/firebase_bootstrap.dart`:

- Auth: `localhost:9099`
- Firestore: `localhost:8080`

## Runtime data model

Content ships with the app; user state is the only persisted data.

- Lessons/modules live in `lib/features/learn/repository/lesson_catalog.dart`.
  Lesson progress is stored per user at
  `users/{uid}/progress/{lessonId}` through
  `ProgressRepository` (`lib/features/learn/repository/progress_repository.dart`).
- Workouts live in `lib/features/workout/repository/workout_catalog.dart`.
  `wodFor(DateTime)` rotates the workout of the day by day-of-year with no
  backend call. Completed sessions are stored at
  `users/{uid}/sessions/{date}_{workoutId}` through `SessionRepository`.
- Profiles live at `users/{uid}` through `ProfileRepository`, which merges the
  SharedPreferences cache with Firestore. Local avatar file paths intentionally
  stay local; only URL avatars are synced.
- Gamification rules live in `lib/features/stats/model/stats_rules.dart`.
  Total XP is derived from completed lessons plus completed workout sessions.
  The profile `xp` field is a denormalized mirror written by
  `StatsCoordinator`, not an authoritative source.

Firestore rules enforce owner-only access and these invariants:

- `users/{uid}.id` must match the authenticated uid.
- progress document ids must match `lessonId`, and status must be one of
  `notStarted`, `inProgress`, or `completed`.
- session document ids must equal `{date}_{workoutId}`, which caps workout XP
  at one award per workout per day.

## Architecture

The app follows feature-first MVVM with Riverpod code generation:

```text
Widget -> ViewModel (AsyncNotifier) -> Repository -> Firebase / SharedPreferences
```

Feature directories live under `lib/features/<feature>/` and usually contain:

```text
model/
repository/
ui/ or presentation/
```

Keep Firebase SDK usage behind repositories. Widgets render `AsyncValue` state
from view models and send user intents to notifiers; they should not call
Firebase SDKs directly.

Key entry points:

- `lib/routing/app_redirect.dart` owns auth/navigation decisions.
- `lib/routing/router.dart` wires top-level GoRouter routes.
- `lib/features/main/ui/main_screen.dart` owns the tab shell and string-keyed
  in-shell overlays such as the lesson path and lesson player.
- `lib/design_system/` contains tokens and Fg components; feature UI should use
  those primitives instead of ad-hoc styles.

See `AGENTS.md` before making changes.
