# Widgetbook enhancements for Forge Dance

**Research and source access date:** 2026-09-01  
**Repository baseline:** Widgetbook 3.25.0  
**Scope:** first-party Widgetbook documentation, blog, package/source material, and Forge Dance's Widgetbook, CI, and design-system tests

> **Implementation status (2026-09-01):** This document preserves the
> pre-migration v3 research baseline. Forge Dance now ships English only,
> isolates Widgetbook `4.0.0-beta.13` in [`widgetbook/`](../../widgetbook/),
> generates a typed 55-component catalogue, captures deterministic Home and
> Stats Riverpod states, and runs two bounded global scenarios. The beta.13
> runner loses semantics after the first component or story in one test
> isolate, so the nine-component pilot isolates components and the six screen
> states while leaving non-pilot variants interactive. Pull-request CI builds
> and captures the catalogue; Widgetbook Cloud upload is restricted to PRs
> carrying the `widgetbook-cloud` label and requires `WIDGETBOOK_API_KEY`. V4
> beta.13 has no `InspectorAddon`; its generated component docs and typed Args
> cover property discovery while Grid, Zoom, Semantics, and accessibility
> diagnostics remain available.

## Executive summary

Forge Dance is already on the latest stable Widgetbook release and has a strong local workbench baseline: four themes, seven mobile/tablet/desktop viewports, text scaling through 3.2×, reduced-motion simulation, the officially recommended accessibility wrapper, a manually organized catalogue that the running workbench reports as **55 components and 59 use cases**, and targeted knobs for buttons and inputs. The main gaps are not another stable dependency upgrade or a replacement device addon. They are:

1. **English/Vietnamese cannot be switched from Widgetbook.** The stock `LocalizationAddon` is not a drop-in fix because it only inserts Flutter `Localizations`, while Forge's locale is owned by the outer `EasyLocalization`; use a small verified bridge/custom addon.
2. **CI never builds the Widgetbook entry point.** Add a web-build smoke gate for `widgetbook/main.dart`.
3. **Most stories are static state matrices.** Add focused playground knobs and deterministic provider-backed screen states rather than multiplying ad hoc stories.
4. **The workbench does not expose Widgetbook's semantics visualization, property inspector, or 4 px design grid.** These are low-effort additions; semantics is explicitly experimental.
5. **There is no visual-regression/review workflow.** Widgetbook Cloud can supply it, including multi-configuration and Figma reviews, but it is hosted and snapshot-metered. Forge Dance's manual v3 catalogue needs generator/metadata work before it can provide the full workflow.
6. **Widgetbook v4 is not a production upgrade yet.** Its typed stories, local scenario runner, interaction snapshots, and accessibility metadata are highly relevant, but the vendor still labels v4 beta and warns that minor releases may break APIs. Evaluate after stable, or only in a disposable spike now.

## Evidence labels and boundaries

- **Stable OSS v3** — available in the installed open-source Widgetbook 3.25.0 package.
- **Cloud** — requires Widgetbook Cloud; this is not a capability of the local OSS workbench alone.
- **v4 beta** — published prerelease functionality, not a stable migration target.
- **Deprecated** — retained for compatibility but should not be newly adopted.
- **Repository finding** — observed in Forge Dance source; local links point to the evidence.
- **Recommendation** — an adoption judgment for Forge Dance, not a Widgetbook product claim.

