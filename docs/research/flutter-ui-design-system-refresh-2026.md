# Flutter UI engineering guidance for a 2026 design-system refresh

**Research and source access date:** 2026-08-31  
**Product frame:** Forge Dance; mobile-first Android and iOS, with responsive Flutter web  
**Primary-source cutoff:** 2026-08-31  
**Intermediate compatibility delta:** Flutter 3.44.7
**Recommended current-stable target at cutoff:** Flutter 3.47.x  
**Current official major stable at cutoff:** Flutter 3.47 (released 2026-08-12)  
**Repository SDK context:** `.fvmrc` pins Flutter 3.35.5. This is availability context, not an implementation assessment.

## Scope and evidence labels

This note converts current first-party guidance into design-system requirements. Sources are limited to Flutter/Dart documentation and API/source pages, Material Design, Android, Apple, W3C/WCAG, and official browser/platform documentation. Every linked source was accessed **2026-08-31**.

- **Stable** — documented for production use in a stable Flutter/platform release or stable specification.
- **Stable, platform-dependent** — production-capable, but availability/behavior differs by OS, browser, hardware, or renderer.
- **Opt-in stable** — shipped on stable but not yet the default path.
- **Preview / experimental** — explicitly experimental, beta, main-channel-only, or announced for a future stable release.
- **Proposal** — tracked by an open Flutter proposal; do not make it a design-system dependency.

The compatibility delta examined in detail is **3.35.5 → 3.44.7**, followed by the recommended move to the current 3.47.x stable train. For source accuracy at the stated cutoff, Flutter's [release index](https://docs.flutter.dev/release/release-notes) and [2026 archive schedule](https://docs.flutter.dev/install/archive#2026-schedule) show that the 3.47 stable train followed 3.44 in August 2026. Section 10 therefore separates the 3.44.7 intermediate compatibility delta from newer 3.47 capabilities.

## Five highest-impact findings

