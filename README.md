# Forge Dance

Forge Dance is a Flutter app built with Riverpod and a feature-first architecture.

## Backend stance

No backend has been selected yet. Do not add any preselected backend-as-a-service code, packages, docs, or generated config. Current auth/profile behavior is local-only until the project chooses offline-first storage, PocketBase, or another owned-server strategy.

## Commands

```bash
flutter pub get
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
