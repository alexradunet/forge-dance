# Forge Dance

Forge Dance is a gamified dance-training app built with Flutter, Riverpod, and Firebase. Users follow structured lesson modules, complete daily WOD/training sessions, and earn XP, streaks, belts, and diamonds.

## Architecture at a glance

- **Feature-first MVVM**: widgets watch Riverpod view models; view models call repositories; repositories own Firebase/local persistence.
- **Generated Riverpod/freezed code**: providers, states, and models rely on codegen that is intentionally not committed.
- **Bundled training content**: lesson modules live in `lib/features/learn/repository/lesson_catalog.dart`; WOD content lives in `lib/features/workout/repository/workout_catalog.dart`.
- **Persisted user state**: profile, lesson progress, and completed workout sessions are stored under `users/{uid}` in Firestore.
- **Derived gamification**: total XP is calculated from completed lessons plus workout sessions. The user document's `xp`, `streakCount`, and `lastActivityDate` fields are denormalized mirrors updated after training activity.

Firebase SDK usage must stay behind repositories/data sources. Widgets should call Riverpod view models, not Firebase APIs directly.

## Setup

Flutter is pinned with FVM (`.fvmrc`) to match CI.

```bash
dart pub global activate fvm
fvm install
fvm use
```

Install dependencies and generate local-only code:

```bash
fvm flutter pub get
fvm flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir assets/translations
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

Generated files (`*.g.dart`, `*.freezed.dart`, and `lib/generated/locale_keys.g.dart`) are gitignored; regenerate them after cloning and after editing models, providers, states, or translations.

## Verify changes

Use the single check script before handing off changes:

```bash
bash tool/checks.sh
```

It runs:

1. `flutter pub get`
2. localization key generation
3. Riverpod/freezed/json code generation
4. `custom_lint`
5. `flutter analyze`
6. `flutter test`

If `fvm` is installed, the script uses `fvm flutter`; otherwise it falls back to `flutter`.

## Firebase setup and local emulators

Firebase project:

- Display name: `forge-dance`
- Project ID: `forge-dance-1bcc7`

FlutterFire app configuration exists for Android, iOS, macOS, web, and Windows. Linux desktop is kept as a local development target, but Firebase initialization is skipped there because FlutterFire did not generate Linux options; repositories then degrade gracefully and local routing enters the app as a guest.

Enable these Firebase Console services before using real auth/profile persistence:

1. **Authentication > Sign-in method > Email/Password**
2. **Firestore Database**, then deploy `firestore.rules`

Useful commands:

```bash
firebase login
flutterfire configure --project=forge-dance-1bcc7
firebase deploy --only firestore:rules
```

For local auth/Firestore development, start the emulator suite and run the app with the emulator flag:

```bash
firebase emulators:start
fvm flutter run --dart-define=USE_FIREBASE_EMULATOR=true
```

The app connects Auth to `localhost:9099` and Firestore to `localhost:8080` when `USE_FIREBASE_EMULATOR=true`.

## Firestore data model

All persisted app data is owner-only under the authenticated user's document:

```text
users/{userId}
├── id, email, name, job, avatar, diamond, createdAt, updatedAt
├── xp, streakCount, lastActivityDate
├── progress/{lessonId}
│   └── lessonId, status, progress, updatedAt
└── sessions/{date}_{workoutId}
    └── workoutId, date, completedAt
```

Constraints enforced by `firestore.rules`:

- `users/{userId}.id` must match the authenticated UID.
- Lesson progress document IDs must match `lessonId`, and `status` must be one of the `LessonStatus` enum names.
- Workout session document IDs must be `{date}_{workoutId}`, capping XP at one award per workout per day.
- Rules changes are not live until `firebase deploy --only firestore:rules`.

## Common developer pitfalls

- Run codegen before analyze/tests; missing generated files cause many unrelated analyzer errors.
- Keep Firebase access in repositories. Use nullable Firebase dependencies so Linux/dev/test modes can no-op safely.
- Firestore repositories should use typed `withConverter` references and normalize `Timestamp` values before model `fromJson` calls.
- Lesson and workout content ships in code. Persist user progress/sessions, not catalog content.
- Belt thresholds in `lib/features/stats/model/stats_rules.dart` are calibrated to the lesson catalog; catalog XP changes require updating stats tests and thresholds deliberately.
- `/main` tab overlays are managed inside `MainScreen`, not as nested GoRouter routes.

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

See `AGENTS.md` before making changes.
