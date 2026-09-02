# Research: AI-assisted developer experience for Forge Dance (2026)

## Summary

Forge Dance already has the highest-value foundation: Flutter 3.47.2 is pinned, the official Dart/Flutter MCP server is project-configured for Cursor, VS Code enables Dart MCP registration, Firebase emulators are declared, and Widgetbook v4 scenarios run in PR CI. The best next steps are to encode repository guidance for all agents, add emulator-backed Firestore Rules tests, add a carefully constrained Firebase MCP server for local interactive use, and automate dependency/a11y/localization checks; production-mutating MCP tools and prerelease Widgetbook upgrades should remain human-approved.

This brief uses only current first-party documentation and direct repository inspection. **Verified facts** and **recommendations** are separated below; community or prerelease surfaces are explicitly flagged.

> **Implementation status (2026-09-01):** The first safe tranche is now implemented: shared/Pi, Cursor, and VS Code MCP configuration; isolated Chrome DevTools MCP; six reviewed official Flutter/Dart skills; emulator-backed Firestore Rules tests and CI; a headless Web registration/profile/logout/returning-sign-in integration test against Auth and Firestore emulators; an emulator-backed Lighthouse, console, and network quality gate; official Flutter accessibility and localization-catalog tests; and Dependabot. Firebase MCP is now enabled through an explicit tool allowlist that excludes deployments and destructive project/database administration; it still targets the active real Firebase project because the server has no emulator mode. Figma MCP is explicitly out of scope and remains unconfigured. The repository baseline below records the pre-implementation inspection.

## Repository baseline (verified)

- `.cursor/mcp.json` launches `.fvm/flutter_sdk/bin/dart mcp-server --force-roots-fallback`; this is correctly tied to the repository SDK rather than ambient `PATH`.
- `.vscode/settings.json` pins `dart.flutterSdkPath` to `.fvm/versions/3.47.2` and sets `dart.mcpServer: true`, but there is no `.vscode/mcp.json` for non-Dart servers.
- The current Pi session has the MCP adapter installed but reports **0 configured servers**. Its host-specific discovery does not automatically consume `.cursor/mcp.json`; a project `.mcp.json` or an explicit adapter import is needed for Dart MCP in Pi.
- `AGENTS.md` is strong repository-wide guidance. `.github/copilot-instructions.md` and `.cursor/rules/` are absent. The repository has many general agent skills under `.agents/skills/`, but not the official Flutter and Dart skill packs.
- `firebase.json` declares Auth (`9099`) and Firestore (`8080`) emulators and loads `firestore.rules`; `AGENTS.md` documents `firebase emulators:start` plus `--dart-define=USE_FIREBASE_EMULATOR=true`.
- `.github/workflows/flutter.yml` runs `bash tool/checks.sh`, builds web, and has a PR-only Widgetbook job. Widgetbook Cloud runs only behind a label and secret.
- `widgetbook/pubspec.yaml` uses **prerelease** `widgetbook: ^4.0.0-beta.13`; the CI globally activates the matching `widgetbook_cli 4.0.0-beta.13`. `accessibility_tools` is a third-party/community package, not an official Flutter accessibility tool.
- Root `pubspec.yaml` has no `integration_test` SDK dependency. `.github/dependabot.yml` is absent.
- Localization uses third-party `easy_localization`, the English catalogue in `assets/translations/en.json`, and generated `lib/generated/locale_keys.g.dart`; `tool/checks.sh` regenerates keys but did not previously verify that supported locales, assets, and generated keys agree.

## Findings

