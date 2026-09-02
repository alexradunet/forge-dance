---
name: flutter-live-development
description: Run a live Flutter development loop with Dart MCP hot reload or restart, runtime and widget inspection, and screenshot-based visual verification. Use when the user asks for hot reload, live UI iteration, interactive Flutter development, visual UI checking, or agent-driven work against a running Flutter app.
---

# Live Flutter development

Use a **live loop**: establish one running debug app, make one coherent change,
reload it, inspect the real result, and repeat. Source inspection alone is not
visual verification.

## 1. Choose the target

- Use **Linux desktop** for fast UI-only work. Firebase is intentionally absent
  on Linux, so authentication and Firestore flows are not valid there.
- Use **Web Server + Firebase emulators** for authentication, profile, routing,
  or persisted-data work. This exposes a stable browser URL for Chrome DevTools
  MCP while Dart MCP owns hot reload.
- Use only debug mode. Profile and release builds cannot hot reload.

Start from a dedicated terminal or the matching VS Code launch configuration:

```bash
bash tool/run_live_flutter.sh linux
bash tool/run_live_flutter.sh web
```

The web command requires Auth and Firestore emulators. Start them first with:

```bash
firebase emulators:start --only auth,firestore
```

The web app is served at `http://127.0.0.1:7357` by default and is always built
with `USE_FIREBASE_EMULATOR=true`.

## 2. Connect Dart MCP

1. Add the repository URI with `dart_roots` if the root is not registered.
2. Call `dart_dtd` with `listDtdUris`.
3. If no DTD exists, start the app in debug mode and retry; do not pretend a
   reload occurred.
4. Connect to the DTD URI, then call `listConnectedApps`.
5. Record the matching app URI and pass it explicitly to runtime tools when
   more than one app is connected. A DTD URI and an app/VM-service URI are
   different values.
6. Clear stale runtime errors and capture a baseline widget tree before editing.

Completion criterion: the intended Forge Dance process appears in
`listConnectedApps`, and runtime-error and widget-inspector calls succeed.

## 3. Iterate

For each coherent Dart change under `lib/`:

1. Inspect the relevant widget subtree and capture a visual baseline when the
   change is visual.
2. Edit the smallest coherent slice.
3. Run targeted Dart MCP analysis on the changed files. Run code generation
   first when annotations, generated models/providers, or translations changed.
4. Apply the change:
   - Use `dart_hot_reload` for widget `build` changes and ordinary method-body
     changes. Hot reload preserves current navigation and state.
   - Use `dart_hot_restart` after changing `main()`, `initState()`, global or
     static initialization, provider lifetimes, generated code, or state whose
     old instance would hide the change.
   - Stop and relaunch after native/plugin configuration, dependency, asset, or
     platform-runner changes.
5. If reload is rejected, inspect analyzer/runtime errors, fix them, and retry
   before evaluating the UI. Never assess a stale screen.
6. Fetch current runtime errors after every successful reload or restart.
7. Re-fetch the widget tree because element identities and structure can change.
8. Capture and inspect the rendered result:
   - **Linux:** run `bash tool/capture_flutter_window.sh`; open the printed PNG
     with an image-capable tool/model. Use the Computer Use skill when desktop
     interaction or accessibility-tree inspection is needed.
   - **Web:** open `http://127.0.0.1:7357` with Chrome DevTools MCP. Use page
     snapshots for interaction, screenshots for visual inspection, and inspect
     console messages after each iteration. Exercise mobile and desktop viewport
     sizes for responsive changes.
9. Compare the result with the requested behavior and repeat if needed.

A visual claim requires an inspected screenshot from the current post-reload
build. A widget tree proves structure, not appearance.

## 4. Finish

Before handoff, require all of the following:

- The requested state is visible in a post-reload screenshot at each relevant
  viewport.
- Dart MCP reports no current runtime errors.
- Targeted analysis/tests pass during the loop.
- `bash tool/checks.sh` passes for the final codebase.
- Run the emulator integration or Lighthouse gates when their AGENTS.md trigger
  conditions apply.
- Generated files and screenshots remain uncommitted.
