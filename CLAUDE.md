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

**One command verifies everything** (codegen → custom_lint → analyze → test). Run it before every hand-off; CI runs exactly the same script, so local green == CI green:

```bash
bash tool/checks.sh
```

Individual commands when you need just one step:

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
| Run against local emulators | `firebase emulators:start` + `flutter run --dart-define=USE_FIREBASE_EMULATOR=true` |
| Web release build | `flutter build web --release` |
| Deploy Firestore rules | `firebase deploy --only firestore:rules` |

CI (`.github/workflows/flutter.yml`, Flutter 3.35.5) runs `tool/checks.sh` + a web release build on every push to `main` — and commits land directly on `main`, so breakage is immediately visible. Note: `custom_lint` (Riverpod lints) is NOT part of `flutter analyze` — the checks script runs it explicitly.

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
│   ├── authentication/   # WIRED: Firebase Auth + authStateChanges stream (single source of truth)
│   ├── profile/          # WIRED: Firestore users/{uid} + SharedPreferences cache
│   ├── learn/            # WIRED: 10-module catalog + Firestore progress (canonical example)
│   ├── home/             # WIRED: dashboard fully derived from profile + learn progress
│   ├── explore/          # WIRED: catalog by category, live search, real progress
│   ├── library/          # WIRED: collection = lessons the user started/completed
│   ├── stats/            # WIRED: XP/belts/streak — pure rules + coordinator + userStatsProvider
│   ├── firebase/         # Nullable Firebase providers + bootstrap (emulator wiring)
│   ├── session/          # SessionCoordinator: cross-feature auth ↔ profile orchestration
│   ├── common/           # Shared widgets, appThemeModeProvider
│   └── workout | wod | settings | main | onboarding/
│                         # PROTOTYPE: hardcoded mock data, no repositories yet
├── generated/            # LocaleKeys (generated, gitignored)
├── routing/              # go_router: router.dart + routes.dart
└── utils/                # validators, provider observer, global loading
```

Feature shape (per `AGENTS.md`): `features/<feature>/model/` (freezed models), `repository/` (IO + provider), `ui/` or `presentation/` (screens, plus `state/` and `view_model/`), optional `application/` for cross-feature coordinators. Both `ui/` and `presentation/pages/` naming conventions coexist — follow whichever the touched feature already uses.

### The canonical pattern (copy from learn or authentication/profile)

- **Model**: `@freezed abstract class X with _$X` (freezed 3 syntax); add `fromJson` only if it's persisted
- **Repository**: plain class whose constructor takes **nullable** `FirebaseAuth?` / `FirebaseFirestore?` and degrades gracefully (reads return empty, writes no-op); Firestore access goes through a typed `withConverter` reference; exposed via a `@riverpod` / `@Riverpod(keepAlive: true)` function
- **ViewModel**: `@riverpod class XViewModel extends _$XViewModel` with `FutureOr<XState> build()`; mutations set `AsyncValue.loading()` then use `AsyncValue.guard(...)`
- Widgets NEVER call Firebase SDKs directly (hard rule from `AGENTS.md`)
- Cross-feature flows (e.g. sign-in must sync the profile) go through a coordinator like `SessionCoordinator`, not widget-side chaining
- The **learn** feature is the end-to-end template: static content catalog (`lesson_catalog.dart`) + typed progress repository + view model + screens rendering `AsyncValue`

### Auth state & navigation

- **Auth state is a stream**: `authStateChangesProvider` (keepAlive) wraps `FirebaseAuth.authStateChanges()` and is the single source of truth. `AuthenticationViewModel` derives from it; nothing stores its own logged-in flag.
- **All navigation guarding lives in `lib/routing/app_redirect.dart`** (`computeRedirect`, a pure function with a full test matrix in `test/app_redirect_test.dart`). The router (a Riverpod provider) re-evaluates it on every auth change via `refreshListenable`. Screens must NOT navigate based on auth state.
- **Local dev mode**: when Firebase is unconfigured (Linux, missing options), the redirect skips auth entirely and enters `/main` as a guest; repositories no-op their writes.
- Top-level routes: go_router in `lib/routing/` with `SlideRouteTransition`; register path constants in `Routes` and add new routes to `_routes` in `router.dart`
- `/main` is `MainScreen`: a stateful `IndexedStack` shell (Collection, Explore, Home, Training, Profile tabs) with string-keyed `_subPage` overlays (`'training'`, `'lesson-path'`, `'lesson-player'`) — these are NOT go_router sub-routes
- Boot flow: `/` splash (branding only) → redirect decides: signed in → `/main`; has account → `/login`; fresh device → `/register`

### Current state: wired vs prototype

**Authentication**, **profile**, **learn** (module view + lesson player), **home**, **explore**, **collection/library**, and **stats** (stats page, level progression, belt grid, home progress card) all run on real data: the 10-module content catalog ships in code (`lesson_catalog.dart`, lesson ids globally unique and stable) and every progress surface derives from `users/{uid}/progress` via `LearnState`. Still prototype (hardcoded mock data): training session/workout, WOD. The explore/collection filter sheets are cosmetic until modules carry difficulty metadata. To productionize a prototype screen: extract models → create a repository → add state/view model → replace inline data, following the learn feature as the template.

**Gamification rules** live in `features/stats/model/stats_rules.dart` as pure functions (XP per lesson type, belt thresholds, streak date logic) with a full test matrix. XP is always derived from lesson progress — the `xp` field on the user doc is a denormalized mirror written by `StatsCoordinator` after each training event, never a source of truth. Belt thresholds are calibrated so completing the whole catalog equals Black Belt; a test enforces this, so catalog changes require deliberate re-calibration.

**Dead code — do not extend by accident**: `features/home/ui/home_screen.dart`, `features/home/ui/home_screen_v2.dart`, `features/explore/ui/explore_screen.dart`, and `features/wod/ui/wod_session_screen.dart` are not imported anywhere. The live screens are in `presentation/pages/` and `features/learn/ui/`.

## Conventions

- **Design system only**: colors/typography/spacing/radii/shadows come from `lib/design_system/tokens/` — no ad-hoc values in feature code. If a primitive is missing, add it to the design system first. Components use the `Fg` prefix (design-system code only). Note: `AppTheme` is a legacy typedef alias of `AppTypography`; both appear in code.
- **Riverpod**: codegen only (`@riverpod` / `@Riverpod(keepAlive: true)`) — no manual `Provider(...)`. Repositories are keepAlive; view models default to autoDispose unless state must outlive the screen (e.g. `ProfileViewModel` is keepAlive).
- **i18n**: user-facing strings use `LocaleKeys.x.tr()` (easy_localization); add keys to BOTH `assets/translations/en.json` and `vi.json`, then regenerate. Prototype screens still contain hardcoded strings — leave those until each screen is productionized, but newly wired features must be localized.
- **Theming**: use `context.isDarkMode` and the semantic colors on `BuildContextExtension` (`primaryBackgroundColor`, `primaryTextColor`, …); theme mode is persisted via `appThemeModeProvider`.
- **Naming**: clear domain names; no starter-template or sample-person names (per `AGENTS.md`).

## Firebase notes

- Providers in `features/firebase/repository/firebase_providers.dart` return **null** when `Firebase.apps.isEmpty` (Linux, unconfigured environments). Everything downstream must tolerate null and degrade gracefully — this is why repositories take nullable dependencies, and it's also what makes test fakes trivial.
- Firestore schema (all owner-only, validated on write in `firestore.rules`):
  - `users/{userId}` — profile (`id`, `email`, `name`, `job`, `avatar`, `diamond`, `createdAt`, `updatedAt`) plus gamification stats (`xp`, `streakCount`, `lastActivityDate` yyyy-MM-dd); `id` must equal the auth uid, stats fields type-checked when present
  - `users/{userId}/progress/{lessonId}` — lesson progress (`lessonId`, `status`, `progress`, `updatedAt`); doc id must equal `lessonId`, `status` whitelisted to the `LessonStatus` enum names
- Rules changes require `firebase deploy --only firestore:rules` — an undeployed rules change is the usual cause of `permission-denied`.
- Firestore access is typed: create one `withConverter` reference per collection inside the repository (see `ProgressRepository._progressRef`). Normalize `Timestamp` → ISO-8601 string before `fromJson`.
- Profile persistence is local-first: SharedPreferences cache merged with Firestore; local (non-URL) avatar file paths are intentionally NOT synced to Firestore.
- **Emulator suite**: `firebase emulators:start` then run the app with `--dart-define=USE_FIREBASE_EMULATOR=true` (wiring in `features/firebase/repository/firebase_bootstrap.dart`; ports in `firebase.json`). Use it whenever exercising auth/Firestore behavior locally — never test against production data.
- Console prerequisites: Email/Password sign-in enabled and a Firestore database created. Do not add another backend-as-a-service dependency.

## Testing

House style (`test/unit_test.dart`, `test/authentication_test.dart`, `test/learn_test.dart`): fake repositories extend the real class with `auth: null, firestore: null` (nullable deps make this trivial — no mocking framework); `ProviderContainer(overrides: [...])` with `addTearDown(container.dispose)`; `await container.read(provider.future)` to settle the initial build before acting on the notifier. Pure logic (like `computeRedirect`) gets a plain matrix test. Add tests for every new view model, repository, and validator. See `.claude/skills/testing/SKILL.md`.

## Optimized for AI agents — keep it that way

This repo deliberately favors properties that make agent (and human) development fast: one blessed pattern per concern, `bash tool/checks.sh` as the single definition of done, pure functions for logic that matters (redirect, state derivation), nullable-dependency fakes over mocking frameworks, and docs that state decisions instead of options. The adopt-vs-skip rationale behind these choices lives in the project's best-practices research; don't reintroduce skipped complexity (realtime profile streams, content CMS, abstract repository interfaces, use-case layers) without a real failure mode demanding it.
