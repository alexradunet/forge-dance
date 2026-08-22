# Forge Dance

Forge Dance is a gamified dance-training app built with Flutter, Riverpod,
Firebase Auth, and Cloud Firestore. The app ships lesson and workout content in
code, then persists only user-owned state such as profile data, lesson progress,
completed workout sessions, XP, and streak metadata.

## Developer setup

Flutter is pinned with FVM:

```bash
dart pub global activate fvm
fvm install
fvm use
```

VS Code/Cursor uses `.fvm/versions/3.35.5` from `.vscode/settings.json`. The
Dart MCP server is configured in `.cursor/mcp.json` and expects
`.fvm/flutter_sdk` to exist after `fvm use`.

Generated files are intentionally gitignored (`*.g.dart`, `*.freezed.dart`,
`lib/generated/locale_keys.g.dart`). A fresh checkout needs code generation
before analysis will pass.

## Daily commands

Use the repo check script as the definition of done:

```bash
bash tool/checks.sh
```

It runs `flutter pub get`, localization key generation, `build_runner`,
`custom_lint`, `flutter analyze`, and `flutter test` in the same order CI uses.
Run individual commands only when iterating on one failure.

For local app runs:

```bash
flutter run -d chrome
```

Linux desktop is supported for local UI development, but Firebase initialization
is skipped there because FlutterFire has no Linux options. In that mode auth is
bypassed and Firebase-backed repositories return empty data or no-op writes.

## Architecture at a glance

The app follows feature-first MVVM with Riverpod code generation:

```text
Widget -> ViewModel (AsyncNotifier) -> Repository -> Firebase/local cache
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

Key constraints:

- Firebase SDK usage stays behind repositories; widgets call view models.
- Providers use Riverpod codegen (`@riverpod` / `@Riverpod(keepAlive: true)`).
- UI primitives come from `lib/design_system/`; avoid ad-hoc colors, spacing,
  or typography.
- Top-level navigation is guarded in `lib/routing/app_redirect.dart`; screens do
  not navigate based on auth state.

## Data-backed subsystems

- **Authentication/profile:** Firebase Auth is the source of auth state. Profile
  data is local-first via SharedPreferences and syncs to `users/{uid}` when
  Firebase is configured.
- **Learn:** Lesson modules and step content live in
  `lib/features/learn/repository/lesson_catalog.dart`; per-user progress is
  stored at `users/{uid}/progress/{lessonId}`.
- **Workout/WOD:** Workout content lives in
  `lib/features/workout/repository/workout_catalog.dart`. `wodFor(DateTime)`
  rotates the workout of the day by day-of-year with no backend dependency.
  Completed sessions are stored at `users/{uid}/sessions/{date}_{workoutId}` so
  the same workout can award XP at most once per day.
- **Stats:** XP is derived from completed lessons plus completed workout
  sessions in `features/stats/model/stats_rules.dart`. `StatsCoordinator`
  mirrors derived XP, streak count, and last activity date onto the user profile
  document after lesson or workout activity.

## Firebase setup and local emulators

Firebase project:

- Display name: `forge-dance`
- Project ID: `forge-dance-1bcc7`

FlutterFire configuration exists for Android, iOS, macOS, web, and Windows.
Before using real auth/profile/progress/session persistence, enable:

1. **Authentication > Sign-in method > Email/Password**
2. **Firestore Database**, then deploy `firestore.rules`

Useful commands:

```bash
firebase login
flutterfire configure --project=forge-dance-1bcc7
firebase deploy --only firestore:rules
```

Exercise auth and Firestore locally with emulators, not production data:

```bash
firebase emulators:start
flutter run --dart-define=USE_FIREBASE_EMULATOR=true
```

Emulator ports live in `firebase.json` (`auth :9099`, `firestore :8080`).

## More contributor guidance

Read `AGENTS.md` before making changes. `CLAUDE.md` and `.claude/skills/`
contain deeper playbooks for architecture, Firebase data, localization,
testing, design system usage, and required checks.
