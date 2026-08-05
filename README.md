# Forge Dance

Forge Dance is a gamified dance-training app built with Flutter, Riverpod
codegen, and Firebase. Users sign in, follow structured lesson paths, complete
daily workout sessions, and earn XP, streaks, belts, and profile progression.

## Current architecture

Product code is feature-first and follows the same data path throughout the app:

```text
Widget -> Riverpod ViewModel -> Repository -> Firebase / SharedPreferences
```

Key constraints:

- Firebase SDK usage stays behind repositories. Widgets render state and call
  view models; they do not call `FirebaseAuth` or `FirebaseFirestore` directly.
- Riverpod providers use annotations (`@riverpod` / `@Riverpod`) and generated
  `*.g.dart` files.
- `*.g.dart`, `*.freezed.dart`, and `lib/generated/locale_keys.g.dart` are
  intentionally gitignored. Regenerate them after cloning and after editing
  models, providers, states, or translations.
- Static lesson and workout content ships in code. User-specific state is stored
  separately under the signed-in user's Firestore document.

Live feature areas:

| Area | Source of truth | Notes |
| --- | --- | --- |
| Authentication | `FirebaseAuth.authStateChanges()` | Centralized by `authStateChangesProvider`; route guarding lives in `lib/routing/app_redirect.dart`. |
| Profile | `users/{uid}` plus SharedPreferences cache | Local avatar file paths stay local and are not synced to Firestore. |
| Learn | `lesson_catalog.dart` plus `users/{uid}/progress` | Catalog has 10 modules; lesson IDs must stay stable because progress docs use them. |
| Explore / Collection / Home | Learn catalog + progress + profile | These screens derive their cards and progress from real app state. |
| Workout / WOD | `workout_catalog.dart` plus `users/{uid}/sessions` | WOD rotates deterministically by day-of-year; session doc IDs prevent double XP for the same workout/day. |
| Stats | Pure rules in `stats_rules.dart` | XP is derived from completed lessons and workout sessions; the profile `xp` field is only a denormalized mirror. |

See `CLAUDE.md` for deeper architecture notes and `AGENTS.md` for contributor
rules.

## Local setup

The repository is pinned to Flutter **3.35.5** with FVM (`.fvmrc`).

```bash
dart pub global activate fvm
fvm install
fvm use
fvm flutter pub get
fvm flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir assets/translations
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

After `fvm use`, VS Code/Cursor use the workspace settings in `.vscode/`:

- `.vscode/settings.json` points Dart at `.fvm/versions/3.35.5` and enables the
  Dart/Flutter MCP server.
- `.vscode/tasks.json` exposes tasks for checks, codegen, custom lint, tests,
  web builds, Firebase emulators, and Firestore rules deploys.
- `.cursor/mcp.json` starts the Dart MCP server from `.fvm/flutter_sdk/bin/dart`;
  restart the editor after creating the `.fvm/flutter_sdk` symlink.

If you do not use FVM, `tool/checks.sh` falls back to `flutter` on PATH.

## Run the app

```bash
fvm flutter run -d chrome
```

Linux desktop is supported for local UI work but has no generated FlutterFire
options. On Linux, Firebase initialization is skipped, nullable Firebase
providers return `null`, and the router enters `/main` in local dev mode.

To exercise auth and Firestore locally, use the emulator suite:

```bash
firebase emulators:start --only auth,firestore
fvm flutter run --dart-define=USE_FIREBASE_EMULATOR=true
```

Ports are defined in `firebase.json`:

- Auth: `9099`
- Firestore: `8080`

## Verification

Run the single checks script before handing off changes:

```bash
bash tool/checks.sh
```

It runs, in order:

1. `flutter pub get`
2. localization key generation
3. Riverpod/freezed/json code generation
4. `custom_lint`
5. `flutter analyze`
6. `flutter test`

CI uses Flutter 3.35.5, performs the same checks, and also runs:

```bash
flutter build web --release --no-pub
```

## Firebase setup

Firebase project:

- Display name: `forge-dance`
- Project ID: `forge-dance-1bcc7`

FlutterFire configuration exists for Android, iOS, macOS, web, and Windows.
Enable these Firebase services before using persisted auth/profile/progress data:

1. Authentication -> Sign-in method -> Email/Password
2. Cloud Firestore, then deploy `firestore.rules`

Useful commands:

```bash
firebase login
flutterfire configure --project=forge-dance-1bcc7
firebase deploy --only firestore:rules
```

Firestore schema enforced by `firestore.rules`:

| Path | Purpose | Constraints |
| --- | --- | --- |
| `users/{userId}` | Profile plus denormalized gamification stats | Owner-only. `id` must equal auth UID. Optional `xp`, `streakCount`, and `lastActivityDate` are type-checked. |
| `users/{userId}/progress/{lessonId}` | Per-lesson progress | Owner-only. Doc ID must equal `lessonId`; status must be one of `notStarted`, `inProgress`, `completed`. |
| `users/{userId}/sessions/{date}_{workoutId}` | Completed workout sessions | Owner-only. Doc ID must equal `date + '_' + workoutId`, capping XP at one award per workout per day. |

## Common pitfalls

| Symptom | What to check |
| --- | --- |
| Missing `*.g.dart`, `*.freezed.dart`, or `LocaleKeys` symbols | Run localization generation and build_runner, or just run `bash tool/checks.sh`. Generated files are not committed. |
| Riverpod lints pass in `flutter analyze` but fail in CI | Run `fvm flutter pub run custom_lint`; it is separate from the analyzer. |
| App skips login and opens `/main` locally | Firebase is unconfigured for the platform. This is expected on Linux and uses local dev mode. |
| `permission-denied` from Firestore | Deploy `firestore.rules` and confirm the document path and owner UID match the rules. |
| Workout XP does not increase after repeating a session | The session doc ID is deterministic by date and workout ID, so the same workout only awards XP once per day. |
| Catalog edits break gamification tests | Belt thresholds are calibrated to the lesson catalog; update `stats_rules.dart` deliberately when changing total catalog XP. |
