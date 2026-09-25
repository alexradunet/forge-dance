# Focused-page migration

Policy: [Focused product pages](product-page-ux.md), required by `AGENTS.md`.

## Migrated production surfaces

| Surface | Default view | Optional content |
| --- | --- | --- |
| Vocabulary reference | Definition, technique cue, visible safety, practice/unlock action, study status | Technique/context, prerequisites, evidence/history, related terms |
| Programme detail | Enrolment/lock status, schedule, progress, next lesson; one useful unlock action when blocked | Full schedule/repeat practice, background/prerequisites/leave, final assessment (expanded when all lessons are studied) |
| Daily practice | Today's session, Start, safety, selected-options summary | Round previews, shared adaptations shown once, related lesson, history/fitness |
| Practice log | Chronological title/date/metrics; scheduled day retained where present | Reflection/evidence/delete alongside the existing full session details and comparisons |
| Method overview | Earned belt, self-assessed status, next-belt progress, assessment-category choices | One belt-reference disclosure with flat sections instead of eight default disclosures |
| Module path | Module progress, current lesson, Start/Continue, lock/completion status | Full lesson list and repeat actions; review list opens by default for completed modules |

Lesson focus and breath remain **visible without expansion**: these fields include active instructions and safety signals. Only secondary energy/movement-quality detail stays collapsed. Active player controls, criteria, form fields, errors, unsaved-result recovery and destructive confirmations were preserved.

The live audit also exposed provider mutation in module/lesson route builders. Those builders now pass route identity to the screens without calling `selectModule` during build. A real-router regression test covers a non-first module and its lesson.

## Reviewed and deliberately unchanged

Home, Explore, programme index, Vocabulary index, lesson history/library, Profile, level progression, Stats, Settings, appearance/account forms, onboarding/splash, backup/restore, assessment forms and reflection editors already use concise task content or appropriate disclosure. Distinct catalogue choices and required form inputs are not optional prose.

Circuit previews and active/completed workouts retain exercise information, safety, timing, navigation and save/retry controls. Consolidated-workout navigation and its per-round summary could receive a separate interaction-design pass; they were not folded automatically as part of this reference/landing-page migration. Debug-only roadmap, skill and motion prototypes were excluded from production migration.

## Verification

- `bash tool/checks.sh`: analyzer and 482 tests passed. Surface contracts include light-host rendering, narrow/large text, disclosure recovery, action reachability, locks, completed programmes, the 18-session schedule, root confirmations, evidence navigation and retry identity.
- `bash tool/check_integration.sh`: passed.
- `bash tool/check_web_quality.sh`: passed; performance 50, accessibility 100, best practices 81, SEO 100, no console errors or failed requests, 8.13 MiB transferred.
- Current Android screenshots checked for programme and practice collapsed/expanded states, belt-reference collapsed/expanded states, large text, locked-module navigation, and visible lesson guidance.
- Unlocked module and populated logbook screenshots checked in an isolated browser context with preview-only local data, including expanded states and enlarged root text. Android progress was not seeded for these screenshots. Normal and 2x text also have real-screen widget coverage.
- Local visual artifacts are under `build/live/*focused*`; screenshots and generated code remain uncommitted. The isolated browser fixtures are not product data or a new application dependency.
