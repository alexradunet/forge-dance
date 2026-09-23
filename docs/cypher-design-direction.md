# Forge / underground cypher — design direction and adoption

## Direction

The user selected an underground dance-battle identity, real dance photography/video, and an **interactive movement teacher**, not an avatar customizer or decorative 3D mascot.

This updates the visual direction of [the foundation refresh plan](design-system-refresh-plan-2026.md). Its semantic theming, accessibility, pure component, and offline-first contracts remain in force. This is a first adoption slice, not a claim that every legacy component has been migrated.

- Charcoal, off-white, Forge Fire. One dominant action accent; reward/error/category colors retain their meaning.
- Poster-scale Bebas Neue for discovery, Inter for instructions and controls.
- Crisp compact corners on actions and editorial panels; established immersive utility cards remain supported.
- Real movement leads Home. Controls and text never depend on photograph contrast.
- One dominant invitation on Home; the current lesson is secondary. Practice is numbered rounds, not a decorative media feed.
- No autoplay, ambient pulsing, gratuitous blur, or glow on every button. Instruction, safety, errors, and unsaved work remain visible.

## Shared implementation and adoption

| Module | Contract | Adopted in |
|---|---|---|
| `FgDanceHero` | Full-bleed decorative image, tested minimum-contrast copy scrim (opaque in high contrast), content-sized headline, explicit action, image failure fallback | Home, daily workout |
| `FgSectionHeading` | Eyebrow/title/subtitle hierarchy, semantic heading, unlimited wrapping | Home, Learn discovery, daily practice, motion lab |
| `FgProgramCard` / `FgProgramCardLayout` | Optional photo, complete route summary, progress/lock/enrolment status, one native keyboard action, responsive content-sized grid | Learn modules, programme discovery |
| `FgCardShape.editorial` | Crisp corners without replacing existing utility-card defaults | Module and programme previews |
| `FgShimmer` | Stops for reduced motion or disabled ticker scope; resumes when allowed | Existing image-loading placeholders |
| `FgRoundPanel` | Numbered or active content region, semantic colors, visible cue/safety slot | Home current lesson, practice blocks, active practice player |
| `FgMovementStage` | Bounded quiet viewport and accessible description; controls live outside it | Motion lab |
| `FgPracticeMeter` | Elapsed time, target progress, accessible status and a wrapping eight-count strip; no decorative animation | Active practice player |
| `FgReferenceCard` | Stable index number, complete definition and real study status; one native keyboard destination | Vocabulary index |
| `FgPhoto` / `FgPhotoHeading` | Decorative image with a fallback; labelled thumbnail beside wrapping text, stacking at narrow widths/large text | Home current lesson, workout rounds |
| `FgPhotoTile` / `FgPhotoTileLayout` | One native destination action per image card; two-up discovery becomes stacked at large text | Home Learn/Programme links |
| `FgButton` | Crisp rounded default; long labels wrap; native focus/keyboard/disabled/loading behavior; pill/circle still explicit choices | Existing application callers |
| `FgBackground` | Matte immersive default; decorative gradients opt-in | Existing immersive flows |

Keep feature-owned copy/localization and view-model intents outside the design system. Do not add a second feature-local version of these surfaces. New component state matrices are in Widgetbook. `test/cypher_design_system_test.dart` supplements actual screen contracts with a scoped adoption guard against raw palette values and text sizes.

Home and Learn now use `FgImmersiveScaffold` and its builder context, including under a light host. No appearance preference is changed. Existing profile, curriculum, daily scheduling, safety, unsaved-session protection, and persistence behavior are retained.

Home and the Workout tab use bundled editorial preview photos: the existing ~148 KB hero plus two additional WebPs (~340 KB total). These are explicitly placeholder/inspiration images, not adjacent movement demonstrations or instructor identities; no activity or progress is fabricated. See [asset provenance](../assets/images/CREDITS.md). Learn catalogue thumbnails remain cached network images. No video autoplay or renderer dependency is added to startup.

## Motion lab: executable interaction experiment

Run `bash tool/run_live_flutter.sh linux`, `bash tool/run_live_flutter.sh web`, or `bash tool/run_orca_android.sh`. In a **debug** build, Home → expand **How it works** → **Preview 3D motion lab**. There is no production route/link. No storage, lesson assessment, practice time, or rewards are affected.

Code: `lib/features/movement_teacher/prototype/`.

