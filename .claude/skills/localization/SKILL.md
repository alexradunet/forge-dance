---
name: localization
description: Add or change user-facing text in Forge Dance using easy_localization — translation keys in the English and Vietnamese JSON files, LocaleKeys code generation, and .tr() usage. Use when adding UI strings, building screens with text, translating hardcoded strings, or fixing missing-translation issues.
---

# Localization (easy_localization)

Supported locales: `en` (fallback) and `vi`, configured in `main.dart` (`useOnlyLangCode: true`). Users switch language via the profile Languages screen.

## Adding a string — the full loop

1. Add the key to **BOTH** files (they must stay in sync):
   - `assets/translations/en.json`
   - `assets/translations/vi.json`

   Keys are flat camelCase (`validatorInvalidEmailFormat`, `unexpectedErrorOccurred`) — no nesting.

2. Regenerate `LocaleKeys` (output: `lib/generated/locale_keys.g.dart`, gitignored):

   ```bash
   fvm flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir assets/translations
   ```

3. Use it:

   ```dart
   import 'package:easy_localization/easy_localization.dart';
   import '../../../generated/locale_keys.g.dart';

   Text(LocaleKeys.welcome.tr())
   ```

   Placeholders: `"greeting": "Hello {}"` → `LocaleKeys.greeting.tr(args: ['Alex'])`; named: `{name}` + `tr(namedArgs: {'name': ...})`; plurals via `.plural(count)`.

## Vietnamese translations

Provide a real Vietnamese translation — never silently copy the English string into `vi.json`. If unsure about phrasing, add your best translation and flag it in the handoff message for review. A key present in `en.json` but missing in `vi.json` falls back to English at runtime (silent, easy to miss) — keeping the files in lockstep is the rule.

## Current state & migration policy

- Wired UI flows (authentication, onboarding, profile/settings, home, explore, collection, learn player, workout/training, stats, common widgets, validators) use `LocaleKeys` for user-facing interface text.
- Catalog/content vocabulary intentionally ships in English in code: lesson titles, lesson steps/tips, lesson type labels, workout titles, workout exercises, belt names, and similar authored training content. Do not invent translation keys for catalog content unless the product explicitly decides to localize content, not just UI chrome.
- Old prototype/dead screens may still contain hardcoded strings. Do not polish them in place; update the live screen or replace the prototype using `.claude/skills/add-feature/SKILL.md`.
- New wired UI MUST use `LocaleKeys` from the start.

## Gotchas

- Forgetting step 2 → `Undefined name 'LocaleKeys'` or missing getters at analyze time. CI regenerates before analyzing, so it will pass CI but fail locally (or vice versa if you don't commit the JSON change).
- `LocaleKeys.x` is a dot-path string; `.tr()` does the lookup — calling `.tr()` on plain literals works but bypasses key generation and should not be used.
- `context.locale`, `context.supportedLocales`, and `localizationDelegates` come from easy_localization's BuildContext extension (wired in `MainApp`).
- Adding a *new locale* means: new JSON file, add `Locale(...)` to `supportedLocales` in `main.dart`, add an entry to the `languages` list in `features/profile/ui/languages_screen.dart`, and regenerate.