1. **Official Dart & Flutter MCP is stable, broad, and already mostly configured.** The server is shipped in the Dart SDK and uses stdio. A client needs MCP **Tools and Resources** for all features; **Roots** support is recommended. `--force-roots-fallback` is specifically intended for clients that claim Roots support but do not set roots. Its live capabilities include analyzer diagnostics/symbol resolution, code fixes, dependency operations, test execution, and connection to a running app through the Dart Tooling Daemon for runtime errors, widget inspection, and hot reload. The official VS Code integration requires Dart Code 3.116+ and can be enabled by `dart.mcpServer`; Cursor supports project `.cursor/mcp.json`. [Dart/Flutter MCP](https://dart.dev/tools/mcp-server) [Flutter AI setup](https://docs.flutter.dev/ai/get-started)

   **Recommendation:** keep the existing `.cursor/mcp.json` command and fallback flag. Add a documented client-version prerequisite (Dart Code >=3.116) to `AGENTS.md` when next editing onboarding docs. Validate the actual client tool list after SDK upgrades; do not duplicate Dart registration in `.vscode/mcp.json` while the Dart extension registers it. **Impact: high; effort: low; risk: low.**

2. **Runtime/test automation is official, but it requires a running target and deterministic tests.** Flutter's official `integration_test` package can use `flutter_test` APIs and run on devices/emulators, web, and Firebase Test Lab; it cannot operate native permission dialogs or other native platform UI. Flutter DevTools provides layout, performance, CPU, memory, network, logs, app-size, and deep-link tooling. The Dart MCP/DTD bridge makes live diagnostics and agentic hot reload possible, but it is an interactive developer workflow—not a CI replacement. [Integration tests](https://docs.flutter.dev/testing/integration-tests) [Testing overview](https://docs.flutter.dev/testing/overview) [DevTools](https://docs.flutter.dev/tools/devtools)

   **Recommendation:** first add one official `integration_test/` smoke path for sign-in/profile against Auth/Firestore emulators, then run it in a separate CI job with `firebase emulators:exec`; retain unit/widget tests as the fast gate. Use MCP live inspection locally to diagnose failures, not as a pass/fail oracle. Candidate seams: root `pubspec.yaml`, `integration_test/`, `firebase.json`, `.github/workflows/flutter.yml`. **Impact: high; effort: medium; risk: low.**

3. **Firebase MCP is powerful enough to touch production data and identities.** The official server runs as `npx firebase-tools … mcp`, supports stdio clients including Cursor and VS Code Copilot, and uses the same Firebase CLI user credentials or Application Default Credentials present in its environment. It exposes read/write/delete Firestore tools, Auth user updates/custom claims, project/app creation, index/database mutations, Rules retrieval/validation, messaging, Remote Config publication, and more. `--dir` fixes project context and `--only` limits feature groups, although core tools always remain. The server also supplies `firestore:generate_security_rules`, which asks the agent to generate Rules **and unit tests**. [Firebase MCP](https://firebase.google.com/docs/ai-assistance/mcp-server)

   **Recommendation:** add Firebase MCP only to local `.cursor/mcp.json` after a team security review, prefer a pinned reviewed `firebase-tools` version over `@latest`, set project directory via a portable workspace variable if supported by the client, and use `--only auth,firestore`. Keep every mutating/production call approval-gated; use a least-privilege non-owner account and never expose service-account JSON in committed config. For VS Code, use `.vscode/mcp.json` with stdio only if Copilot users need it. **Severity: high** if production credentials are used with auto-approval. **Impact: high; effort: low; risk: high.**

4. **Firebase MCP is not a substitute for emulator-backed Rules tests.** Official Emulator Suite guidance supports `firebase emulators:exec`, loads Rules from `firebase.json`, and recommends `@firebase/rules-unit-testing` v9 because it can mock authenticated/unauthenticated contexts and is emulator-aware so it does not touch production resources. The Firestore emulator UI includes Rules evaluation tracing. The MCP documentation does not claim that its Firestore document/query tools automatically target the emulator; only Data Connect's execute tool explicitly mentions an emulator. [Emulator configuration](https://firebase.google.com/docs/emulator-suite/install_and_configure) [Rules unit tests](https://firebase.google.com/docs/firestore/security/test-rules-emulator)

   **Recommendation:** create a small Node test workspace (for example `firebase-tests/`) covering owner/non-owner/unauthenticated access and run it via `firebase emulators:exec --only auth,firestore`. Require it before Rules deployment. Treat agent-generated Rules/tests as drafts requiring review. Candidate seams: `firestore.rules`, `firebase.json`, `firebase-tests/`, `tool/checks.sh` or a dedicated CI job. **Severity: high** because the current CI does not prove authorization behavior. **Impact: very high; effort: medium; risk: low.**

5. **Copilot cloud agent is suitable for bounded maintenance, provided setup and instructions are explicit.** It works in an ephemeral GitHub Actions-powered environment, can edit a branch and run checks, and has a 59-minute session ceiling. Repository instructions can live in `.github/copilot-instructions.md` or path-specific `.github/instructions/*.instructions.md`; Copilot CLI also discovers `AGENTS.md`. Cloud-agent repository MCP settings also apply to Copilot code review, support tools (not MCP resources/prompts), and should allowlist specific read-only tools. GitHub and Playwright MCP servers are enabled by default; broader MCP access requires careful tokens/secrets prefixed `COPILOT_MCP_`. [Cloud agent](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-coding-agent) [Custom instructions](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-custom-instructions) [Repository MCP](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/configure-mcp-servers)

   **Recommendation:** add `.github/copilot-instructions.md` that points to/condenses `AGENTS.md`, mandates `bash tool/checks.sh`, generated-file policy, Firebase repository boundaries, and Flutter 3.47.2. Optionally add path-specific instructions for `lib/features/**`, `lib/design_system/**`, and `widgetbook/**`. Use cloud agent for tests, docs, dependency PR repair, and small refactors—not production Firebase operations. A custom `.github/agents/flutter-maintainer.md` is a later optimization, not required initially. **Impact: high; effort: low; risk: medium.**

6. **Cursor rules and MCP config are complementary, but rules are guidance rather than enforcement.** Cursor project rules are versioned `.mdc` files in `.cursor/rules/` and can always apply, match globs, be selected by relevance, or be manually invoked. Cursor's project MCP file is `.cursor/mcp.json`; stdio and remote servers, environment interpolation, and OAuth are supported. Cursor warns that rules are not guarantees and recommends enforcement hooks/checks for hard requirements. [Cursor rules](https://cursor.com/docs/rules) [Cursor MCP](https://cursor.com/docs/mcp) [Cursor safety controls](https://cursor.com/docs/enterprise/llm-safety-and-controls)

   **Recommendation:** keep `AGENTS.md` canonical; add only narrow `.cursor/rules/*.mdc` files for path-scoped architecture/design-system/generated-file rules to avoid drift. Never commit tokens in `.cursor/mcp.json`; use `${env:…}`. The existing relative Dart binary is good for reproducibility, but requires `fvm use` to create the SDK path. **Impact: medium; effort: low; risk: low.**

7. **Widgetbook v4 offers deterministic agent-friendly scenarios, but this repository is on a beta.** Official v4 docs say Scenarios run on `flutter_test`, expose `WidgetTester` for interactions/assertions, lock Args/Modes, and support global theme/locale/viewport scenario definitions. Widgetbook Cloud can compare snapshots and Figma designs. The official docs describe “developers and coding agents” executing scenarios, but no official Widgetbook MCP server or general AI design-to-code integration was found. [Widgetbook v4 scenarios](https://docs.widgetbook.io/~v4/testing/overview) [Create scenarios](https://docs.widgetbook.io/~v4/testing/create-scenario) [v4 status](https://docs.widgetbook.io/~v4/whats-new-in-v4)

   **Recommendation:** expand scenarios for loading/error/empty, light/dark, locale, text-scale, and small/large viewports; keep the Cloud upload label-gated until cost and signal are proven. Pin package and CLI to exactly the same beta (avoid caret drift), or move to stable v4 only after release notes and a green pilot. Do **not** adopt an unofficial “Widgetbook MCP” without independent security/source review. Candidate seams: `widgetbook/pubspec.yaml`, `widgetbook/lib/widgetbook.config.dart`, scenario files, `.github/workflows/flutter.yml`. **Flag: prerelease/community adjacency. Impact: high; effort: medium; risk: medium.**

8. **Figma's official remote MCP can improve design-system fidelity, but raw output is not Flutter-specific by default.** Figma recommends its OAuth remote endpoint (`https://mcp.figma.com/mcp`) for supported clients including Cursor and VS Code. It supplies design context, assets, Code Connect mappings, design-system rules, and some write-to-canvas/live-web-capture tools. `get_design_context` defaults to React + Tailwind unless prompted otherwise. Code Connect template mappings are framework-agnostic and can attach component usage and accessibility instructions; remote access is link-based, while selection-based prompting is desktop-only. [Figma MCP](https://developers.figma.com/docs/figma-mcp-server/) [Remote setup](https://developers.figma.com/docs/figma-mcp-server/remote-server-installation/) [Code Connect](https://developers.figma.com/docs/figma-mcp-server/code-connect-integration/) [Tools](https://developers.figma.com/docs/figma-mcp-server/tools-and-prompts/)

   **Decision:** do not configure or pilot Figma MCP. Keep design implementation within the reviewed Forge design system and Widgetbook workflow. Reconsider only if the project explicitly reverses this decision. **Risk avoided: medium** (design/IP exposure, plan dependence, generated-code mismatch).

9. **Dependency and supply-chain automation has a clear missing seam.** Dependabot version updates require `.github/dependabot.yml`; it can update supported package ecosystems and GitHub Actions. Security updates depend on Dependency Graph/alerts and raise minimum patched-version PRs. Dependency Review can fail PRs that introduce known vulnerable dependencies, but the Action is available to public repos and private repos with GitHub Code Security/Advanced Security. [Dependabot version updates](https://docs.github.com/en/code-security/concepts/supply-chain-security/dependabot-version-updates) [Security updates](https://docs.github.com/en/code-security/concepts/supply-chain-security/dependabot-security-updates) [Dependency Review](https://docs.github.com/en/code-security/concepts/supply-chain-security/dependency-review)

   **Recommendation:** add weekly grouped `pub` updates for `/` and `/widgetbook` plus `github-actions` for `/`; retain the Flutter SDK pin and let `tool/checks.sh` validate PRs. Enable Dependency Graph, alerts, and security updates in repository settings. Add Dependency Review if repository licensing permits. Avoid unattended auto-merge for Flutter/Firebase major updates or Widgetbook betas. Candidate seams: `.github/dependabot.yml`, repository security settings, `.github/workflows/flutter.yml`. **Impact: high; effort: low; risk: low/medium.**

10. **Official accessibility checks are immediately automatable; localization needs a deliberate policy.** Flutter's Accessibility Guideline API checks Android/iOS target sizes, labels, and text contrast in widget tests; platform scanners and screen readers remain necessary. The official localization stack uses ARB plus `flutter gen-l10n`, configured through `l10n.yaml`, but Forge Dance currently uses third-party `easy_localization`; migration is optional and should not be mixed casually. [Accessibility testing](https://docs.flutter.dev/ui/accessibility/accessibility-testing) [Flutter internationalization](https://docs.flutter.dev/ui/internationalization)

    **Recommendation:** add an official-guideline widget test around reusable design-system components and important screens, including text scaling; retain manual TalkBack/VoiceOver audits before release. Add a deterministic test that verifies supported locales, translation assets, parseability, and generated-key freshness. If more locales are introduced, extend it to compare key sets and placeholder arity. Evaluate ARB/`gen-l10n` only as a planned migration. Keep `widgetbook`'s community `accessibility_tools` as supplemental, not authoritative. **Impact: high; effort: low/medium; risk: low.**

11. **Flutter and Dart now publish official agent skill packs.** Flutter documents installable, on-demand skills for responsive layout, state management, widget testing, and related workflows; Dart publishes a complementary skill pack. Universal clients can install both into `.agents/skills`, while Claude Code, Cursor, and Codex also have client-specific plugin installation paths. These skills complement—rather than replace—the live Dart MCP server. [Flutter agent skills](https://docs.flutter.dev/ai/agent-skills) [Flutter AI tooling](https://docs.flutter.dev/ai/mcp-server)

    **Recommendation:** install the official packs in a reviewable branch, inspect overlap with Forge Dance's existing custom skills, and keep project-specific architecture rules authoritative. Do not blindly overwrite similarly named skills. The universal install commands are `npx skills add flutter/agent-plugins --skill '*' --agent universal --yes` and `npx skills add dart-lang/skills --skill '*' --agent universal --yes`. **Impact: high; effort: low; risk: low/medium** (instruction overlap and future upstream changes).

12. **Chrome DevTools has an official MCP server for Flutter Web debugging.** Google's server can drive an isolated Chrome instance, inspect console/network/DOM state, capture screenshots, emulate devices, and perform performance analysis. It can attach to a running browser, but authenticated profiles and remote-debugging sessions expose sensitive browser data to the agent. [Chrome DevTools for agents](https://developer.chrome.com/docs/devtools/agents/get-started) [Configuration](https://developer.chrome.com/docs/devtools/agents/get-started/configuration) [Security](https://github.com/ChromeDevTools/chrome-devtools-mcp/blob/main/SECURITY.md)

    **Recommendation:** add it only as an opt-in local MCP server and use an isolated Chrome profile against the local Flutter web app and Firebase emulators. Pin a reviewed package version instead of `@latest`, disable telemetry if team policy requires it, and never attach it to a normal signed-in browser profile. This gives agents visual verification that the Dart analyzer cannot provide. **Impact: high; effort: low; risk: medium.**

13. **The project currently configures Dart MCP per editor, not for the active Pi harness.** The installed Pi MCP adapter prefers project `.mcp.json`; it does not automatically load host-specific Cursor configuration in its default mode. This explains why the current session reports zero servers even though Cursor is configured.

    **Recommendation:** if Pi is part of the team workflow, add a project `.mcp.json` containing the same FVM-pinned Dart server, or explicitly adopt `.cursor/mcp.json` through the adapter setup flow. Keep `.cursor/mcp.json` for Cursor unless the client is verified to read the shared file. Then smoke-test analyzer, test, and running-app tools in each supported client. **Impact: high for Pi users; effort: low; risk: low.**

## Prioritized adoption plan

| Rank | Integration | Impact | Effort | Risk | Concrete seam |
|---:|---|---|---|---|---|
| 1 | Make Dart MCP available to every used client, including Pi | High | Low | Low | existing `.cursor/mcp.json`; add `.mcp.json` only for Pi/shared clients |
| 2 | Review and install official Flutter/Dart agent skills | High | Low | Low–medium | `.agents/skills/` or client plugins |
| 3 | Emulator-backed Firestore Rules tests | Very high | Medium | Low | `firebase-tests/`, `firestore.rules`, CI |
| 4 | Chrome DevTools MCP for isolated local Flutter Web QA | High | Low | Medium | local/shared MCP config, isolated Chrome profile |
| 5 | Accessibility + locale consistency gates | High | Low–medium | Low | `test/a11y_test.dart`, `tool/checks.sh`, `assets/translations/` |
| 6 | Dependabot + security settings | High | Low | Low–medium | `.github/dependabot.yml`, GitHub settings |
| 7 | Official integration-test emulator smoke path | High | Medium | Low | `integration_test/`, `pubspec.yaml`, CI |
| 8 | Expand Widgetbook v4 scenarios | High | Medium | Medium (beta) | `widgetbook/`, Widgetbook CI job |
| 9 | Shared Copilot/agent instructions and narrow Cursor rules | Medium–high | Low | Low | `.github/copilot-instructions.md`, `.cursor/rules/*.mdc` |
| 10 | Firebase MCP, local and constrained | High | Low | **High** | opt-in local MCP config; never autonomous production access |
| Not planned | Figma MCP + Code Connect | Medium | Medium–high | Medium | explicitly excluded by project decision |
| 12 | Copilot custom agent/repository MCP | Medium | Medium | Medium | `.github/agents/`, GitHub repository MCP settings |

## Security and release guardrails

- **Blocker/high:** never enable autonomous Firebase mutators against an owner credential or production project; MCP inherits CLI/ADC authority.
- **High:** generated Security Rules are untrusted until emulator tests prove deny and allow cases and a human reviews the diff.
- **Medium:** pin executable MCP/CLI packages rather than executing `@latest`; updates should arrive through reviewed dependency/tooling work.
- **Medium:** cloud agents and Figma remote MCP transmit repository/design context to their respective services; confirm organization policy, plan, and data controls.
- **Medium:** Widgetbook `4.0.0-beta.13` is prerelease. Keep package/CLI synchronized and upgrades isolated.
- Hard requirements remain enforced by `tool/checks.sh`, tests, CI, branch protection, and approval—not prose rules or model judgment.

## Sources

### Kept

- [Dart and Flutter MCP / Flutter AI setup](https://dart.dev/tools/mcp-server) — official capabilities, transports, client requirements, and setup.
- [Firebase MCP server](https://firebase.google.com/docs/ai-assistance/mcp-server) — official tools, credentials, filtering, and client configuration.
- [Firebase Local Emulator Suite](https://firebase.google.com/docs/emulator-suite/install_and_configure) — official CI and emulator behavior.
- [Firestore Rules emulator tests](https://firebase.google.com/docs/firestore/security/test-rules-emulator) — official authenticated/unauthenticated Rules-testing workflow.
- [GitHub Copilot cloud agent](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-coding-agent) and [repository MCP](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/configure-mcp-servers) — execution model, limits, instructions, and MCP security.
- [Cursor Rules](https://cursor.com/docs/rules) and [Cursor MCP](https://cursor.com/docs/mcp) — official project configuration and scope behavior.
- [Flutter integration tests](https://docs.flutter.dev/testing/integration-tests), [DevTools](https://docs.flutter.dev/tools/devtools), and [accessibility tests](https://docs.flutter.dev/ui/accessibility/accessibility-testing) — official runtime/test automation.
- [Flutter agent skills](https://docs.flutter.dev/ai/agent-skills) — official Flutter/Dart skill-pack installation and supported clients.
- [Chrome DevTools for agents](https://developer.chrome.com/docs/devtools/agents/get-started) — official browser automation, debugging, and performance tooling.
- [Widgetbook v4 testing](https://docs.widgetbook.io/~v4/testing/overview) — official scenario and Cloud behavior for the installed major version.
- [Figma MCP](https://developers.figma.com/docs/figma-mcp-server/) — official design context and Code Connect workflow.
- [GitHub dependency security](https://docs.github.com/en/code-security/concepts/supply-chain-security/dependabot-version-updates) — official update and vulnerability automation.
- [Flutter internationalization](https://docs.flutter.dev/ui/internationalization) — official localization alternative and generator.

### Dropped

- Community Flutter MCP servers, Patrol/Maestro, unofficial Widgetbook MCP packages, AI design-to-Flutter generators, and generic MCP registries — excluded because the task requires current primary sources and/or the tooling is community-maintained.
- Vendor comparison blogs and marketplace listings — excluded where the official product documentation was available.
- `accessibility_tools` package claims — not used as evidence because it is third-party; only its presence in this repository is reported.

## Gaps

- Repository settings (Copilot entitlement/policies, Dependency Graph/alerts, branch protection, Widgetbook Cloud plan, Figma plan) were not inspectable from local files.
- No official Widgetbook MCP server was found in Widgetbook's v4 documentation. Absence cannot prove none will be released; re-check before adopting any similarly named package.
- Client versions/extensions actually installed on each developer machine were not inspectable, so Dart Code >=3.116, MCP tool visibility, Roots behavior, and OAuth flows require a manual smoke test.
- This was a research-only task; no builds/tests were run and no proposed configuration was applied.
