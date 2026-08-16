---
name: add-feature
description: Scaffold a new feature or screen in Forge Dance following the feature-first MVVM + Riverpod codegen architecture. Use when adding a feature, screen, view model, repository, state class, or catalog-backed lesson/workout content.
---

# Adding a Feature

Every feature follows the same shape. `features/learn/` is the canonical end-to-end example (bundled content catalog + typed Firestore progress + view model + screens); `features/authentication/` and `features/profile/` show auth and local-first persistence. When in doubt, copy them.

## 1. Directory layout

```text
lib/features/<feature>/
├── model/                  # freezed data models
├── repository/             # IO + data access, exposed via generated providers
├── ui/                     # or presentation/ — follow what the touched feature uses
│   ├── state/              # freezed UI state
│   ├── view_model/         # @riverpod AsyncNotifier
│   ├── widgets/            # feature-scoped widgets
│   └── <feature>_screen.dart
└── application/            # only for cross-feature coordinators (see step 7)
```

## 2. Model (freezed 3 — `abstract class` is required)

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'lesson.freezed.dart';
part 'lesson.g.dart';

@freezed
abstract class Lesson with _$Lesson {
  const factory Lesson({
    required String id,
    required String title,
    @Default(0) int durationMinutes,
  }) = _Lesson;

  factory Lesson.fromJson(Map<String, Object?> json) => _$LessonFromJson(json);
}
```

## 3. Repository

Plain class with **nullable** Firebase dependencies, plus a generated provider. Repositories are `keepAlive`. See `.claude/skills/firebase-data/SKILL.md` for Firestore specifics.

```dart
part 'lesson_repository.g.dart';

@Riverpod(keepAlive: true)
LessonRepository lessonRepository(Ref ref) {
  return LessonRepository(
    auth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firebaseFirestoreProvider),
  );
}

class LessonRepository {
  const LessonRepository({
    required firebase_auth.FirebaseAuth? auth,
    required FirebaseFirestore? firestore,
  })  : _auth = auth,
        _firestore = firestore;

  final firebase_auth.FirebaseAuth? _auth;
  final FirebaseFirestore? _firestore;

  bool get isFirebaseConfigured => _auth != null && _firestore != null;

  // Intent-based methods: get(), update(...), completeLesson(...) — not raw CRUD leaks.
}
```

## 4. UI state (freezed)

```dart
@freezed
abstract class LessonState with _$LessonState {
  const factory LessonState({
    @Default([]) List<Lesson> lessons,
    Lesson? activeLesson,
  }) = _LessonState;
}
```

## 5. View model (`@riverpod` AsyncNotifier)

Widgets render `AsyncValue` states and send intents here. No business logic in widgets.

```dart
part 'lesson_view_model.g.dart';

@riverpod
class LessonViewModel extends _$LessonViewModel {
  late LessonRepository _repository;

  @override
  FutureOr<LessonState> build() async {
    _repository = ref.read(lessonRepositoryProvider);
    return LessonState(lessons: await _repository.get());
  }

  Future<void> completeLesson(String id) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() => _repository.completeLesson(id));
    // map result to AsyncData/AsyncError — see AuthenticationViewModel._handleResult
  }
}
```

Use `@Riverpod(keepAlive: true)` on the class only when state must outlive the screen (e.g. `ProfileViewModel`). Default is autoDispose.

## 6. Screen

- Build UI exclusively from the design system (`.claude/skills/design-system/SKILL.md`).
- User-facing strings via `LocaleKeys.x.tr()` (`.claude/skills/localization/SKILL.md`).
- `ConsumerWidget` / `ConsumerStatefulWidget`; watch the view model, render `AsyncValue.when(...)` or check `isLoading`/`hasError`.
- Don't read providers from reusable leaf widgets — pass data down unless the widget is intentionally feature-coupled.

## 7. Cross-feature orchestration

If the flow spans features (e.g. sign-in must also sync the profile), add or extend a coordinator in `features/<flow>/application/` like `SessionCoordinator` — a `keepAlive` provider-exposed class that reads other view models via `Ref`. Never chain view models from widget callbacks.

## 8. Routing

Two navigation systems coexist:

- **Top-level route**: add a constant in `lib/routing/routes.dart`, then a `GoRoute` to the `_routes` list in `lib/routing/router.dart` using the `state.slidePage(...)` extension (optionally with `direction:`). Pass objects via `state.extra` (see `accountInformation`).
- **Inside the main shell**: tabs and overlays in `/main` are managed by `MainScreen`'s `IndexedStack` + string-keyed `_subPage` values (`'training'`, `'lesson-path'`, `'lesson-player'`), NOT go_router. A new tab-level or overlay screen means editing `lib/features/main/presentation/pages/main_screen.dart`.

**Auth guarding is automatic and centralized.** New top-level routes are guarded by `computeRedirect` in `lib/routing/app_redirect.dart` (signed-out users get bounced to login/register). Screens must never navigate based on auth state — if a route needs different guarding (e.g. reachable signed-out), extend `computeRedirect` and its test matrix in `test/app_redirect_test.dart`.

## 9. Generate + verify

```bash
bash tool/checks.sh
```

One command runs the whole pipeline (codegen → lints → analyze → test) — same script CI runs. Failure fixes: `.claude/skills/quality-checks/SKILL.md`.

## 10. Test it

Add a view-model test with a fake repository (`.claude/skills/testing/SKILL.md`).

## Existing wired screens

The primary app surfaces are already wired to real state: auth/profile, learn module view + lesson player, home, explore, collection/library, workout/training, stats, level progression, and the belt grid. For new work, follow the same pattern instead of adding local mock lists: model → repository/provider → state/view model → screen renders `AsyncValue`.

Beware dead code: `home_screen.dart`, `home_screen_v2.dart`, `explore_screen.dart` (in `ui/`), and `wod_session_screen.dart` are orphaned. The live screens are in `presentation/pages/` and `learn/ui/`.

## Adding catalog content

Lesson and workout content ships in code by design; Firestore stores only user state.

- Lessons live in `lib/features/learn/repository/lesson_catalog.dart`.
  - Keep lesson ids globally unique and stable. Existing `hip-hop-foundations` lesson ids predate the module-id prefix convention and must not change because user progress references them.
  - Every module ends with a `LessonType.boss` lesson, and `subtitle` module numbering follows `allModules` display order.
  - `LessonStep` content includes `title`, `description`, `focus`, `breath`, and `energy`; all five must be non-empty after `stepsFor(lesson)` resolves defaults.
  - Modules 1 and 2 (`hipHopFoundations`, `bodyControl1`) are fully hand-authored. Tests fail if any lesson in those modules falls back to default steps.
- Workouts live in `lib/features/workout/repository/workout_catalog.dart`.
  - `wodFor(date)` rotates deterministically by day-of-year, with no backend.
  - Workout `xp` feeds the stats system through completed sessions. Keep values modest relative to lesson XP so the belt ladder stays lesson-driven.

When changing the lesson catalog, run the stats and learn tests: catalog XP controls belt thresholds, and `test/stats_test.dart` enforces that completing the catalog reaches Black Belt exactly.
