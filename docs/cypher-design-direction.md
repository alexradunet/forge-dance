# Forge / underground cypher — design direction and adoption

## Direction

The user selected an underground dance-battle identity, real dance photography/video, and an **interactive movement teacher**, not an avatar customizer or decorative 3D mascot.

This updates the visual direction of [the foundation refresh plan](design-system-refresh-plan-2026.md). Its semantic theming, accessibility, pure component, and offline-first contracts remain in force. The routed and programmatic product-surface rollout is inventoried below. This does not claim that every unused design-system specimen or native platform surface has been redesigned.

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
| `FgPhotoTile` / `FgPhotoTileLayout` | One native destination action per image card; two-up discovery becomes stacked at large text | Available in Widgetbook; Home now uses compact links |
| `FgButton` | Crisp rounded default; long labels wrap; native focus/keyboard/disabled/loading behavior; pill/circle still explicit choices | Existing application callers |
| `FgBackground` | Matte immersive default; decorative gradients opt-in | Existing immersive flows |

Keep feature-owned copy/localization and view-model intents outside the design system. Do not add a second feature-local version of these surfaces. New component state matrices are in Widgetbook. `test/cypher_design_system_test.dart` supplements actual screen contracts with a scoped adoption guard against raw palette values and text sizes.

Home and Learn now use `FgImmersiveScaffold` and its builder context, including under a light host. No appearance preference is changed. Existing profile, curriculum, daily scheduling, safety, unsaved-session protection, and persistence behavior are retained.

Home and the Workout tab use bundled editorial preview photos: the existing ~148 KB hero plus two additional WebPs (~340 KB total). These are explicitly placeholder/inspiration images, not adjacent movement demonstrations or instructor identities; no activity or progress is fabricated. See [asset provenance](../assets/images/CREDITS.md). Learn catalogue thumbnails remain cached network images. No video autoplay or renderer dependency is added to startup.

### Home density refinement

Home retains only the first **Continue Training** card, even when several modules are in progress. Other learning paths remain available through Learn. The oversized **Make it your own** heading and photo tiles are removed; Learn and Programmes remain compact links alongside assessments and the logbook. The hero, actual current-lesson action, progress, recommendations and full disclosures are preserved.

Rendered Home contracts cover multiple in-progress modules at320/1040px with2× text, the retained lesson destination and compact Learn/Programme routes. Core409 tests, browser integration and release-web quality checks pass (55/100/81/100;8.11MiB;zero console errors/failed requests). Current normal/2× collapsed/expanded emulator captures are under ignored `build/home-simplification/`; the disconnected physical phone has not received this update.

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

## Adoption follow-through

- The product destination audit below supersedes the initial remaining-page list. It includes programmatic children, root media, all legacy circuit branches, and shell departure guards—not only tabs.
- Commission battle/cypher imagery with consistent crops and explicit rights. Add only purpose-driven, opt-in instructional video. Written lesson/circuit instruction is explicitly not a movement demonstration.
- Keep real light-host, expanded disclosure, large-text and root-dialog tests alongside every migrated screen. Component stories alone are not acceptance. Native import/playback and platform performance require real media/device evidence, not fake transport tests.

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

## Exhaustive remaining-surface adoption audit (A/B/C, 2026-09-23)

Audit base: `afbf9bfae7711e91c0b27bf08098905c092d23ad`. **Changed** means this rollout changed the actual product composition; **regression** means an already-revised surface was preserved and exercised by the shared-component tests. Live observations belong to the parent, recorded in ignored `build/all-pages-refresh/live-review.md`; a checkpoint is not blanket final-tree visual acceptance.

The central rendered suite is `test/feature_surface_contract_test.dart`, with `personal_surface_contracts.dart`, `learning_surface_contracts.dart`, `remaining_surface_contracts.dart`, and `review_surface_contracts.dart` as parts. It resolves real screens under a light host, checks actual painted backing/text contrast (including decorated fills), and exercises 320/1040px at 2× text for changed destinations. Private destinations below are opened through their public caller, not substituted with mock screens. Specialized player/shell/component suites remain alongside it.

