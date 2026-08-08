# Forge Dance

Forge Dance is a gamified Flutter dance-training app built with Riverpod,
Firebase, and a feature-first architecture. Users sign in, follow structured
lesson paths, complete daily workouts, and track XP, streaks, belts, and
diamonds from real user state.

See `AGENTS.md` before making changes. `CLAUDE.md` has the deeper architecture
notes and current subsystem map.

## Current product surface

- Authentication and profile persistence use Firebase Auth, Cloud Firestore,
  and a local SharedPreferences cache.
- Learn/explore/collection screens render the bundled module catalog from
  `lib/features/learn/repository/lesson_catalog.dart`.
- Lesson progress is stored per user in `users/{uid}/progress/{lessonId}`.
- Daily training uses the bundled workout catalog and deterministic WOD
  rotation in `lib/features/workout/repository/workout_catalog.dart`.
- Workout completions are stored in `users/{uid}/sessions/{date}_{workoutId}`;
  the deterministic document id caps XP at one award per workout per day.
- Stats, belts, and streaks are derived from lesson progress plus workout
  sessions in `lib/features/stats/model/stats_rules.dart`. The profile `xp`
  field is only a denormalized mirror written after training activity.

## Backend

Firebase is the selected MVP backend for fastest path to market.

Firebase project:

- Display name: `forge-dance`
- Project ID: `forge-dance-1bcc7`

Current stack:

- Firebase Auth for email/password accounts
- Cloud Firestore for profile, lesson progress, and workout session data

Firebase SDK usage should stay behind repositories/data sources. Widgets should call Riverpod view models, not Firebase APIs directly.

## Firebase setup

FlutterFire has generated app configuration for Android, iOS, macOS, web, and Windows.

Enable these services in Firebase Console before using auth and Firestore persistence:

1. **Authentication > Sign-in method > Email/Password**
2. **Firestore Database** in production mode or test mode, then deploy `firestore.rules`

Useful Firebase commands:

```bash
firebase login
flutterfire configure --project=forge-dance-1bcc7
firebase deploy --only firestore:rules
```

Linux desktop is kept as a local development target; Firebase initialization is skipped there because FlutterFire did not generate Linux options.

For local auth/Firestore testing, use the Firebase Emulator Suite instead of
production data:

```bash
firebase emulators:start
fvm flutter run --dart-define=USE_FIREBASE_EMULATOR=true
```

## Commands

Flutter is pinned to 3.35.5 through FVM (`.fvmrc`). In a fresh checkout:

```bash
dart pub global activate fvm
fvm install
fvm use
```

Generated files are gitignored (`*.g.dart`, `*.freezed.dart`,
`lib/generated/locale_keys.g.dart`). Regenerate them locally after dependency,
model, provider, state, or translation changes.

The full verification command mirrors CI:

```bash
bash tool/checks.sh
```

That runs:

```bash
flutter pub get
flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir assets/translations
flutter pub run build_runner build --delete-conflicting-outputs
flutter pub run custom_lint
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
└── utils/
```
