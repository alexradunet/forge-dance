# Forge Dance

Forge Dance is a Flutter app built with Riverpod, Firebase, and a feature-first architecture.

## Backend

Firebase is the selected MVP backend for fastest path to market.

Firebase project:

- Display name: `forge-dance`
- Project ID: `forge-dance-1bcc7`

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
flutterfire configure --project=forge-dance-1bcc7
firebase deploy --only firestore:rules
```

Linux desktop is kept as a local development target; Firebase initialization is skipped there because FlutterFire did not generate Linux options.

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
