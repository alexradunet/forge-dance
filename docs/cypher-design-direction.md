# Forge / underground cypher — first vertical slice

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
| `FgDanceHero` | Bundled/decorative image, opaque copy area, adaptive split layout, content-sized headline, explicit action, image failure fallback | Home |
| `FgSectionHeading` | Eyebrow/title/subtitle hierarchy, semantic heading, unlimited wrapping | Home, daily practice, motion lab |
| `FgRoundPanel` | Numbered or active content region, semantic colors, visible cue/safety slot | Home current lesson, practice blocks, active practice player |
| `FgMovementStage` | Bounded quiet viewport and accessible description; controls live outside it | Motion lab |
| `FgButton` | Crisp rounded default; long labels wrap; native focus/keyboard/disabled/loading behavior; pill/circle still explicit choices | Existing application callers |
| `FgBackground` | Matte immersive default; decorative gradients opt-in | Existing immersive flows |

Keep feature-owned copy/localization and view-model intents outside the design system. Do not add a second feature-local version of these surfaces. New component state matrices are in Widgetbook. `test/cypher_design_system_test.dart` supplements actual screen contracts with a scoped adoption guard against raw palette values and text sizes.

Home now uses `FgImmersiveScaffold` and its builder context, including under a light host. No appearance preference is changed. Existing profile, curriculum, daily scheduling, safety, unsaved-session protection, and persistence behavior are retained.

The hero photo is bundled (~148 KB) so it does not depend on a first-run network request. See [asset provenance](../assets/images/CREDITS.md). Other catalogue thumbnails remain the existing cached network images. No new video autoplay or renderer dependency is added to startup.

## Motion lab: executable interaction experiment

Run `bash tool/run_live_flutter.sh linux`, `bash tool/run_live_flutter.sh web`, or `bash tool/run_orca_android.sh`. In a **debug** build, Home → **Preview 3D motion lab** (below “How it works”). There is no production route/link. No storage, lesson assessment, practice time, or rewards are affected.

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

- Apply the editorial hierarchy to Explore, programme/lesson discovery and vocabulary after reviewing each screen's purpose. Don't put a promotional hero on forms or active exercise pages.
- Audit legacy badge foregrounds and small type, card semantics, shimmer reduced-motion behavior, and raw-palette usage outside the adopted slice. These are existing inconsistencies, not solved by a token rename.
- Commission battle/cypher imagery with consistent crops and explicit rights. Add only purpose-driven, opt-in instructional video.
- Keep real light-host, expanded disclosure, large-text and root-dialog tests alongside every migrated screen. Component stories alone are not acceptance.

## Verification

`bash tool/checks.sh` is the required core gate. Major composition/assets also require `bash tool/check_web_quality.sh`. Home interaction regression can be exercised with `bash tool/check_integration.sh`. The lab has deterministic controller tests; Home, practice, the player and the lab have rendered surface coverage in `test/feature_surface_contract_test.dart`.

Local visual captures and logs are under ignored `build/design-refresh/`; they are not source assets.

### Local outcomes (2026-09-23)

- Core gate passed: analyzer clean, 232 tests passed.
- Browser integration passed; Widgetbook code generation and analysis passed.
- Release Web Wasm + JS fallback build and Lighthouse gate passed: performance 55, accessibility 100, best practices 81, SEO 100; 8.10 MiB transferred, no console errors or failed requests. Lighthouse printed a non-fatal Lantern `NO_LCP` diagnostic; these are the gate's reported scores, not a lab-renderer benchmark.
- Current Android debug screenshots inspected for Home, daily practice, active player and motion lab, including expanded disclosures, large text and a wide Home layout. The live lab exercised half-speed playback, pause, side view and its loop. Runtime error check was empty.
- Home's headerless immersive scroll viewport now respects the status-bar inset; the regression has a focused scaffold test. Emulator font scale was restored to 1.0 and portrait orientation after checks.
- No physical-device performance result, iOS execution, skinned-model rendering result, or production-teacher readiness is claimed.
