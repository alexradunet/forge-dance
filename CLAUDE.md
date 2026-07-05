# CLAUDE.md

Guidance for Claude Code when working in this repository. `AGENTS.md` contains the contributor rules this file builds on — read it before making changes. Task-specific playbooks live in `.claude/skills/`.

## What this app is

Forge Dance is a gamified dance-training app ("THE STAGE IS YOURS") built with Flutter. Users sign in, follow structured lesson paths (modules → lessons → movements, with boss nodes), run training/WOD sessions with BPM control, and track levels, diamonds, and achievements. Visual identity is dark and game-like: forge fire orange `#FF4500`, electric blue, Bebas Neue display type.

- Package name: `forge_dance` (imports: `package:forge_dance/...`)
- Platforms: Android, iOS, macOS, web, Windows (Firebase configured); Linux runs but skips Firebase entirely
- Backend: Firebase Auth + Cloud Firestore, project `forge-dance-1bcc7`

## Critical: generated code is gitignored

`*.g.dart`, `*.freezed.dart`, and `lib/generated/locale_keys.g.dart` are NOT committed. After cloning — and after editing models, providers, states, or translations — you MUST regenerate, or the analyzer reports hundreds of missing-part errors:

```bash
flutter pub get
flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir assets/translations
flutter pub run build_runner build --delete-conflicting-outputs
```

Never commit generated files.

## Commands

| Task | Command |
|---|---|
| Install deps | `flutter pub get` |
| Generate LocaleKeys | `flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir assets/translations` |
| Generate Riverpod/freezed/json code | `flutter pub run build_runner build --delete-conflicting-outputs` |
| Codegen watch mode | `flutter pub run build_runner watch --delete-conflicting-outputs` |
| Riverpod lints | `flutter pub run custom_lint` |
| Analyze | `flutter analyze` |
| Tests | `flutter test` |
| Run app | `flutter run -d chrome` (or another device) |
| Web release build | `flutter build web --release` |
| Deploy Firestore rules | `firebase deploy --only firestore:rules` |

### Required checks before handing off

CI (`.github/workflows/flutter.yml`, Flutter 3.35.5) runs on every push to `main` — and commits land directly on `main`, so breakage is immediately visible. Always finish with:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
flutter pub run custom_lint
flutter analyze
flutter test
```

`custom_lint` (Riverpod lints) is NOT wired into `flutter analyze` — the plugin isn't registered in `analysis_options.yaml`, so run the CLI explicitly. CI also builds `flutter build web --release`, so keep the web target compiling.

## Architecture

Feature-first + MVVM + Riverpod codegen. Data flow:

```
Widget → ref.watch(xViewModelProvider) → ViewModel (AsyncNotifier)
       → Repository (via generated provider) → Firebase / SharedPreferences
