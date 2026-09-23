# Maestro Android scenarios

Maestro drives the compiled app through Android accessibility, with no Flutter
package or backend dependency. These tests complement widget tests and the
existing browser integration gate; they do not replace them.

## Install once

Install Java 17+ (JDK 21 recommended for this project's Android build), the Android
SDK, and the [Maestro CLI](https://docs.maestro.dev/maestro-cli/how-to-install-maestro-cli):

```bash
curl -fsSL https://get.maestro.mobile.dev -o /tmp/install-maestro.sh
# Review the installer before executing it.
bash /tmp/install-maestro.sh
export PATH="$HOME/.maestro/bin:$PATH"
maestro --version
```

Set `JAVA_HOME` and `ANDROID_HOME` as needed. Use the project's pinned Flutter SDK
(`fvm use`). Maestro is a separate developer tool, not a pub dependency.

## Run

**Every scenario clears all Forge Dance data on the selected emulator**, including
progress and private media. Create and boot a disposable Android API 35 AVD (for
example `Forge_Dance_Maestro_API_35`) in Android Studio. Use an English device
locale and its default font/display scale. Do not use your personal/dev profile
or run Maestro alongside a live Flutter session on the same device.

```bash
adb devices
FORGE_ANDROID_DEVICE=emulator-5556 FORGE_MAESTRO_ALLOW_CLEAR=1 \
  bash tool/check_maestro.sh

# Just one scenario:
FORGE_ANDROID_DEVICE=emulator-5556 FORGE_MAESTRO_ALLOW_CLEAR=1 \
  bash tool/check_maestro.sh .maestro/flows/onboarding-persistence.yaml
```

Replace the serial with your disposable emulator's actual serial. The runner
regenerates ignored Dart sources, builds a release APK, installs it, then runs
Maestro. To reuse an existing APK, set `FORGE_MAESTRO_APK` to its absolute path.
The APK must have application ID `dance.forge.app`.

Each run writes JUnit XML, screenshots, and debug output to a unique
`build/maestro-*` directory. A failing scenario returns a nonzero exit code. The
runner also works in CI with an already-booted emulator and the same explicit
environment variables; emulator provisioning is not part of `tool/checks.sh`.

## Watch live in Orca

Attach the disposable AVD to the current workspace, then run the same test command
in an Orca terminal. Maestro drives the device shown in the embedded pane; do not
click/type in that pane while a scenario is running.

```bash
# Use orca-ide instead of orca in unmanaged Linux shells.
orca emulator attach Forge_Dance_Maestro_API_35 --worktree active --focus --json
orca emulator devices --json
# Use the serial returned by attach (not the AVD name) with the runner above.
```

For quick replays without rebuilding:

```bash
FORGE_ANDROID_DEVICE=emulator-5556 FORGE_MAESTRO_ALLOW_CLEAR=1 \
  FORGE_MAESTRO_APK="$PWD/build/app/outputs/flutter-apk/app-release.apk" \
  bash tool/check_maestro.sh
```

Validated CLI version: **Maestro 2.10.0**. No Maestro account is needed for local
runs. Set `MAESTRO_CLI_NO_ANALYTICS=1` to disable CLI analytics.

## Scenarios and selectors

- `onboarding-persistence`: empty-name Continue is disabled, profile creation
  reaches Home, and the saved name survives a process restart.
- `profile-navigation`: independent clean setup, Home → Profile → Home.
- `vocabulary-search`: search with no matches, then clear and recover the list.
- `helpers/`: reusable flows, excluded from suite discovery in `config.yaml`.

Use `maestro --device <serial> studio` to inspect the accessibility tree and
write more scenarios. Prefer visible semantic labels over screen coordinates.
Flutter `ValueKey`s are **not** exposed to Maestro; if a stable ID is needed,
add a `Semantics(identifier: ...)` to the app and target it with `id:`. Current
flows use English accessibility labels and retrying assertions, not fixed sleeps.
Keep each top-level flow independently runnable, with its own clean setup.

Direct `maestro test .maestro` bypasses the runner's safety checks and still
clears data. Only use it against a disposable emulator.
