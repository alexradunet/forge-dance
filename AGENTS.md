# AGENTS.md

Rules for AI agents and contributors working on Forge Dance.

## Target platforms

- Mobile (Android and iOS) and Web are the primary product targets.
- Linux desktop is a local UI-development target.

## Persistence

- Forge Dance is offline-first. There is no registration, login, or Firebase dependency.
- Persist progress locally behind repositories/data sources; widgets must not call storage APIs directly.
- Current MVP storage is `SharedPreferences` for profile, lesson progress, workout sessions, and preferences.
- Keep repository JSON shapes portable so future cloud sync can import/export a transferable file.
- Do not add a backend-as-a-service dependency unless the project explicitly changes direction.

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

- **Flutter SDK** is pinned to **3.47.2** via [FVM](https://fvm.app) (`.fvmrc`, matches CI in `.github/workflows/flutter.yml`). After cloning:
  ```bash
  dart pub global activate fvm   # one-time
  fvm install                    # downloads 3.47.2
  fvm use                        # creates .fvm/flutter_sdk symlink
  ```
  VS Code picks up `.fvm/flutter_sdk` automatically (`.vscode/settings.json`). Use `fvm flutter …` in a plain terminal, or just `flutter …` inside the VS Code integrated terminal once the Dart extension has switched SDKs.
- Do not run `flutter upgrade` on this repo without a deliberate version bump.
- Release Web builds use `flutter build web --wasm`; Flutter also emits the JavaScript fallback used when WasmGC is unavailable. Keep the fallback working for iOS and older browsers.
- **MCP (AI assistants):** `.mcp.json` configures the official Dart/Flutter server and an isolated Chrome DevTools server for shared/Pi clients. Cursor mirrors them in `.cursor/mcp.json`; VS Code registers Dart through `dart.mcpServer` and the others through `.vscode/mcp.json`. Run `fvm use` first, then reload the client. Chrome launches with a temporary profile; keep authenticated browsing in your normal profile.
- **Figma MCP:** Intentionally excluded. Do not add or configure it unless the project explicitly reverses this decision.

## Live Flutter development

- **Live loop:** When a Flutter debug app is running, or the user asks for hot reload, interactive UI iteration, or visual verification, follow `.agents/skills/flutter-live-development/SKILL.md`.
- During a live loop, apply each non-documentation change under `lib/` with Dart MCP hot reload or hot restart before evaluating it. Verify visual claims from a current screenshot, not from source or the widget tree alone.
- Prefer Linux desktop for fast UI-only iteration. Use the fixed-port Web Server target for browser flows.
- **Orca Android loop:** For Android UI, platform behavior, or device accessibility work in Orca, run `tool/run_orca_android.sh`; it attaches the AVD to Orca's embedded pane. Drive the device through `orca emulator` and follow the Android branch in the live-development skill.
- On Omarchy, `tool/capture_flutter_window.sh` captures the visible Forge Dance window under `build/live/` for vision-model review. `tool/capture_android_emulator.sh` captures the Android framebuffer. Web sessions use Chrome DevTools MCP at `http://127.0.0.1:7357`.

## Required checks

Run before handing off. CI runs the same script, so local green == CI green:

```bash
bash tool/checks.sh
```

That runs `flutter pub get`, localization codegen, `build_runner`, `flutter analyze` (including `riverpod_lint` through the analyzer plugin), and `flutter test`.

The browser integration gate exercises local profile setup and Home:

```bash
bash tool/check_integration.sh
```

Run it after changing onboarding, profile persistence, or routing. It requires Node.js, Java, and Chrome/Chromium with a matching ChromeDriver; the script downloads a matched test browser pair when necessary.

The release-web quality gate runs Lighthouse, checks category score floors, and rejects browser console errors or HTTP failures:

```bash
bash tool/check_web_quality.sh
```

Run it after changing web startup, routing, assets, metadata, or major UI composition. Reports are written under
`build/lighthouse/`. The performance and transfer floors protect the current
cold-start mobile baseline; raise them deliberately as startup improves.
