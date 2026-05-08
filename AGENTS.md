# AGENTS.md

Rules for AI agents and contributors working on Forge Dance.

## Backend

- Do not add any preselected backend-as-a-service dependencies, initialization, generated config, docs, or examples.
- Keep repositories backend-neutral. If a server is needed later, hide it behind repository/data-source interfaces.
- Current auth/profile flows are local-only placeholders until offline-first/PocketBase/owned-server architecture is chosen.

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

## Required checks

Run before handing off:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
```
