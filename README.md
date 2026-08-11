# Forge Dance

Forge Dance is a gamified dance-training app built with Flutter, Riverpod
codegen, Firebase Auth, and Cloud Firestore. Users follow lesson modules,
complete daily workouts, and track XP, streaks, belts, and diamonds.

## Current app surface

- **Auth and profile:** email/password Firebase Auth plus `users/{uid}` profile
  documents, with SharedPreferences as a local cache.
- **Learn:** a static in-app lesson catalog (`lesson_catalog.dart`) backed by
  per-user progress documents in Firestore.
- **Explore and collection:** catalog views derived from the same lesson modules;
  collection shows lessons the user has started or completed.
- **Training/WOD:** seven static workouts rotate deterministically by day of
  year. Completion writes `users/{uid}/sessions/{date}_{workoutId}`.
- **Stats:** XP is derived from completed lessons plus completed workout
  sessions. The profile `xp`, `streakCount`, and `lastActivityDate` fields are
  denormalized mirrors written after training events.

## Quick start

Flutter is pinned with FVM:

```bash
dart pub global activate fvm
fvm install
fvm use
```

Then install and generate the code that is intentionally gitignored:

```bash
fvm flutter pub get
fvm flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir assets/translations
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

`*.g.dart`, `*.freezed.dart`, and `lib/generated/locale_keys.g.dart` are not
committed. Regenerate after changing models, Riverpod providers, states, or
translations.

## Verify changes

Run the full local checks script before handing off:

```bash
bash tool/checks.sh
```

That script runs dependency resolution, localization generation, build_runner,
Riverpod custom lints, `flutter analyze`, and `flutter test`. CI runs the same
sequence and then `flutter build web --release --no-pub`. VS Code users can run
the default task **forge: checks (CI pipeline)**; individual codegen,
custom_lint, analyze, test, web build, and Firebase emulator tasks are also
defined in `.vscode/tasks.json`.

## Running locally

Common launch targets are in `.vscode/launch.json`:

- **Chrome (Debug)** for normal web development.
- **Chrome (Firebase Emulator + Start Emulators)** to run Auth and Firestore
  locally before launching the app.
- **Linux Desktop (Debug)** for local UI work without Firebase. Linux has no
  generated FlutterFire options, so Firebase initialization is skipped and
  repositories return empty/no-op results.

Manual emulator loop:

```bash
firebase emulators:start --only auth,firestore
fvm flutter run -d chrome --dart-define=USE_FIREBASE_EMULATOR=true
```

## Firebase runbook

Firebase project:

- Display name: `forge-dance`
- Project ID: `forge-dance-1bcc7`

Required console setup:

1. Enable **Authentication > Sign-in method > Email/Password**.
2. Create a **Firestore Database**.
3. Deploy owner-only security rules after changes:

```bash
firebase login
flutterfire configure --project=forge-dance-1bcc7
firebase deploy --only firestore:rules
```

Storage shape:

```text
users/{userId}
users/{userId}/progress/{lessonId}
users/{userId}/sessions/{date}_{workoutId}
```

Firestore rules require profile `id == uid`, progress document ids to match the
lesson id, progress status to match the `LessonStatus` enum names, and workout
session ids to match `date + '_' + workoutId`.

## Architecture constraints

Data flow is intentionally narrow:

```text
Widget -> Riverpod view model -> repository -> Firebase / SharedPreferences
```

- Keep Firebase SDK calls inside repositories or Firebase bootstrap/providers.
- View models orchestrate mutations and expose `AsyncValue` state.
- Widgets render state and send user intents; they should not contain business
  logic or auth redirects.
- Navigation guarding lives in `lib/routing/app_redirect.dart` and is tested as
  a pure function.
- New user-facing strings should use easy_localization keys in both
  `assets/translations/en.json` and `assets/translations/vi.json`.
- UI should use `lib/design_system/` tokens/components instead of ad-hoc colors,
  spacing, or typography.

See `AGENTS.md` and `CLAUDE.md` before making code changes; they contain the
complete contributor rules and feature-specific implementation patterns.
