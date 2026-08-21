# Forge Dance

Forge Dance is a gamified dance-training app built with Flutter, Riverpod,
Firebase Auth, and Cloud Firestore. The app ships its lesson and workout
catalogs in code, then persists only user-owned state such as profile data,
lesson progress, workout completions, XP, and streak metadata.

Read `AGENTS.md` before changing code. It is the contributor contract for
architecture, generated code, design-system usage, and required checks.

## Quick start

Flutter is pinned to 3.35.5 with FVM (`.fvmrc`).

```bash
dart pub global activate fvm
fvm install
fvm use
bash tool/checks.sh
```

`tool/checks.sh` is the single definition of done. It runs dependency
resolution, localization key generation, Riverpod/freezed/json code generation,
Riverpod custom lints, `flutter analyze`, and `flutter test`.

If you do not use FVM, the same script falls back to `flutter` on `PATH`.

## Generated code

Generated files are intentionally gitignored:

- `*.g.dart`
- `*.freezed.dart`
- `lib/generated/locale_keys.g.dart`

Regenerate after cloning and after editing models, providers, state classes, or
translations:

```bash
flutter pub get
flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir assets/translations
flutter pub run build_runner build --delete-conflicting-outputs
```

Do not commit generated output.

## App architecture

The app uses feature-first MVVM with Riverpod code generation:

```text
Widget -> ViewModel (AsyncNotifier) -> Repository -> Firebase / local cache
```

Feature code lives under `lib/features/<feature>/`:

```text
lib/
├── constants/
├── design_system/
├── extensions/
├── features/
│   ├── authentication/
│   ├── profile/
│   ├── learn/
│   ├── explore/
│   ├── library/
│   ├── workout/
│   ├── stats/
│   └── <feature>/
│       ├── model/
│       ├── repository/
│       └── ui/ or presentation/
├── generated/
├── routing/
└── utils/
```

Key constraints:

- Widgets render state and call view-model methods; they do not call Firebase
  SDKs directly.
- Repositories own IO and expose intent-based methods.
- Riverpod providers are generated with `@riverpod` or
  `@Riverpod(keepAlive: true)`.
- Feature UI must use design-system tokens/components from
  `lib/design_system/`; avoid ad-hoc colors, spacing, and typography.
- User-facing strings use `easy_localization` keys from both
  `assets/translations/en.json` and `assets/translations/vi.json`.

## Routing and auth flow

Auth-driven navigation is centralized in `lib/routing/app_redirect.dart`.
`router.dart` listens to `authenticationViewModelProvider` and re-runs the pure
`computeRedirect` function when auth state changes. Screens should not navigate
imperatively based on login state.

Boot flow:

```text
/ splash -> signed in: /main
          -> signed out with previous account: /login
          -> new device/user: /register
```

When Firebase is not configured (for example Linux desktop), the redirect enters
local dev mode and sends pre-auth routes to `/main`.

## Firebase and local emulator

Firebase project:

- Display name: `forge-dance`
- Project ID: `forge-dance-1bcc7`

FlutterFire options exist for Android, iOS, macOS, web, and Windows. Linux
intentionally skips Firebase initialization; nullable Firebase providers then
return `null`, repositories read empty data, and writes no-op for local
development.

Enable these Firebase Console services before using a real backend:

1. Authentication > Sign-in method > Email/Password
2. Firestore Database, then deploy `firestore.rules`

Useful commands:

```bash
firebase login
flutterfire configure --project=forge-dance-1bcc7
firebase deploy --only firestore:rules
```

Run against local emulators instead of production data:

```bash
firebase emulators:start
flutter run --dart-define=USE_FIREBASE_EMULATOR=true
```

Emulator ports are defined in `firebase.json`: Auth `9099`, Firestore `8080`.

## Firestore data model

All persisted data is scoped under the signed-in user:

```text
users/{uid}
├── profile fields: id, email, name, job, avatar, diamond, createdAt, updatedAt
├── stats mirror: xp, streakCount, lastActivityDate
├── progress/{lessonId}
│   └── lessonId, status, progress, updatedAt
└── sessions/{date}_{workoutId}
    └── workoutId, date, completedAt
```

Constraints enforced by `firestore.rules`:

- A user can only read/write their own document tree.
- `users/{uid}.id` must equal the auth uid.
- Lesson progress document id must equal `lessonId`.
- Progress `status` must match `LessonStatus`
  (`notStarted`, `inProgress`, `completed`).
- Workout session document id must be `${date}_${workoutId}`, capping workout
  XP at one award per workout per day.

Repositories use typed Firestore references with `withConverter`. Timestamp
fields are normalized to ISO-8601 strings before JSON deserialization.

## Learning, workouts, and gamification

Content is app-shipped:

- Lessons/modules live in `lib/features/learn/repository/lesson_catalog.dart`.
- Workouts live in `lib/features/workout/repository/workout_catalog.dart`.
- `wodFor(DateTime)` rotates through the workout catalog by day-of-year.

Only user state is persisted:

- `ProgressRepository` stores lesson progress in `users/{uid}/progress`.
- `SessionRepository` stores completed workouts in `users/{uid}/sessions`.
- `StatsCoordinator` recalculates XP and streaks after lesson or workout
  completion and mirrors the result onto the profile document.

XP source of truth:

- Lesson XP is derived from completed lessons and `xpForLessonType`.
- Workout XP is derived from completed session docs priced by the workout
  catalog.
- The `xp` field on `users/{uid}` is a denormalized display mirror, not the
  source of truth.
- Belt thresholds in `stats_rules.dart` are calibrated so completing the lesson
  catalog reaches Black Belt. Catalog changes may require threshold updates and
  test changes.

Catalog authoring rules:

- Keep lesson ids stable; persisted progress references them.
- New module lesson ids should be globally unique and usually prefixed by the
  module id.
- Every module ends with a boss lesson.
- Lesson content is English content vocabulary; app UI strings still go through
  localization.

## Common pitfalls

- Missing generated files cause many analyzer errors. Run `bash tool/checks.sh`
  or the codegen commands above.
- `flutter analyze` does not run Riverpod custom lints; `tool/checks.sh` does.
- Permission-denied errors usually mean `firestore.rules` were changed but not
  deployed, or document ids do not match rule constraints.
- Linux local runs intentionally skip Firebase and behave as guest/dev mode.
- Do not extend known prototype/dead screens by accident; live home/explore/
  collection screens are under `presentation/pages/`, and the live learn screens
  are under `features/learn/ui/`.

## Editor and MCP notes

VS Code is configured to use `.fvm/versions/3.35.5`, format Dart on save, ignore
generated files in search/watchers, and enable the Dart MCP server. Cursor MCP
uses `.fvm/flutter_sdk/bin/dart mcp-server --force-roots-fallback`, so run
`fvm use` after cloning before relying on MCP tooling.
