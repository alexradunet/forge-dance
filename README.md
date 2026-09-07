# Forge Dance

Forge Dance is an offline-first Flutter app built with Riverpod and a feature-first architecture.

## Target platforms

Mobile (Android and iOS) and Web are the primary product targets. Linux desktop is available for local UI development.

## Persistence

Forge Dance has no registration, login, or Firebase dependency. Profile data, lesson progress, workout sessions, FORGE assessment history, practice records, programme enrolment, and preferences are saved locally behind repositories.

Settings → **Backup & restore** transfers these records and private video bytes in a versioned JSON file. Restoring replaces local data after validation; failed writes attempt rollback. Keep the exported file until restoration is complete. Device-only avatar files are excluded, and previously deleted evidence remains explicitly unavailable.

Video imports are private and permission-cleared by the learner: up to 20 MiB each and 100 MiB per library. Native media lives in an app-private database; Web uses IndexedDB and is subject to browser eviction or site-data clearing. Export backups rather than relying on browser storage alone.

## FORGE Method and practice

- Six core categories build the belt: rhythm, body control, footwork, coordination, retention, and creativity. Mobility and movement capacity guide supporting practice without gating belts.
- Seven assessed levels per category and seven integrated assessments define promotion through the existing eight belt colours. All six core categories and an integrated assessment must meet the target level. XP remains participation history, never proof of mastery.
- Results are self-assessed against provisional, versioned teaching rubrics—not coach verification or a universal dance ranking. Failed retests can lower current capability without removing previously earned belts.
- Daily practice scales each category independently and offers seated/supported options, time budgets, gentler variants, and optional conditioning. Repeated same-day practice is recorded separately.
- The offline cue player provides count-in, metronome, phrase loops, independent practice, notes, and private evidence. Imported video supports mirroring, speed, seeking, and phrase loops. No instructor footage is bundled; the step-touch graphic is explicitly schematic.
- Five programmes curate the existing lesson curriculum. Vocabulary distinguishes studying a lesson from demonstrated category capability and recorded practice.
- Learning and practice screens share the app's immersive dark palette, rounded charcoal cards, orange actions, and editorial headers. Their dialogs use the same theme even on light-system devices; high-contrast and large-text settings remain supported without changing saved appearance preferences.

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
