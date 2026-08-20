# Forge Dance

Forge Dance is a Flutter app built with Riverpod, Firebase, and a feature-first architecture.

## Backend

Firebase is the selected MVP backend for fastest path to market.

Firebase project:

- Display name: `forge-dance`
- Project ID: `forge-dance-1bcc7`

Current stack:

- Firebase Auth for email/password accounts
- Cloud Firestore for user profiles, lesson progress, and completed workout sessions

Firebase SDK usage should stay behind repositories/data sources. Widgets should call Riverpod view models, not Firebase APIs directly.

## Firebase setup

FlutterFire has generated app configuration for Android, iOS, macOS, web, and Windows.

Enable these services in Firebase Console before using auth/profile persistence:

1. **Authentication > Sign-in method > Email/Password**
2. **Firestore Database** in production mode or test mode, then deploy `firestore.rules`

Useful Firebase commands:

```bash
firebase login
flutterfire configure --project=forge-dance-1bcc7
firebase deploy --only firestore:rules
```

Linux desktop is kept as a local development target; Firebase initialization is skipped there because FlutterFire did not generate Linux options.

## Commands

```bash
bash tool/checks.sh
```

That script is the CI-equivalent verification path: dependency resolution, localization codegen, Riverpod/freezed/json codegen, custom_lint, analyzer, and tests.

Useful individual commands while iterating:

```bash
flutter pub get
flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir assets/translations
flutter pub run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
```

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
├── theme/
└── utils/
```

## Lesson catalog and progress workflow

Lesson content is app-shipped Dart data in `lib/features/learn/repository/lesson_catalog.dart`; Firestore stores only each user's progress at `users/{uid}/progress/{lessonId}`. `LearnViewModel` combines the static `allModules` catalog with `ProgressRepository.getAll()`, then home, explore, collection, the module path, and the lesson player render derived state from that single model.

Catalog constraints:

- `allModules` is display order. The first module is the default active module for new users.
- Lesson ids are stable public identifiers because they are Firestore document ids and stats inputs. New ids should be globally unique and prefixed by the module id, for example `body-control-1-center-posture`.
- Do not rename the original `hip-hop-foundations` lesson ids; existing progress documents reference them.
- Every module path ends with a `LessonType.boss` lesson.
- A `LessonStep` has `title`, `description`, `focus`, `breath`, and `energy`. `stepsFor(lesson)` uses hand-authored steps when present and otherwise falls back to type-specific defaults.

Minimal authoring shape:

```dart
const Module bodyControl1 = Module(
  id: 'body-control-1',
  title: 'Body Control I',
  subtitle: 'Module 2 • Path',
  category: ModuleCategory.fundamentals,
  tag: 'Rhythm',
  lessons: [
    Lesson(
      id: 'body-control-1-center-posture',
      title: 'Center & Posture',
      type: LessonType.theory,
      duration: '4 min',
      steps: [
        LessonStep(
          title: 'FIND YOUR CENTER',
          description: 'All isolation starts from a stable center.',
          focus: 'Stand tall and feel where your weight settles.',
          breath: 'Breathe into the belly, not the chest.',
          energy: 'Still and grounded.',
        ),
      ],
    ),
    Lesson(
      id: 'body-control-1-boss',
      title: 'Control Check',
      type: LessonType.boss,
    ),
  ],
);
```

Progress behavior:

- `startLesson` writes `LessonStatus.inProgress` unless the lesson is already completed.
- `completeLesson` writes `LessonStatus.completed` with `progress: 1.0`, unlocks the next lesson in that module, and best-effort syncs XP/streak stats through `StatsCoordinator`.
- Collection/library content is every started or completed lesson; explore and home progress bars are derived from completed lessons per module.
- Module selection is session-local. Restarting the app opens the first module again.

When changing catalog lesson counts or types, run at least:

```bash
flutter test test/learn_test.dart test/stats_test.dart
```

`test/learn_test.dart` verifies effective lesson step content, and `test/stats_test.dart` enforces that the full catalog XP still matches the Black Belt threshold. If that calibration test fails, update `beltThresholds` in `lib/features/stats/model/stats_rules.dart` deliberately.

See `AGENTS.md` before making changes.
