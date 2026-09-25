# Skill progression — throwaway product preview

Question: does a 0–99 experience profile, with capability milestones kept separate,
feel more understandable and motivating than one overall belt identity?

This is **not a belt replacement or migration**. It is a debug-only comparison
using fictional data. The prototype imports no repositories, storage APIs or
production progress providers. It does not read or convert the user's levels,
belts, assessments, lesson progress, workout records or programme enrolments.

## Run and compare

```sh
bash tool/run_orca_android.sh
```

Open **Profile → Preview skill progression** in the debug app. Cycle layouts
with the fixed comparison bar above the real tabs, or left/right keys outside
text inputs and dialogs:

- `/main/profile?variant=skills`: A — skill profile leads, dance and optional physical support grouped separately.
- `/main/profile?variant=journal`: B — the session experience leads; skills are secondary.
- `/main/profile?variant=quests`: C — a creative quest leads; contributing skills are foregrounded.

These query variants and their entry button are gated by `kDebugMode`. Release
and profile builds retain the real Profile page. The layout is URL-addressable;
simulation state is in memory and resets when the preview is removed/restarted.

## Four connected surfaces

1. **Profile:** nine independent experience levels. No total score, global rank,
   competitive leaderboard, required daily quota or forced specialisation.
2. **Skill detail:** experience and fictional self-assessed capability examples
   in distinct sections. Adding/removing demo evidence never changes XP.
3. **Session summary:** placeholder XP in three relevant skills; apply once to the
   demo and see Rhythm cross 24 → 25. Reopening cannot duplicate that reward.
4. **Quest:** five fictional steps reference real lesson titles. Each can locate
   its lesson in the existing read-only roadmap preview. Marking a quest step is
   explicitly a simulation, never a lesson completion or prerequisite bypass.

Quest completion grants a separate, once-only demo reward. It does not award a
belt or invent assessment evidence. Real progression remains unchanged.

## Economy intentionally NOT decided

- XP thresholds use `100 × level²` only to render a coherent demo. Neither this
  curve nor the +120/+80/+40 session awards are a calibrated product proposal.
- Level 99 caps the displayed level; experience can remain recorded beyond it.
- The prototype has no real workout instrumentation, repeat-session policy,
  anti-idle detection, migration algorithm or production XP ledger.
- Level 0 means no recorded experience, not no ability. Physical support levels
  describe participation, not strength, mobility, fitness or health measurements.
- No decay for rest; no reward multiplier for intensity, discomfort or range.
- Strength is a proposed category, not a claim that suitable content is complete.

Expand **Prototype controls & state** to load the sample dancer, a level-0
newcomer, or near-99 fixtures, and inspect current XP, rewards and milestones.
Switching fixture resets only the local demo. English copy is prototype-only.

## What to evaluate next

- Does the profile feel like a personal development direction, not a ranking?
- Is it immediately clear why XP and capability milestones differ?
- Are rewards enjoyable without pressuring longer/harder sessions?
- Does the quest make the roadmap useful without creating duplicate content?
- Which hierarchy should lead: skills, recent practice, or a meaningful goal?

Selection is pending. Before production: validate category boundaries, reward
rules, accessibility, evidence language and a reversible migration that preserves
existing awards. Rewrite the chosen UI; remove losing variants and debug controls,
and archive the comparison on a throwaway branch once a decision is agreed.
No automated commit or migration is part of this preview.
