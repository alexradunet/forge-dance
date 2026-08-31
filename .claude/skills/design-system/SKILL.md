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
- **molecules/**: `FgContentCard`, `FgInteractiveCard` (+thumbnail), `FgEmpty`, `FgCheckboxGroup`, `FgRadioGroup`, lesson timeline nodes/cards, `FgAppNavButton`
- **organisms/**: `AppHeader`, `AppBottomNav`, `ForgeBottomSheet`, `ForgeAlertDialog`, `FgFilterSheet`, `ProgressSection`, `StatsBreakdown`, lesson path timeline (`LessonPathTimeline`, `LessonNode` models: theory/drill/movement/experiment/boss × completed/current/locked)
- **templates/**: `SwipeableCardScreenTemplate` (header + step progress + action zone)

Screen scaffolding pattern: `Scaffold(backgroundColor: Colors.transparent, body: FgBackground(child: CustomScrollView(...)))` with `AppHeader` as the first sliver — see `home_page.dart`.

## Adding a new component

1. Pick the correct atomic layer (atom = indivisible primitive, molecule = composition of atoms, organism = full section, template = page scaffold).
2. Name it `Fg<Name>` in `lib/design_system/<layer>/<category>/fg_<name>.dart` (some legacy organisms use `Forge`/`App` prefixes — `Fg` is the standard for new work).
3. Build it from semantic theme roles and geometry tokens. Expose intent (`variant`, `size`, state), not raw colors, text styles, shadows, or animation values.
4. Register it in `lib/design_system/design_system.dart` (and `tokens/tokens.dart` for new token files).
5. Resolve motion through `context.forgeMotion`; make icon-only actions require caller-owned semantic labels.
6. Keep reusable leaves pure and prop-driven; they do not read Riverpod providers.
7. Add the component/state matrix to Widgetbook and defend new observable interaction or accessibility contracts with a focused widget test.
