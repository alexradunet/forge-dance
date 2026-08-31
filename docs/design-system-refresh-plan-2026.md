# Forge Dance design-system refresh plan (2026)

**Assessment date:** 2026-08-31  
**Scope:** Foundations, reusable UI modules, Widgetbook, responsive composition, accessibility, interaction, visual language, and migration sequencing  
**Companion primary-source research:** [Flutter UI engineering guidance for a 2026 design-system refresh](research/flutter-ui-design-system-refresh-2026.md)

## Decision

Refresh the system in layers, not screen by screen:

1. Move Forge Dance to the current supported Flutter stable train before relying on 2026 APIs.
2. Make a complete semantic theme the single styling authority.
3. Preserve Flutter's standard control behavior and skin it with Forge semantics instead of rebuilding interaction with `GestureDetector`.
4. Establish accessibility, local responsiveness, reduced motion, and input-modality support as component interface requirements.
5. Migrate every production caller and delete the parallel legacy widget system.
6. Apply the visual refresh only after the behavior and token seams are correct.

The intended result is a branded Material 3 application, not a stock Material app. Material supplies mature behavior, semantics, focus, and platform integration; Forge supplies color, type, shape, hierarchy, motion, and content patterns.

Do not make Material 3 Expressive or Apple Liquid Glass a dependency. Flutter's first-party implementations remain incomplete as of the research cutoff. Their durable principles can inform replaceable tokens; their unshipped widgets and effects cannot define the architecture.

## Current-system inventory

The current catalog is broad:

| Layer | Dart files | Current role |
|---|---:|---|
| Tokens | 8 | Color, typography, spacing, size, radius, shadow, and animation constants |
| Theme | 1 | Light and dark `ThemeData` builders |
| Atoms | 32 | Controls, identity, progress, surfaces, and visual primitives |
| Molecules | 10 | Cards, grouped controls, navigation, empty state, and lesson nodes |
| Organisms | 9 | Navigation, modals, progress, and lesson timelines |
| Templates | 1 | Swipeable-card screen composition |

Widgetbook documents Foundations → Atoms → Molecules → Organisms → Templates → Screens and already provides Android viewports and text scaling. This is a strong base for the refresh.

The application has 18 page/screen files. Only registration and sign-in currently have screen-level Widgetbook stories. No dedicated design-system widget, semantics, accessibility-guideline, or golden test files were found under `test/`.

## What should be retained

- The feature-first production structure and pure, prop-driven intent for design-system widgets.
- The `Fg` namespace for reusable Forge modules.
- The 4 logical-pixel spacing scale as a reference scale.
- The integrated Widgetbook rather than a second package.
- Semantic variants recently introduced in `FgButton`, `FgInput`, and `FgLabel`.
- The custom Forge mark and wordmark.
- Localization ownership in feature code.
- The dark, energetic Forge identity: orange brand accent, strong display type, technical/data typography, and motion used for training feedback.

These are assets. The refresh should deepen them rather than replace them with another parallel system.

## Current gap analysis

### P0: correctness and accessibility