- Original synthetic mannequin in 3D coordinates, perspective projection and depth-sorted capsules on Flutter Canvas.
- Front/side/back, continuous orbit slider and horizontal dragging.
- Play/pause, paused scrubbing, 0.25×/0.5×/1× speed, optional fixed 2–6 second loop.
- Starts paused, including with reduced motion. Playback is explicit, has no sound, and pauses on backgrounding. Ticker and controller are disposed with the page.
- Visible warning: this is **not** coach-validated movement or dance instruction. Anatomical orientation is explicit; there is no hidden mirror operation.

This proves the control/state model and an offline projected-rig UI. It does **not** prove GLB loading, GPU skinning, mocap fidelity, production rendering performance, or iOS renderer support. Do not promote the procedural animation as a lesson.

The delegated renderer-research lane was stopped because the worker's advertised web tools were unavailable at runtime. No package recommendation or cross-platform compatibility claim was inferred from that failed lane.

### Before a real teacher can ship

1. License or commission one motion asset, retaining source, redistribution rights, rig conventions, scale, clip timing and educator approval. Review contact, foot sliding and weight transfer; a convincing render is not proof of correct technique.
2. Verify a maintained renderer's actual skeletal playback, seek, speed, clip-range, orbit, disposal and context-loss behavior. Test Android/iOS, release Web Wasm and its JS fallback, not just package badges.
3. Provide equivalent coach-approved video, instructional cues, accessible descriptions, and an honest unsupported/loading/error fallback. Do not use this mannequin as the fallback for an unrelated lesson.
4. Benchmark on a modest phone: load time, memory, sustained frame timing, battery/thermal behavior, pause/resume and repeated navigation. This emulator/debug experiment is not that benchmark.
5. Integrate verified clip/cue timing with the learning view model; keep the renderer replaceable only where there is real variation. Do not introduce a speculative renderer interface around one implementation.

## Remaining rollout

- Continue the editorial hierarchy into module/lesson detail after reviewing each screen's purpose. Home, Explore, programme discovery and Vocabulary establish the shared patterns; don't put a promotional hero on forms or active exercise pages.
- Audit legacy badge foregrounds and small type, remaining card semantics, shimmer palette defaults, and raw-palette usage outside the adopted slice. Shimmer motion is now covered, but these remaining inconsistencies are not solved by a token rename.
- Commission battle/cypher imagery with consistent crops and explicit rights. Add only purpose-driven, opt-in instructional video.
- Keep real light-host, expanded disclosure, large-text and root-dialog tests alongside every migrated screen. Component stories alone are not acceptance.

## Verification

`bash tool/checks.sh` is the required core gate. Major composition/assets also require `bash tool/check_web_quality.sh`. Home interaction regression can be exercised with `bash tool/check_integration.sh`. The lab has deterministic controller tests; Home, practice, the player and the lab have rendered surface coverage in `test/feature_surface_contract_test.dart`.

Local visual captures and logs are under ignored `build/design-refresh/`; they are not source assets.

### First-slice outcomes (2026-09-23)

- Core gate passed: analyzer clean, 232 tests passed.
- Browser integration passed; Widgetbook code generation and analysis passed.
- Release Web Wasm + JS fallback build and Lighthouse gate passed: performance 55, accessibility 100, best practices 81, SEO 100; 8.10 MiB transferred, no console errors or failed requests. Lighthouse printed a non-fatal Lantern `NO_LCP` diagnostic; these are the gate's reported scores, not a lab-renderer benchmark.
- Current Android debug screenshots inspected for Home, daily practice, active player and motion lab, including expanded disclosures, large text and a wide Home layout. The live lab exercised half-speed playback, pause, side view and its loop. Runtime error check was empty.
- Home's headerless immersive scroll viewport now respects the status-bar inset; the regression has a focused scaffold test. Emulator font scale was restored to 1.0 and portrait orientation after checks.
- No physical-device performance result, iOS execution, skinned-model rendering result, or production-teacher readiness is claimed.

### Discovery continuation (2026-09-23)