```

```text
lib/
├── constants/            # Constants (prefs keys, URLs) and Assets paths
├── design_system/        # Atomic design: tokens → atoms → molecules → organisms → templates
├── extensions/           # BuildContextExtension (theme, snackbars), string/date/iterable helpers
├── features/
│   ├── authentication/   # WIRED: Firebase Auth email/password (canonical MVVM example)
│   ├── profile/          # WIRED: Firestore users/{uid} + SharedPreferences cache
│   ├── firebase/         # Nullable FirebaseAuth/FirebaseFirestore providers
│   ├── session/          # SessionCoordinator: cross-feature auth ↔ profile orchestration
│   ├── common/           # Shared widgets, appThemeModeProvider
│   └── home | explore | library | learn | workout | wod | stats | settings | main | onboarding/
│                         # PROTOTYPE: hardcoded mock data, no repositories yet
├── generated/            # LocaleKeys (generated, gitignored)
├── routing/              # go_router: router.dart + routes.dart
└── utils/                # validators, provider observer, global loading
```

Feature shape (per `AGENTS.md`): `features/<feature>/model/` (freezed models), `repository/` (IO + provider), `ui/` or `presentation/` (screens, plus `state/` and `view_model/`), optional `application/` for cross-feature coordinators. Both `ui/` and `presentation/pages/` naming conventions coexist — follow whichever the touched feature already uses.

### The canonical pattern (copy from authentication/profile)

- **Model**: `@freezed abstract class X with _$X` (freezed 3 syntax) + `fromJson`
- **Repository**: plain class whose constructor takes **nullable** `FirebaseAuth?` / `FirebaseFirestore?`, guarded by `isFirebaseConfigured`; exposed via a `@riverpod` / `@Riverpod(keepAlive: true)` function
- **ViewModel**: `@riverpod class XViewModel extends _$XViewModel` with `FutureOr<XState> build()`; mutations set `AsyncValue.loading()` then use `AsyncValue.guard(...)`
- Widgets NEVER call Firebase SDKs directly (hard rule from `AGENTS.md`)
- Cross-feature flows (e.g. sign-in must sync the profile) go through a coordinator like `SessionCoordinator`, not widget-side chaining

### Navigation

- Top-level routes: go_router in `lib/routing/` with `SlideRouteTransition`; register path constants in `Routes`
- `/main` is `MainScreen`: a stateful `IndexedStack` shell (Collection, Explore, Home, Training, Profile tabs) with string-keyed `_subPage` overlays (`'training'`, `'lesson-path'`, `'lesson-player'`) — these are NOT go_router sub-routes
- Boot flow: `/` splash (~2s) → logged in → `/main`; has existing account → `/login`; otherwise → `/register`

### Current state: wired vs prototype

Only **authentication** and **profile** talk to real data. Everything else (home, explore, collection, training session, module view, lesson player, WOD, stats, level progression) renders hardcoded mock data pending backend wiring. To productionize a prototype screen: extract models → create a repository → add state/view model → replace inline data, following the canonical pattern above.

**Dead code — do not extend by accident**: `features/home/ui/home_screen.dart`, `features/home/ui/home_screen_v2.dart`, `features/explore/ui/explore_screen.dart`, and `features/wod/ui/wod_session_screen.dart` are not imported anywhere. The live screens are in `presentation/pages/` and `features/learn/ui/`.

## Conventions

- **Design system only**: colors/typography/spacing/radii/shadows come from `lib/design_system/tokens/` — no ad-hoc values in feature code. If a primitive is missing, add it to the design system first. Components use the `Fg` prefix (design-system code only). Note: `AppTheme` is a legacy typedef alias of `AppTypography`; both appear in code.
- **Riverpod**: codegen only (`@riverpod` / `@Riverpod(keepAlive: true)`) — no manual `Provider(...)`. Repositories are keepAlive; view models default to autoDispose unless state must outlive the screen (e.g. `ProfileViewModel` is keepAlive).
- **i18n**: user-facing strings use `LocaleKeys.x.tr()` (easy_localization); add keys to BOTH `assets/translations/en.json` and `vi.json`, then regenerate. Prototype screens still contain hardcoded strings — leave those until each screen is productionized, but newly wired features must be localized.
- **Theming**: use `context.isDarkMode` and the semantic colors on `BuildContextExtension` (`primaryBackgroundColor`, `primaryTextColor`, …); theme mode is persisted via `appThemeModeProvider`.
- **Naming**: clear domain names; no starter-template or sample-person names (per `AGENTS.md`).

## Firebase notes

- Providers in `features/firebase/repository/firebase_providers.dart` return **null** when `Firebase.apps.isEmpty` (Linux, unconfigured environments). Everything downstream must tolerate null and degrade gracefully — this is why repositories take nullable dependencies, and it's also what makes test fakes trivial.
- Firestore schema: a single `users/{userId}` collection (`id`, `email`, `name`, `job`, `avatar`, `diamond`, `createdAt`, `updatedAt`) with owner-only access in `firestore.rules`. New collections require rules updates + `firebase deploy --only firestore:rules`.
- Profile persistence is local-first: SharedPreferences cache merged with Firestore; local (non-URL) avatar file paths are intentionally NOT synced to Firestore.
- Console prerequisites: Email/Password sign-in enabled and a Firestore database created. Do not add another backend-as-a-service dependency.

## Testing

`test/unit_test.dart` shows the house style: fake repositories extend the real class with `auth: null, firestore: null`; `ProviderContainer(overrides: [...])` with `addTearDown(container.dispose)`; `await container.read(provider.future)` to settle the initial build before acting on the notifier. Add tests for new view models, repositories, and validators. See `.claude/skills/testing/SKILL.md`.