| Finding | Evidence | Impact | Decision |
|---|---|---|---|
| The theme does not define a complete semantic color system. | `AppThemes._build` changes `primary`, `secondary`, `error`, and `surface` on an existing base `ColorScheme` but retains unrelated `on…`, container, outline, inverse, and fixed roles. | Built-in widgets can receive mismatched foreground/background pairs; custom widgets resolve colors inconsistently. | Generate or explicitly construct a complete `ColorScheme` for each brightness and contrast level. |
| Primary and status foreground pairs are not contrast-safe. | Current WCAG relative-luminance calculations are recorded below. | Normal button/status text can fail WCAG 2.2 AA. | Introduce explicit semantic foreground pairs and test every state automatically. |
| Most custom controls reimplement interaction with `GestureDetector`. | `FgToggle`, `FgCheckboxItem`, `FgRadioButton`, `FgSlider`, `FgStepper`, `FgRating`, navigation items, cards, and modal actions. | Missing or incomplete keyboard activation, focus, hover, semantics, target sizing, and standard platform behavior. | Rebuild their implementation on standard Flutter controls or `FocusableActionDetector` where no standard control fits. |
| Small controls expose undersized hit regions. | `FgIconButtonSize.sm` is 32×32; small buttons are 36 high; checkbox/radio visuals are 20×20 with no guaranteed outer hit region. | Fails the cross-platform 48×48 logical-pixel target policy. | Separate visual size from hit/semantic size and enforce at least 48×48 for mobile-capable controls. |
| `FgSlider` uses window width for local track geometry. | Active width and thumb position derive from `MediaQuery.of(context).size.width - 48`. | Incorrect inside cards, panes, dialogs, split screen, and web containers; custom drag/keyboard semantics are absent. | Replace with themed `Slider`/`SliderTheme` or local `LayoutBuilder` geometry only if a custom renderer is required. |
| Grouped-input dependency direction is inverted. | `fg_checkbox_group.dart` and `fg_radio_group.dart` import `features/common/ui/widgets/material_ink_well.dart`. | The design system cannot stand independently and depends on a legacy feature helper. | Remove the dependency; design-system modules may depend only on Flutter and lower design-system layers. |
| `FgCheckboxGroup` copies caller state once. | `_items = List.from(widget.items)` in `initState` with no synchronization when inputs change. | External state updates can render stale selection. | Make the group controlled; caller state is the single source of truth. |
| Interactive progress/rating/status primitives lack semantic value contracts. | Custom rendering does not expose progress value, adjustable actions, selected state, or a concise status label. | Screen-reader users cannot understand or operate the state reliably. | Add semantic label/value/actions and test the semantics tree. |
| Destructive-dialog state is ineffective. | `ForgeAlertDialog.isPrimaryDestructive` resolves both branches to `AppColors.forgeFire`. | A semantic interface promises a state that the implementation does not express. | Map destructive action to danger container/foreground roles and use `FgButton`. |
| Design-system copy is hardcoded. | `AppBottomNav` owns English destination labels; `FgFilterSheet` owns `FILTERS`, `RESET`, and `APPLY FILTERS`; `FgInteractiveCard` owns an empty-details string. | Localization cannot be complete; reusable modules own product content. | Require caller-provided localized labels and semantic descriptions. |

### Current contrast evidence

Ratios were calculated from the values in `AppColors` using the WCAG relative-luminance formula. Normal text needs 4.5:1; large text and meaningful non-text graphics need 3:1 where the applicable criterion allows it.

| Pair | Ratio | Result for normal text |
|---|---:|---|
| `crystalWhite` on `forgeFire` | 3.21:1 | Fail |
| white on `forgeFire` | 3.44:1 | Fail |
| `gray950` on `forgeFire` | 5.75:1 | Pass |
| `textDark` on `bgDeep` | 4.10:1 | Fail |
| `textDark` on `surfaceDark` | 3.88:1 | Fail |
| `textMuted` on `bgDeep` | 7.72:1 | Pass |
| white on `growthGreen` | 2.54:1 | Fail |
| white on `warningAmber` | 2.15:1 | Fail |
| white on `electricBlue` | 2.12:1 | Fail |
| white on `mysticPurple` | 3.96:1 | Fail |
| white on `passionRed` | 4.99:1 | Pass |

Recommended default: use a near-black foreground on `forgeFire`, `growthGreen`, `warningAmber`, and `electricBlue`; preserve white on the current danger red. Generate and verify the complete light, dark, high-contrast, disabled, hovered, focused, pressed, and selected matrices before locking final colors.

### P1: architecture and theming

