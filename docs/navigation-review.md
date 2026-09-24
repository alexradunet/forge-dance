# Navigation review and first refactor

## Scope and evidence

Reviewed `lib/routing/`, the primary shell, Home, Practice and their entry points;
compared their behavior with Flutter/go_router documentation and Material's
published navigation guidance. This is a code and interaction audit, not a user
study or an exhaustive accessibility audit.

Sources:
- [Flutter navigation and routing](https://docs.flutter.dev/ui/navigation): declarative routing for deep links and multiple navigators; imperative routes have different web/history behavior.
- [go_router StatefulShellRoute](https://pub.dev/documentation/go_router/latest/go_router/StatefulShellRoute-class.html): separate navigators and retained branch state; `goBranch` restores a branch.
- [Material bottom navigation (legacy guidance)](https://m1.material.io/components/bottom-navigation.html): three to five primary destinations, short labels, destination switching rather than task actions, separate focused tasks, and side navigation on larger displays.

Material 3 and Apple HIG pages did not yield readable content in this environment.
Do not treat this as a verified comparison with their latest specifications. In
particular, we retain visible labels rather than adopting legacy Material's
inactive-label hiding advice. Retaining branch detail is our deliberate product
choice, supported by go_router, not a claim that every navigation standard
requires it.

## Flow map

| Primary area | Intent | Secondary destinations |
|---|---|---|
| Home | Resume or choose today's next action | Practice, recommended modules/lessons, FORGE progress |
| Vocabulary | Look up a movement or concept | Reference entry, learning path, practice/evidence |
| Learn | Follow structured learning | Module, lesson, programmes, lesson history |
| Practice (previously labelled Workout) | Do today's dance practice | Logbook, related lesson, optional conditioning circuit |
| Profile | Personal progress and preferences | FORGE method/assessments, settings, appearance, local backup |

Focused lessons and timed sessions should cover the primary navigation. Reference
and discovery pages keep it available. Settings/backup remain secondary utilities,
not extra tabs. Existing URLs and the legacy library redirect remain valid.

## Findings and changes

### High priority: switching tabs discarded context — fixed

The single `ShellRoute` used `go()` on every tab tap, replacing the destination
stack. The shell now uses `StatefulShellRoute.indexedStack` with one navigator per
primary destination. Switching away and returning retains details, local widget
state and scroll position. Reselecting the current destination returns to its
root. Only the active branch's observer gates navigation; unfinished work cannot
be bypassed through tab switching or reselection.

### High priority: Back violated the source journey — fixed for conditioning

The conditioning preview always closed to Home, including when launched from
Practice. Close and Android Back now return to the caller when pushed, or Practice
when entered directly. The Home Practice CTA switches primary destinations rather
than pushing a duplicate primary page.

### Medium priority: inconsistent focus mode — fixed for Practice lessons

A related lesson opened imperatively on the shell navigator, leaving tabs visible,
unlike routed lessons. It now opens on the root navigator and returns to Practice.
This intentionally remains an imperative contextual lesson, not a new deep link.

### Medium priority: misleading label and dead root Back button — fixed

The Workout tab actually opens Daily practice, with conditioning only an optional
secondary action. Its localized label is now Practice. Home/Learn/Profile labels
also use the translation catalogue. Practice no longer displays a Back arrow at
its top-level root; `FgImmersiveScaffold.showBack` makes this explicit.

### Lower priority: route identity and lifecycle — hardened

Legacy route classification now respects segment boundaries for method,
programmes and workout paths. The provider disposes its router with its lifecycle.
The shell uses its actual branch index rather than inferring selection from a
cross-branch pushed URL.

## Critical follow-ups, intentionally not bundled

1. **Large-text navigation geometry:** live verification at Android font scale
   1.5 shows Profile wrapping onto a second row. All destinations remain usable,
   but this consumes substantial height and weakens stable spatial placement.
   Design an accessible compact/wide navigation system rather than shrinking text
   or hiding labels. A desktop navigation rail is also still absent.
2. **Information hierarchy:** Home being central is a visual convention, not
   evidence of optimal discoverability. Test Home-first ordering and whether
   Vocabulary deserves a primary slot. Do not reorder familiar destinations
   without a task-based comparison.
3. **Progress and history fragmentation:** FORGE assessments, lesson history,
   practice log and statistics live in different places. Explore a coherent
   Progress hub, while preserving the difference between practice and mastery.
4. **Deep-link completeness:** programme details and several contextual screens
   still use imperative routes; account editing requires an in-memory extra.
   Test cold links, refresh and browser Back for each of these before a broader
   route migration. No claim of complete deep-link coverage is made here.
5. **Guard feedback:** blocked tab taps preserve work but can be silent. A shared
   leave-flow confirmation should be designed around the existing save/abandon
   states, not implemented as unconditional route replacement.
6. **Retained-state cost:** branches are loaded lazily, then retained. Watch memory
   and shared lesson-selection state as more media-heavy pages are added. Active
   players remain focused routes rather than background tab activities.
7. **Transitions:** the existing custom slide transitions still warrant a separate
   reduced-motion and platform-convention review.

## Verification

- New navigation tests: retained detail/form state; active-tab reset; guarded
  switching/reselection; system Back; source-aware circuit Close; focused session
  hides tabs and Back restores them; normal and 2× text under a light host.
- Updated real Home → Practice surface contract uses the production shell builder
  with real primary pages, checks localized selection and absence of root Back.
- Existing feature contracts continue to cover disclosures, immersive surfaces,
  root dialogs and session abandonment.
- `tool/checks.sh`, `tool/check_integration.sh`, and `tool/check_web_quality.sh` run
  for this refactor. See execution results for the final gate status.
- Android live inspection: Home, Vocabulary detail → Home → Vocabulary retention,
  active-tab reset, and expanded Vocabulary filters at 1.5× text. Font scale was
  restored to 1.0 after inspection. Local screenshots live under `build/live/`.

Next evaluation: measure whether a new user can resume a lesson, find a named
movement, start daily practice, inspect their last session, and return to their
original screen without unexpected resets. Compare task completion and wrong
turns before undertaking the larger information-architecture redesign.
