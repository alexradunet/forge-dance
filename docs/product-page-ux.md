# Focused product pages

## Default experience

A page should answer **where am I, what is my current state, and what can I do next?** before asking the dancer to read supporting material. Apply this to new screens and to existing screens when changing their content or composition.

- Lead with a short title, the minimum useful context/status, and one dominant next action. Keep that action ahead of optional reading and reachable on a normal phone without scrolling through explanations.
- Match the action to the current state. For locked content, offer the unlocking path instead of a stack of disabled actions. Keep a concise reason for a lock available beside the action or in clearly labelled prerequisites.
- Put secondary explanations, methodology, prerequisites, history/evidence, related content, and alternate practice options in descriptive, collapsed `FgDetails` sections or existing detail destinations. Preserve the full content and its actions; do not replace it with an inaccessible truncation.
- Co-locate optional actions with the explanation they act on. Avoid a row of equally prominent destinations or repeated primary buttons under every explanation.
- Keep navigation lightweight on detail screens. A compact, persistent back/header is useful when expanding a long reference; constrain it to the same reading width as the content.

The Vocabulary movement reference is the reference implementation: definition and cue, visible safety, one practice/path action, then optional technique, prerequisites, progress, and related vocabulary.

## What stays visible

Progressive disclosure must not hide something needed to make or carry out the current decision:

- Active exercise instructions, timing, playback and pause/stop controls.
- Assessment criteria, current answers, required inputs, and validation errors.
- Essential safety and stop signals.
- Loading/failure recovery, unsaved work, and destructive-action consequences.
- The current plan or selection and the controls needed to change it.

A catalogue, form, active lesson, or workout may legitimately need several choices or instructions. Organize those around the task rather than folding every section just to achieve a short screen. Avoid nested disclosures; use stable content keys and retain form state where disclosure is genuinely necessary. Do not eagerly instantiate hidden media.

## Migration and acceptance

Audit the **default rendered state**, not file length or the mere presence of `FgDetails`. A migration is warranted when optional prose or competing actions push the actual task down the screen. Prefer a local rearrangement using existing design-system components and existing copy; keep business rules, persistence, and access checks unchanged.

For each migrated page:

1. Identify its primary task, essential visible content, and optional sections.
2. Check the collapsed state has a clear next action and that full secondary content/actions remain reachable after expansion.
3. Extend real-screen surface contracts under a light host, including expansion/collapse, action reachability, and large text; cover locks, errors, forms, and root dialogs where affected.
4. Inspect current collapsed and expanded screenshots in the running app, at normal and large text. Small screens and large text may scroll; content must reflow without clipping or inaccessible controls.
5. Run the repository's required gates. Report any unverified surfaces or deferred migrations explicitly.

Implementation details and component contracts remain in `.claude/skills/design-system/SKILL.md`; this document owns page-level information hierarchy.