| Finding | Evidence | Impact | Decision |
|---|---|---|---|
| Reference and semantic colors are mixed. | `AppColors` contains raw palette values, role-like values, aliases, dance-style data colors, and legacy names. Feature and component code import all of them directly. | A theme change requires edits across callers; light/dark/high-contrast behavior is inconsistent. | Split reference palette from semantic runtime roles. Feature code consumes semantic roles only. |
| Theme-aware and dark-only modules coexist without an explicit contract. | `FgButton`, `FgInput`, `FgLabel`, and `FgLogo` use `ColorScheme`; many other modules hardcode `surfaceDark`, white, and gray values. Authentication screens force `AppThemes.dark` inside the page. | Light mode is nominally available but not system-wide. | Every reusable module supports all themes or has an explicit immersive-surface interface with paired colors. |
| Typography is not mapped to Flutter roles. | `AppTypography` exposes `h1`…`h6`, `body`, `caption`, `overline`, and a legacy `AppTheme` typedef. Components repeatedly override raw sizes as low as 8–10 pixels. | Callers must know implementation details; scaling and hierarchy drift. | Map durable roles to `TextTheme`; keep only a small Forge display/data extension. Remove the alias and raw feature overrides. |
| Font source and runtime use disagree. | Assets contain Nunito files; runtime styles request Bebas Neue, Inter, and JetBrains Mono through `google_fonts`. | Offline and deterministic web rendering are not guaranteed; payload contains unused fonts. | Choose and bundle the exact production families; disable runtime fetching; delete unused font assets. |
| Token names preserve mockup/Tailwind history. | Comments and values refer to HTML mockups, `rounded-3xl`, `text-lg`, and requested 8/9-pixel text. | Implementation follows screenshots rather than a durable interface. | Rename around product semantics; mockups become test fixtures, not the token source of truth. |
| Safe-area values are constants. | `AppSizes.safeAreaTop = 44` and `safeAreaBottom = 34`. | Hardware/system geometry varies and changes with edge-to-edge, multitasking, foldables, and browser UI. | Delete static safe-area tokens; resolve actual `MediaQuery`/`SafeArea` insets. |
| Component interfaces expose many raw style escape hatches. | Colors, widths, heights, radii, shadows, and font sizes appear across public constructors. | Modules are shallow: callers still make design decisions. | Keep content geometry where necessary; replace appearance overrides with semantic size/tone/variant roles. |
| Naming and layer ownership drift. | `FgNavButton` lives in `fg_app_nav_button.dart`; public `ToggleListItem`, `CheckboxListItem`, and `RadioListItem` live in atom files; `Forge…`, `App…`, and unprefixed public names coexist. | Catalog navigation and discovery are unreliable. | Clean cutover to consistent `Fg` names and move list-item compositions to molecules. |
| Domain modules sit inside the global design system. | Lesson node models and navigation callbacks such as `onNavigate('ignite')` are product-domain concepts. | Global UI modules know feature vocabulary and routes. | Move feature-specific models/compositions to `features/learn`; retain only genuinely reusable visual primitives. |
| A second shared widget system still exists. | `features/common/ui/widgets` contains primary/secondary buttons, logo, text field, dialog, shimmer, header, ink well, and surface helpers. Several production screens still call them. | Two conventions produce inconsistent behavior and multiply fixes. | Migrate all callers to `Fg` modules, then delete obsolete helpers and imports. |

### P1: responsive and adaptive behavior

- Responsive logic is sparse. `FgSlider` and `FgInteractiveCard` use global window width for local layout.
- `AppBottomNav` is fixed to five hardcoded destinations and has no rail/drawer variant.
- `AppHeader` centers title content in a `Stack`; long titles or large side slots can overlap. Its preferred height does not describe its safe-area-inclusive rendered height.
- Most spacing uses physical `left`/`right` rather than directional insets, so an RTL pass would expose layout assumptions.
- Fixed card/modal widths and heights are common. Several modules place text in rigid geometry.
- Widgetbook viewports cover three Android devices only. It does not cover iPhone/iPad, split-screen, foldable, Chromebook/desktop web, breakpoint boundaries, browser zoom, reduced motion, or high contrast.
- `_ForgePreviewApp` hardcodes `ThemeMode.dark`. This can mask whether the theme addon actually reaches stories and must be corrected or explicitly verified.