| Destination / entry | Adoption and retained states | Automated / parent live evidence |
|---|---|---|
| Splash `/` | **Changed A**: true profile readiness, no fake timed progress | Personal contracts; parent light-host normal/narrow/wide large-text diagnostic of actual screen |
| Onboarding `/onboarding` | **Changed A**: local name validation, busy save/failure, keyboard submit | Personal contracts; isolated browser actual onboarding/Enter |
| Home `/main/home` | **Regression**: poster, actual next lesson, utility disclosures, loading/error | Central Home/photo navigation contracts; parent `home-c-regression.png` after nav changes |
| Learn `/main/explore` | **Regression**: search/clear/empty, prerequisite status, links and retry | Central rendered/search contracts; parent final normal/2× shared regression montages |
| Module `/main/module/:moduleId` | **Changed B**: numbered editorial lesson path, actual available/current/completed/locked progress | Learning contracts; `module-after.png`, `module-large.png` |
| Lesson `/main/module/:moduleId/lesson/:lessonId` | **Changed B**: loading/error/locked, all five lesson types, full written cues/details, guarded completion/retry | Central + `lesson_player_screen_test.dart`; compact 2× cues/normal/expanded parent screenshots |
| Collection `/main/explore/history` | **Changed B**: zero-history vs filtered-empty, content-sized cards, actual draft filter/apply/reset and column popup | Learning contracts; actual filter sheet normal/2× and populated history screenshots |
| Vocabulary `/main/vocabulary` (`/main/library` redirects here) | **Regression**: alias/style/kind filters, offline references and actual status | Central index/filter/large-text contracts; parent final normal/2× shared regression montages |
| Vocabulary reference `/:entryId` | **Regression composition; changed C save guard**: complete definition/cue/safety, prerequisites, lesson/Method/log/evidence links, exact pending practice record | Central reference + actual GoRouter failure/retry/discard contracts at 2×; parent real pending failure/retry/discard panel at390/light/2× in disposable harness |
| Method `/main/method` | **Changed B**: overview, honest self-assessment vs XP, method/belt disclosures, error/retry | Learning contracts; parent overview and expanded explanations normal/2× |
| Method category / dated attempt (Navigator) | **Changed B**: category status, dated criteria/reflection/evidence, no invented attempt | Learning contracts now open the actual root EvidenceViewer at both widths; parent actual populated fixture normal/2× and expanded dated history; distinct evidence action opens root viewer after semantic fix |
| Assessment form (Navigator / initialAssessmentId) | **Changed B**: visible criteria/safety, adaptations, confirmation and notes validation, save/error/retry with same attempt ID | Learning + actual shell imperative-save guard; parent form/actions normal/2×, no Android assessment save |
| Daily Practice `/main/practice` (Workout tab) | **Regression**: photo preview, numbered rounds, preferences/safety, pending-result discard, busy guards | Central + real GoRouter pending-save tab guard; parent final normal/2× shared regression montages |
| Practice player (root Navigator) | **Regression**: real clock/count-in/pause, guidance/notes retained, lifecycle pause, audio, caller-owned result | Central/player specialist tests; no decorative media or production teacher added; parent live player2× rechecked in actual pending-result flow |
| Practice log `/main/practice/log` and filtered programmatic callers | **Changed B**: dated real records, comparable/no-comparable details, error/retry, delete confirmation | Learning contracts plus C actual root evidence opening; isolated browser populated/expanded/delete cancel+confirm |
| Reflection form (log → edit) | **Changed B**: validation, retained error/busy back guard, measured fields unchanged | Actual parent interaction contracts; isolated browser normal/2× form/validation reviewed |
| Programme discovery `/main/programmes` | **Regression**: real enrolment/progress, inspectable locked programmes | Central contracts; parent final normal/2× shared regression montages |
| Programme detail (Navigator) | **Changed B; C departure safety**: next session, full rest/schedule disclosure, gates, enrolment busy guard and exact pending practice retry/discard | Learning + real GoRouter 2× pending/busy enrol tests; review contracts independently drive learning and enrolment loading/error/retry; parent normal/expanded/2× composition and pending panel at1×/2× with discard confirmation |
| Profile `/main/profile` | **Changed A**: actual identity/belt/progress, level grid, Settings/Method | Personal contracts; parent normal/2× including initials correction |
| Belt progression (actual Profile bottom sheet) | **Changed A; regression B**: selected belt, requirements, earned/current/locked, method disclosure and action | Actual sheet loaded/loading/error/dismiss/recover contracts; parent normal/2× expanded belt recheck |
| Settings `/settings` | **Changed A**: constrained editorial menu, version and external links retained | Personal contracts; parent normal/2× |
| Account `/accountInformation` | **Changed A**: local avatar/name, real email display, dirty/busy/error, blocking save overlay | Personal + loading-overlay contracts; parent normal/2× keyboard/Confirm, no Android import/save |
| Appearance `/appearances` | **Changed A, intentionally standard themed utility**: explicit System/Light/Dark selection only | Light-host contrast/selection contracts; parent wide light-host + Android normal/2× |
| Backup `/settings/data` | **Changed A**: export/import, full inclusion disclosure, visible restore consequence, busy guard, root cancel/confirm | Personal/central fake transfer contracts; parent normal/2× expanded content |
| Stats `/stats` | **Changed B**: real XP/streak/mastery/max-belt, loading/error | Learning contracts; parent actual light-host route at390/1040 |
| Legacy circuit preview `/main/workout` | **Changed C**: full purpose, metadata and numbered exercises; separate explicit start | Remaining + training tests; parent normal/2× `legacy-overview-refined.png`, `legacy-overview-large.png` |
| Legacy circuit `/main/workout/session` | **Changed C**: loading/retry, explicit timer, deliberate skip, keyboard gating, lifecycle pause, full safety; no unrelated photograph/docking stage | Remaining/training tests incl compact 1040×400/2×; parent portrait and `legacy-session-compact-cues.png` |
| Circuit exit modal / completion summary | **Changed C**: cancel preserves paused exercise; stale locked SKIP removed/guarded; actual save/loading/error/retry, duplicate/back guards, reward only after durable result | Actual locked-next→exit/captured stale action, saving and same-day persistence tests; midnight retry identity tests include committed-then-failed writes; parent exit normal/2× and actual success summary at390/light reviewed in disposable browser storage |
| EvidencePicker (assessment, reflection, player) | **Changed C**: editorial local selection; busy import/view/unlink/delete, loading/missing metadata, mapped quota/size/storage/unsupported errors, complete privacy disclosure | Actual picker metadata loading/error, held import/delete busy and library/delete contracts; parent actual missing-ID picker, privacy, empty library and delete cancel under light host |
| Media library + removal root dialogs | **Regression with C busy/scroll safety**: real empty/list/selection; explicit destructive consequence, cancel/confirm | Remaining 320/1040/2× contracts with repository doubles; parent empty/remove-cancel live, populated list/native IO unverified |
| EvidenceViewer (root from Method/log/reference/picker) | **Changed C**: constrained full-page warning precedes video/failure; no new fullscreen mode invented | Actual Method/log/picker routes tested; parent real missing-ID viewer collapsed/expanded at390/2× and1040/1× in isolated harness |
| LocalVideoView embedded controls | **Changed C**: native creation only after local bytes, safe missing/init failure/disposal; no autoplay, explicit transport/mirror/speed/seek/loop, lifecycle pause and recorded-perspective disclosure | Platform-safe fake transport covers ready/expanded/error/loop/disposal at2×; missing-ID live only. Native decoded video/import/iOS unverified |
| Main shell / bottom navigation | **Changed C**: matte semantic surfaces, native keyboard/selected semantics, whole labels wrap as controls, safe reserved space, real destination mapping; lesson/circuit session routes remain immersive | Actual GoRouter tests for blocked Practice/Method/Programme/Vocabulary saves and allowed idle details; parent orphan-label fix rechecked normal/2× and ordinary Home tab |
| Debug motion lab (Home disclosure, debug only) | **Regression**: warning and synthetic projected rig remain prototype-only | Central + deterministic controller tests; parent final normal/2×/controls/expanded limitations screenshots; no production 3D claim |
| Global offline banner | **Regression; C web guard**: offline-first semantics/reflow retained; avoid calling native Platform.isIOS on web | Real connectivity-channel offline/online events with Home at320/1040px/2×, banner contrast/live-region; native platform switching live not re-exercised |
| Blocking save overlay | **Regression**: route-scoped progress, blocking barrier, finally dismissal | Existing `global_loading_test.dart` and account contracts; no new overlay style or persistence IO |
| Shared root alert, filters, popup/sheets and snackbars | **Shared alignment**: Forge alert helper uses immersive root theme and scrollable copy; real belt/filter/player popups use established immersive context; status/error/badge contrast paired semantically | Central actual restore/delete/filter/phrase/sheet interactions + four-theme badge and root-alert component tests; parent belt/filter/delete/cancel evidence above |
| OS avatar/video/file pickers, sharing, external policy/rating URLs | **Preserved native boundaries**, not replacement product pages | Repository/route tests preserved. No fabricated media or cross-platform IO success; actual native picker/share behavior remains unverified in this rollout |

