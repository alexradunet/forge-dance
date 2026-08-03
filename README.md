# Forge Dance

Forge Dance is a gamified Flutter dance-training app built with Riverpod,
Firebase, and a feature-first MVVM architecture. Users sign in, follow lesson
paths, complete the workout of the day, and earn XP, streaks, belts, and
diamonds.

## Developer quick start

Flutter is pinned to **3.35.5** with FVM (`.fvmrc`). Use FVM when available;
`tool/checks.sh` automatically falls back to `flutter` on PATH.

```bash
dart pub global activate fvm   # one-time, if fvm is not installed
fvm install
fvm use
flutter pub get
flutter run -d chrome
```

Before handing off any change, run the same pipeline CI runs:

```bash
bash tool/checks.sh
```

That script runs `pub get`, localization key generation, Riverpod/freezed/json
code generation, `custom_lint`, `flutter analyze`, and `flutter test`.

Generated files are intentionally gitignored:

- `*.g.dart`
- `*.freezed.dart`
- `lib/generated/locale_keys.g.dart`

If a fresh checkout reports missing `part` files, run `bash tool/checks.sh` or
the individual generators listed in `CLAUDE.md`.

## Architecture

Product code is organized by feature under `lib/features/<feature>/`:

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

The normal data flow is:

```text
Widget → Riverpod view model → repository → Firebase / SharedPreferences
```

Rules of thumb:

- Widgets do not import Firebase SDKs directly.
- Repositories hide IO and expose intent-based methods.
- View models own orchestration and publish `AsyncValue` state.
- Cross-feature flows use coordinators, for example `SessionCoordinator` for
  auth/profile sync and `StatsCoordinator` for XP/streak sync.
- Route guarding lives in `lib/routing/app_redirect.dart`; screens should not
  imperatively redirect based on auth state.

## Firebase and local development

Firebase project:

- Display name: `forge-dance`
- Project ID: `forge-dance-1bcc7`

FlutterFire configuration exists for Android, iOS, macOS, web, and Windows.
Linux is intentionally supported for local development without Firebase:
`initializeFirebase()` skips unsupported platforms, Firebase providers return
`null`, and the router enters the app in guest/local-dev mode.

Enable these services before testing against a real Firebase project:

1. **Authentication > Sign-in method > Email/Password**
2. **Firestore Database**, then deploy `firestore.rules`

Useful commands:

```bash
firebase login
flutterfire configure --project=forge-dance-1bcc7
firebase deploy --only firestore:rules
```

Use emulators for auth/Firestore development:

```bash
firebase emulators:start
flutter run --dart-define=USE_FIREBASE_EMULATOR=true
```

Emulator ports are defined in `firebase.json`:

- Auth: `9099`
- Firestore: `8080`
- Emulator UI: enabled

## Firestore data model

All Firestore data is owner-only and validated by `firestore.rules`.

| Path | Purpose | Key constraints |
|---|---|---|
| `users/{userId}` | Profile plus denormalized gamification stats | `id` must equal the auth uid; optional `xp`, `streakCount`, and `lastActivityDate` must have valid types |
| `users/{userId}/progress/{lessonId}` | Per-lesson status/progress | Document id must equal `lessonId`; status is one of `notStarted`, `inProgress`, `completed` |
| `users/{userId}/sessions/{date}_{workoutId}` | Completed workout sessions | Deterministic id caps workout XP at once per workout per day |

Repositories use typed Firestore converters and tolerate nullable Firebase
dependencies. In unconfigured local mode, reads return empty/local state and
writes no-op instead of crashing.

## Content and gamification

Lesson and workout content ships in code:

- Lessons/modules: `lib/features/learn/repository/lesson_catalog.dart`
- Workouts and WOD rotation: `lib/features/workout/repository/workout_catalog.dart`

Persisted user state is separate from content:

- Lesson progress is stored under `users/{uid}/progress`.
- Workout completions are stored under `users/{uid}/sessions`.
- Total XP is derived from completed lessons plus completed workout sessions.
- The profile `xp` field is a denormalized mirror written after training
  activity; it is not the source of truth.

When changing lesson IDs, workout IDs, XP values, or belt thresholds, update the
relevant tests (`test/learn_test.dart`, `test/workout_test.dart`,
`test/stats_test.dart`) so catalog stability and XP calibration stay explicit.

## Common pitfalls

| Symptom | Check |
|---|---|
| Missing generated Dart files | Run `bash tool/checks.sh`; generated files are not committed |
| `permission-denied` from Firestore | Confirm `firestore.rules` were deployed or run against emulators |
| App skips login on Linux | Expected: Linux has no generated FlutterFire options and runs in local-dev mode |
| Riverpod provider name missing | Regenerate build_runner output and verify the `part` filename |
| WOD completion gives XP once | Expected: session doc ids are `{date}_{workoutId}` |

See `AGENTS.md` before making changes and `CLAUDE.md` for the full agent
playbook, architecture notes, and command reference.