### P1: motion and rendering

- Motion tokens are duration/curve constants, not a resolved motion policy. No component checks Android/web disabled animations or iOS Reduce Motion/autoplay preferences.
- `FgStatusDot` starts and repeats its controller even when `isLive` is false and does not react to later `isLive` changes.
- Every `FgShimmer` instance owns an indefinitely repeating controller.
- `FgInteractiveCard` rebuilds its full front/back subtree during every flip frame rather than passing static content through the animation builder.
- Blur, transparency, glow, shadows, and clipping appear throughout controls, cards, backgrounds, and navigation. They are not assigned a performance budget or reduced-transparency fallback.
- Direct `Image.network` usage bypasses the existing cached `FgImage` module in some components.

Decision: glow and blur remain brand tools, but only for high-emphasis chrome or state. They are not default surface decoration.

### P2: catalog and verification

Widgetbook is useful documentation, but its current state matrices are uneven:

- Many stories have a single generic `States` case rather than complete state coverage.
- Theme, locale, directionality, high contrast, reduced motion, and platform-input combinations are not a shared fixture matrix.
- Only two of 18 application screens are present.
- Network images make stories nondeterministic and unsuitable as visual contracts.
- There are no enforceable semantics, accessibility-guideline, or golden contracts for the design system.

Decision: keep Widgetbook as the sole human-facing catalog. Do not add Flutter Widget Previewer as a second catalog during the refresh. Reassess it after the SDK migration only if source-adjacent previews remove more work than they add.

## Target module architecture

### Theme seam

`AppThemes` becomes a deep module: callers choose a supported theme; the implementation owns full color, typography, component styling, focus, selection, motion defaults, and platform-appropriate transitions.

Proposed interface shape:

```dart
abstract final class AppThemes {
  static ThemeData light({bool highContrast = false});
  static ThemeData dark({bool highContrast = false});
}
```

Exact caching can remain internal. If runtime-generated platform color is adopted later, it becomes another theme input rather than a second styling system.

### Token tiers

1. **Reference palette, internal to theme construction**
   - Raw sRGB colors and optional tested Display P3 enhancements.
   - No feature imports.
2. **Flutter semantic roles**
   - Complete `ColorScheme`.
   - Material `TextTheme`.
   - Component themes: buttons, icon buttons, inputs, chips, switches, checkbox/radio, slider, progress, cards, dialogs, sheets, navigation, tooltip, focus, selection, snackbar.
3. **Small Forge theme extensions**
   - Only roles Material cannot express: immersive surface, reward tiers, dance-style data tones, glow/emphasis, Forge display/data typography, motion policy, and possibly product shape roles.
4. **Layout constants**
   - Spacing and content constraints remain typed Dart constants.
   - Safe areas, view padding, display corners, text scale, and platform settings remain runtime inputs.

Do not add runtime token JSON. DTCG is useful only if design tooling later requires an interchange format; generated Dart remains the runtime authority.

### Component interface rules

Every reusable UI module must satisfy these invariants:

- Caller supplies semantic content, state, and callbacks; the module owns rendering and behavior.
- Controlled state remains controlled. A module does not copy caller selection into private long-lived state.
- Public appearance inputs use enums or semantic roles, not arbitrary color/shadow/radius values.
- Standard Flutter controls provide behavior wherever possible.
- The module exposes correct semantics, focus, keyboard activation, mouse/stylus behavior, and a visible focus state.
- The interactive hit region is at least 48×48 logical pixels on mobile-capable surfaces.
- Local layout uses incoming constraints. Window metrics are reserved for page-level decisions.
- Text can reflow and scale; control height is content-driven where text is present.
- Copy and localization stay with callers.
- Components use directional geometry unless physical direction is intrinsic.
- Every animation has normal and reduced/no-motion outcomes.
- No design-system module imports a feature module.
- A component is global only if multiple features need the same behavior. Feature-domain compositions stay in the feature.

