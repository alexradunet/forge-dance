# Forge Dance

Forge Dance is a gamified dance-training app built with Flutter, Riverpod,
Firebase Auth, and Cloud Firestore. Users follow lesson paths, complete daily
workouts, and earn XP, belts, streaks, and diamonds.

Start with `AGENTS.md` before changing code. `CLAUDE.md` has the deeper
architecture map and agent playbooks live under `.claude/skills/`.

## Local setup

Flutter is pinned to **3.35.5** via FVM (`.fvmrc`) and CI uses the same SDK.

```bash
dart pub global activate fvm   # one-time, if fvm is not installed
fvm install
fvm use
bash tool/checks.sh
```

`tool/checks.sh` is the single verification command. It runs:

1. `flutter pub get`
2. easy_localization key generation
3. Riverpod/freezed/json code generation
4. `custom_lint`
5. `flutter analyze`
6. `flutter test`

CI also builds web with `flutter build web --release --no-pub`.

### Generated files

Generated Dart files are intentionally gitignored:

- `*.g.dart`
- `*.freezed.dart`
- `lib/generated/locale_keys.g.dart`

Regenerate them after cloning or after editing models, providers, state classes,
or translation JSON:

```bash
flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir assets/translations
flutter pub run build_runner build --delete-conflicting-outputs
```

If `fvm` is installed, `tool/checks.sh` automatically uses `fvm flutter`;
otherwise it falls back to `flutter`.

## Project structure

Feature code lives under `lib/features/<feature>/` and follows MVVM with
Riverpod codegen:

```text
Widget -> ViewModel (AsyncNotifier) -> Repository -> Firebase / local cache
```

```text
lib/
├── constants/
├── design_system/        # tokens and Fg components
├── extensions/
├── features/
│   └── <feature>/
│       ├── model/
│       ├── repository/
│       ├── ui/ or presentation/
│       └── application/  # only for cross-feature coordinators
├── generated/            # generated LocaleKeys, not committed
├── routing/
└── utils/
```

Core live subsystems:

- `authentication`: Firebase Auth plus `authStateChanges()` as the source of
  truth.
- `profile`: local-first SharedPreferences cache plus Firestore user document.
- `learn`: 10-module static lesson catalog plus per-user progress documents.
- `workout`: 7 static workouts, deterministic workout-of-the-day rotation, and
  completed session persistence.
- `stats`: pure XP/belt/streak rules and a coordinator that mirrors derived
  stats to the user profile document.

Widgets should call Riverpod view models. Firebase SDK calls belong in
repositories only.

## Firebase

Firebase project:

- Display name: `forge-dance`
- Project ID: `forge-dance-1bcc7`

FlutterFire configuration exists for Android, iOS, macOS, web, and Windows.
Linux desktop is a local development target, but Firebase initialization is
skipped there because FlutterFire did not generate Linux options.

Enable these services before using real auth/profile persistence:

1. **Authentication > Sign-in method > Email/Password**
2. **Firestore Database**, then deploy `firestore.rules`

Useful commands:

```bash
firebase login
flutterfire configure --project=forge-dance-1bcc7
firebase deploy --only firestore:rules
```

Current Firestore shape, all owner-only and validated in `firestore.rules`:

```text
users/{userId}
  profile fields plus xp, streakCount, lastActivityDate
users/{userId}/progress/{lessonId}
  lessonId, status, progress, updatedAt
users/{userId}/sessions/{date}_{workoutId}
  workoutId, date, completedAt
```

The `sessions` document id is deterministic so a workout awards XP at most once
per workout per local date.

### Emulator runbook

Use emulators for local auth/Firestore testing; do not test against production
data.

```bash
firebase emulators:start
flutter run --dart-define=USE_FIREBASE_EMULATOR=true
```

Ports are configured in `firebase.json` (`auth:9099`, `firestore:8080`).

## Common pitfalls

- Missing generated files usually means codegen has not run after clone or
  after a model/provider/translation change.
- `custom_lint` is separate from `flutter analyze`; use `tool/checks.sh`.
- Firestore rule changes are not live until `firebase deploy --only
  firestore:rules`.
- The `.cursor/mcp.json` Dart MCP server expects `.fvm/flutter_sdk`, which is
  created by `fvm use`.
