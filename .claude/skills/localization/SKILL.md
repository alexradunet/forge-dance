---
name: localization
description: Add or change user-facing text in Forge Dance using easy_localization — translation keys in the English JSON catalogue, LocaleKeys code generation, and .tr() usage. Use when adding UI strings, building screens, translating hardcoded strings, or fixing missing-translation issues.
---

# Localization (easy_localization)

Supported locale: `en` (fallback), configured through `AppLocales` with `useOnlyLangCode: true`.

## Adding a string — the full loop

1. Add the key to `assets/translations/en.json`.

   Keys are flat camelCase (`validatorInvalidEmailFormat`, `unexpectedErrorOccurred`) — no nesting.

2. Regenerate `LocaleKeys` (output: `lib/generated/locale_keys.g.dart`, gitignored):

   ```bash
   flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir assets/translations
   ```

3. Use it:

   ```dart
   import 'package:easy_localization/easy_localization.dart';
   import '../../../generated/locale_keys.g.dart';

   Text(LocaleKeys.welcome.tr())
   ```

   Placeholders: `"greeting": "Hello {}"` → `LocaleKeys.greeting.tr(args: ['Alex'])`; named: `{name}` + `tr(namedArgs: {'name': ...})`; plurals via `.plural(count)`.

## Current state & migration policy

- Wired features (authentication, profile, common widgets, validators) use `LocaleKeys` properly.
- Prototype screens (home, explore, collection, training, learn, WOD, stats) contain hardcoded English strings — this is accepted **until** a screen is productionized. When wiring a prototype screen to real data, migrate its strings to `LocaleKeys` as part of the work.
- New wired features MUST use `LocaleKeys` from the start.

## Gotchas

- Forgetting step 2 → `Undefined name 'LocaleKeys'` or missing getters at analyze time. CI regenerates before analyzing, so it will pass CI but fail locally (or vice versa if you don't commit the JSON change).
- `LocaleKeys.x` is a dot-path string; `.tr()` does the lookup — calling `.tr()` on plain literals works but bypasses key generation and should not be used.
- `context.locale`, `context.supportedLocales`, and `localizationDelegates` come from easy_localization's BuildContext extension (wired in `MainApp`).
- Adding a *new locale* means: add a matching JSON file, register its `Locale(...)` in `lib/localization/app_locales.dart`, add any language-selection UI, and regenerate.