## Visual direction: Forge kinetic clarity

The refresh should preserve the Forge identity while reducing noise and improving hierarchy.

### Color

- Keep Forge Fire orange as the recognizable action/emphasis color.
- Use a tested near-black `onPrimary` rather than white for normal-size primary CTA text.
- Build true light, dark, and high-contrast schemes from semantic pairs.
- Use one dominant accent per region. Electric blue, gold, purple, green, and red communicate distinct meanings rather than decorating every surface.
- Never encode state by color alone; pair it with icon, label, shape, or position.
- Keep dynamic color optional and bounded. Wallpaper colors may influence general surfaces but must not replace brand, danger, success, reward, or dance-style meaning.

### Surface and material

- Replace ubiquitous black-plus-glow cards with a tonal elevation ladder: background, base surface, raised surface, and high-emphasis overlay.
- Reserve glow for current lesson, live training state, earned reward, focused hero action, or active playback.
- Reserve blur/glass for measured navigation or modal chrome. Provide opaque fallbacks for reduced transparency, unsupported renderers, and high contrast.
- Use edge-to-edge backgrounds while protecting interactive content with actual insets.
- Treat Apple Liquid Glass as future iOS-specific navigation/control chrome. Do not imitate it across content cards, Android, or web.

### Shape

- Define a small shape family instead of arbitrary radii: compact control, standard control/card, large surface, pill, and circle.
- Evaluate Flutter's stable `ShapedInputBorder` with `RoundedSuperellipseBorder` for selected input/surface roles after the SDK upgrade.
- Use expressive shape contrast sparingly. Brand recognition should come from a coherent shape family, not a different silhouette for every component.

### Typography

Recommended default:

- Bebas Neue for display moments only.
- Inter for body, controls, labels, and navigation.
- Use tabular numeral features in Inter for timers/stats where they are sufficient; retain JetBrains Mono only if side-by-side testing proves a distinct product need.
- Bundle the exact selected files and Vietnamese coverage. Remove unused Nunito assets and disable runtime font fetching.
- Map all common roles to `TextTheme`. Do not expose `h1`…`h6` as the primary interface.
- Eliminate 8/9-pixel product copy. Small metadata must remain scalable and contrast-safe.

### Motion

- `fastFeedback`: press, hover, focus, toggle.
- `standardTransition`: expansion, card state, modal content.
- `emphasizedTransition`: rare progress/reward/training moments.
- Direct manipulation follows the pointer immediately; decorative travel never blocks completion.
- Reduced motion removes parallax, flip travel, shimmer travel, pulse, bounce, and nonessential autoplay while preserving immediate state feedback.
- Motion curves and duration are replaceable tokens. Do not depend on unshipped Material 3 Expressive physics.

### Platform adaptation

- Android/web use stable Material 3 behavior and Forge theming.
- iOS preserves Flutter's automatic scrolling, text editing, selection, gestures, and transitions. Use Cupertino-specific sheets/controls only where behavior genuinely differs.
- Branded content stays common. Platform chrome may adapt.
- Touch, keyboard, mouse, trackpad, screen-reader actions, and stylus all reach the same intent.

## Component disposition

