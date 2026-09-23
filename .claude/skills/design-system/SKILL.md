---
name: design-system
description: Use and extend the Forge Dance design system — semantic ThemeData roles, Forge theme extensions, Fg components, design tokens, and the atomic design structure. Use whenever building or styling UI, choosing colors/fonts/spacing/motion, or when a visual primitive is missing.
---

# Forge Dance Design System

Hard rules (from `AGENTS.md`):

1. **No ad-hoc styles in feature code** — use `ThemeData`/Forge semantic roles for appearance and design-system tokens for geometry.
2. **Missing primitive → add it to the design system first**, then use it from feature code.
3. **`Fg` prefix is reserved for design-system components** — never name feature widgets `Fg*`.

## Tokens (`lib/design_system/tokens/`)

Import individual token files or the barrel (`design_system/design_system.dart` re-exports `tokens/tokens.dart`).

### Color authority

Use colors in this order:

1. `Theme.of(context).colorScheme` for primary, secondary, error, surface, outline, inverse, and their matching `on*` roles.
2. `Theme.of(context).forgeColors` for Forge-only semantics: immersive surfaces, success, warning, reward, and focus.
3. `AppColors` only as the raw reference palette used to construct themes or represent durable domain identity such as category/reward tones.

Pair backgrounds with their matching foreground role (`primary`/`onPrimary`, `error`/`onError`, `immersiveBackground`/`onImmersive`). Ordinary feature UI must not branch on brightness or choose raw palette values.

`Theme.of(context).forgeEmphasis` owns semantic shadow/glass treatment. High-contrast themes remove blur and shadow-only emphasis. `context.forgeMotion` owns durations and curves and resolves to zero-duration motion when `MediaQuery.disableAnimations` is true.

### AppTypography — bundled deterministic fonts

- **Bebas Neue** (`h1`, `h2`): display headers and hero text.
- **Inter**: body, UI, labels, and tabular-number `mono*` roles.

Styles and `AppTypography.textTheme` are compile-time constants backed by bundled assets. Prefer `Theme.of(context).textTheme` for ordinary Material roles; use the named Forge roles only when the visual role is intentionally Forge-specific.

### AppSpacing — 4px base unit

`xs` 4, `sm` 8, `md` 12, `lg` 16, `xl` 20, `xxl` 24, `xxxl` 32, `huge` 40, `huge2` 48, `huge3` 64, `huge4` 80 — plus `EdgeInsets` presets (`AppSpacing.allLG`, etc.). Never hardcode pixel values.

### Also available

`AppBorderRadius`, `AppSizes`, `AppSpacing`, and `AppAnimation` define geometry and the base motion scale. Components consume semantic emphasis through `ForgeEmphasis`; raw `AppShadows` values are reference inputs, not feature-level styling.

## Component inventory

Atomic hierarchy under `lib/design_system/`:

- **atoms/**: `FgButton` (semantic variants/sizes/shapes, loading/disabled states, optional focus control), `FgIconButton` (required semantic label, selected/loading/disabled states, visual size independent from its 48px target), `FgFilterChip` (native selection/focus/keyboard behavior), `FgBadge`, `FgLevelBadge`, `FgLogo`, `FgInput`, `FgToggle`, `FgRadioButton`, `FgCheckboxItem`, `FgSlider`, `FgStepper`, `FgProgressBar`, `FgSpinner`, `FgAvatar`, `FgCard`, `FgLabel`, `FgIcon`, `FgStatusDot`, `FgDivider`, and visuals (`FgBackground`, `FgGlassContainer`, `FgGradientOverlay`, `FgShimmer`, `FgImage`, `FgRating`, `FgTooltip`, `FgAspectRatio`)
- **molecules/**: `FgDanceHero`, `FgSectionHeading`, `FgRoundPanel`, `FgMovementStage`, `FgProgramCard` (+ responsive `FgProgramCardLayout`), `FgContentCard`, `FgInteractiveCard` (+thumbnail), `FgDetails` (accessible progressive disclosure), `FgEmpty`, `FgCheckboxGroup`, `FgRadioGroup`, lesson timeline nodes/cards, `FgAppNavButton`
- **organisms/**: `AppHeader`, `AppBottomNav`, `ForgeBottomSheet`, `ForgeAlertDialog`, `FgFilterSheet`, `ProgressSection`, `StatsBreakdown`, lesson path timeline (`LessonPathTimeline`, `LessonNode` models: theory/drill/movement/experiment/boss × completed/current/locked)
- **templates/**: `FgImmersiveScaffold` (product flow surface, adaptive editorial header, dark root dialogs), `SwipeableCardScreenTemplate` (lesson header + step progress + action zone)

## Product screen contract

Use `FgImmersiveScaffold(bodyBuilder: (context) => ...)` for learning, assessment, practice, player, history, programme, and related progress/backup screens. Resolve `Theme.of(context)` inside that builder; pass its context into Stateful helper methods instead of reading an outer `State.context`. Keep Riverpod watches in the Consumer's build method and pass the resulting state into the builder.

Use `FgCard(immersive: true)` for the established rounded charcoal cards; `shape: FgCardShape.editorial` provides crisp discovery panels. Prefer `FgProgramCard` for module/route previews: it owns the single card action, wrapping metadata, optional image, and selected/locked presentation. Route confirmations and pickers through `FgImmersiveScaffold.showModal`, including dialogs pushed on the root navigator. The scaffold owns the palette, high-contrast theme, Material ink surface, status bar, and adaptive header; screen code does not recreate them.

Standard surfaces remain available for deliberately non-immersive utilities and component previews. A light device theme is a required regression case, not a reason to switch a product page to a white background.

## Progressive disclosure

Lead with a short title, meaningful status/metrics, and the next action. Keep full secondary copy in `FgDetails` with a descriptive label (for example, “Adaptations & guidance”), collapsed by default. Reference existing translation/catalogue content rather than maintaining a shortened duplicate as the only source.

- Keep current exercise cues, assessment criteria, safety stop signals, errors, unsaved-state warnings, and destructive confirmation consequences visible.
- Full text must remain reachable in the disclosure or the existing detail destination. Truncation without a way to read the full content is not disclosure.
- Use stable content keys for repeated disclosures. Keep forms outside collapsed details, or use `maintainState: true` when collapsing must retain an active form; do not eagerly create hidden media players.
- Avoid nested explanation panels and repeated paragraphs on each card. Test expand/collapse accessibility, preserved content, and the primary action remaining usable.

## UI completion gate

Add new or substantially changed public product screens to `test/feature_surface_contract_test.dart`; test rendered surfaces and text contrast under a light host rather than inspecting source code for widget names. Add meaningful screen disclosure/interaction coverage, keep `test/immersive_scaffold_test.dart` passing, and exercise the changed screen in the live app at normal and large text. Inspect current collapsed and expanded screenshots before calling a UI change complete.

## Adding a new component

1. Pick the correct atomic layer (atom = indivisible primitive, molecule = composition of atoms, organism = full section, template = page scaffold).
2. Name it `Fg<Name>` in `lib/design_system/<layer>/<category>/fg_<name>.dart` (some legacy organisms use `Forge`/`App` prefixes — `Fg` is the standard for new work).
3. Build it from semantic theme roles and geometry tokens. Expose intent (`variant`, `size`, state), not raw colors, text styles, shadows, or animation values.
4. Register it in `lib/design_system/design_system.dart` (and `tokens/tokens.dart` for new token files).
5. Resolve motion through `context.forgeMotion`; make icon-only actions require caller-owned semantic labels.
6. Keep reusable leaves pure and prop-driven; they do not read Riverpod providers.
7. Add the component/state matrix to Widgetbook and defend new observable interaction or accessibility contracts with a focused widget test.
