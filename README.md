# Forge Dance

Forge Dance is a Flutter app built with Riverpod, Firebase, and a feature-first architecture.

## Backend

Firebase is the selected MVP backend for fastest path to market.

Current stack:

- Firebase Auth for email/password accounts
- Cloud Firestore for user/profile data

Firebase SDK usage should stay behind repositories/data sources. Widgets should call Riverpod view models, not Firebase APIs directly.

## Firebase setup

Install and run FlutterFire CLI before using Firebase services in a real environment:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Then enable **Authentication > Sign-in method > Email/Password** in Firebase Console.

Until real Firebase options are generated, the checked-in `lib/firebase_options.dart` skips Firebase initialization so CI and local desktop development can still run.

## Commands

```bash
flutter pub get
flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir assets/translations
flutter pub run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
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
