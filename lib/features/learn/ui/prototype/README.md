# Mobile learning roadmap — throwaway preview

**Question:** which mobile hierarchy best explains the learner's next action,
the common foundation, and optional style/skill branches?

This is a design comparison, not the new production Learn screen. Selection is
pending. Do not promote this file set as-is; rewrite the chosen layout after
feedback, remove the debug entry/switcher, and archive the comparison on a
throwaway branch once a winner is agreed. No branch or commit has been created
because the worktree contains ongoing product changes.

## Run

```sh
bash tool/run_orca_android.sh
```

In the debug app: **Learn → Preview roadmap**. The comparison bar above the real
app tabs cycles through three structurally different layouts. Left/right keyboard
arrows also cycle when not editing text or in a modal.

For a running debug web app, append one of these paths to its origin (using the
app's normal URL strategy):

- `/main/explore?variant=roadmap` — A: full vertical foundation with optional branches
- `/main/explore?variant=stages` — B: select one foundation stage and inspect its lessons/branches
- `/main/explore?variant=next` — C: the next lesson leads; alternatives and the full catalogue are secondary

The routes and preview entry are gated by `kDebugMode`; release/profile builds
continue to render the normal Learn catalogue, even with a variant query.

## What is real, and what is simulated?

- Real bundled lessons, module prerequisites, and current local learning progress.
- Programme-based focus highlights the same lesson IDs; it is **not** a second
  completion store, and selecting it does not enrol the learner.
- Lesson taps show a read-only modal, including locked/available state. They never
  start a player, save progress, or bypass a prerequisite.
- Focus, stage selection and search are in memory. Only the layout is reflected
  in the URL. The expanded Prototype state section exposes current selections.
- Browsing finds all modules/lesson titles, including those outside the foundation.
- Multi-prerequisite branches are positioned after their latest direct catalogue
  parent. All actual gates remain visible. This is a simple tree placement for
  the preview, not a general-purpose prerequisite-graph renderer.
- Labels are intentionally English prototype copy. Production needs localization,
  a chosen visual language for connectors, and a decision about focus persistence.

## Evaluation prompts

1. Can you identify your next lesson without opening anything?
2. Can you tell that Hip Hop is optional, and what unlocks it?
3. Does choosing Find the Beat feel like a useful route rather than duplicate content?
4. Can you find a specific lesson without understanding the roadmap first?
5. Compare the long-scroll cost of A, the stage-switching cost of B, and the
   hidden-overview cost of C at normal and large text.

Current recommendation to evaluate: **A for orientation**, potentially with C's
compact next-action emphasis. This is a hypothesis, not a validated winner.

The app's existing large-text tab wrapping is unchanged. Prototype surface tests
are an integration safety net for light-host contrast, large text, modal previews,
variant switching and read-only interactions, not acceptance of the design.