1. **Make semantic tokens and themes the only styling authority.** Flutter recommends app-wide `ThemeData`, component themes, and local overrides; `ThemeExtension` is the supported seam for custom theme data and interpolation. A platform-neutral token source can align with stable DTCG 2025.10 while generated Flutter themes remain the runtime representation. ([Flutter themes](https://docs.flutter.dev/cookbook/design/themes), [`ThemeExtension`](https://api.flutter.dev/flutter/material/ThemeExtension-class.html), [DTCG 2025.10](https://www.w3.org/community/reports/design-tokens/CG-FINAL-format-20251028/)) **Stable.**
2. **Design against the current window and local constraints, never device labels.** Use `MediaQuery.sizeOf` for the app window and `LayoutBuilder` for local constraints; adapt navigation and bound readable content by available width. This is necessary for split-screen, foldables, tablets, desktop-class Android, and resized web. ([Flutter adaptive approach](https://docs.flutter.dev/ui/adaptive-responsive/general), [large screens](https://docs.flutter.dev/ui/adaptive-responsive/large-screens), [Android adaptive quality](https://developer.android.com/docs/quality-guidelines/adaptive-app-quality)) **Stable.**
3. **Accessibility is a component contract, not a final audit.** Every primitive needs semantics, keyboard focus, scalable text, adequate contrast, and at least 48×48 logical-pixel mobile targets. Web additionally needs WCAG 2.2 AA reflow, target spacing, non-drag alternatives, and unobscured focus. ([Flutter accessibility](https://docs.flutter.dev/ui/accessibility), [WCAG 2.2](https://www.w3.org/TR/WCAG22/), [reflow](https://www.w3.org/WAI/WCAG22/Understanding/reflow.html), [target size](https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum.html)) **Stable.**
4. **Treat motion as semantic, optional, and budgeted.** Centralize motion roles, preserve platform behavior, and define a reduced/no-motion outcome. Android/web's disable-animation signal and iOS Reduce Motion are separate APIs; 3.44 adds more iOS autoplay/cursor preference signals and browser reduced-motion parity. ([Flutter animations](https://docs.flutter.dev/ui/animations), [`disableAnimations`](https://api.flutter.dev/flutter/widgets/MediaQueryData/disableAnimations.html), [Flutter 3.44](https://flutter.dev/blog/whats-new-in-flutter-3-44#accessibility-a-more-inclusive-experience-for-all-users)) **Stable, platform-dependent.**
5. **Plan a controlled SDK/design-package migration rather than copying 2026 visual trends.** The 3.44.7 intermediate compatibility delta delivers useful UI/accessibility primitives; 3.47 later makes first-party `material_ui` and `cupertino_ui` 1.0 opt-in stable and Widget Previews stable. Flutter's Material 3 Expressive and Apple Liquid Glass widget work remain open proposals. ([Flutter 3.44](https://flutter.dev/blog/whats-new-in-flutter-3-44), [Flutter 3.47](https://flutter.dev/blog/whats-new-in-flutter-3-47), [M3 Expressive](https://github.com/flutter/flutter/issues/168813), [Liquid Glass](https://github.com/flutter/flutter/issues/170310)) **Mixed.**

## 1. Architecture and theming

### Separate product state, component behavior, and appearance

**Recommendation — Stable.** Keep widgets lean and driven by immutable view state. Component APIs accept semantic content, state, and callbacks; they do not fetch data or own business rules. Flutter's architecture guide calls for UI/business separation, lean reusable widgets, single sources of truth, unidirectional data flow, and UI as a function of immutable state. ([Flutter architecture concepts](https://docs.flutter.dev/app-architecture/concepts))

Use three layers:

1. **Foundations/tokens:** semantic color, type, spacing, size, radius, elevation, and motion decisions.
2. **Components:** behavior, semantics, interaction states, and composition that consume tokens.
3. **Patterns/screens:** responsive arrangement and product state, with no new raw visual constants.

This lets a visual refresh change appearance without changing behavior, and lets adaptive variants share feature state rather than duplicate it.

### Map semantic tokens into Flutter-native themes

**Recommendation — Stable.** Use `ThemeData.colorScheme` and `textTheme` for standard roles, component themes for component defaults, and small cohesive `ThemeExtension<T>` types only for product roles Flutter does not represent. Implement `copyWith` and `lerp`. Flutter documents style precedence as widget style → nearest parent theme → app theme and defines `ThemeExtension` as the interface for additions to `ThemeData`. ([theme recipe](https://docs.flutter.dev/cookbook/design/themes), [`ThemeExtension`](https://api.flutter.dev/flutter/material/ThemeExtension-class.html))

Use semantic names (`surface`, `onSurface`, `dangerContainer`, `focusRing`, `compactBodyPadding`, `motionEmphasized`) at call sites, not palette/value names (`purple500`, `white`, `spacing12`). Android's Dynamic Color guidance explains that semantic role tokens make light, dark, and user-generated schemes flexible and consistent. ([Android Dynamic Color](https://developer.android.com/develop/ui/views/theming/dynamic-colors))

| Tier | Purpose | Example |
|---|---|---|
| Reference | Raw input to theme generation | `palette.brand.40`, `dimension.12` |
| System semantic | Meaning throughout the product | `color.surface`, `color.onSurface`, `space.componentGap` |
| Component | Documented component-specific mapping | `button.primary.container.pressed` |

Component tokens should alias system roles unless behavior truly differs. Do not build a second theme mechanism alongside Flutter's.

### Use DTCG as interchange, not runtime architecture

**Recommendation — Stable Community Group report, not a W3C Standard.** DTCG Format Module 2025.10 is explicitly considered stable and intended for implementation, while its status also says it is not a W3C Standard or Standards Track document. It defines platform-neutral names, values, groups, types, aliases, and composites. Use it as a design/tooling source only if useful, then generate typed Dart; do not parse token JSON at runtime. ([DTCG 2025.10](https://www.w3.org/community/reports/design-tokens/CG-FINAL-format-20251028/))

### Make state matrices first-class

**Recommendation — Stable.** A component is incomplete until it covers applicable enabled, disabled, hovered, focused, pressed, selected, error, loading, light, dark, and high-contrast states. Prefer built-in Material/Cupertino components because they carry focus, pointer, semantics, text editing, scrolling, and platform behavior; custom widgets must supply those contracts directly. ([Flutter adaptive input](https://docs.flutter.dev/ui/adaptive-responsive/input), [platform adaptations](https://docs.flutter.dev/ui/adaptive-responsive/platform-adaptations))

## 2. Material 3 and adaptive platform UI

### Use Material 3 as the Android/web baseline

**Recommendation — Stable.** Material 3 has been Flutter's default since 3.16. Use current Material 3 components such as `NavigationBar`, not Material 2 equivalents behind `useMaterial3: false`; Flutter warns the opt-out and Material 2 support will eventually be deprecated. ([Material Design for Flutter](https://docs.flutter.dev/ui/design/material))

Use `ColorScheme.fromSeed` where it fits the brand, then review every semantic pair. The API constructs Material 3 tonal palettes, exposes `DynamicSchemeVariant` and `contrastLevel`, and permits explicit overrides. ([`ColorScheme.fromSeed`](https://api.flutter.dev/flutter/material/ColorScheme/ColorScheme.fromSeed.html))

Flutter cites bottom navigation below 600 logical pixels and a rail at 600 or above, but emphasizes that the decision depends on **available window width**, not device type. Treat 600 as a navigation starting point, then verify content around it with large text. ([adaptive approach](https://docs.flutter.dev/ui/adaptive-responsive/general))

### Preserve platform behavior before platform decoration

**Recommendation — Stable.** Flutter distinguishes OS behaviors that would be wrong if not adapted (text editing, selection, scrolling, gestures/transitions) from app design decisions Flutter cannot choose automatically. Keep automatic behavior; branch explicitly only where information architecture or behavior genuinely differs. ([automatic platform adaptations](https://docs.flutter.dev/ui/adaptive-responsive/platform-adaptations))

- Share content/state across Android, iOS, and web variants.
- Preserve default route transitions, scroll physics, text editing, selection menus, back behavior, and haptics unless product requirements demand otherwise.
- Do not branch every component on `TargetPlatform`.
- Test actual Android and iOS surfaces; a Flutter-rendered Material component on iOS is not a UIKit control.

### Adapt navigation and bound content

**Recommendation — Stable.** Abstract destinations, measure available space, and switch presentation instead of cloning screens. Use compact navigation on narrow widths; use a rail/sidebar and optionally list-detail/supporting panes when width and task justify them. Constrain readable content rather than stretching text/cards edge to edge. Flutter recommends window-based grid counts, lazy `GridView.builder`, and max-width constraints. ([Flutter large screens](https://docs.flutter.dev/ui/adaptive-responsive/large-screens), [Android adaptive quality](https://developer.android.com/docs/quality-guidelines/adaptive-app-quality))

### Do not depend on unshipped style systems

**Recommendation — Proposal.** Material 3 Expressive is an official Material direction, but Flutter issue #168813 remains an open P3 umbrella assigned to `material_ui`; the component and style checklist is incomplete. Keep shape, type emphasis, color, and motion replaceable via semantic tokens, but do not require Expressive-only components or physics. ([Flutter issue #168813](https://github.com/flutter/flutter/issues/168813), [Material 3 Expressive](https://m3.material.io/blog/building-with-m3-expressive))

Apple Liquid Glass is discussed in section 10 as **platform-specific navigation/control material guidance**, not a cross-platform glass effect to imitate.

## 3. Accessibility

### Make WCAG 2.2 AA and native settings the baseline

**Recommendation — Stable.** Treat WCAG 2.2 AA as the web baseline and Flutter's stricter mobile guidance as the shared component baseline. WCAG 2.2 is a W3C Recommendation covering desktop, laptop, tablet, and mobile web. Flutter recommends accessibility release criteria, TalkBack/VoiceOver testing, contrast, adequate targets, large scaling, and avoiding automatic context changes. ([WCAG 2.2](https://www.w3.org/TR/WCAG22/), [Flutter accessibility](https://docs.flutter.dev/ui/accessibility))

Every interactive component needs:

- an intelligible semantic label or visible text;
- the correct role, value, selected/toggled/disabled state, and action;
- logical reading/focus order independent of incidental paint order;
- a visible focus indicator not hidden by sticky bars or overlays;
- operation by touch, keyboard/switch-style focus, and screen reader;
- non-color-only indications for error, selection, success, and progress.

Standard Flutter widgets generate an accessibility tree; custom behavior can use `Semantics`. Test TalkBack, VoiceOver, and supported browser screen readers instead of inferring accessibility from visuals. ([assistive technologies](https://docs.flutter.dev/ui/accessibility/assistive-technologies))

### Target size, contrast, and high-contrast modes

**Recommendation — Stable.** Use **at least 48×48 logical pixels** as the cross-platform touch hit region. Flutter's Android guideline uses 48×48; iOS guidance uses 44×44 points. WCAG 2.2 AA's web minimum is 24×24 CSS pixels or qualifying spacing/exceptions, but W3C recommends larger targets where practical. ([Flutter accessible styling](https://docs.flutter.dev/ui/accessibility/ui-design-and-styling), [WCAG target size](https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum.html)) The visible icon may be smaller; its hit/semantic target may not.

Verify all theme/state pairs rather than eyeballing them:

- normal text at least 4.5:1;
- large text at least 3:1;
- meaningful non-text boundaries, icons, and focus indicators meet non-text contrast;
- information never depends on color alone.

Flutter documents the text thresholds and exposes an automated guideline. ([Flutter accessible styling](https://docs.flutter.dev/ui/accessibility/ui-design-and-styling), [WCAG text contrast](https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html), [non-text contrast](https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html))

**3.44 addition — Stable.** The 3.44 release notes include accessibility evaluations for unlabeled leaf nodes, non-text control contrast, and titles, plus VM-service support for accessibility evaluation. Use these as extra automated evidence after upgrading, while retaining manual assistive-technology checks. ([Flutter 3.44 release notes](https://docs.flutter.dev/release/release-notes/release-notes-3.44.0))

**3.47 addition — Stable, beyond the 3.44.7 intermediate delta.** Android high-contrast and color-inversion settings populate `MediaQueryData.highContrast` and `invertColors`. Add explicit high-contrast token mappings rather than merely increasing saturation. ([Flutter 3.47 framework polish](https://flutter.dev/blog/whats-new-in-flutter-3-47#framework-polish))

### Text scaling and reflow

**Recommendation — Stable.** Never globally disable or silently clamp text scaling to preserve a screenshot. Flutter text respects OS settings and layouts must remain usable at the largest sizes. Use flexible constraints, wrapping, content-driven height, scroll where appropriate, and alternate layouts when actions collide. ([Flutter large-font guidance](https://docs.flutter.dev/ui/accessibility/ui-design-and-styling#large-fonts))

Use `TextScaler`, not arithmetic with deprecated `textScaleFactor`. Flutter introduced `TextScaler` for Android nonlinear scaling because already-large text scales differently from smaller text. If geometry depends on text, call `TextScaler.scale(fontSize)` or redesign around measured content. ([nonlinear scaling migration](https://docs.flutter.dev/release/breaking-changes/deprecate-textscalefactor))

On web, non-exempt content must preserve information and functionality without two-dimensional scrolling at a viewport equivalent to 320 CSS pixels wide. Keep horizontal scrolling local to genuinely two-dimensional content such as maps/tables. ([WCAG Reflow](https://www.w3.org/WAI/WCAG22/Understanding/reflow.html))

### Focus, gestures, and errors

**Recommendation — Stable.** A focused component must remain at least partially visible; preferably the full control and indicator remain unobscured. Test bottom navigation, sticky workout controls, snackbars, sheets, dialogs, and browser zoom. ([WCAG Focus Not Obscured](https://www.w3.org/WAI/WCAG22/Understanding/focus-not-obscured-minimum.html))

Every custom drag interaction—reordering, scrubbing, moving an exercise, or carousel swiping—needs a simple pointer alternative such as move up/down, direct selection, step buttons, or previous/next. Keyboard support alone does not satisfy WCAG's dragging criterion for touch users. ([WCAG Dragging Movements](https://www.w3.org/WAI/WCAG22/Understanding/dragging-movements.html))

Validation errors need semantic association/correction and cannot rely on red. **3.44 addition — Stable:** Flutter web responds immediately to validation errors using `aria-description`, alongside browser `prefers-reduced-motion` support. Component semantics still need to be correct. ([Flutter 3.44 web accessibility](https://flutter.dev/blog/whats-new-in-flutter-3-44#accessibility))

## 4. Responsive layout, large screens, and edge-to-edge

### Measure the space the component owns

**Recommendation — Stable.** Use:

- `MediaQuery.sizeOf(context)` for whole-window decisions;
- `LayoutBuilder` for local parent constraints;
- specialized `MediaQuery` accessors instead of `MediaQuery.of` when only one property is needed, avoiding unrelated rebuilds.

Flutter documents this distinction and logical-pixel measurement. ([adaptive approach](https://docs.flutter.dev/ui/adaptive-responsive/general)) Breakpoints describe **layout capacity**, not phone/tablet/desktop. Define them where content or navigation stops working; test on both sides with maximum scaling and localized strings.

Do not orientation-lock. Flutter/Material guidance warns this creates letterboxing and poor large-screen/foldable behavior. ([general guidance](https://docs.flutter.dev/ui/adaptive-responsive/general), [foldables](https://docs.flutter.dev/ui/adaptive-responsive/large-screens#foldables))

### Prefer fluid constraints before branching

**Recommendation — Stable.** Within a mode, use flexible constraints, wrapping, max widths, and grid delegates based on item extent. Branch only when information architecture changes: bar → rail, one pane → list/detail, modal → side sheet. Long grids/lists use lazy builders. ([Flutter large screens](https://docs.flutter.dev/ui/adaptive-responsive/large-screens), [performance practices](https://docs.flutter.dev/perf/best-practices))

Useful design-system layout primitives are: safe-page inset; readable content max width; minimum tile/card width and fluid gap; compact/medium/expanded navigation slots; optional supporting/list-detail pane; fold/hinge avoidance based on display features.

### Draw edge-to-edge but protect content

**Recommendation — Stable.** Android displays apps edge-to-edge when targeting SDK 35 on Android 15+, and Android 16 removes the normal opt-out. Backgrounds/scrolling content can extend behind bars; interactive and meaningful content must react to system bars, cutouts, and gesture insets. ([Android edge-to-edge](https://developer.android.com/develop/ui/views/layout/edge-to-edge), [Flutter migration](https://docs.flutter.dev/release/breaking-changes/default-systemuimode-edge-to-edge))

Use `SafeArea` around content that would lose meaning/interaction if obscured, not as a blanket frame that prevents edge-to-edge backgrounds. Nested `SafeArea`s compose because descendant `MediaQuery` is adjusted. ([SafeArea and MediaQuery](https://docs.flutter.dev/ui/adaptive-responsive/safearea-mediaquery))

**3.44 addition — Stable, Android API 31+ only.** `MediaQueryData.displayCornerRadii` exposes logical display-corner radii on Android API 31+ and is `null` on earlier Android, iOS, and other platforms. Use it only for hardware-aware content avoidance/geometry; always retain safe fallbacks. ([3.44 announcement](https://flutter.dev/blog/whats-new-in-flutter-3-44#android-display-corner-radii-support), [API](https://main-api.flutter.dev/flutter/widgets/MediaQueryData/displayCornerRadii.html))

### Use the 2026 adaptive test matrix

**Recommendation — Stable Android guidance.** Target at least Tier 2 (“Adaptive optimized”): optimized layouts for all sizes/configurations and enhanced external-input support. Android's current test set includes a foldable at 841×701 dp, 8-inch tablet at 1024×640, 10.5-inch tablet at 1280×800, and 13-inch Chromebook at 1600×900. Add compact phones, iPad split-screen sizes, and browser widths around each breakpoint. ([Android adaptive quality](https://developer.android.com/docs/quality-guidelines/adaptive-app-quality))

## 5. Motion

### Define motion by purpose

**Recommendation — Stable.** Centralize semantic roles such as `fastFeedback`, `standardTransition`, `emphasizedTransition`, and direct-manipulation spring parameters instead of scattering durations/curves. Flutter recommends the simplest suitable approach: packaged implicit animation, then built-in explicit animation, then custom explicit animation only when needed. Many Material widgets already provide spec motion. ([Flutter animations](https://docs.flutter.dev/ui/animations), [Material motion](https://m3.material.io/styles/motion/overview/how-it-works))

Keep animation ownership local, pass static children through transition builders, and use `vsync` so offscreen animations do not consume resources. ([Flutter animation concepts](https://docs.flutter.dev/ui/animations#essential-animation-concepts-and-classes))

### Reduced/autoplay motion is part of the contract

**Recommendation — Stable, platform-dependent.** Every animation defines a reduced outcome: remove decorative travel/parallax, shorten or skip nonessential transitions, preserve immediate state and completion feedback.

- `MediaQueryData.disableAnimations` corresponds to Android Remove animations, is used by framework animation APIs, and should guide custom explicit animations.
- On iOS, `AccessibilityFeatures.reduceMotion` is separate and does not set `MediaQueryData.disableAnimations`.
- **3.44:** Flutter web maps browser `prefers-reduced-motion`; iOS additionally exposes `autoPlayAnimatedImages`, `autoPlayVideos`, and `deterministicCursor` preferences through `AccessibilityFeatures`.

Sources: [`disableAnimations`](https://api.flutter.dev/flutter/widgets/MediaQueryData/disableAnimations.html), [`reduceMotion`](https://api.flutter.dev/flutter/dart-ui/AccessibilityFeatures/reduceMotion.html), [3.44 web support](https://flutter.dev/blog/whats-new-in-flutter-3-44#accessibility), [3.44 iOS accessibility support](https://flutter.dev/blog/whats-new-in-flutter-3-44#accessibility-a-more-inclusive-experience-for-all-users).

### Stay within the frame budget

**Recommendation — Stable.** Flutter targets 60 fps and 120 fps on capable devices; 60 fps gives about 16 ms per frame. Profile in profile mode on physical hardware, including the slowest supported device, because debug/emulator performance is unrepresentative. ([Flutter UI performance](https://docs.flutter.dev/perf/ui-performance))

Avoid effects that make every frame expensive. Flutter calls out `saveLayer`, overlapping transparency, opacity widgets, clipping, some shadows, and excessive rebuilds. This directly constrains blur/glass-heavy directions. ([performance best practices](https://docs.flutter.dev/perf/best-practices), [rendering performance](https://docs.flutter.dev/perf/rendering-performance))

## 6. Input modalities

### Every action works beyond touch

**Recommendation — Stable.** Support touch, mouse, trackpad, hardware keyboard, screen-reader actions, switch/voice-style focus, and stylus where beneficial. Responsive web/desktop-class Android add scroll wheel, right-click, hover, traversal, and shortcuts; hover may enhance but never reveal the only action. ([Flutter input guidance](https://docs.flutter.dev/ui/adaptive-responsive/input), [Android adaptive quality](https://developer.android.com/docs/quality-guidelines/adaptive-app-quality))

For custom controls, use `FocusableActionDetector` to combine focus, hover, shortcuts, and actions; `FocusTraversalGroup` for logical order; `Shortcuts`/`Actions` for scoped accelerators. Flutter warns global handlers must be manually disabled for hidden UI/text entry. ([Flutter input guidance](https://docs.flutter.dev/ui/adaptive-responsive/input))

Define pressed, hovered, focused, selected, disabled, and error visuals. Focus cannot depend on hover or color alone. Preserve framework cursor, scroll, selection, and context-menu behavior. ([platform adaptations](https://docs.flutter.dev/ui/adaptive-responsive/platform-adaptations), [WCAG Focus Visible](https://www.w3.org/WAI/WCAG22/Understanding/focus-visible.html))

Never make swipe, long press, drag, pinch, or stylus pressure the sole path for an important task. Provide visible buttons/menus or direct entry. ([WCAG Dragging Movements](https://www.w3.org/WAI/WCAG22/Understanding/dragging-movements.html), [mobility support](https://docs.flutter.dev/ui/accessibility/assistive-technologies#mobility-support))

## 7. Typography and color

### Typography is a semantic scale

**Recommendation — Stable.** Base typography on `TextTheme` roles and add product aliases only for durable purpose. Body readability and scalable layout take priority over screenshot matching. Flutter identifies `textTheme` and `colorScheme` as the app-wide theme foundations; default Material typography adapts the platform family where retained. ([Flutter themes](https://docs.flutter.dev/cookbook/design/themes), [platform typography](https://docs.flutter.dev/ui/adaptive-responsive/platform-adaptations#typography))

Bundle intentional brand fonts for deterministic/offline use and define fallback coverage. Test Vietnamese diacritics, large/bold accessibility text, and mixed numeric/time content. Never wrap text in fixed-height containers. Use `TextScaler` and content-driven sizing. ([large fonts](https://docs.flutter.dev/ui/accessibility/ui-design-and-styling#large-fonts), [nonlinear scaling](https://docs.flutter.dev/release/breaking-changes/deprecate-textscalefactor))

### Use semantic color roles and paired foregrounds

**Recommendation — Stable.** Build complete light/dark `ColorScheme`s and consume paired roles (`primary`/`onPrimary`, `surface`/`onSurface`, containers and their `on…` roles) instead of calculating foregrounds ad hoc. `ColorScheme.fromSeed` provides tonal generation, variants, and contrast adjustment; any override must be retested. ([`ColorScheme.fromSeed`](https://api.flutter.dev/flutter/material/ColorScheme/ColorScheme.fromSeed.html))

Dynamic Color is Android 12+ personalization. It is **platform-dependent**, not permission for wallpaper colors to overwrite safety/status or essential brand meaning. Design the boundary so a platform scheme can replace general roles while protected product colors remain explicit and checked. ([Android Dynamic Color](https://developer.android.com/develop/ui/views/theming/dynamic-colors))

### Use 3.44 shape primitives accurately

**3.44 addition — Stable.** Flutter 3.44 adds `ShapedInputBorder`, which lets Material inputs use any `ShapeBorder`; the official example uses `RoundedSuperellipseBorder`, and `CupertinoFocusHalo` also gains superellipse support. The official API is **not** named `RoundedSuperellipseInputBorder`. Centralize input shape in the input theme instead of constructing bespoke borders per field, and keep focus geometry consistent with the control. ([Flutter 3.44 framework additions](https://flutter.dev/blog/whats-new-in-flutter-3-44#material-and-cupertino-updates), [`ShapedInputBorder`](https://main-api.flutter.dev/flutter/material/ShapedInputBorder-class.html))

Use superellipses only as a replaceable shape token. They are a geometry option, not a reason to mimic all Apple chrome across platforms.

### Wide gamut is enhancement, not baseline

**Recommendation — Stable, platform/renderer/hardware-dependent.** Flutter's `ColorSpace.displayP3` is supported in cases such as Impeller on iOS; unsupported platforms clamp to sRGB. Keep meaning and contrast correct in sRGB, then selectively add P3 for tested imagery/accents on physical supported hardware and preserve asset profiles. ([`ColorSpace`](https://api.flutter.dev/flutter/dart-ui/ColorSpace.html), [wide-gamut migration](https://docs.flutter.dev/release/breaking-changes/wide-gamut-framework))

## 8. Performance engineering

### Put performance constraints in component acceptance criteria

**Recommendation — Stable.** Components should not do expensive work in `build`, rebuild broad subtrees for local changes, or eagerly build long collections. Prefer const widgets, local state updates, static animation children, and lazy list/grid builders. ([Flutter performance best practices](https://docs.flutter.dev/perf/best-practices))

- Avoid `saveLayer` effects unless measured and essential.
- Prefer direct alpha colors over `Opacity` around simple content.
- Avoid clipping when rounded geometry can be painted directly.
- Use `RepaintBoundary` for an actually expensive independently-changing region, not every atom.
- Specify/decode images near display size where appropriate.
- Pause/dispose controllers and autoplay media offscreen; honor 3.44 autoplay preferences on iOS.

Flutter documents build, `saveLayer`, opacity, clipping, and lazy-list costs; animation docs describe `vsync` for offscreen work. ([performance best practices](https://docs.flutter.dev/perf/best-practices), [animations](https://docs.flutter.dev/ui/animations))

### Measure representative surfaces

**Recommendation — Stable.** Profile representative feeds, exercise grids, charts, transitions, large text, and dark mode on low-end physical Android hardware in profile mode. Use DevTools frame traces to separate UI-thread build/layout cost from raster cost. Flutter says debug mode and simulators/emulators are not representative and recommends the slowest reasonable user device. ([UI performance profiling](https://docs.flutter.dev/perf/ui-performance))

For web, measure startup/download and interaction on production-like hosting. WebAssembly is an opt-in build target, not a substitute for smaller assets and less eager work. ([Flutter Wasm](https://docs.flutter.dev/platform-integration/web/wasm))

## 9. Testing and tooling

### Layer UI verification

**Recommendation — Stable.** Flutter recommends many unit/widget tests and enough integration tests for important flows. For the design system:

1. **Widget behavior:** semantics, callbacks, focus traversal/activation, disabled/loading/error transitions, overflow, large text, and responsive boundaries.
2. **Golden tests:** deliberate visual contracts, not every implementation detail. Pin SDK, fonts, locale, pixel ratio, and size because Flutter warns goldens differ across OS, SDK, and font versions.
3. **Integration/manual:** TalkBack, VoiceOver, keyboard-only web, touch, mouse/trackpad, browser zoom, Android edge-to-edge, iOS safe areas, reduced motion, and high contrast.
4. **Performance:** representative complex/animated surfaces on physical hardware in profile mode.

Sources: [testing overview](https://docs.flutter.dev/testing/overview), [`matchesGoldenFile`](https://api.flutter.dev/flutter/flutter_test/matchesGoldenFile.html), [accessibility testing](https://docs.flutter.dev/ui/accessibility/accessibility-testing), [performance profiling](https://docs.flutter.dev/perf/ui-performance).

### Automate invariants, then use real assistive technology

**Recommendation — Stable.** Use Flutter's Accessibility Guideline API on representative fixtures for Android/iOS target size, labels, and text contrast. On 3.44.7, add the new evaluation coverage noted above. Automated checks do not replace Android Accessibility Scanner, Xcode Accessibility Inspector, browser accessibility-tree inspection, TalkBack, or VoiceOver. ([Flutter accessibility testing](https://docs.flutter.dev/ui/accessibility/accessibility-testing), [3.44 release notes](https://docs.flutter.dev/release/release-notes/release-notes-3.44.0))

Fixture matrix:

- light, dark, and applicable high-contrast/inverted settings;
- default and maximum supported text sizes;
- English and Vietnamese plus long/pseudolocalized strings if available;
- compact, breakpoint-adjacent, and expanded widths;
- touch, hover, focus, pressed, selected, disabled, loading, and error states;
- reduced/disabled/autoplay-limited motion;
- semantic labels, values, roles, actions, and order.

### Previews/catalogs are not tests

**3.44.7 intermediate delta — Experimental.** Flutter 3.44 calls Widget Previews experimental, with analysis-server discovery and filtering improvements. Do not make the baseline workflow depend on it. ([Flutter 3.44 Widget Previews](https://flutter.dev/blog/whats-new-in-flutter-3-44#widget-previews-experimental))

**3.47 current target — Stable.** Widget Previewer supports size, text scale, wrapper/state injection, brightness, localization, theme layering, and multiple configurations. After upgrading, use it for fast review; keep behavioral/golden/accessibility tests as enforceable contracts and the component catalog as usage documentation. ([Widget Previewer](https://docs.flutter.dev/tools/widget-previewer), [Flutter 3.47](https://flutter.dev/blog/whats-new-in-flutter-3-47#widget-previews-go-stable))

## 10. Version deltas and 2026-ready capabilities

### Pinned 3.35.5 → intermediate 3.44.7 compatibility delta

The following is the UI-relevant adoption delta established by official 3.44 sources. It is not a full SDK migration checklist.

| 3.44 capability | Status | Design-system implication |
|---|---|---|
| Android display corner radii via `MediaQueryData.displayCornerRadii` | **Stable; Android API 31+, nullable elsewhere** | Let hardware-aware page/chrome primitives avoid aggressively rounded corners; keep safe null fallback. ([announcement](https://flutter.dev/blog/whats-new-in-flutter-3-44#android-display-corner-radii-support), [API](https://main-api.flutter.dev/flutter/widgets/MediaQueryData/displayCornerRadii.html)) |
| iOS autoplay animated images, autoplay video, and non-blinking cursor preferences | **Stable, iOS-specific** | Make animated assets/media/cursor behavior consume accessibility preference state; do not collapse these into one generic “reduced motion” boolean. ([3.44 accessibility](https://flutter.dev/blog/whats-new-in-flutter-3-44#accessibility-a-more-inclusive-experience-for-all-users)) |
| Browser `prefers-reduced-motion` and validation `aria-description` | **Stable, web-specific** | Test reduced animation and form announcements in actual supported browsers/screen readers. ([3.44 web accessibility](https://flutter.dev/blog/whats-new-in-flutter-3-44#accessibility)) |
| Accessibility evaluations: unlabeled leaves, non-text contrast, title, VM-service support | **Stable tooling/framework additions** | Add automated evaluation to the component/screen fixture matrix, but preserve manual AT audit. ([3.44 release notes](https://docs.flutter.dev/release/release-notes/release-notes-3.44.0)) |
| `ShapedInputBorder` with `RoundedSuperellipseBorder`; superellipse `CupertinoFocusHalo` | **Stable** | Represent input/focus shape semantically and theme it centrally. The first-party class is `ShapedInputBorder`, not `RoundedSuperellipseInputBorder`. ([3.44 Material/Cupertino updates](https://flutter.dev/blog/whats-new-in-flutter-3-44#material-and-cupertino-updates)) |
| `CupertinoSheetRoute.scrollableBuilder` coordinates sheet dragging and inner scrolling | **Stable; migration required for old builder APIs** | Use the managed `ScrollController` for scrollable sheet content; 3.44 deprecates `builder`/`pageBuilder` in `showCupertinoSheet`/`CupertinoSheetRoute` in favor of `scrollableBuilder`. ([3.44 Cupertino sheet](https://flutter.dev/blog/whats-new-in-flutter-3-44#material-and-cupertino-updates)) |
| Material/Cupertino code freeze ahead of package decoupling | **Stable release architecture signal, not yet package migration in 3.44** | Avoid deep dependencies on core-library internals; plan separately for 3.47 standalone packages. ([3.44 framework](https://flutter.dev/blog/whats-new-in-flutter-3-44#material-and-cupertino-updates)) |
| Widget Previews | **Experimental in 3.44** | Evaluate only; use existing catalog/tests for required workflow until 3.47+. ([3.44 previews](https://flutter.dev/blog/whats-new-in-flutter-3-44#widget-previews-experimental)) |

### Current 3.47 target at the 2026-08-31 cutoff

| Capability | Status | Action |
|---|---|---|
| Flutter 3.47 train | **Stable current major train** | Review the 3.47 release and breaking changes, then pin the latest available 3.47.x patch. ([release index](https://docs.flutter.dev/release/release-notes), [3.47 announcement](https://flutter.dev/blog/whats-new-in-flutter-3-47)) |
| `material_ui` / `cupertino_ui` 1.0 | **Opt-in stable in 3.47**; core copies still ship, later deprecation announced | Inventory dependencies/localizations; migrate coherently. Flutter says ecosystem packages should treat this as a major release. ([3.47 design packages](https://flutter.dev/blog/whats-new-in-flutter-3-47#choose-your-own-ui-adventure)) |
| Widget Previewer | **Stable in 3.47** | After upgrade, add a small canonical state/size/theme/locale preview matrix; do not replace tests. ([Widget Previewer](https://docs.flutter.dev/tools/widget-previewer)) |
| Android high contrast and inversion | **Stable in 3.47** | Add high-contrast token mappings and actual Android setting tests. ([3.47 framework polish](https://flutter.dev/blog/whats-new-in-flutter-3-47#framework-polish)) |
| Flutter web Wasm | **Opt-in stable; JS fallback remains; iOS browsers cannot run Flutter/Wasm at cutoff** | Keep dependencies on `package:web`/`dart:js_interop`, test Wasm and JS fallback. ([Flutter Wasm](https://docs.flutter.dev/platform-integration/web/wasm)) |
| Wasm deferred loading | **Experimental on main; announced for 3.50 later in 2026** | Do not make release architecture depend on it; keep routes/assets modular for later evaluation. ([Wasm deferred loading](https://docs.flutter.dev/platform-integration/web/wasm#run-or-build-your-app)) |
| DTCG token format 2025.10 | **Stable Community Group report; not W3C Standard** | Use for interchange only when helpful; generate typed Dart and retain themes as runtime authority. ([DTCG](https://www.w3.org/community/reports/design-tokens/CG-FINAL-format-20251028/)) |
| Display P3 | **Stable, platform-dependent** | Keep accessible sRGB fallbacks; selectively enhance on supported Impeller/iOS hardware. ([`ColorSpace`](https://api.flutter.dev/flutter/dart-ui/ColorSpace.html)) |

### Style directions that are not cross-platform foundations

#### Material 3 Expressive

**Proposal in Flutter as of cutoff.** Flutter issue #168813 is still open, P3, and assigned to the standalone `material_ui` direction. Its component list (including button groups, FAB menu, loading indicator, split buttons, and toolbars) and expressive motion/type/shape/color checklist remain incomplete. Material's published guidance may inspire experiments, but it is not evidence that Flutter components implement Expressive. Keep any experiments behind replaceable tokens/components; do not fork the stable Material library or promise first-party parity. ([Flutter issue #168813](https://github.com/flutter/flutter/issues/168813), [Material 3 Expressive](https://m3.material.io/blog/building-with-m3-expressive))

#### Apple Liquid Glass

**Stable Apple platform guidance; Flutter support remains a proposal.** Apple's adoption guide defines Liquid Glass as a distinct **functional layer for controls and navigation**, advises using it sparingly, reducing custom backgrounds in bars/navigation, keeping a clear content/navigation hierarchy, and testing reduced-transparency, contrast, and motion settings. Those principles are relevant to iOS-specific chrome. They are not a mandate to apply translucent blur to content cards or Android/web components. ([Apple: Adopting Liquid Glass](https://developer.apple.com/documentation/technologyoverviews/adopting-liquid-glass), [Apple materials HIG](https://developer.apple.com/design/human-interface-guidelines/materials))

Flutter's issue #170310 remains open, P3, and explicitly moves potential new work to `cupertino_ui`; its use case says existing Cupertino widgets do not provide the new design. Flutter also documents that app-level OEM conventions are not automatically adapted when an app design choice is required. Therefore:

- preserve Liquid Glass as **platform-specific navigation/control chrome guidance**;
- prefer future first-party `cupertino_ui` support over a bespoke imitation;
- do not add “glass” as a universal design token or cross-platform surface primitive;
- do not approximate it with unmeasured blur/`saveLayer` effects;
- keep content hierarchy, safe areas, contrast, reduced transparency, and reduced motion correct whether or not the material exists.

Sources: [Flutter Liquid Glass issue #170310](https://github.com/flutter/flutter/issues/170310), [Flutter adaptation philosophy](https://docs.flutter.dev/ui/adaptive-responsive/platform-adaptations), [Flutter performance guidance](https://docs.flutter.dev/perf/best-practices).

#### Other current platform requirements

- **Android edge-to-edge — Stable/enforced:** include system-inset behavior in every page/bottom-control scaffold; do not restore a legacy opaque safe-area frame. ([Android guidance](https://developer.android.com/develop/ui/views/layout/edge-to-edge), [Flutter migration](https://docs.flutter.dev/release/breaking-changes/default-systemuimode-edge-to-edge))
- **Android adaptive quality — Stable/current:** target Tier 2 and use its foldable/tablet/Chromebook matrix. ([Android adaptive quality](https://developer.android.com/docs/quality-guidelines/adaptive-app-quality))
- **iOS/macOS 27 and Xcode 27 — beta/upcoming in the 3.47 announcement:** test Apple betas; Flutter 3.47 raises supported minimums to iOS 15/macOS 12 and documents the iOS 27 `UIScene` launch requirement, especially for customized native lifecycle/plugin code. ([Flutter 3.47 Apple updates](https://flutter.dev/blog/whats-new-in-flutter-3-47#prepping-for-the-next-wave-of-apple-updates))

## Source register

Every source below was accessed **2026-08-31**.

### Flutter and Dart

- [Stable release index](https://docs.flutter.dev/release/release-notes)
- [Flutter SDK archive and 2026 schedule](https://docs.flutter.dev/install/archive)
- [Flutter 3.44 announcement](https://flutter.dev/blog/whats-new-in-flutter-3-44)
- [Flutter 3.44 release notes](https://docs.flutter.dev/release/release-notes/release-notes-3.44.0)
- [Flutter 3.47 announcement](https://flutter.dev/blog/whats-new-in-flutter-3-47)
- [Common architecture concepts](https://docs.flutter.dev/app-architecture/concepts)
- [Use themes to share colors and font styles](https://docs.flutter.dev/cookbook/design/themes)
- [`ThemeExtension`](https://api.flutter.dev/flutter/material/ThemeExtension-class.html)
- [Material Design for Flutter](https://docs.flutter.dev/ui/design/material)
- [`ColorScheme.fromSeed`](https://api.flutter.dev/flutter/material/ColorScheme/ColorScheme.fromSeed.html)
- [General adaptive approach](https://docs.flutter.dev/ui/adaptive-responsive/general)
- [Large screen devices](https://docs.flutter.dev/ui/adaptive-responsive/large-screens)
- [SafeArea and MediaQuery](https://docs.flutter.dev/ui/adaptive-responsive/safearea-mediaquery)
- [User input and accessibility](https://docs.flutter.dev/ui/adaptive-responsive/input)
- [Automatic platform adaptations](https://docs.flutter.dev/ui/adaptive-responsive/platform-adaptations)
- [Flutter accessibility](https://docs.flutter.dev/ui/accessibility)
- [Accessible UI design and styling](https://docs.flutter.dev/ui/accessibility/ui-design-and-styling)
- [Assistive technologies](https://docs.flutter.dev/ui/accessibility/assistive-technologies)
- [Accessibility testing](https://docs.flutter.dev/ui/accessibility/accessibility-testing)
- [`MediaQueryData.disableAnimations`](https://api.flutter.dev/flutter/widgets/MediaQueryData/disableAnimations.html)
- [`AccessibilityFeatures.reduceMotion`](https://api.flutter.dev/flutter/dart-ui/AccessibilityFeatures/reduceMotion.html)
- [Nonlinear text scaling migration](https://docs.flutter.dev/release/breaking-changes/deprecate-textscalefactor)
- [Animations](https://docs.flutter.dev/ui/animations)
- [Performance best practices](https://docs.flutter.dev/perf/best-practices)
- [Rendering performance](https://docs.flutter.dev/perf/rendering-performance)
- [UI performance profiling](https://docs.flutter.dev/perf/ui-performance)
- [Testing overview](https://docs.flutter.dev/testing/overview)
- [`matchesGoldenFile`](https://api.flutter.dev/flutter/flutter_test/matchesGoldenFile.html)
- [Widget Previewer](https://docs.flutter.dev/tools/widget-previewer)
- [WebAssembly support](https://docs.flutter.dev/platform-integration/web/wasm)
- [Flutter edge-to-edge migration](https://docs.flutter.dev/release/breaking-changes/default-systemuimode-edge-to-edge)
- [`MediaQueryData.displayCornerRadii`](https://main-api.flutter.dev/flutter/widgets/MediaQueryData/displayCornerRadii.html)
- [`ShapedInputBorder`](https://main-api.flutter.dev/flutter/material/ShapedInputBorder-class.html)
- [`ColorSpace`](https://api.flutter.dev/flutter/dart-ui/ColorSpace.html)
- [Wide-gamut `Color` migration](https://docs.flutter.dev/release/breaking-changes/wide-gamut-framework)
- [Material 3 Expressive umbrella issue](https://github.com/flutter/flutter/issues/168813)
- [Liquid Glass/Cupertino umbrella issue](https://github.com/flutter/flutter/issues/170310)

### Material and Android

- [Material 3 color system](https://m3.material.io/styles/color/system/overview)
- [Material 3 motion](https://m3.material.io/styles/motion/overview/how-it-works)
- [Material 3 Expressive](https://m3.material.io/blog/building-with-m3-expressive)
- [Android Dynamic Color](https://developer.android.com/develop/ui/views/theming/dynamic-colors)
- [Android edge-to-edge](https://developer.android.com/develop/ui/views/layout/edge-to-edge)
- [Android adaptive app quality](https://developer.android.com/docs/quality-guidelines/adaptive-app-quality)

### Apple

- [Apple HIG: accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility)
- [Apple HIG: layout](https://developer.apple.com/design/human-interface-guidelines/layout)
- [Apple HIG: materials](https://developer.apple.com/design/human-interface-guidelines/materials)
- [Adopting Liquid Glass](https://developer.apple.com/documentation/technologyoverviews/adopting-liquid-glass)

### W3C/WCAG

- [WCAG 2.2 Recommendation](https://www.w3.org/TR/WCAG22/)
- [Contrast (Minimum)](https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html)
- [Non-text Contrast](https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html)
- [Reflow](https://www.w3.org/WAI/WCAG22/Understanding/reflow.html)
- [Target Size (Minimum)](https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum.html)
- [Dragging Movements](https://www.w3.org/WAI/WCAG22/Understanding/dragging-movements.html)
- [Focus Visible](https://www.w3.org/WAI/WCAG22/Understanding/focus-visible.html)
- [Focus Not Obscured (Minimum)](https://www.w3.org/WAI/WCAG22/Understanding/focus-not-obscured-minimum.html)
- [Design Tokens Format Module 2025.10](https://www.w3.org/community/reports/design-tokens/CG-FINAL-format-20251028/)

## Audit checklist for comparison against the repository

### Architecture and theming

- [ ] One semantic token source maps to `ColorScheme`, `TextTheme`, component themes, and small `ThemeExtension`s; widgets contain no competing raw palette/spacing system.
- [ ] Components are lean, state-driven, and separated from business/data logic.
- [ ] Public components define applicable enabled, disabled, hovered, focused, pressed, selected, loading, and error behavior.
- [ ] Light, dark, and high-contrast mappings are complete, paired, and contrast-tested.

### Material, platform, and responsiveness

- [ ] Material 3 components are the Android/web baseline; no Material 2 opt-out is a design dependency.
- [ ] Platform branching is reserved for behavior/information-architecture differences; native scrolling, navigation, editing, selection, and back behavior are preserved.
- [ ] Layout uses window/local constraints, not device names or orientation.
- [ ] Compact, breakpoint-adjacent, expanded, split-screen, foldable/tablet, and browser-zoom layouts preserve all content/actions.
- [ ] Body content has readable max widths; long collections use lazy builders.
- [ ] Edge-to-edge backgrounds coexist with safe-inset protection for tappable/meaningful content.
- [ ] On 3.44+, Android display-corner radii have a nullable fallback; input superellipse shape uses themed `ShapedInputBorder`; scrollable Cupertino sheets use `scrollableBuilder`.

### Accessibility and input

- [ ] TalkBack, VoiceOver, keyboard-only web, and browser semantics expose correct labels, roles, values, states, actions, order, and focus restoration.
- [ ] Mobile hit regions are at least 48×48 logical pixels; web targets satisfy WCAG 2.2 size/spacing.
- [ ] Text works at maximum platform scaling and web content reflows at 320 CSS pixels without nonessential two-dimensional scrolling.
- [ ] Text, non-text controls, and focus indicators meet contrast; color is never the only signal.
- [ ] Focus remains visible and unobscured by navigation, sheets, snackbars, sticky controls, or overlays.
- [ ] Every drag/swipe/precision gesture has a simple pointer and keyboard-accessible alternative.
- [ ] Custom controls support touch, mouse/trackpad, hover, focus, keyboard, screen-reader actions, and applicable stylus use.
- [ ] 3.44 accessibility evaluations and iOS autoplay/non-blinking preferences are covered after upgrade.

### Motion, color, and performance

- [ ] Motion uses semantic roles and every animation has reduced/no-motion outcomes for Android, iOS, and web preferences.
- [ ] Typography uses semantic roles and `TextScaler`; fixed heights do not clip text/localization.
- [ ] Dynamic color and Display P3 are optional enhancements with accessible sRGB/brand-safe fallbacks.
- [ ] Components avoid unmeasured `saveLayer`, blur/glass, opacity, clipping, eager collection, and broad rebuild costs.
- [ ] Representative complex/animated surfaces meet frame targets in profile mode on physical low-end hardware.
- [ ] Liquid Glass is not a cross-platform surface primitive; any future use is iOS-specific first-party navigation/control chrome.

### Tests, tooling, and migration readiness

- [ ] Widget tests cover behavior, semantics, focus, text scaling, overflow, and responsive boundaries; goldens use a deterministic intentional matrix.
- [ ] Automated guidelines/evaluations are backed by Android Scanner, Xcode Accessibility Inspector, TalkBack, VoiceOver, and browser accessibility-tree review.
- [ ] Previews/catalog stories cover canonical states, sizes, themes, text scales, and locales but are not treated as tests.
- [ ] The upgrade plan uses the 3.35.5 → 3.44.7 UI delta above as an intermediate compatibility review, then targets current-stable 3.47.x and covers standalone UI packages, localization/dependency compatibility, and breaking changes.
- [ ] Material 3 Expressive, Liquid Glass, and Wasm deferred loading remain optional watch-list items until Flutter implementations are stable and verified.
