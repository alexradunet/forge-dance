---
name: testing
description: Write and run tests for Forge Dance — unit tests for view models, repositories, and validators using fake repositories and Riverpod ProviderContainer overrides. Use when adding tests, fixing failing tests, or verifying notifier and repository behavior before handing off changes.
---

# Testing

Tests live in `test/`. References for house style:

- `test/unit_test.dart` — validators + profile view model.
- `test/authentication_test.dart` — stream-driven auth view model + fake auth
  repository.
- `test/learn_test.dart` — catalog invariants, progress repository no-op mode,
  learn view model, derived collection/continue/recommended rails, and lesson
  step availability.
- `test/workout_test.dart` — deterministic daily WOD rotation, session
  idempotency, workout XP, workout view model, and best-effort stats sync.
- `test/stats_test.dart` — pure XP, belt threshold, streak, and display-stat
  rules.
- `test/app_redirect_test.dart` — pure routing redirect matrix.

Run with `flutter test` — **codegen must have run first** (or just run
`bash tool/checks.sh`, which does everything in order).

Design rule that keeps testing cheap: put decision logic in pure functions (like `computeRedirect`) or view models — never in widgets — so a plain matrix test covers it without any widget pumping.

## Fake repositories — the core pattern

Repositories take nullable Firebase deps, so a fake is just a subclass with `null` deps and overridden methods:

```dart
class FakeProfileRepository extends ProfileRepository {
  FakeProfileRepository(this.profile) : super(auth: null, firestore: null);

  Profile? profile;
  Profile? savedProfile;

  @override
  Future<Profile?> get() async => profile;

  @override
  Future<void> update(Profile profile) async {
    savedProfile = profile;   // capture for assertions
    this.profile = profile;
  }
}
```

No mocking framework is used — keep it that way (hand-written fakes only).

## Testing a view model with ProviderContainer

```dart
final repository = FakeProfileRepository(const Profile(id: 'user-1', ...));
final container = ProviderContainer(
  overrides: [
    profileRepositoryProvider.overrideWithValue(repository),
  ],
);
addTearDown(container.dispose);

// CRITICAL: settle the async build() before acting on the notifier
await container.read(profileViewModelProvider.future);

await container.read(profileViewModelProvider.notifier).updateProfile(name: 'New Name');

expect(repository.savedProfile, expectedProfile);
expect(container.read(profileViewModelProvider).value?.profile, expectedProfile);
```

Key points:

- Always `addTearDown(container.dispose)`.
- Always `await container.read(provider.future)` first — calling notifier methods before `build()` completes races the initial state.
- Assert on both the repository side-effects AND the resulting `AsyncValue` state.
- For error paths, make the fake throw and expect `container.read(provider)` to be `AsyncError`.

## Validators and pure logic

`lib/utils/validator.dart` has two layers:

- Pure predicates (`isValidEmail`, `isValidPhone`, `isValidEmailOrPhone`) — test these directly, no setup needed.
- Form validators (`notEmptyEmailValidator`, …) return `LocaleKeys.x.tr()` strings — they need EasyLocalization initialized, so prefer testing the pure predicates and keep `.tr()`-dependent assertions out of unit tests.

## Widget tests (when needed)

Wrap in `ProviderScope(overrides: [...])` + `MaterialApp`. Screens using `LocaleKeys.x.tr()` require `EasyLocalization.ensureInitialized()` and an `EasyLocalization` wrapper with `assets/translations` — this makes widget tests heavier; prefer pushing logic into view models (unit-testable) and keeping widgets thin.

## What to cover

- Every new view model: initial `build()` state, each mutation's happy path, one error path.
- Repository logic that doesn't need Firebase (merging, normalization, payload building) — instantiate with `auth: null, firestore: null` where the method allows it.
- Catalog/content invariants when shipped content changes. Examples:
  - Lesson IDs stay unique and every lesson resolves to non-empty `stepsFor`
    content.
  - Workout IDs stay unique and every workout has exercises plus positive XP.
  - Completing the full lesson catalog still equals the final belt threshold, or
    `beltThresholds` is deliberately recalibrated.
- New validators/extensions/utils: direct unit tests.
- Firestore-touching code paths are NOT integration-tested (no emulator setup in this repo) — isolate them behind repository methods so everything around them stays testable.

## Before handing off

`flutter test` is part of the required check pipeline (with build_runner, custom_lint, analyze) and runs in CI on every push to main. See `.claude/skills/quality-checks/SKILL.md`.