### Independent-review resolution and final worker gates

Both independent reviews were accepted as actionable; no concrete regression finding was dismissed as cosmetic.

- **Behavior P1 — wrong lesson after retry:** `LessonPlayerScreen` now resolves the globally unique route ID with `LearnState.lessonById`, handles an unknown ID explicitly and retains prerequisite checks. The central non-first-module regression fails a completion, reloads (resetting active-module selection), checks the original final-step content and confirms both submissions use the same lesson ID.
- **Behavior P2 — midnight circuit retry:** `WorkoutViewModel` retains the first completion moment until persistence succeeds and passes it to the existing `TrainingActivity.completeWorkout(now:)` seam. Controlled before/after-midnight tests cover both pre-write failure and a committed write that reports failure; retry targets one original daily record, never a second day.
- **Final challenge P2 — Discard boundary:** accepted the retained-provider edge identified in `build/all-pages-refresh/review-discard-boundary.md`. Confirmed circuit Discard now calls the explicit `WorkoutViewModel.abandonCompletion()` intent; Cancel and failed-save Retry do not reset the attempt, and no durable record is deleted. Four real nested overview/session contracts retain the identical overview State and notifier across navigation, use only a test clock override around the real completion method, and delegate writes to the actual local repository. They cover pre-write and committed-then-failed saves: Cancel/retry keeps the original date; Discard/new session after midnight uses the new date, preserves an earlier commit and awards exactly once per durable record. Parent's post-reload Android Cancel/Discard/new-session smoke (`discard-smoke-modal.png`, `discard-smoke-new-session.png`) is navigation-only, not live midnight/failure evidence.
- **Coverage P1 — missing loading/error/busy branches:** central real-screen cases now drive Programme detail learning and enrolment independently through loading/error/retry; the actual Profile belt sheet through loading/error/dismiss/recovery; EvidencePicker through held metadata/error/import/delete; and the real global offline banner through connectivity-channel events while Home remains usable. All use a light host and 320/1040px at 2× text. No source-string substitutes.
- **Coverage P2 — rendered contrast:** shared assertions now composite translucent painted layers and foregrounds, include disabled controls, and examine actual visible dialog descendants. Existing selected/status/error screen cases inherit the stronger checks; real backup, history-delete and media-removal dialogs check foreground/backing pairs, not only theme tokens.
- **Coverage P1 — live acceptance:** parent follow-through includes final shared Learn/Programme discovery/Vocabulary/Daily Practice normal/2× montages (`final-shared-normal.png`, `final-shared-large.png`), both actual pending-result panels in a failing-repository harness, and the actual successful legacy circuit summary in disposable production-web storage. Populated Method dated-history fixture normal/2×, actual root evidence navigation, player2× and final debug-lab normal/2×/controls/expanded limitations are also recorded in the final section of `build/all-pages-refresh/live-review.md`. Parent reports no remaining known visual blocker; latest Android runtime and isolated Method/evidence browser console are empty. Prior checkpoints remain labelled, not automatically promoted to fresh screenshots.

