# Forge Dance

Forge Dance is a Flutter app built with Riverpod, Firebase, and a feature-first architecture.

## Target platforms

Mobile (Android and iOS) and Web are the primary product targets. Linux desktop is available only for local UI development and skips Firebase initialization because FlutterFire does not support Linux.

## Backend

Firebase is the selected MVP backend for fastest path to market.

Firebase project:

- Display name: `forge-dance`
- Project ID: `forgedance-52c54`

Current stack:

- Firebase Auth for email/password accounts
- Cloud Firestore for user/profile data

Firebase SDK usage should stay behind repositories/data sources. Widgets should call Riverpod view models, not Firebase APIs directly.

## Firebase setup

FlutterFire has generated app configuration for Android, iOS, macOS, web, and Windows.

Enable these services in Firebase Console before using auth/profile persistence:

1. **Authentication > Sign-in method > Email/Password**
2. **Firestore Database** in production mode or test mode, then deploy `firestore.rules`

Useful Firebase commands:

```bash
firebase login
flutterfire configure --project=forgedance-52c54
firebase deploy --only firestore:rules
```

## Android development in Orca

The Orca-native loop boots or reuses an Android AVD, opens its embedded H.264
pane for this worktree, and starts Flutter against the local Firebase Auth and
Firestore emulators:

```bash
firebase emulators:start --only auth,firestore
bash tool/run_orca_android.sh
```

The recommended AVD is `Forge_Dance_API_35`. Override the selected booted device
with `FORGE_ANDROID_DEVICE=<adb-serial>`. The app uses `10.0.2.2` to reach the
host's Firebase emulators, so this path never uses production Firebase.

While the app is running, agents can inspect and operate the same device shown
in Orca:

```bash
orca emulator devices --json
orca emulator ax --device emulator-5554 --json
orca emulator tap 0.5 0.7 --device emulator-5554 --json
orca emulator logcat --lines 200 --device emulator-5554 --json
bash tool/capture_android_emulator.sh
```

Inside an Orca terminal use `orca`; on unmanaged Linux shells use `orca-ide`.
The capture command writes `build/live/android-emulator.png` for visual review.
Flutter remains attached for hot reload through Dart MCP.

## Widgetbook

Use the integrated workbench to develop Forge Dance foundations, components, and screens in isolation:

```bash
fvm flutter run -d web-server -t widgetbook/main.dart --web-port=7357
```

Open `http://127.0.0.1:7357`. Widgetbook uses the production design-system tokens and themes without initializing Firebase.

The catalog follows the production composition order:

1. **Foundations** — tokens and themes
2. **Atoms** — indivisible controls and visuals
3. **Molecules** — small atom compositions
4. **Organisms** — reusable application sections
5. **Templates** — screen-level layout contracts
6. **Screens** — integrated feature surfaces

Refine the lowest applicable layer first, export reusable components from `lib/design_system/design_system.dart`, then compose them into higher layers.

## Commands

```bash
flutter pub get
dart run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir assets/translations
dart run build_runner build
flutter analyze
flutter test
flutter build web --release --wasm
bash tool/check_firebase_rules.sh
bash tool/check_integration.sh
bash tool/check_web_quality.sh
```

## Project structure

```text
lib/
├── constants/
├── design_system/
├── extensions/
├── features/
│   └── <feature>/
│       ├── model/
│       ├── repository/
│       └── ui/ or presentation/
├── generated/
├── routing/
├── theme/
└── utils/
```

See `AGENTS.md` before making changes.
