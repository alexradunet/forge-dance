# Forge Dance

Forge Dance is a gamified dance-training app built with Flutter, Riverpod,
Firebase Auth, and Cloud Firestore. The product flow is structured lesson paths
and daily workout sessions, with XP, belts, diamonds, achievements, and streaks
derived from training activity.

Read `AGENTS.md` before changing code. It contains the contributor rules this
README summarizes.

## First-time setup

The repo is pinned to Flutter `3.35.5` via FVM (`.fvmrc`) and CI uses the same
Flutter version.

```bash
dart pub global activate fvm
fvm install
fvm use
flutter pub get
```

If your shell does not automatically pick up `.fvm/flutter_sdk`, prefix Flutter
commands with `fvm flutter`.

## Required checks

Run the full local verification pipeline before handing off changes:

```bash
bash tool/checks.sh
```

That script installs dependencies, regenerates localization keys, regenerates
Riverpod/freezed/json code, runs Riverpod `custom_lint`, runs `flutter analyze`,
and runs `flutter test`. CI mirrors those steps and then builds a web release.

Generated files are gitignored. After editing models, Riverpod providers/states,
or translations, regenerate instead of committing generated output:

```bash
flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir assets/translations
flutter pub run build_runner build --delete-conflicting-outputs
```

## Architecture

The app is feature-first, MVVM-oriented, and uses Riverpod code generation:

```text
Widget -> ViewModel (AsyncNotifier) -> Repository -> Firebase / SharedPreferences
```

Keep SDK and IO calls behind repositories. Widgets render `AsyncValue` state and
send user intents to view models; they do not call Firebase directly.

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
├── generated/   # generated LocaleKeys only, gitignored
├── routing/
└── utils/
```

Core patterns to copy:

- `features/learn/`: static catalog, typed progress repository, view model, and
  screens backed by real progress.
- `features/authentication/` and `features/profile/`: nullable Firebase
  dependencies, local persistence, and session/profile coordination.
- `features/stats/model/stats_rules.dart`: pure, unit-tested gamification rules.

## Runtime data model

Static training content ships in Dart code; only user state is persisted.

| Data | Source of truth | Notes |
| --- | --- | --- |
| Lesson catalog | `lib/features/learn/repository/lesson_catalog.dart` | Lesson ids are stable user-data keys. Do not rename shipped ids. |
| Workout catalog and WOD rotation | `lib/features/workout/repository/workout_catalog.dart` | `wodFor(date)` rotates by day-of-year, no backend required. |
| Profile | `users/{uid}` and SharedPreferences cache | Local non-URL avatar file paths stay local and are not synced. |
| Lesson progress | `users/{uid}/progress/{lessonId}` | Doc id must equal `lessonId`; status values match `LessonStatus`. |
| Workout sessions | `users/{uid}/sessions/{date}_{workoutId}` | Deterministic doc ids cap XP at one award per workout per day. |
| XP and streak mirror | `users/{uid}` | Derived by `StatsCoordinator`; lesson/workout records remain the source of truth. |

Firestore rules in `firestore.rules` enforce owner-only access and the document
id constraints above.

## Auth, Firebase, and local dev mode

Firebase project:

- Display name: `forge-dance`
- Project ID: `forge-dance-1bcc7`

FlutterFire configuration exists for Android, iOS, macOS, web, and Windows.
Linux intentionally has no Firebase options: `initializeFirebase()` catches the
unsupported platform, nullable Firebase providers return `null`, and the app
enters local dev mode.

Auth state is centralized:

- `authStateChangesProvider` wraps `FirebaseAuth.authStateChanges()` and emits
  `null` immediately when Firebase is unavailable.
- `AuthenticationViewModel` derives login state from that stream.
- `routing/app_redirect.dart` owns all route guarding as the pure
  `computeRedirect` function.
- `routerProvider` listens to auth state via `refreshListenable`; screens should
  not navigate imperatively based on auth changes.

For Firebase-backed local testing, start the emulator suite first:

```bash
firebase emulators:start
flutter run --dart-define=USE_FIREBASE_EMULATOR=true
```

Emulator ports live in `firebase.json` (`auth:9099`, `firestore:8080`).

Before using a real Firebase environment:

1. Enable **Authentication > Sign-in method > Email/Password**.
2. Create a Firestore database.
3. Deploy rules after rule changes:

```bash
firebase deploy --only firestore:rules
```

## Navigation shape

Top-level routes live in `lib/routing/router.dart` and constants live in
`lib/routing/routes.dart`.

`/main` renders `MainScreen`, a stateful `IndexedStack` shell with these tabs:

1. Collection
2. Explore
3. Home
4. Training
5. Profile

Lesson path, lesson player, and training overlays inside the shell are
string-keyed `_subPage` states (`'lesson-path'`, `'lesson-player'`,
`'training'`), not go_router sub-routes.

## Development pitfalls

- Run code generation after touching `@riverpod`, `@freezed`, JSON models, or
  translations. Missing generated files produce many analyzer errors.
- Run `custom_lint`; it is separate from `flutter analyze` and catches Riverpod
  issues.
- Keep colors, typography, spacing, radii, and shadows in `lib/design_system/`.
  Feature UI should use existing design tokens/components or add missing
  primitives there first.
- Add user-facing strings to both `assets/translations/en.json` and
  `assets/translations/vi.json`, then regenerate `LocaleKeys`.
- Keep Firebase writes nullable-safe. Repositories should no-op writes and
  return empty data when Firebase or the current user is unavailable.
- Treat `profile.xp`, `profile.streakCount`, and `profile.lastActivityDate` as
  denormalized display fields. Recompute XP from lesson progress and workout
  sessions.
