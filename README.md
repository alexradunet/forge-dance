# Forge Dance

Forge Dance is a gamified dance-training Flutter app built with Riverpod,
Firebase, and a feature-first MVVM architecture. Users follow lesson paths,
run daily workouts, and earn XP, diamonds, streaks, belts, and achievements.

Read `AGENTS.md` before making changes. It is the contributor rulebook; this
README is the quick-start and operations guide.

## Quick start

The Flutter SDK is pinned to **3.35.5** with FVM (`.fvmrc`) so local tooling,
VS Code/Cursor, and CI use the same SDK.

```bash
dart pub global activate fvm   # one-time, if fvm is not installed
fvm install
fvm use
bash tool/checks.sh
```

`tool/checks.sh` is the local definition of done. It runs dependency install,
localization codegen, Riverpod/freezed/json codegen, `custom_lint`,
`flutter analyze`, and `flutter test`. CI mirrors those steps and also runs a
web release build.

### Generated code

Generated files are intentionally ignored:

- `*.g.dart`
- `*.freezed.dart`
- `lib/generated/locale_keys.g.dart`

After cloning, and after editing models, providers, states, or translations,
regenerate them with:

```bash
fvm flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir assets/translations
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

Never commit generated files.

## Common commands

| Task | Command |
| --- | --- |
| Full verification | `bash tool/checks.sh` |
| Install packages | `fvm flutter pub get` |
| Generate localization keys | `fvm flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir assets/translations` |
| Generate Riverpod/freezed/json code | `fvm flutter pub run build_runner build --delete-conflicting-outputs` |
| Watch generated code | `fvm flutter pub run build_runner watch --delete-conflicting-outputs` |
| Riverpod lints | `fvm flutter pub run custom_lint` |
| Analyze | `fvm flutter analyze` |
| Tests | `fvm flutter test` |
| Run web locally | `fvm flutter run -d chrome` |
| Web release build | `fvm flutter build web --release` |

VS Code and Cursor users can also run the checked-in tasks in `.vscode/tasks.json`
and launch profiles in `.vscode/launch.json`. The default test task is
`forge: checks (CI pipeline)`.

## Firebase and local emulators

Firebase is the selected MVP backend.

- Display name: `forge-dance`
- Project ID: `forge-dance-1bcc7`
- Auth: Firebase Auth email/password accounts
- Database: Cloud Firestore user, progress, and session data

FlutterFire configuration exists for Android, iOS, macOS, web, and Windows.
Linux desktop is supported for local development, but Firebase initialization is
skipped there because no Linux Firebase options are generated; repositories
receive nullable Firebase dependencies and degrade to local/no-op behavior.

Before using auth/profile persistence against a real Firebase project, enable:

1. **Authentication > Sign-in method > Email/Password**
2. **Firestore Database**, then deploy `firestore.rules`

Useful Firebase commands:

```bash
firebase login
flutterfire configure --project=forge-dance-1bcc7
firebase deploy --only firestore:rules
```

For local auth and Firestore testing:

```bash
firebase emulators:start --only auth,firestore
fvm flutter run -d chrome --dart-define=USE_FIREBASE_EMULATOR=true
```

Emulator ports live in `firebase.json`: Auth `9099`, Firestore `8080`.

## Architecture orientation

Data flow follows:

```text
Widget
  -> Riverpod view model
  -> repository
  -> Firebase / SharedPreferences / static catalog
```

Product code lives under `lib/features/<feature>/`:

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

Important constraints:

- Keep Firebase SDK calls behind repositories/data sources.
- Widgets render state and send user intents to Riverpod view models.
- Use code-generated Riverpod providers (`@riverpod` / `@Riverpod`).
- Use design-system tokens and `Fg` components for UI primitives.
- Add user-facing text to both `assets/translations/en.json` and
  `assets/translations/vi.json`, then regenerate localization keys.
- Navigation guarding lives in `lib/routing/app_redirect.dart`.

## Troubleshooting

- **`flutter: command not found`**: install FVM and run `fvm install && fvm use`,
  or ensure Flutter 3.35.5 is on `PATH`.
- **Missing `*.g.dart`, `*.freezed.dart`, or `LocaleKeys` symbols**: run
  `bash tool/checks.sh` or the two codegen commands above.
- **Riverpod lint failures after `flutter analyze` passed**: run
  `fvm flutter pub run custom_lint`; CI and `tool/checks.sh` run it separately.
- **Auth/Firestore calls fail locally**: start the Firebase emulators and run
  the app with `--dart-define=USE_FIREBASE_EMULATOR=true`.
- **Linux behaves like a guest session**: expected. Linux skips Firebase
  initialization and routing enters local development mode.
