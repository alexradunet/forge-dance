# Forge Dance

Forge Dance is an offline-first Flutter app built with Riverpod and a feature-first architecture.

## Target platforms

Mobile (Android and iOS) and Web are the primary product targets. Linux desktop is available for local UI development.

## Persistence

Forge Dance has no registration, login, or Firebase dependency. Profile data, lesson progress, workout sessions, theme preferences, and other MVP state are saved locally behind repositories.

The local repository JSON shapes are intentionally portable so future cloud sync can import/export a transferable progress file without changing widgets.

## Android development in Orca

The Orca-native loop boots or reuses an Android AVD, opens its embedded H.264 pane for this worktree, and starts Flutter:

```bash
bash tool/run_orca_android.sh
```

The recommended AVD is `Forge_Dance_API_35`. Override the selected booted device with `FORGE_ANDROID_DEVICE=<adb-serial>`.

While the app is running, agents can inspect and operate the same device shown in Orca:

```bash
orca emulator devices --json
orca emulator ax --device emulator-5554 --json
orca emulator tap 0.5 0.7 --device emulator-5554 --json
orca emulator logcat --lines 200 --device emulator-5554 --json
bash tool/capture_android_emulator.sh
```

Inside an Orca terminal use `orca`; on unmanaged Linux shells use `orca-ide`. The capture command writes `build/live/android-emulator.png` for visual review. Flutter remains attached for hot reload through Dart MCP.

## Widgetbook

Use the integrated workbench to develop Forge Dance foundations, components, and screens in isolation:

```bash
fvm flutter run -d web-server -t widgetbook/main.dart --web-port=7357
```

Open `http://127.0.0.1:7357`. Widgetbook uses the production design-system tokens and themes.

## Commands

```bash
flutter pub get
dart run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir assets/translations
dart run build_runner build
flutter analyze
flutter test
flutter build web --release --wasm
bash tool/check_integration.sh
bash tool/check_web_quality.sh
```

See `AGENTS.md` before making changes.
