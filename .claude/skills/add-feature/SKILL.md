---
name: add-feature
description: Scaffold a new feature or screen in Forge Dance following the feature-first MVVM + Riverpod codegen architecture. Use when adding a feature, screen, view model, repository, or state class, and when productionizing a prototype screen (home, explore, collection, learn, workout, wod, stats) so it runs on real data instead of hardcoded mocks.
---

# Adding a Feature

Every feature follows the same shape. `features/authentication/` and `features/profile/` are the canonical, fully wired examples — when in doubt, copy them.

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

- **Top-level route**: add a constant in `lib/routing/routes.dart`, then a `GoRoute` in `lib/routing/router.dart` using the `state.slidePage(...)` extension (optionally with `direction:`). Pass objects via `state.extra` (see `accountInformation`).
- **Inside the main shell**: tabs and overlays in `/main` are managed by `MainScreen`'s `IndexedStack` + string-keyed `_subPage` values (`'training'`, `'lesson-path'`, `'lesson-player'`), NOT go_router. A new tab-level or overlay screen means editing `lib/features/main/presentation/pages/main_screen.dart`.

## 9. Generate + verify

```bash
flutter pub run build_runner build --delete-conflicting-outputs
flutter pub run custom_lint
flutter analyze
flutter test
```

Codegen must run before analyze — `*.g.dart` / `*.freezed.dart` are gitignored. Full pipeline and failure fixes: `.claude/skills/quality-checks/SKILL.md`.

## 10. Test it

Add a view-model test with a fake repository (`.claude/skills/testing/SKILL.md`).

## Productionizing a prototype screen

Home, explore, collection, training, module view, lesson player, WOD, stats, and level progression currently render hardcoded mock data. To wire one up: extract the inline data classes into `model/` (freezed), create the repository + provider, add `state/` + `view_model/`, then swap the widget's local constants for the view model. Beware dead code: `home_screen.dart`, `home_screen_v2.dart`, `explore_screen.dart` (in `ui/`), and `wod_session_screen.dart` are orphaned — the live screens are in `presentation/pages/` and `learn/ui/`.
