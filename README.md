# Forge Dance

Forge Dance is a gamified dance-training app built with Flutter, Riverpod,
Firebase Auth, and Cloud Firestore. Users sign in, follow lesson paths, complete
training workouts, and earn XP, streaks, and belt levels.

## Developer setup

Flutter is pinned with FVM:

```bash
dart pub global activate fvm
fvm install
fvm use
```

The VS Code workspace points Dart at `.fvm/versions/3.35.5`; plain terminal
commands can use either `fvm flutter ...` or `flutter ...` after the SDK is on
`PATH`.

Generated files are intentionally gitignored (`*.g.dart`, `*.freezed.dart`, and
`lib/generated/locale_keys.g.dart`). After cloning, and after changing models,
providers, states, or translations, regenerate them:

```bash
flutter pub get
flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir assets/translations
flutter pub run build_runner build --delete-conflicting-outputs
```

## Verification

Use the repo script before handing off a change:

```bash
bash tool/checks.sh
```

It runs dependency resolution, localization codegen, Riverpod/freezed/json
codegen, `custom_lint`, `flutter analyze`, and `flutter test`. CI mirrors those
steps on pull requests to `main` and also runs:

```bash
flutter build web --release --no-pub
```

## Architecture

The app uses feature-first MVVM with Riverpod code generation:

```text
Widget -> ref.watch(viewModelProvider) -> ViewModel
       -> Repository -> Firebase / SharedPreferences / local catalog
```

Product code lives under `lib/features/<feature>/`:

```text
lib/
├── constants/
├── design_system/
├── extensions/
├── features/
│   ├── authentication/   # Firebase Auth and auth state stream
│   ├── profile/          # user document plus local cache
│   ├── learn/            # lesson catalog and progress
│   ├── workout/          # daily WOD catalog and sessions
│   ├── stats/            # XP, streaks, belts
│   └── <feature>/
│       ├── model/
│       ├── repository/
│       └── ui/ or presentation/
├── generated/
├── routing/
└── utils/
```

Rules of thumb:

- Widgets render state and send user intents to view models.
- Firebase SDK usage stays behind repositories; widgets must not call Firebase
  directly.
- Repositories accept nullable Firebase dependencies and degrade gracefully when
  Firebase is unavailable.
- Shared cross-feature writes go through coordinators, such as
  `SessionCoordinator` for auth/profile setup and `StatsCoordinator` for XP and
  streak updates.
- Styling should use the design system in `lib/design_system/`.

## Content and progress model

Lesson and workout content ships with the app:

- Lessons: `lib/features/learn/repository/lesson_catalog.dart`
  - `allModules` currently contains 10 modules.
  - Lesson IDs must remain stable because progress documents use them as keys.
  - Hand-authored `LessonStep` content can include `focus`, `breath`, and
    `energy`; lessons without steps fall back to `defaultStepsFor(lesson.type)`.
- Workouts: `lib/features/workout/repository/workout_catalog.dart`
  - `allWorkouts` currently contains 7 workouts.
  - `wodFor(DateTime)` rotates through the catalog by day-of-year, so no backend
    is needed to pick the daily WOD.

Only user state is persisted:

- Lesson progress is stored at `users/{uid}/progress/{lessonId}`.
- Workout completions are stored at `users/{uid}/sessions/{date}_{workoutId}`.
  The deterministic document ID makes a workout completion idempotent for a
  given day.
- The profile document mirrors gamification fields (`xp`, `streakCount`,
  `lastActivityDate`), but display XP is derived from completed lessons plus
  completed workout sessions.

## Firebase setup and local mode

Firebase project:

- Display name: `forge-dance`
- Project ID: `forge-dance-1bcc7`

FlutterFire configuration exists for Android, iOS, macOS, web, and Windows.
Linux desktop intentionally skips Firebase initialization because no Linux
FlutterFire options are generated; nullable Firebase providers then return
`null`, auth redirects enter local dev mode, and repository writes no-op.

Enable these services before using real auth/profile persistence:

1. Authentication > Sign-in method > Email/Password
2. Firestore Database, then deploy `firestore.rules`

Useful Firebase commands:

```bash
firebase login
flutterfire configure --project=forge-dance-1bcc7
firebase deploy --only firestore:rules
```

For local Firebase testing:

```bash
firebase emulators:start
flutter run --dart-define=USE_FIREBASE_EMULATOR=true
```

Emulator ports are defined in `firebase.json` (`auth:9099`, `firestore:8080`).

## Common pitfalls

- Run code generation before analyzing; missing generated files cause large
  cascades of unresolved-symbol errors.
- Do not commit generated Dart files.
- Keep `firestore.rules` in sync with persisted models and enum names.
- When changing catalog XP or lesson counts, check the stats tests because belt
  thresholds are calibrated to the lesson catalog.
- Use `custom_lint` as part of verification; Riverpod lints are not covered by
  `flutter analyze`.

See `AGENTS.md` and `CLAUDE.md` before making changes.
