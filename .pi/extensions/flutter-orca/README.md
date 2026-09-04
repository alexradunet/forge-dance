# Flutter Orca Pi extension

Controls Forge Dance's Android debug process in the emulator pane attached to the current Orca worktree.

## Prerequisites

- Trust this project in Pi so project-local extensions load.
- Run `fvm use` after cloning the repository.
- Keep Orca installed; the extension starts Orca when `start` or `relaunch` needs it.
- Have an Android device or AVD available to Orca. `tool/run_orca_android.sh` reuses an active Android attachment when possible; otherwise it attaches a booted or available device and lets Orca's video transport settle before Flutter creates its VM-service forwarding.

Reload Pi resources after installing or changing the extension:

```text
/reload
```

## Commands

```text
/flutter start
/flutter reload
/flutter restart
/flutter relaunch
/flutter stop
/flutter status
```

- `start` creates or reuses the **Forge Dance — Flutter Android** terminal, focuses it, and waits up to two minutes for Flutter's VM-service URI.
- `reload` sends Flutter's `r` hot-reload key and preserves application state.
- `restart` sends Flutter's `R` hot-restart key and resets Dart application state.
- `relaunch` gracefully stops the process and starts it again, focusing its terminal.
- `stop` sends Flutter's `q` key. If needed, it sends a terminal interrupt; it never closes the Orca terminal.
- `status` reports the managed process without starting Orca or Flutter.

The LLM can perform the same operations with the `flutter_orca` tool. Reloads are intentionally explicit: the extension does not watch files or reload incomplete intermediate edits.

## State and recovery

Runtime state is stored at `build/live/flutter-orca-state.json`, which is covered by the repository's `/build/` ignore rule. The file records the managed runner PID, Orca terminal identity, readiness phase, and VM-service URI.

On Pi startup or `/reload`, the extension restores its footer status without launching anything. It validates both the runner process and Orca terminal before treating saved state as live. If Orca issues a new terminal handle after restarting, the extension recovers it by PTY identity and then by the dedicated terminal title.

Complete Flutter output remains in the Orca terminal. Pi displays only concise operation results and failure excerpts.

## Tests

Run the extension's environment-independent unit tests with:

```bash
node --test .pi/extensions/flutter-orca/core.test.mjs
```

A live smoke test requires Orca and an Android emulator:

1. Run `/reload` in Pi.
2. Run `/flutter start` and confirm the emulator pane is visible and the footer says `Flutter: running`.
3. Make a harmless Dart method-body or widget-build change and run `/flutter reload`.
4. Run `/flutter restart`, `/flutter status`, and `/flutter stop`.
5. Run `/reload` while Flutter is running and confirm that the footer recovers without relaunching the app.