- Learn has editorial hierarchy, crisp photo cards, direct Programme/history links, and retryable loading errors. Search, prerequisite explanations and existing learning-path destinations are retained.
- Programme previews reuse the same card, with numbered routes, complete purpose copy, progress and a labelled enrolment state. Locked programmes remain inspectable; enrolment still uses the existing prerequisite checks and repository.
- The surface suite covers both screens under a light host, search/empty/clear behavior, expanded explanations, real enrolment, and blocked enrolment. Both screens reflow at 320px and 1024px with 2× text. Card tests cover keyboard activation and selected semantics in all four themes; shimmer tests cover live motion/visibility changes and disposal.
- Core gate passed: analyzer clean, **240 tests passed**. Browser integration and Widgetbook generation/analysis passed.
- Release Web Wasm + JS fallback build and quality gate passed: performance 53, accessibility 100, best practices 81, SEO 100; 8.11 MiB transferred, zero console errors and failed requests. The same non-fatal Lantern `NO_LCP` diagnostic remains; this is not a production 3D benchmark.
- Current Android screenshots cover Learn and Programme discovery, collapsed/expanded programme guidance, 2× system text, and landscape Learn. Runtime error check was empty. Emulator font scale was restored to 1.0 and orientation to portrait.
- No new media dependency, persistence shape, instructional content, or production renderer was introduced.

### Home / Workout photo preview (2026-09-23)

- Responding to feedback that the screens felt too plain: Home now has a full-bleed poster, a photo-led current lesson, and two image destinations for Learn and Programmes. Utility links and the debug lab sit below discovery; complete explanatory copy remains available.
- The **Workout tab is `PracticePage`**, not the legacy fitness-circuit overview. It now has a photographic daily header, an explicit first-round action, and labelled round thumbnails. Starting still opens the real first block paused; the active player has no new decorative photographs.
- Photos are bundled placeholders with documented provenance, not fabricated lesson content. Existing scheduling, progress, preferences, unsaved-record handling, lesson locks, adaptations and safety copy are retained.
- Core gate: analyzer clean, **251 tests passed**. Browser integration and Widgetbook generation/analysis passed. Component coverage includes keyboard activation, missing-image recovery, scrim contrast over white, light hosts and large text. Screen coverage includes real photo-tile routes, full disclosures, and first-round navigation.
- Release Web Wasm/JS-fallback quality gate passed: performance 51, accessibility 100, best practices 81, SEO 100; 8.11 MiB startup transfer, zero console errors/failed requests. The existing non-fatal Lantern `NO_LCP` diagnostic remains; startup scores are not a benchmark of every photo-bearing screen.
- Current Android normal/2×-text, collapsed/expanded Home and Workout screenshots are under ignored `build/photo-refresh/`. Font scale restored to 1.0; no appearance preference or training record was changed.

### Active workout / Vocabulary continuation (2026-09-23)

- The active workout is `PracticePlayerPage`, reached from **Start first round**. Its new readout shows real active time, suggested target progress and the current count. Start/pause and save precede changing cues so cue length cannot move the pause target. Written instruction and safety remain outside disclosures; no decorative image or unverified teacher is added.
- Tempo, phrase and independent-mode controls are grouped under **Tempo, counts & guidance**. Optional notes/effort retain their values when collapsed; media selection still pauses practice. Clock, count-in, lifecycle pause, audio, record creation and caller-owned persistence are unchanged.
- Vocabulary now uses an immersive, constrained index, offline preview header, numbered reference cards and a responsive two-column layout. Alias search, combined kind/style filters, clearing/reset, full definitions and real study status are preserved. Reference pages expose the technique cue, comfort guidance, lesson/practice access and complete contextual/evidence disclosures without relaxing prerequisite gates.
- Disabled `FgButton` content now uses the same muted foreground as its disabled Material state, rather than retaining a primary button's black foreground on a dark disabled fill.
- Core gate: clean analyzer, **263 tests passed**. Coverage includes real screens under a light host, 320px/1040px at 2× text, expanded disclosures, draft notes, muted start/background pause, dark phrase popup selection, real reference navigation and locked/unlocked practice. Reference keyboard actions and meter high-contrast/reduced-motion states have focused component tests and Widgetbook stories; Widgetbook generation/analysis passed.
- Release Web Wasm/JS-fallback quality gate passed: performance **54**, accessibility **100**, best practices **81**, SEO **100**; **8.11 MiB**, zero console errors or failed requests. The existing non-fatal Lantern `NO_LCP` diagnostic remains. Routing, onboarding and persistence schemas were not changed.
- Live Android normal/2×-text and collapsed/expanded screenshots are under ignored `build/session-vocabulary-refresh/`. Muted playback, count-in, active counts and pause were exercised without saving a training record. Runtime errors were empty; font scale was restored to 1.0 and the player reopened ready at 00:00. No new asset, backend or renderer dependency was introduced.