| Area | Action | Key acceptance |
|---|---|---|
| `AppThemes`, colors, typography, shapes, motion | Rebuild foundation first | Complete semantic roles; light/dark/high contrast; deterministic fonts; no raw feature palette use |
| `FgButton` | Retain interface, implement with themed standard button behavior | All variants/states; 48 target; focus/hover; loading semantics; accessible foregrounds |
| `FgIconButton` | Rebuild and align with `FgButton` | Required semantic label/tooltip; no raw color override; visual size independent of hit size |
| `FgFilterChip` | Rebuild on `FilterChip`/themed chip behavior | Selected/disabled/focus/hover semantics and contrast |
| `FgInput`, `FgLabel` | Retain contract, move appearance into input/label themes | Form semantics, error association, autofill, keyboard, large text, superellipse experiment behind shape token |
| Toggle, checkbox, radio, slider | Replace custom gesture implementations with themed standard controls | Native semantics/keyboard; controlled state; 48 target; local constraints |
| `FgStepper` | Rebuild as an adjustable control with explicit decrement/increment actions | Bounds, disabled actions, semantics value, keyboard, long-label layout |
| Progress, spinner, status dot, shimmer | Rebuild around semantic indicators and resolved motion policy | Value semantics; reduced motion; controllers run only when visible/active |
| Badge and rating | Split display badge from interactive chip; rebuild rating semantics | No tiny hit targets; selected/adjustable semantics; caller content |
| Avatar and image | Unify on an image-source/cache contract | Semantic label/decorative mode; decode sizing; deterministic placeholders/errors |
| Card/surface/glass | Deepen semantic variants and reduce raw overrides | Ink/focus/semantics; tonal hierarchy; measured blur; content-driven size |
| Content/interactive cards | Split generic behavior from product data | Responsive local layout; static animation child; no hardcoded empty copy; move feature-specific adapters |
| Grouped inputs | Make controlled molecules from refreshed controls | No feature dependency; external state updates immediately; group semantics |
| Navigation | Introduce destination data plus adaptive scaffold | Caller-localized labels; bar/rail/drawer; selected semantics; edge-to-edge and keyboard support |
| Header | Rebuild on toolbar/app-bar layout primitives | No side-slot overlap; sliver option; long text and large-scale support |
| Dialogs/sheets/snackbars | Consolidate legacy and design-system variants | Focus management, barrier/dismiss semantics, adaptive width/sheet behavior, correct destructive role |
| Lesson timeline | Move domain model/compositions to `features/learn` | Global system retains only reusable track/indicator/surface primitives |
| Legacy common widgets | Migrate and delete | No `PrimaryButton`, `SecondaryButton`, `ForgeLogo`, `CommonTextFormField`, `CommonDialog`, or `MaterialInkWell` callers/files remain |

## Migration roadmap

Each phase is a clean, reviewable cutover. Do not leave aliases or two supported paths.

### Phase 0 — Current stable SDK and baseline evidence

1. Update FVM from Flutter 3.35.5 to the latest patched Flutter 3.47 stable release available at implementation time.
2. Review 3.38, 3.41, 3.44, and 3.47 breaking changes; update Dart and platform constraints deliberately.
3. Upgrade Widgetbook and UI-related dependencies to compatible current versions.
4. Keep core Flutter Material/Cupertino imports during the first migration. Evaluate opt-in `material_ui`/`cupertino_ui` packages separately; do not combine that ecosystem migration with theme reconstruction.
5. Capture baseline screenshots and profile traces for authentication, home, collection, learn path, training session, stats, and navigation on representative phone/tablet/web widths.
6. Record current semantics trees and accessibility-guideline failures for primitives.

**Exit criteria**

- Full project checks pass on the new pinned SDK.
- Android, iOS build configuration, and web build remain supported.
- Baseline fixtures are deterministic: bundled fonts, local images, fixed locale/data.
- Current-stable-only APIs are isolated from product behavior until their tests exist.

### Phase 1 — Semantic foundations

1. Split the raw Forge palette from semantic roles.
2. Generate complete light/dark schemes; add high-contrast mappings.
3. Map typography to `TextTheme`; add minimal display/data extensions.
4. Bundle final fonts and delete unused/runtime-fetched font paths.
5. Add semantic shape, elevation/emphasis, and resolved motion roles.
6. Build component themes for all standard controls used by Forge.
7. Replace `BuildContextExtension` color getters with `ThemeData`/extensions; keep unrelated keyboard/snackbar/URL behavior out of the theme interface.
8. Remove static safe-area values.
9. Add automated contrast tests for every semantic pair and interactive state.

