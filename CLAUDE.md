# CLAUDE.md

Guidance for Claude Code when working in this repository. `AGENTS.md` contains the contributor rules this file builds on — read it before making changes. Task-specific playbooks live in `.claude/skills/`.

## What this app is

Forge Dance is a gamified offline-first dance-training app ("THE STAGE IS YOURS") built with Flutter. Dancers complete structured lesson paths, run training/WOD sessions with BPM control, and track levels, streaks, diamonds, and achievements. Visual identity is dark and game-like: forge fire orange `#FF4500`, electric blue, Bebas Neue display type.

- Package name: `forge_dance` (imports: `package:forge_dance/...`)
- Platforms: Android, iOS, macOS, web, Windows, and Linux desktop
- Persistence: local-only repositories backed by `SharedPreferences`; no registration, login, or Firebase

## Critical: generated code is gitignored

`*.g.dart`, `*.freezed.dart`, and `lib/generated/locale_keys.g.dart` are NOT committed. After cloning — and after editing models, providers, states, or translations — regenerate, or the analyzer reports missing-part errors:

```bash
flutter pub get
dart run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir assets/translations
dart run build_runner build
```

Never commit generated files.

## Commands

**One command verifies the fast Flutter gate** (codegen → analyze, including Riverpod lints → unit/widget tests). Run it before every hand-off; CI runs the same script:

```bash
bash tool/checks.sh
```

Individual commands:

| Task | Command |
|---|---|
| Install deps | `flutter pub get` |
| Generate LocaleKeys | `dart run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir assets/translations` |
| Generate Riverpod/freezed/json code | `dart run build_runner build` |
| Codegen watch mode | `dart run build_runner watch` |
| Analyze | `flutter analyze` |
| Tests | `flutter test` |
| Run app | `flutter run -d chrome` (or another device) |
| Offline web integration test | `bash tool/check_integration.sh` |
| Web quality gate | `bash tool/check_web_quality.sh` |
| Web release build | `flutter build web --release --wasm` |

CI (`.github/workflows/flutter.yml`, Flutter 3.47.2) runs the fast gate, Wasm web release build, offline web smoke test, Lighthouse gate, and Widgetbook checks for PRs.

## Architecture

Feature-first + MVVM + Riverpod codegen. Data flow:

```text
Widget → ref.watch(xViewModelProvider) → ViewModel (AsyncNotifier)
       → Repository (via generated provider) → local storage
```

Feature shape: `features/<feature>/model/` (freezed models), `repository/` (IO + provider), `ui/` or `presentation/` (screens, plus `state/` and `view_model/`), optional `application/` for cross-feature coordinators.

Live feature modules:

- `profile/` — local profile and avatar metadata
- `learn/` — static lesson catalog + locally persisted lesson progress
- `home/`, `explore/`, `library/` — projections over profile/catalog/progress
- `stats/` — XP, belts, streak rules, and repairable projection
- `workout/` — daily WOD rotation + locally persisted session tracking
- `session/` — local cross-feature coordination
- `common/`, `settings/`, `main/`, `onboarding/` — shell and app flow screens

### Canonical pattern

- **Model**: `@freezed abstract class X with _$X` (Freezed 4 syntax); add `fromJson` only if persisted.
- **Repository**: plain class with intent-based methods, exposed via a generated Riverpod provider. Keep persistence details inside the repository. Preserve portable JSON shapes for future file/cloud sync.
- **ViewModel**: `@riverpod class XViewModel extends _$XViewModel` with `FutureOr<XState> build()`; mutations set `AsyncValue.loading()` then use `AsyncValue.guard(...)` or explicit `try/catch` when preserving previous state matters.
- Widgets render state and send intents to view models; they do not call storage APIs directly.
- Cross-feature flows go through an application/coordinator module, not widget-side chaining.

### Navigation

All navigation guarding lives in `lib/routing/app_redirect.dart` (`computeRedirect`, a pure function with a full test matrix in `test/app_redirect_test.dart`). The router re-evaluates it when local profile setup completes.

Boot flow: `/` splash → local profile missing/name empty → `/onboarding`; local profile complete → `/main`.

## Conventions

- **Design system only**: colors/typography/spacing/radii/shadows come from `lib/design_system/tokens/`.
- **Riverpod**: codegen only (`@riverpod` / `@Riverpod(keepAlive: true)`).
- **i18n**: user-facing strings use `LocaleKeys.x.tr()`; edit `assets/translations/en.json`, then regenerate.
- **Naming**: clear domain names; no starter-template or sample-person names.

## Testing

Fake repositories extend the real class and override intent methods; no mocking framework is needed. Use `ProviderContainer(overrides: [...])` with `addTearDown(container.dispose)`, and `await container.read(provider.future)` to settle initial builds. Pure logic gets plain matrix tests. Add tests for every new view model, repository, and validator.

## Optimized for AI agents

This repo favors one blessed pattern per concern, `bash tool/checks.sh` as the single definition of done, pure functions for logic that matters, and docs that state decisions instead of options. Keep the offline persistence seam deep: callers should learn intent methods, not storage details.