- **Parent live semantic finding — merged evidence action:** reproduced the dated Method attempt being exposed as one heading containing the button label. `FgButton` and `FgSectionHeading` now establish their own semantic containers. Central real-screen tests at both widths assert distinct labelled/enabled evidence-button and title-heading nodes, then activate the semantic action to open the actual root viewer. Four-theme shared contracts keep body copy out of heading semantics; existing single-action programme-card keyboard/selection contracts remain green. Parent confirmed the separate browser AX button and actual navigation after reload. This verifies semantic representation/activation, not a claim of physical screen-reader testing.

Final code/test tree, after the discard-boundary fix (the earlier403/209 source barrier and `final-source.sha256` remain historical):

- `timeout --kill-after=10s 420s bash tool/checks.sh`: clean analyzer, **407 tests passed**, `build/all-pages-refresh/discard-core-final.log`.
- Focused central/workout/training/shell/action-primitive/program-card/design-system suite (180s process, 25s per-test bounds): **213 passed**, zero hit-test warnings, `discard-focused-final.log`.
- `timeout --kill-after=10s 360s bash tool/check_integration.sh`: passed actual local-profile/Home browser smoke flow, `discard-integration-final.log`.
- Widgetbook bounded `build_runner build` + analyzer: passed, `discard-widgetbook-codegen.log`, `discard-widgetbook-analyze.log`.
- `timeout --kill-after=10s 600s bash tool/check_web_quality.sh`: Wasm plus JS fallback build and gate passed, **performance53 / accessibility100 / best-practices81 / SEO100**, **8.11MiB**, zero console errors/failed requests. `discard-web-quality-final.log` and `build/lighthouse/forge-dance.report.{json,html}`. Existing non-fatal Lantern `NO_LCP` diagnostic remains visible.
- `git diff --check` and empty index checked. No storage-schema, backend/auth, renderer, media dependency or new photo asset. No staging, commit or push. Unrelated untracked devtools/research files preserved; generated files, diagnostic harnesses, screenshots and build artifacts remain ignored.
- **Honest boundaries:** shell save/departure tests use a purpose-built GoRouter with the actual shell observer/screens, not the full production routing configuration. The browser integration and router lifecycle tests cover production routing separately; they are not a production-router save-guard end-to-end matrix. Native decoded/imported media and delayed native decoder disposal, OS picker/share behavior, iOS and physical-device performance remain unverified; fake transport tests are not native compatibility evidence. No production movement-teacher readiness is claimed.
- Worker performed no device interactions or independent screenshot review. Parent owns live/runtime evidence and the retained reviewer’s final discard-fix verification gate. The prior challenge verified the original fixes, semantics and expanded coverage; its new discard finding is addressed above, not self-approved.
