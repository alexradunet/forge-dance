# Forge Dance

Forge Dance is a Flutter dance-training app built with Riverpod, Firebase,
and a feature-first MVVM architecture. Users sign in, follow lesson paths,
complete workouts, and earn XP, streaks, belts, and diamonds.

Read `AGENTS.md` before contributing; `CLAUDE.md` contains the fuller agent
playbook and feature status.

## Quick start

Flutter is pinned to **3.35.5** in `.fvmrc` and CI uses the same version.

```bash
dart pub global activate fvm
fvm install
fvm use
fvm flutter pub get
```

Cursor/VS Code settings point Dart tooling at the FVM SDK and enable the Dart
MCP server. If MCP fails to start after cloning, run `fvm use` so
`.fvm/flutter_sdk` exists, then restart the editor.

Run the app:

```bash
fvm flutter run -d chrome
```

Linux desktop is supported for local UI work, but Firebase initialization is
skipped because FlutterFire has no Linux options in this repo. In that mode
auth is bypassed and repositories degrade to empty reads/no-op writes.

## Architecture at a glance

Data flow:

```text
Widget -> Riverpod view model -> repository -> Firebase / SharedPreferences
```

Key constraints:

- Firebase SDKs stay behind repositories in `lib/features/*/repository/`.
  Widgets render state and call view-model intents.
- Providers use Riverpod code generation (`@riverpod` /
  `@Riverpod(keepAlive: true)`), not hand-written `Provider(...)` instances.
- Generated files (`*.g.dart`, `*.freezed.dart`,
  `lib/generated/locale_keys.g.dart`) are gitignored and must be regenerated
  locally.
- Navigation auth guarding lives in `lib/routing/app_redirect.dart`; screens
  should not imperatively redirect based on auth state.
- Design primitives come from `lib/design_system/` tokens and components.

Feature shape:

```text
lib/features/<feature>/
├── model/
├── repository/
└── ui/ or presentation/
```

Live data surfaces include:

- Auth/profile: Firebase Auth plus `users/{uid}` profile documents, with a
  SharedPreferences profile cache.
- Learn: static lesson catalog in code plus per-user progress at
  `users/{uid}/progress/{lessonId}`.
- Workout: static workout catalog plus completed sessions at
  `users/{uid}/sessions/{date}_{workoutId}`.
- Stats: XP and belts are derived from lesson progress and workout sessions;
  the user document mirrors aggregate stats for display.

## Required checks

Use the repository script as the single local definition of done:

```bash
bash tool/checks.sh
```

It runs:

1. `flutter pub get`
2. localization key generation
3. `build_runner` for Riverpod/freezed/json code
4. `custom_lint` for Riverpod lints
5. `flutter analyze`
6. `flutter test`

The script uses `fvm flutter` when `fvm` is installed and falls back to
`flutter` on `PATH`. GitHub Actions runs the same sequence on `main` and then
adds:

```bash
flutter build web --release --no-pub
```

Do not commit generated files.

## Firebase setup and emulator runbook

Firebase project:

- Display name: `forge-dance`
- Project ID: `forge-dance-1bcc7`

FlutterFire configuration is committed for Android, iOS, macOS, web, and
Windows. Before using real auth/profile/progress persistence, enable:

1. **Authentication > Sign-in method > Email/Password**
2. **Firestore Database**, then deploy `firestore.rules`

Useful commands:

```bash
firebase login
flutterfire configure --project=forge-dance-1bcc7
firebase deploy --only firestore:rules
```

For local auth/Firestore testing:

```bash
firebase emulators:start
fvm flutter run --dart-define=USE_FIREBASE_EMULATOR=true
```

Ports are defined in `firebase.json`: Auth `9099`, Firestore `8080`, Emulator
UI enabled.

## Common pitfalls

| Symptom | Fix |
|---|---|
| Missing `*.g.dart`, `*.freezed.dart`, or `LocaleKeys` symbols | Run `bash tool/checks.sh` or rerun the localization and build_runner commands from the script. |
| `flutter analyze` passes but Riverpod issues remain | Run `flutter pub run custom_lint` or the full checks script; custom_lint is separate from analyzer. |
| Firebase auth fails locally with `operation-not-allowed` | Enable Email/Password sign-in in Firebase Console or use the local emulator flow. |
| Firestore `permission-denied` | Deploy `firestore.rules` to the project you are testing against. |
| App opens `/main` without login on Linux | Expected local-dev behavior: Firebase is unconfigured on Linux, so auth is bypassed. |
| Dart MCP cannot start | Run `fvm use` to create `.fvm/flutter_sdk`, then restart Cursor/VS Code. |
