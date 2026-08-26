# Forge Dance

Forge Dance is a gamified dance-training app built with Flutter, Riverpod
codegen, Firebase, and a feature-first MVVM architecture. Users sign in,
follow module-based lessons, complete daily WOD training sessions, and track
XP, belts, streaks, diamonds, and achievements.

Read `AGENTS.md` before making changes. It is the contributor contract for
architecture, generated code, checks, and local development.

## Local setup

Flutter is pinned with FVM to match CI:

```bash
dart pub global activate fvm
fvm install
fvm use
```

Then install dependencies and generate ignored source files:

```bash
fvm flutter pub get
fvm flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir assets/translations
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

If `fvm` is not on `PATH`, the check script falls back to `flutter`. Do not run
`flutter upgrade` in this repo without a deliberate SDK version bump.

### Generated files

Generated Dart files are intentionally gitignored:

- `*.g.dart`
- `*.freezed.dart`
- `lib/generated/locale_keys.g.dart`

Regenerate after editing models, Riverpod providers, state classes, or
translations. Never commit generated files.

## Day-to-day commands

Use the single verification entry point before handing off or pushing:

```bash
bash tool/checks.sh
```

It runs, in order:

1. `flutter pub get`
2. localization key generation
3. `build_runner`
4. `custom_lint`
5. `flutter analyze`
6. `flutter test`

Useful focused commands:

```bash
fvm flutter run -d chrome
firebase emulators:start
fvm flutter run --dart-define=USE_FIREBASE_EMULATOR=true
firebase deploy --only firestore:rules
```

`custom_lint` is not part of `flutter analyze`; use `tool/checks.sh` when you
need parity with CI.

## Backend and data model

Firebase is the selected MVP backend.

- Firebase project ID: `forge-dance-1bcc7`
- Firebase Auth: email/password accounts
- Cloud Firestore: profile, lesson progress, and workout session data

FlutterFire configuration exists for Android, iOS, macOS, web, and Windows.
Linux desktop is supported for local development, but Firebase initialization is
skipped because there is no generated Linux FlutterFire configuration. In that
mode, Firebase providers return `null`; repositories degrade to empty reads and
no-op writes.

Firestore data is owner-only and validated by `firestore.rules`:

```text
users/{uid}
users/{uid}/progress/{lessonId}
users/{uid}/sessions/{date}_{workoutId}
```

Key constraints:

- `users/{uid}.id` must match the authenticated uid.
- Optional profile stats (`xp`, `streakCount`, `lastActivityDate`) must have
  sane types.
- `progress/{lessonId}.lessonId` must match the document id, and `status` must
  be one of the `LessonStatus` enum names.
- `sessions/{date}_{workoutId}` uses a deterministic document id so a workout
  can award XP at most once per day.

XP is derived from completed lessons plus completed workout sessions. The
profile `xp` field is a denormalized mirror written after training events, not
the source of truth.

### Local Firebase emulators

Use emulators for auth and Firestore behavior:

```bash
firebase emulators:start
fvm flutter run --dart-define=USE_FIREBASE_EMULATOR=true
```

Emulator ports are defined in `firebase.json`:

- Auth: `9099`
- Firestore: `8080`
- Emulator UI: enabled

Enable Email/Password auth and create a Firestore database in Firebase Console
before using real Firebase persistence, then deploy `firestore.rules`.

## Architecture

Product code is feature-first under `lib/features/<feature>/`:

```text
lib/
├── constants/
├── design_system/
├── extensions/
├── features/
│   ├── authentication/
│   ├── profile/
│   ├── learn/
│   ├── home/
│   ├── explore/
│   ├── library/
│   ├── stats/
│   ├── workout/
│   ├── firebase/
│   ├── session/
│   └── <feature>/
│       ├── model/
│       ├── repository/
│       └── ui/ or presentation/
├── generated/
├── routing/
└── utils/
```

Data flow:

```text
Widget -> Riverpod view model -> Repository -> Firebase / local persistence
```

Keep Firebase SDK usage behind repositories. Widgets render state and send user
intents to view models; they should not call Firebase directly.

## Editor and MCP tooling

VS Code settings and launch/tasks files are committed for the pinned FVM SDK.
Cursor's Dart MCP server is configured in `.cursor/mcp.json` and runs
`.fvm/flutter_sdk/bin/dart mcp-server --force-roots-fallback`, so run `fvm use`
after cloning before relying on MCP tools.