Official package data reports 3.25.0 as the latest stable release, published 2026-06-25, while the same package feed lists 4.0.0-beta.13 as the newest prerelease on the research date ([pub.dev package API](https://pub.dev/api/packages/widgetbook)). The vendor's v4 announcement explicitly says v4 remains beta, minor releases may contain API-breaking changes, and production adoption should wait or use a non-critical evaluation ([v4 beta announcement](https://www.widgetbook.io/blog/widgetbook-v4-beta-is-here)).

## 1. Installed version and current integration

### Version and architecture

- [`pubspec.yaml`](../../pubspec.yaml) declares `widgetbook: ^3.25.0`; [`pubspec.lock`](../../pubspec.lock) resolves exactly **3.25.0**. This is the current stable package, so there is no stable-version upgrade gap ([official package API](https://pub.dev/api/packages/widgetbook), [official changelog](https://raw.githubusercontent.com/widgetbook/widgetbook/main/packages/widgetbook/CHANGELOG.md)).
- The catalogue is hand-authored with `WidgetbookCategory`, `WidgetbookFolder`, `WidgetbookComponent`, and `WidgetbookUseCase`; it does not use `widgetbook_generator`, generated directories, or `@UseCase` metadata. Because helper builders expand repeated registrations at runtime, source-level constructor counts understate it; the running workbench reports **55 components and 59 use cases** across foundations, atoms, molecules, organisms, templates, and screens ([entry point](../../widgetbook/main.dart), [atom catalogue](../../widgetbook/atom_stories.dart), [screen catalogue](../../widgetbook/screen_stories.dart)).
- The workbench is embedded in the main package rather than a separate Flutter package. `ProviderScope` and `EasyLocalization` wrap `ForgeWidgetbook`, and the preview uses a `MaterialApp.router` with a small `GoRouter` route set ([`widgetbook/main.dart`](../../widgetbook/main.dart)).

### Capabilities already used — non-gaps

| Area | Forge Dance today | Assessment |
|---|---|---|
| Themes | `MaterialThemeAddon` exposes Forge Light, Dark, High Contrast Light, and High Contrast Dark. | **Strong non-gap.** Widgetbook's stable theme addon is intended to inject and switch `ThemeData`; Cloud can also snapshot named theme configurations ([theme addon](https://docs.widgetbook.io/addons/theme-addon)). |
| Responsive/device | `ViewportAddon` offers iPhone SE, iPhone 13, two Android phones, a small Android tablet, iPad Air 4, and MacBook Pro. | **Strong baseline.** The addon constrains width/height and overrides device pixel ratio and platform; it is the current stable replacement for device frames ([viewport addon](https://docs.widgetbook.io/addons/viewport-addon)). |
| Text scaling | `TextScaleAddon(min: 1, max: 3.2, divisions: 11)` applies a broad interactive scale range. | **Strong non-gap.** The addon changes `MediaQuery.textScaler`; Forge Dance's 3.2× maximum exceeds the documented default range ([text-scale addon](https://docs.widgetbook.io/addons/text-scale-addon)). |
| Reduced motion | A custom `_ReducedMotionAddon` sets `MediaQuery.disableAnimations`. | **Useful project-specific extension.** It is URL-backed through a Widgetbook field and complements the built-ins ([`widgetbook/main.dart`](../../widgetbook/main.dart)). |
| Accessibility overlay | A `BuilderAddon` wraps every use case in `AccessibilityTools(checkFontOverflows: true)`. | **Correct current approach.** Widgetbook deprecates its old `AccessibilityAddon` and explicitly recommends `BuilderAddon` plus `accessibility_tools` ([accessibility addon migration](https://docs.widgetbook.io/addons/accessibility-addon)). |
| Knobs | The button and input playgrounds use string, Boolean, dropdown, and segmented knobs; the catalogue has 16 `context.knobs` inputs in those playgrounds. | **Good start, narrow coverage.** Knobs are the stable v3 mechanism for changing use-case inputs live ([knobs overview](https://docs.widgetbook.io/knobs/overview), [button stories](../../widgetbook/atoms/action_atom_stories.dart), [input stories](../../widgetbook/atoms/input_atom_stories.dart)). |
| Deep-link state | The app uses standard Widgetbook routing and has not replaced its URL router. | **Core capability already available.** Widgetbook encodes the selected path and control state in the web URL; `initialRoute` can choose a landing use case, and `preview`/`panels` query parameters support focused links and embeds ([initial route](https://docs.widgetbook.io/configure/initial-route), [embedding](https://docs.widgetbook.io/essentials/embedding)). A shared hosted URL is still absent. |

### Test and CI baseline

Forge Dance already tests design-system behavior that pixel snapshots alone would not protect:

- theme color contrast, deterministic typography, high-contrast emphasis, and minimum control geometry ([theme contracts](../../test/design_system_theme_test.dart));
- touch targets, keyboard activation, semantics, disabled/loading distinctions, and reduced motion for actions ([action contracts](../../test/design_system_action_primitives_test.dart));
- input semantics and interaction states ([input contracts](../../test/design_system_input_primitives_test.dart));
- selection semantics plus a 2× text-scale layout stress case ([selection contracts](../../test/design_system_selection_primitives_test.dart)); and
- surface semantics and interactions ([surface contracts](../../test/design_system_surface_primitives_test.dart)).

Those are **non-gaps** and should remain even if visual snapshots are adopted. The current tests contain no golden-image matcher or Widgetbook scenario runner. CI runs dependency/code generation, `flutter analyze`, all tests, and a release build of the product's default web entry point, but it does **not** build `widgetbook/main.dart` or upload Widgetbook metadata/builds ([check script](../../tool/checks.sh), [GitHub Actions workflow](../../.github/workflows/flutter.yml)).

## 2. Current stable capabilities: facts and Forge Dance gaps

| Capability | Confirmed first-party behavior and constraint | Forge Dance comparison |
|---|---|---|
| Accessibility audit | The old `AccessibilityAddon` is deprecated; `BuilderAddon` plus `accessibility_tools` is the documented replacement ([official migration page](https://docs.widgetbook.io/addons/accessibility-addon)). | **No gap:** already implemented. Keep the behavioral semantics tests; an overlay is not proof of full accessibility. |
| Semantics inspection | `SemanticsAddon` visualizes a minimal Flutter semantics tree and should be placed after other addons, but it is explicitly **experimental** and may break in a minor release ([semantics addon](https://docs.widgetbook.io/addons/semantics-addon)). | **Gap:** not in the addon list. Useful for diagnosing merged/missing nodes, but not a CI gate. |
| Viewports | `ViewportAddon` controls logical bounds, device-pixel ratio, and simulated platform; it supports iOS, Android, macOS, Windows, Linux, `Viewports.none`, and custom `ViewportData` ([viewport docs](https://docs.widgetbook.io/addons/viewport-addon), [3.25 source model](https://github.com/widgetbook/widgetbook/blob/main/packages/widgetbook/lib/src/addons/viewport_addon/viewport_data.dart)). | **Small gap:** broad device coverage exists, but no unconstrained/resizable option, Windows/Linux desktop, landscape, or explicit boundary-width viewports. Add only widths tied to a real layout seam, not every preset. |
| Text scale | `TextScaleAddon` updates `MediaQuery.textScaler`; it can be included in Cloud multi-snapshot configurations ([text-scale docs](https://docs.widgetbook.io/addons/text-scale-addon)). | **No interactive gap:** 1–3.2× already exceeds the default range. **Automation gap:** no chosen scale is captured in CI/reviews. |
| Themes | Material, Cupertino, and custom theme addons are supported; named themes can become Cloud snapshot configurations ([theme docs](https://docs.widgetbook.io/addons/theme-addon)). | **No interactive gap:** all four production/accessibility themes are present. **Automation gap:** no cross-theme snapshots. |
| Locales | `LocalizationAddon` switches a Flutter `Localizations` wrapper's locale/delegates and supports Cloud configurations ([localization docs](https://docs.widgetbook.io/addons/localization-addon), [official package source](https://github.com/widgetbook/widgetbook/blob/main/packages/widgetbook/lib/src/addons/localization_addon/localization_addon.dart)). | **Clear gap with compatibility requirement:** English and Vietnamese are initialized, but there is no selector. The stock addon only wraps the use case in `Localizations`; Forge's outer `EasyLocalization` owns the locale used by `.tr()`. Do not add it unmodified. Use a small Widgetbook addon/bridge that synchronizes selection to the existing `EasyLocalization` context and verify translated strings actually change. |
| Knobs | v3 knobs cover Boolean, integer, double, string, duration, date/time, color, iterable, and object inputs, including nullable forms; labels must be unique within a use case ([knobs matrix](https://docs.widgetbook.io/knobs/overview)). v3.20 added dynamic knobs, and 3.25 added duration-unit selection ([official changelog](https://raw.githubusercontent.com/widgetbook/widgetbook/main/packages/widgetbook/CHANGELOG.md)). | **Coverage gap:** only button and input have playground controls. Existing variant/state matrices remain valuable for simultaneous comparison and should not be replaced wholesale. |
| State and mocking | Official guidance prefers extracting external state into widget parameters; for screens where that is not practical, provide the dependency in the use-case tree or use a mocking library ([mocking guide](https://docs.widgetbook.io/~1416/guides/mocking)). | **Gap:** the global `ProviderScope` has no overrides, and the screen catalogue exposes only default Register and Sign-in states. Existing repository fakes in tests show the project-native seam; per-use-case Riverpod overrides can model loading, empty, populated, offline, and error states without Firebase. |
| Deep links and embeds | A selected use case can be copied from the web URL or set as `initialRoute`; `preview` hides chrome and `panels` selects navigation/knobs/addons for embedding ([initial route](https://docs.widgetbook.io/configure/initial-route), [embedding](https://docs.widgetbook.io/essentials/embedding)). | **Local non-gap, collaboration gap:** URLs already encode state locally, but there is no persistent hosted Widgetbook URL for design/review sharing. Keep catalogue names stable because they form links. |
| Property inspection | `InspectorAddon` exposes colors, sizes, padding, and other widget properties in the Workbench ([inspector addon](https://docs.widgetbook.io/addons/inspector-addon)). | **Low-effort gap:** especially useful during token/design QA. |
| Layout grid | `GridAddon` draws configurable grid guidance behind use cases ([grid addon](https://docs.widgetbook.io/addons/grid-addon)). | **Low-effort gap:** use Forge's 4 px foundation, not the docs' illustrative 10 px grid. |
| Local golden/interaction runner | Stable v3 documentation centers visual regression in Cloud. The new reusable scenario runner is a **v4 beta** capability: `testWidgetbook` runs scenarios on `flutter_test`, applies constraints, executes interactions, captures PNG/JSON, semantics, and accessibility violations under `build/.widgetbook` ([v4 testing overview](https://docs.widgetbook.io/~v4/testing/overview), [v4 scenario runner](https://docs.widgetbook.io/~v4/testing/run-scenarios)). | **Gap, but defer:** no local Widgetbook snapshots today. Do not migrate the catalogue solely for beta APIs. Existing behavioral tests remain authoritative until v4 is stable. |
| Visual regression | Widgetbook Cloud compares base/head UI builds and advertises automatic UI regression detection without hand-writing a golden test for every use case ([Cloud Reviews](https://docs.widgetbook.io/cloud/reviews)). Stable v3 has documented limitations for animations and random/dynamic values; deterministic values or explicit static controls are recommended ([review limitations](https://docs.widgetbook.io/cloud/reviews/limitations)). | **Gap:** no snapshot baseline or visual-diff service. Reduced-motion simulation and hardcoded story data are a useful starting point, but animated/loading content still needs deterministic capture states. |
| Review workflow | Cloud creates a PR review, posts commit status, supports approve/request-changes, can block merging, supports multi-snapshot configurations, and can link Figma designs ([Cloud Reviews](https://docs.widgetbook.io/cloud/reviews), [multi-snapshot reviews](https://docs.widgetbook.io/cloud/snapshots/multi-snapshot), [Figma reviews](https://docs.widgetbook.io/cloud/reviews/figma), [GitHub enforcement](https://docs.widgetbook.io/cloud/guides/github/enforce-reviews)). | **Gap and Cloud dependency:** no uploaded build, API secret, review status, branch rule, design links, or metadata-generation path. |
| CI and hosting | Widgetbook recommends uploading every commit/branch through CI. Its GitHub guide builds the web catalogue, generates metadata, installs `widgetbook_cli`, and pushes with `WIDGETBOOK_API_KEY` ([build upload](https://docs.widgetbook.io/cloud/builds/upload), [GitHub Actions guide](https://docs.widgetbook.io/cloud/guides/github/upload)). | **Gap:** current CI neither builds the custom Widgetbook target nor pushes it. A local build gate is free; upload/reviews require Cloud. |
| Telemetry | The documented telemetry belongs to **Widgetbook Generator**. It sends package name, an anonymous hash based on git email, first-commit SHA, repository owner URL, and component/use-case counts after generated directories change. It can be disabled in `build.yaml` by disabling `widgetbook_generator:telemetry` ([telemetry policy and opt-out](https://docs.widgetbook.io/telemetry)). | **No current generator path:** Forge Dance does not depend on `widgetbook_generator` and declares directories manually, so this documented report is not currently triggered **[INFERENCE]**. Make an explicit choice if generator-based v3 Cloud metadata or v4 generation is adopted. |

## 3. Cloud, plan, and cost boundary

The OSS workbench, addons, knobs, URL routing, and local development are free/open source. Hosted builds, automated screenshot comparison, PR reviews, Figma comparison, and shareable branch builds are Widgetbook Cloud capabilities ([official pricing](https://www.widgetbook.io/pricing), [Cloud Reviews](https://docs.widgetbook.io/cloud/reviews)).

As of the research date, official pricing lists:

| Plan | Monthly snapshots | Material constraint |
|---|---:|---|
| Free | 1,000 | $0; 14-day build storage |
| Starter | 10,000 | $149/month; $0.05 per additional snapshot |
| Standard | 20,000 | $349/month; $0.05 per additional snapshot |
| Pro | 50,000 | $649/month; $0.05 per additional snapshot; dedicated support |
| Enterprise | Custom | Annual/custom pricing and enterprise controls |

Source: [Widgetbook pricing](https://www.widgetbook.io/pricing). Snapshot use is multiplicative: per build, Widgetbook counts the cross-product of knob configurations and addon configurations across use cases ([snapshot counting](https://docs.widgetbook.io/cloud/snapshots/overview)). Therefore Forge Dance should not start by crossing 59 use cases × four themes × two locales × seven viewports × multiple knob states. A Free-plan pilot should choose a small review matrix based on risk.

### Practical Cloud prerequisite for this repository

The documented stable-v3 Cloud flow generates use-case/addon/knob metadata before upload ([upload flow](https://docs.widgetbook.io/cloud/builds/upload), [multi-snapshot configuration](https://docs.widgetbook.io/cloud/snapshots/multi-snapshot)). Forge Dance's manual `WidgetbookUseCase` tree has no generator annotations or generator dependency, so a full Cloud review pilot is **not** only a workflow edit: it needs a deliberate catalogue-metadata migration. Do not add the deprecated `WidgetbookCloudIntegration`; the official changelog says it has been unused/deprecated since v3.11 ([official changelog](https://raw.githubusercontent.com/widgetbook/widgetbook/main/packages/widgetbook/CHANGELOG.md)).

## 4. Deprecated and prerelease approaches to avoid

| Avoid | Current replacement / decision | Evidence |
|---|---|---|
| `AccessibilityAddon` | Keep Forge Dance's existing `BuilderAddon` + `AccessibilityTools`. | [Official deprecation notice](https://docs.widgetbook.io/addons/accessibility-addon) |
| `DeviceFrameAddon` | Keep `ViewportAddon`; it has been the non-experimental replacement since v3.15 and supports Cloud configurations. | [Official changelog](https://raw.githubusercontent.com/widgetbook/widgetbook/main/packages/widgetbook/CHANGELOG.md), [device-frame deprecation](https://docs.widgetbook.io/addons/device-frame-addon) |
| `WidgetbookCloudIntegration()` | Do not add it; the official changelog says it is unused and deprecated. | [Official changelog](https://raw.githubusercontent.com/widgetbook/widgetbook/main/packages/widgetbook/CHANGELOG.md) |
| Deprecated discrete `TextScaleAddon(scales: ...)` | Keep Forge Dance's current `min`/`max`/`divisions` slider form. | [Official changelog](https://raw.githubusercontent.com/widgetbook/widgetbook/main/packages/widgetbook/CHANGELOG.md) |
| Old `knobs.list` APIs | Continue using `object.dropdown`/`object.segmented`; add iterable knobs only where multi-selection is real. | [Official changelog](https://raw.githubusercontent.com/widgetbook/widgetbook/main/packages/widgetbook/CHANGELOG.md), [knobs overview](https://docs.widgetbook.io/knobs/overview) |
| Stock `LocalizationAddon` as an assumed `easy_localization` controller | Use a verified bridge that changes the outer EasyLocalization locale; Flutter `Localizations` alone is insufficient for Forge's `.tr()` owner. | [Official localization source](https://github.com/widgetbook/widgetbook/blob/main/packages/widgetbook/lib/src/addons/localization_addon/localization_addon.dart), [`widgetbook/main.dart`](../../widgetbook/main.dart) |
| Production-wide v4 migration now | Track stable v4. If evaluated early, isolate a 3–5-story spike and expect breaking changes. | [v4 beta warning](https://www.widgetbook.io/blog/widgetbook-v4-beta-is-here), [v4 migration guide](https://docs.widgetbook.io/~v4/v4-migration) |

## 5. Ranked adoption plan

Impact reflects design-quality/risk reduction for Forge Dance; effort is relative implementation and maintenance cost.

| Rank | Recommendation | Benefit | Effort | Plan/cost dependency | Exact implementation seam |
|---:|---|---|---|---|---|
| **1** | Add a verified English/Vietnamese locale bridge. | Makes translation length, Vietnamese diacritics, localized copy, and locale-driven layout review part of every story. | **Medium** | Stable OSS v3; no paid dependency. Compatibility code is project-specific. | In [`widgetbook/main.dart`](../../widgetbook/main.dart), add a small `_EasyLocalizationAddon` with a locale field/query value and a stateful use-case wrapper. The wrapper must synchronize addon selection to the existing outer `EasyLocalization` locale through its context API outside the widget's `build` method, then render the child through the existing preview delegates. Do **not** merely add stock `LocalizationAddon`. Verify both `.tr()` output and `Localizations.localeOf` change together before expanding locale coverage. The stable Widgetbook addon is a useful API model but only wraps `Localizations` ([docs](https://docs.widgetbook.io/addons/localization-addon), [source](https://github.com/widgetbook/widgetbook/blob/main/packages/widgetbook/lib/src/addons/localization_addon/localization_addon.dart)). |
| **2** | Build the Widgetbook web target in pull-request CI. | Prevents a catalogue-only asset/router/web failure from landing even when the product entry point builds. Keeps the workbench deployable. | **Low** | Free CI only. | Add a dedicated step in [`.github/workflows/flutter.yml`](../../.github/workflows/flutter.yml) after required checks: release-build the target `widgetbook/main.dart` with the same resolved dependencies. Keep the existing product web build; this is a second entry-point smoke gate, not a replacement. |
| **3** | Expand knobs only on high-change primitives and preserve matrix stories. | Speeds design iteration on content extremes and state combinations while retaining side-by-side state coverage. | **Medium** | Stable OSS v3; no paid dependency. | Add `Playground` use cases beside existing matrices in [`visual_atom_stories.dart`](../../widgetbook/atoms/visual_atom_stories.dart), [`feedback_atom_stories.dart`](../../widgetbook/atoms/feedback_atom_stories.dart), and the most actively changing molecule/organism files. Prioritize label length, semantic variant, size, enabled/selected/loading, progress/value, and optional content. Use unique stable labels because URL and Cloud configurations address knobs by label ([knobs overview](https://docs.widgetbook.io/knobs/overview)). |
| **4** | Add deterministic Riverpod-backed screen states. | Exposes hard-to-reach loading, empty, populated, offline, validation, and failure states without Firebase or manual navigation. | **Medium–High** | Stable OSS v3; no Cloud required. No new mocking package is necessary if existing fakes suffice. | In [`screen_stories.dart`](../../widgetbook/screen_stories.dart), wrap each state use case in a nested `ProviderScope(overrides: [...])`, reusing the fake-repository/provider-override pattern from feature tests. Expand beyond the two default auth screens only when dependencies can be deterministic. Keep fake behavior out of product widgets. Official guidance permits dependency extraction or providing/mocking the dependency in the use-case tree ([mocking guide](https://docs.widgetbook.io/~1416/guides/mocking)). |
| **5** | Add design diagnostics: `InspectorAddon`, `GridAddon(4)`, and optional `SemanticsAddon`. | Makes token/padding inspection, 4 px rhythm review, and semantics-tree diagnosis available in one workbench. | **Low** | Inspector/grid are stable OSS. Semantics is experimental OSS and must not become a hard gate. | In [`widgetbook/main.dart`](../../widgetbook/main.dart), keep `ViewportAddon` first, then theme/locale/text scale/custom controls; add `InspectorAddon()` and `GridAddon(4)` before the accessibility wrapper, and `SemanticsAddon()` last as its docs require ([addon ordering](https://docs.widgetbook.io/addons/overview), [inspector](https://docs.widgetbook.io/addons/inspector-addon), [grid](https://docs.widgetbook.io/addons/grid-addon), [semantics](https://docs.widgetbook.io/addons/semantics-addon)). |
| **6** | Add a small responsive boundary set, not every preset. | Tests actual layout transitions and unconstrained browser resizing rather than treating device names as coverage. | **Low–Medium** | Stable OSS v3; no paid dependency. | Extend `ViewportAddon` in [`widgetbook/main.dart`](../../widgetbook/main.dart) with `Viewports.none`, one landscape viewport, and custom `ViewportData` values immediately below/above each real Forge breakpoint once those breakpoints exist. Preserve the representative phone/tablet/Mac set. `ViewportData` supports logical size, DPR, platform, and safe areas ([viewport addon](https://docs.widgetbook.io/addons/viewport-addon)). |
| **7** | Pilot Widgetbook Cloud visual reviews on a deliberately small matrix. | Adds base/head visual diffs, shareable branch builds, designer approval, and optional Figma comparison. | **High initial**, then medium operational | **Cloud required.** Start within Free's 1,000 monthly snapshots; use paid tiers only if measured use justifies them. | First migrate a small critical slice to generator-readable metadata; then add the official build/generate/push flow and `WIDGETBOOK_API_KEY` to [`.github/workflows/flutter.yml`](../../.github/workflows/flutter.yml). Start with atoms plus one screen, two themes, English/Vietnamese, one phone viewport, and a few deterministic knob states. Expand only after measuring snapshots. Require the branch status only after review reliability is demonstrated ([GitHub upload](https://docs.widgetbook.io/cloud/guides/github/upload), [review enforcement](https://docs.widgetbook.io/cloud/guides/github/enforce-reviews)). |
| **8** | Track v4 stable; evaluate scenarios locally only in an isolated spike before then. | v4 can unify catalogue states, interactions, screenshots, semantics, and accessibility metadata, reducing duplicated setup. | **High migration** | OSS beta is available; Cloud v4 remains a beta program. Production cutover should wait for stable. | When stable, migrate 3–5 representative stories first as the official guide recommends: one atom with args, one stateful component, one Riverpod-backed screen, and Forge fonts/themes. Add `test/widgetbook_test.dart` only after the spike proves deterministic snapshots. v4's runner records PNG/JSON and accessibility violations, but violations are metadata rather than failures by default ([scenario runner](https://docs.widgetbook.io/~v4/testing/run-scenarios), [accessibility guidelines](https://docs.widgetbook.io/~v4/testing/accessibility)). |
| **9** | Record an explicit generator-telemetry choice when generation is introduced. | Avoids accidental policy drift and makes repository metadata handling intentional. | **Low** | Relevant only if `widgetbook_generator`/v4 generation is added. | If generation is approved, decide whether the documented report is acceptable. If not, add the official `widgetbook_generator:telemetry` disablement to root `build.yaml` in the same change ([telemetry docs](https://docs.widgetbook.io/telemetry)). No action is needed for the manual catalogue **[INFERENCE]**. |

## 6. Recommended sequence and future acceptance checks

This is an adoption sequence, not work performed by this research note.

1. **Local workbench quality:** verified locale bridge → CI target build → diagnostic addons.
2. **Catalogue depth:** targeted primitive playgrounds → deterministic Riverpod screen states.
3. **Responsive precision:** add only boundary viewports justified by real `LayoutBuilder`/window-width transitions.
4. **Review economics:** estimate the snapshot matrix before a Cloud pilot; begin below 1,000 snapshots/month.
5. **Architecture migration:** reassess v4 after a stable release; do not combine a v4 migration with the first Cloud pilot.

For each future change, confirm the actual Widgetbook surface:

- changing locale visibly switches `.tr()` English/Vietnamese copy, `Localizations.localeOf`, and text direction without nested-localization conflict;
- every added viewport renders its intended logical size/platform and long text remains usable;
- provider-backed use cases never contact Firebase/network and reset deterministically when revisited;
- CI builds the explicit Widgetbook target;
- a Cloud pilot produces the expected base/head diff and measured snapshot count; and
- any v4 spike reproduces Forge fonts/themes, interactions, semantics metadata, and stable snapshots before migration is proposed.

## Source index

All external sources below are first-party Widgetbook documentation, official Widgetbook blog/package/source material, or the official package registry record:

- [Widgetbook package API and published versions](https://pub.dev/api/packages/widgetbook)
- [Widgetbook official changelog](https://raw.githubusercontent.com/widgetbook/widgetbook/main/packages/widgetbook/CHANGELOG.md)
- [Widgetbook v4 beta announcement](https://www.widgetbook.io/blog/widgetbook-v4-beta-is-here)
- [Addon overview and ordering](https://docs.widgetbook.io/addons/overview)
- [Viewport addon](https://docs.widgetbook.io/addons/viewport-addon)
- [Text-scale addon](https://docs.widgetbook.io/addons/text-scale-addon)
- [Theme addon](https://docs.widgetbook.io/addons/theme-addon)
- [Localization addon](https://docs.widgetbook.io/addons/localization-addon)
- [Localization addon source](https://github.com/widgetbook/widgetbook/blob/main/packages/widgetbook/lib/src/addons/localization_addon/localization_addon.dart)
- [Knobs overview](https://docs.widgetbook.io/knobs/overview)
- [Accessibility addon deprecation](https://docs.widgetbook.io/addons/accessibility-addon)
- [Semantics addon](https://docs.widgetbook.io/addons/semantics-addon)
- [Inspector addon](https://docs.widgetbook.io/addons/inspector-addon)
- [Grid addon](https://docs.widgetbook.io/addons/grid-addon)
- [Mocking guide](https://docs.widgetbook.io/~1416/guides/mocking)
- [Initial routes](https://docs.widgetbook.io/configure/initial-route)
- [Embedding and preview URLs](https://docs.widgetbook.io/essentials/embedding)
- [Telemetry and opt-out](https://docs.widgetbook.io/telemetry)
- [Cloud build uploads](https://docs.widgetbook.io/cloud/builds/upload)
- [Cloud Reviews](https://docs.widgetbook.io/cloud/reviews)
- [Multi-snapshot reviews](https://docs.widgetbook.io/cloud/snapshots/multi-snapshot)
- [Snapshot counting](https://docs.widgetbook.io/cloud/snapshots/overview)
- [Review limitations](https://docs.widgetbook.io/cloud/reviews/limitations)
- [Figma reviews](https://docs.widgetbook.io/cloud/reviews/figma)
- [GitHub upload guide](https://docs.widgetbook.io/cloud/guides/github/upload)
- [GitHub review enforcement](https://docs.widgetbook.io/cloud/guides/github/enforce-reviews)
- [Widgetbook pricing](https://www.widgetbook.io/pricing)
- [v4 testing overview](https://docs.widgetbook.io/~v4/testing/overview)
- [v4 scenario runner](https://docs.widgetbook.io/~v4/testing/run-scenarios)
- [v4 scenario authoring](https://docs.widgetbook.io/~v4/testing/create-scenario)
- [v4 accessibility guidelines](https://docs.widgetbook.io/~v4/testing/accessibility)
- [v4 migration guide](https://docs.widgetbook.io/~v4/v4-migration)