**Exit criteria**

- `AppThemes` is the only runtime styling authority.
- No feature code chooses reference palette colors for ordinary surfaces/text/actions.
- Light, dark, and high-contrast samples pass text and non-text contrast checks.
- English and Vietnamese typography renders offline and deterministically.

### Phase 2 — Action and input primitives

Refresh in dependency order:

1. `FgButton`, `FgIconButton`, `FgFilterChip`.
2. `FgLabel`, `FgInput`.
3. `FgToggle`, `FgCheckboxItem`, `FgRadioButton`, `FgSlider`, `FgStepper`.
4. `FgCheckboxGroup`, `FgRadioGroup`.

For each module:

- define the supported semantic interface and state matrix;
- implement standard control behavior underneath;
- add Widgetbook fixtures for every applicable state;
- add behavior, semantics, focus, target-size, contrast, text-scale, locale, and reduced-motion tests;
- migrate all callers immediately and delete the superseded path.

**Exit criteria**

- No interactive primitive depends only on `GestureDetector`.
- Keyboard and screen-reader activation invoke the same callback as touch.
- Every target is at least 48×48 on mobile-capable layouts.
- Group controls are fully controlled and import no feature code.
- Authentication, onboarding, account information, and filter flows use only refreshed inputs/actions.

### Phase 3 — Adaptive page chrome and navigation

1. Define compact/medium/expanded layout capacity tokens. Derive exact transitions from content tests; use 600 logical pixels only as the initial navigation breakpoint.
2. Introduce an `FgAdaptiveScaffold` template with caller-owned destinations and bar/rail/drawer presentation.
3. Rebuild header/toolbar composition to prevent slot overlap and support slivers.
4. Centralize readable content max width, fluid grid/list constraints, page gutters, and safe inset behavior.
5. Handle Android edge-to-edge, display corners, keyboard insets, iOS safe areas, split screen, and fold features.
6. Convert physical paddings to directional geometry.

**Exit criteria**

- The same destination/state model drives compact and expanded navigation.
- No destination copy is hardcoded in the design system.
- No screen decides layout from a device name or platform label.
- Phone, foldable, tablet, Chromebook/desktop web, browser zoom, and large-text matrices show no overlap or clipped primary action.

### Phase 4 — Feedback, media, surfaces, and motion

1. Rebuild progress, spinner, status, shimmer, rating, avatar, and image modules.
2. Consolidate cards and surface roles; restrict glass/blur to documented high-emphasis variants.
3. Consolidate dialogs, sheets, filter sheet, snackbars, banners, empty/error/loading states.
4. Make all animations consume the resolved accessibility motion policy.
5. Fix static-child animation structure and pause inactive/offscreen controllers.
6. Profile blur, shadows, animated cards, image decode/cache, and long collections in profile mode.

**Exit criteria**

- Indicators expose semantic state/value.
- Reduced motion produces stable, immediate alternatives.
- No inactive status/shimmer controller repeats unnecessarily.
- Modal focus, dismissal, destructive action, keyboard, and screen-reader behavior are verified.
- Complex catalog surfaces meet the target frame budget on representative low-end Android hardware.

### Phase 5 — Reclassify domain compositions and remove legacy modules

1. Apply the deletion test to every molecule/organism: global only if behavior is reused across features.
2. Move lesson-path models and feature routing/content to `features/learn`.
3. Split generic card mechanics from training/content adapters.
4. Migrate settings, onboarding, profile, error, loading, offline, and dialog call sites from `features/common/ui/widgets`.
5. Delete obsolete widgets, aliases, imports, comments, and barrel exports in the same change that migrates the final caller.
6. Normalize filenames and public names around the `Fg` convention.

**Exit criteria**

