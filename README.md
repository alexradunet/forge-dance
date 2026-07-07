# Forge Dance

Forge Dance is a gamified dance-training app built with Flutter, Riverpod
codegen, and Firebase. Users follow structured lesson paths, complete daily
training/WOD sessions, and earn XP, streaks, belts, and achievements.

Start with `AGENTS.md` before contributing. `CLAUDE.md` is the detailed
architecture handbook and `.claude/skills/` contains task-specific playbooks.

## Stack

- Flutter 3.35.5, pinned by FVM (`.fvmrc`)
- Feature-first MVVM with generated Riverpod providers
- Firebase Auth + Cloud Firestore, project `forge-dance-1bcc7`
- Generated code for Riverpod/freezed/json and localization is gitignored

Firebase SDK usage belongs behind repositories/data sources. Widgets render
Riverpod view-model state and must not call Firebase APIs directly.

## Local setup

```bash
dart pub global activate fvm # one-time, if FVM is not installed
fvm install
fvm use
fvm flutter pub get
```

The VS Code workspace is configured to use `.fvm/flutter_sdk`. In a terminal
without FVM, the scripts fall back to `flutter` when available.

## Verify a change

Run the project check script before handing off:

```bash
bash tool/checks.sh
```

It installs packages, regenerates localization and Riverpod/freezed/json code,
runs `custom_lint`, analyzes, and runs tests. GitHub Actions mirrors these
steps on Flutter 3.35.5 and adds a web release build.

Useful one-off commands:

| Task | Command |
|---|---|
| Codegen only | `fvm flutter pub run build_runner build --delete-conflicting-outputs` |
| Watch codegen | `fvm flutter pub run build_runner watch --delete-conflicting-outputs` |
| Analyze | `fvm flutter analyze` |
| Tests | `fvm flutter test` |
| Web release build | `fvm flutter build web --release` |

## Firebase setup

FlutterFire configuration exists for Android, iOS, macOS, web, and Windows.
Linux desktop runs locally but skips Firebase initialization because there is no
FlutterFire Linux config.

Enable these services before using real auth/profile persistence:

1. **Authentication > Sign-in method > Email/Password**
2. **Firestore Database**, then deploy the checked-in rules

```bash
firebase login
flutterfire configure --project=forge-dance-1bcc7
firebase deploy --only firestore:rules
```

For local auth/Firestore development, use the emulator suite instead of
production data:

```bash
firebase emulators:start --only auth,firestore
fvm flutter run --dart-define=USE_FIREBASE_EMULATOR=true
```

VS Code also provides `Chrome (Firebase Emulator + Start Emulators)`, which
starts the emulator task before launching Chrome.

## Project structure

```text
lib/
├── constants/       # shared constants and asset paths
├── design_system/   # tokens and Fg components
├── extensions/      # BuildContext, string, date, iterable helpers
├── features/
│   ├── <feature>/
│   │   ├── model/          # immutable/freezed models
│   │   ├── repository/     # IO and provider-backed data access
│   │   ├── ui/ or presentation/
│   │   └── application/    # optional cross-feature coordinators
│   └── firebase/           # nullable Firebase providers/bootstrap
├── generated/       # LocaleKeys output (gitignored)
├── routing/         # go_router routes and redirect policy
└── utils/
```

The live app is wired to real data across authentication, profile, learn,
home, explore, collection, stats, and workout/training. Lesson and workout
content ships in code; user state lives in `users/{uid}/progress` and
`users/{uid}/sessions`.
