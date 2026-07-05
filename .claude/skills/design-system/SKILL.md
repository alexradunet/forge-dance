---
name: design-system
description: Use and extend the Forge Dance design system — Fg components, design tokens (AppColors, AppTypography, AppSpacing, AppShadows, AppBorderRadius, AppSizes, AppAnimation), and the atomic design structure. Use whenever building or styling UI, choosing colors/fonts/spacing, or when a visual primitive you need doesn't exist yet.
---

# Forge Dance Design System

Hard rules (from `AGENTS.md`):

1. **No ad-hoc styles in feature code** — every color, text style, spacing value, radius, and shadow comes from `lib/design_system/tokens/`.
2. **Missing primitive → add it to the design system first**, then use it from feature code.
3. **`Fg` prefix is reserved for design-system components** — never name feature widgets `Fg*`.

## Tokens (`lib/design_system/tokens/`)

Import individual token files or the barrel (`design_system/design_system.dart` re-exports `tokens/tokens.dart`).

### AppColors — dark, game-like palette

| Token | Value | Use |
|---|---|---|
| `forgeFire` | `#FF4500` | Primary brand, CTAs, highlights |
| `electricBlue` | `#00BFFF` | Secondary actions, progress, energy |
| `legendGold` | `#FFD700` | Achievements, rare rewards |
| `mysticPurple` | `#A855F7` | Magic moments, special features |
| `bgDeep` / `surfaceDark` / `surfaceCard` / `surfaceLight` | `#0A0A0A` → `#2C2C2C` | Backgrounds and surfaces |
| `gray50…gray950`, `crystalWhite`, `passionRed` | — | Neutrals, text, error |

For theme-aware colors in feature code, prefer the semantic getters on `BuildContextExtension` (`context.primaryBackgroundColor`, `context.primaryTextColor`, `context.secondaryTextColor`, `context.dividerColor`, …) which switch on `context.isDarkMode`.

### AppTypography — three font families with distinct roles

- **Bebas Neue** (`h1` 48, `h2` 36): display headers, hero text
- **Inter** (`h3`–`h6`, `bodyLarge`, `body`, `bodySmall`, `caption`, `overline`, `label`): all body/UI text
- **JetBrains Mono** (`mono`, `monoLarge`, `monoSmall`): stats, timers, BPM, numbers, technical text

Styles are `static final` (GoogleFonts). ⚠️ `AppTheme` is a legacy `typedef AppTheme = AppTypography;` — existing code uses both names; prefer `AppTypography` in new code. Customize with `.copyWith(...)`, e.g. `AppTypography.h1.copyWith(color: AppColors.forgeFire)`.

### AppSpacing — 4px base unit

`xs` 4, `sm` 8, `md` 12, `lg` 16, `xl` 20, `xxl` 24, `xxxl` 32, `huge` 40, `huge2` 48, `huge3` 64, `huge4` 80 — plus `EdgeInsets` presets (`AppSpacing.allLG`, etc.). Never hardcode pixel values.

### Also available

`AppShadows`, `AppBorderRadius`, `AppSizes`, `AppAnimation` (durations/curves).

## Component inventory

Atomic hierarchy under `lib/design_system/`:

- **atoms/**: `FgButton` (variants/sizes/shapes, `isLoading`, `expand`), `FgIconButton`, `FgFilterChip`, `FgBadge`, `FgLevelBadge`, `FgLogo`, `FgInput`, `FgToggle`, `FgRadioButton`, `FgCheckboxItem`, `FgSlider`, `FgStepper`, `FgProgressBar`, `FgSpinner`, `FgAvatar`, `FgCard`, `FgLabel`, `FgIcon`, `FgStatusDot`, `FgDivider`, and visuals (`FgBackground`, `FgGlassContainer`, `FgGradientOverlay`, `FgShimmer`, `FgImage`, `FgRating`, `FgTooltip`, `FgAspectRatio`)
- **molecules/**: `FgContentCard`, `FgInteractiveCard` (+thumbnail), `FgEmpty`, `FgCheckboxGroup`, `FgRadioGroup`, lesson timeline nodes/cards, `FgAppNavButton`
- **organisms/**: `AppHeader`, `AppBottomNav`, `ForgeBottomSheet`, `ForgeAlertDialog`, `FgFilterSheet`, `ProgressSection`, `StatsBreakdown`, lesson path timeline (`LessonPathTimeline`, `LessonNode` models: theory/drill/movement/experiment/boss × completed/current/locked)
- **templates/**: `SwipeableCardScreenTemplate` (header + step progress + action zone)

Screen scaffolding pattern: `Scaffold(backgroundColor: Colors.transparent, body: FgBackground(child: CustomScrollView(...)))` with `AppHeader` as the first sliver — see `home_page.dart`.

## Adding a new component

1. Pick the correct atomic layer (atom = indivisible primitive, molecule = composition of atoms, organism = full section, template = page scaffold).
2. Name it `Fg<Name>` in `lib/design_system/<layer>/<category>/fg_<name>.dart` (some legacy organisms use `Forge`/`App` prefixes — `Fg` is the standard for new work).
3. Build it exclusively from tokens; expose semantic props (variant/size enums like `FgButtonVariant`), not raw styles.
4. **Register it in the barrel** `lib/design_system/design_system.dart` (and `tokens/tokens.dart` for new token files).
5. Support both themes when the component uses semantic colors (`context.isDarkMode`), or document that it's dark-surface-only like most game screens.
6. Reusable leaf components must not read Riverpod providers — keep them pure and prop-driven.