- The design system has no feature imports or route/domain strings.
- One button, field, logo, dialog, shimmer, feedback, and ink/focus convention remains.
- Public modules earn global placement through multiple real callers or are moved to their owning feature.

### Phase 6 — Screen visual refresh

Refresh screens only after their dependency layers are stable:

1. Authentication and onboarding.
2. Main navigation shell, home, explore, and collection.
3. Learn path, module view, and lesson player.
4. Workout/training session.
5. Stats, profile, settings, account, language, appearance, and level progression.

For each surface:

- use the new adaptive scaffold and semantic themes;
- remove raw visual constants;
- preserve feature state and repository interfaces;
- add Widgetbook states for loading, data, empty, error, offline, and key interaction modes;
- verify mobile, tablet/foldable, and web behavior before integration.

**Exit criteria**

- All 18 page/screen surfaces have deterministic catalog coverage or a documented reason they require an integration fixture.
- Light/dark/high-contrast, English/Vietnamese, text scaling, and breakpoint-adjacent widths are verified.
- No production screen needs a local theme hack to make its controls legible; intentional immersive surfaces use an explicit documented theme role.

### Phase 7 — Enforcement and release hardening

1. Add design-system widget tests for observable contracts.
2. Add Flutter accessibility-guideline checks for representative interactive fixtures.
3. Add a small, stable golden matrix for high-value foundations/components/screens.
4. Add lint/architecture checks that prevent feature imports into the design system and new feature-level raw visual constants where practical.
5. Profile representative animated/scrolling surfaces on physical hardware.
6. Run TalkBack, VoiceOver, keyboard-only web, browser accessibility tree, Android Accessibility Scanner, and Xcode Accessibility Inspector passes.
7. Update README/design-system skill documentation only after the final interfaces are real.

**Exit criteria**

- CI enforces semantics, target size, contrast, behavior, and selected visual contracts.
- Manual assistive-technology and device checks are recorded for release-critical flows.
- Full Forge Dance checks pass with no deprecated migration path remaining.

## Verification matrix

Every refreshed reusable module is exercised across applicable dimensions:

| Dimension | Required fixtures |
|---|---|
| Theme | Light, dark, high contrast; color inversion where supported |
| State | Enabled, disabled, hovered, focused, pressed, selected/toggled, loading, error, empty |
| Text | English, Vietnamese, long/pseudo-localized copy, default scaling, 2×, maximum supported scaling |
| Width | 320 web-equivalent reflow, compact phone, both sides of each breakpoint, foldable/tablet, 1024+, 1600 web |
| Insets | Edge-to-edge Android, notched iOS, keyboard open, bottom gesture area, display corner/fold fallback |
| Input | Touch, mouse, trackpad/scroll wheel, keyboard traversal/activation, screen-reader action, stylus where relevant |
| Motion | Normal, reduced/disabled animation, autoplay disabled where relevant |
| Semantics | Role, label, value, selected/toggled/disabled state, actions, reading order, live announcements |
| Performance | Profile-mode frame trace for complex/animated modules; image/cache and blur paths on representative hardware |

## Explicit non-goals

- Do not rewrite feature state management or repositories as part of the UI refresh.
- Do not add a second design-system package.
- Do not parse token JSON at runtime.
- Do not create platform forks of every screen.
- Do not clone Apple Liquid Glass with generic `BackdropFilter` surfaces.
- Do not depend on incomplete Material 3 Expressive Flutter widgets.
- Do not refresh unused speculative modules before applying the deletion test.
- Do not preserve old widgets through aliases or deprecated compatibility wrappers.

## First implementation slice

The first production change should contain only:

1. Flutter current-stable pin and compatibility fixes.
2. Deterministic font decision and assets.
3. Complete semantic color schemes plus Forge theme extensions.
4. Contrast and theme contract tests.
5. Corrected Widgetbook theme propagation and expanded theme/accessibility knobs.

Do not restyle screens in that slice. It establishes the seam every later component consumes and avoids repeating migration work.
