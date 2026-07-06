# AGENTS.md

Rules for AI agents and contributors working on Forge Dance.

## Backend

- Firebase is the selected backend for the MVP because speed to market is the priority.
- Keep Firebase usage behind repositories/data sources. Do not call `FirebaseAuth`, `FirebaseFirestore`, or other Firebase SDKs directly from widgets.
- Current Firebase MVP stack:
  - Firebase Auth for accounts
  - Cloud Firestore for user/profile data
- Do not add another backend-as-a-service dependency unless the project explicitly changes direction.
- Before using Firebase services in a real environment, run `flutterfire configure` and enable Email/Password sign-in in Firebase Console.

## Feature structure

- Put product code under `lib/features/<feature>/`.
- Use this shape when adding features:
  - `model/` for immutable data models
  - `repository/` for IO and business-facing data access
  - `ui/` or `presentation/` for widgets/pages/view models
- Do not put business logic in widgets. Widgets render state and send user intents to notifiers/view models.

## Riverpod conventions

- Prefer code-generated Riverpod providers with `riverpod_annotation`.
- Keep provider names descriptive and feature-scoped.
- Repositories expose intent-based methods; view models orchestrate state changes.
- Avoid reading providers directly from reusable leaf widgets unless the widget is intentionally feature-coupled.

## Naming

- Package/import name is `forge_dance`.
- Use `Forge`/`Fg` prefixes only for design-system components.
- Use clear domain names; avoid starter-template names and sample-person names.

## Design system

- Use `lib/design_system/` tokens/components for colors, typography, spacing, shadows, buttons, inputs, and layout primitives.
- No ad-hoc colors, text styles, spacing systems, or one-off design primitives in feature code.
- If a design primitive is missing, add it to the design system first.

## Generated code

`*.g.dart`, `*.freezed.dart`, and `lib/generated/locale_keys.g.dart` are gitignored. After cloning — or after editing models, providers, states, or translations — regenerate or the analyzer reports missing-part errors. Never commit generated files.

## Local development

- Use **Flutter 3.35.5** (matches CI in `.github/workflows/flutter.yml`). Pin the SDK to that tag; do not run `flutter upgrade` on this repo without a deliberate version bump.
- **Linux desktop** runs locally but skips Firebase initialization (no FlutterFire Linux config).
- For auth/Firestore locally: `firebase emulators:start`, then `flutter run --dart-define=USE_FIREBASE_EMULATOR=true`.

## Required checks

Run before handing off. CI runs the same script, so local green == CI green:

```bash
bash tool/checks.sh
```

That runs `flutter pub get`, localization codegen, `build_runner`, `custom_lint`, `flutter analyze`, and `flutter test`. Note: `custom_lint` (Riverpod lints) is not part of `flutter analyze`.
