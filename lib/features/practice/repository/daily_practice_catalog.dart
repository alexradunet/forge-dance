import '../../method/model/forge_method.dart';

/// Bundled English instructional content, like the common-foundation lessons.
/// Variations are ordered White (0) through Black (7); complexity, not speed,
/// is the progression. Lesson links are references, not completion credit.
class DailyPracticeVariation {
  const DailyPracticeVariation(this.title, this.drill, this.application);

  final String title;
  final String drill;
  final String application;
}

class DailyPracticeTheme {
  const DailyPracticeTheme({
    required this.id,
    required this.title,
    required this.focus,
    required this.category,
    required this.lessonId,
    required this.warmup,
    required this.cooldown,
    required this.conditioning,
    required this.seated,
    required this.supported,
    required this.variations,
  });

  final String id;
  final String title;
  final String focus;
  final ForgeCategory category;
  final String lessonId;
  final String warmup;
  final String cooldown;
  final String conditioning;
  final String seated;
  final String supported;
  final List<DailyPracticeVariation> variations;
}

/// A continuous civil-day rotation, including leap days and dates before epoch.
/// Rebuilding midnight in UTC avoids local DST elapsed-hour discontinuities.
DailyPracticeTheme dailyPracticeThemeFor(DateTime date) {
  final day = DateTime.utc(date.year, date.month, date.day);
  final offset = day.difference(DateTime.utc(2026, 1, 1)).inDays;
  return dailyPracticeThemes[offset % dailyPracticeThemes.length];
}

const dailyPracticeThemes = <DailyPracticeTheme>[
  DailyPracticeTheme(
    id: 'pulse-and-pause',
    title: 'Pulse & Pause',
    focus: 'Keep a clear pulse while changing accents and silence.',
    category: ForgeCategory.rhythm,
    lessonId: 'common-time-weight-rhythm-patterns',
    warmup: 'Open and release one hand slowly. Notice a comfortable repeating pace, then mark four easy pulses with a tap or gesture and rest.',
    cooldown: 'Let the pulse gesture become smaller for four counts, then stop. Release fingers and shoulders and return to uncounted, natural breathing.',
    conditioning: 'Repeat easy single taps or low-impact pulses; keep the beat simple rather than repeating the hardest rhythm.',
    seated: 'Keep your seated base supported and mark every pulse or accent with an available hand, finger or other comfortable gesture; remain seated.',
    supported: 'Maintain contact with a stable support. Mark rhythm with a free hand or small pressure changes without releasing the support.',
    variations: [
      DailyPracticeVariation(
        'Discover a pulse',
        'Listen to, see or create four slow timing cues. Notice them first, then try one comfortable tap when you choose; matching every cue is not required.',
        'Choose one cue to join and one cue to watch without moving. Try again and notice the difference between moving and waiting.',
      ),
      DailyPracticeVariation(
        'Join and restart',
        'Tap on eight evenly spaced cues, rest for four cues, then restart. Use your own count or a visual pulse if audio is not useful.',
        'Perform two rounds of eight taps and four silent counts. Keep counting during the pause so the restart lands on the next pulse.',
      ),
      DailyPracticeVariation(
        'Place an accent',
        'Tap two groups of four and make the first tap of each group distinct using size or intention, not extra force.',
        'Keep the first-count accent while changing the tapping gesture for the second group of four. Preserve the spacing of all taps.',
      ),
      DailyPracticeVariation(
        'Hold a silent count',
        'Repeat tap, tap, rest, tap across four even counts. Trace the silent count mentally before restarting the pattern.',
        'Alternate four plain taps with tap, tap, rest, tap. Return to plain taps without shortening the silent count.',
      ),
      DailyPracticeVariation(
        'Divide and reunite',
        'Alternate four single-beat taps with four pairs of even half-beat taps. Keep the underlying count at the same pace.',
        'Make an eight-count rhythm: single taps for counts one to four, paired taps for five and six, silence on seven, one tap on eight.',
      ),
      DailyPracticeVariation(
        'Move the accent',
        'Keep four-count taps even while placing the accent on one, then two, then three, then four over successive groups.',
        'Repeat tap, tap, rest, tap with an accent on one, then on four. Preserve the missing third tap while the accent moves.',
      ),
      DailyPracticeVariation(
        'Switch rhythmic layers',
        'Keep a small beat gesture in one available area while another marks only counts one and three. Rehearse each layer separately first.',
        'Keep the beat layer unchanged; move the second layer to counts two and four, remove it for a group, then restore it on one and three.',
      ),
      DailyPracticeVariation(
        'Transform and recover a motif',
        'Create a repeatable eight-count motif containing an accent, a silent count and a paired subdivision. Name its event order and reproduce it twice.',
        'Perform the motif, shift its accent without changing event order, then move its silence to another count. Recover the original exactly after a rest.',
      ),
    ],
  ),
  DailyPracticeTheme(
    id: 'clear-initiations',
    title: 'Clear Initiations',
    focus: 'Choose where movement starts and keep its pathway readable.',
    category: ForgeCategory.bodyControl,
    lessonId: 'common-ready-body-body-map',
    warmup: 'Release your hands and make small comfortable shoulder glides. Explore one available area at a time; let the rest respond without bracing.',
    cooldown: 'Reverse one small, comfortable glide back to neutral. Release any effort used to isolate and let the whole body settle into its support.',
    conditioning: 'Alternate easy hand openings and small shoulder glides, returning to neutral between them; leave complex isolation layers out.',
    seated: 'Stay in a stable seated base with supported feet or your usual supports. Use hands, shoulders or another available area; avoid leaning to create range.',
    supported: 'Keep one contact on a stable support. Use a free hand or a comfortable shoulder glide and keep your base unchanged.',
    variations: [
      DailyPracticeVariation(
        'Notice one beginning',
        'Choose a comfortable hand or shoulder. Explore a tiny movement and notice where it starts; let other areas respond naturally, then rest.',
        'Try the same beginning twice with a pause. Name or notice the starting area without trying to hold the rest of the body rigid.',
      ),
      DailyPracticeVariation(
        'Start and return',
        'Move one chosen area a small distance, pause and return to neutral. Repeat four times with a clear beginning each time.',
        'Perform the movement on your own start cue, return fully, and wait before repeating. Notice whether the start stayed in the chosen area.',
      ),
      DailyPracticeVariation(
        'Alternate initiators',
        'Choose two available areas, such as hand and shoulder. Start with the first, return, then start with the second; keep a pause between them.',
        'Use the order first, second, second, first. Make the initiating area clear without increasing range.',
      ),
      DailyPracticeVariation(
        'Connect two beginnings',
        'Let a hand-led movement pass into a shoulder-led response, or choose two other available areas. Practice each link slowly with a relaxed base.',
        'Connect the two initiations without a pause, then reverse their order. Keep the transfer of leadership visible or felt.',
      ),
      DailyPracticeVariation(
        'Trace and redirect',
        'Use one area to trace a small forward, side and return pathway. Repeat from a different initiating area while keeping the same three directions.',
        'Link two pathways with different initiators and insert a clear stop at the change of leader. Avoid forcing the end of any range.',
      ),
      DailyPracticeVariation(
        'Contrast continuous and stopped',
        'Repeat a two-initiation pathway once flowing and once with clear stops. Change continuity rather than muscular force.',
        'Perform flowing, stopped, flowing versions in sequence. Keep both the starting areas and spatial pathway recognizable.',
      ),
      DailyPracticeVariation(
        'Sustain an independent layer',
        'Repeat a tiny hand opening while a second available area glides side and returns. Learn the parts alone, then preserve the hand rhythm during the glide.',
        'Keep the repeating layer steady while redirecting the glide forward. Remove and restore the glide without interrupting the repeating action.',
      ),
      DailyPracticeVariation(
        'Reassign the leader',
        'Compose a three-initiation phrase from available areas. Repeat it, then begin from a different area while preserving the phrase pathway and timing.',
        'Perform the original phrase, the new-leader version and a stopped-texture version. Return to the original and identify the moment leadership changed.',
      ),
    ],
  ),
  DailyPracticeTheme(
    id: 'weight-and-pathways',
    title: 'Weight & Pathways',
    focus: 'Organize supported transfers and recover a clear home base.',
    category: ForgeCategory.footwork,
    lessonId: 'common-time-weight-transfer-weight',
    warmup: 'Find a stable home base. Notice the pressure at your contact points, then make tiny side-to-side pressure changes with all needed support maintained.',
    cooldown: 'Reduce each pressure shift until you are back at your home base. Let the contact points settle and release unnecessary effort in hands and legs.',
    conditioning: 'Repeat small side-and-return pressure shifts or comfortable step-touches without crossing, turning or lifting away needed support.',
    seated: 'Remain seated with a supported base. Translate each step or direction into a hand tap in that direction or a comfortable seated pressure change; do not stand.',
    supported: 'Keep contact with a stable wall, chair or usual mobility aid. Replace steps with partial pressure transfers and keep both feet down when needed; do not pivot.',
    variations: [
      DailyPracticeVariation(
        'Discover your base',
        'Notice which contact points carry you. Try a tiny pressure change toward one side and return; no contact point needs to lift.',
        'Choose a comfortable side, make one partial shift and find home again. Pause and notice what support made the return easy.',
      ),
      DailyPracticeVariation(
        'Shift and settle',
        'Alternate a small side shift and a return to home for four rounds. Pause at home before changing sides; use the seated or supported substitute as needed.',
        'Link left, home, right, home at a comfortable pace. Finish each transfer or hand tap before beginning the next.',
      ),
      DailyPracticeVariation(
        'Add a second direction',
        'Practice side, home, forward, home with small transfers or directional hand taps. Keep each return distinct.',
        'Perform the four-event route twice, then start with forward instead of side. Keep the home base in the same place.',
      ),
      DailyPracticeVariation(
        'Link a step-touch route',
        'Use side, together, side, together with small low-impact steps, or the equivalent hand-tap sequence. Settle support before the next event.',
        'Connect one step-touch route to forward, home, side, home. Pause at the join if you cannot recover the home base clearly.',
      ),
      DailyPracticeVariation(
        'Change the timing of a route',
        'Repeat side, home, forward, home evenly, then hold the first direction for an extra count and leave home equally unhurried.',
        'Alternate an even route and a held-first-direction route. Preserve directional order and full support rather than rushing to catch up.',
      ),
      DailyPracticeVariation(
        'Choose a new destination',
        'Repeat a familiar four-event route. Before each restart, choose side or diagonal as the first destination; mark directions with taps if travel is unsuitable.',
        'Use two side-start routes followed by one diagonal-start route. Keep the same home base and prepare the new direction before transferring.',
      ),
      DailyPracticeVariation(
        'Switch routes and recover',
        'Define A as side, home, forward, home and B as diagonal, home, side, home. Practice each separately without crossing steps or turning your base.',
        'Switch A to B on your own cue, pause at home, then resume A. Keep the timing and contact support consistent through the switch.',
      ),
      DailyPracticeVariation(
        'Transform a pathway deliberately',
        'Compose two four-event routes with different directions and a shared home. Perform A then B, and redesign one destination without losing either return.',
        'Perform A, revised B, original B, A. Change the pause placement in the final A while preserving its route and a controlled recovery.',
      ),
    ],
  ),
  DailyPracticeTheme(
    id: 'parts-in-conversation',
    title: 'Parts in Conversation',
    focus: 'Combine available movement regions without losing either part.',
    category: ForgeCategory.coordination,
    lessonId: 'common-space-coordination-parts-together',
    warmup: 'Find two comfortable movement regions, such as fingers and shoulder. Move each separately, release it, then try a small action in both together.',
    cooldown: 'Remove one movement layer, make the remaining layer smaller, then stop. Relax each region separately and settle your breathing.',
    conditioning: 'Repeat a simple alternating action in two available regions. Drop back to one region whenever coordination or breathing becomes less comfortable.',
    seated: 'Keep the seated base still and supported. Coordinate two available regions such as fingers and shoulder; hand and foot labels do not require leg movement.',
    supported: 'Keep a stable support contact throughout. Choose two available regions that do not require letting go, such as free fingers and a small shoulder gesture.',
    variations: [
      DailyPracticeVariation(
        'Meet the two parts',
        'Explore one small action in an available region, rest, then explore a second region. There is no need to move them together yet.',
        'Choose which region moves first and let the other answer after a pause. Notice the change of region rather than keeping a rhythm.',
      ),
      DailyPracticeVariation(
        'Alternate two actions',
        'Alternate the two chosen actions slowly for four events. Keep the inactive region comfortable rather than rigid.',
        'Repeat first, second, first, second; rest and restart with the second region. Keep each event separate.',
      ),
      DailyPracticeVariation(
        'Share a pulse',
        'Practice an easy pulse in one region and an opening gesture in another separately, then perform both on the same four counts.',
        'Alternate four counts together with four counts using only the pulse region. Bring the opening gesture back on the next first count.',
      ),
      DailyPracticeVariation(
        'Change the relationship',
        'Let the first region move on counts one and three and the second on two and four. Then try both together on one and three.',
        'Perform one alternating group and one together group. Say or imagine the change before beginning the next group.',
      ),
      DailyPracticeVariation(
        'Use two rates',
        'Keep one region moving on every count while the other moves every second count. Rehearse each rate alone before combining.',
        'Sustain the two rates for eight counts, rest, then swap which region carries the slower rate without changing the pulse.',
      ),
      DailyPracticeVariation(
        'Redirect one layer',
        'Keep one region pulsing while another traces side, return, forward, return. Make the tracing layer smaller if the pulse drifts.',
        'Preserve the pulse and reverse the tracing order to forward, return, side, return. Restore the original order after eight counts.',
      ),
      DailyPracticeVariation(
        'Remove and restore',
        'Combine a steady pulse with a second region moving every two counts. Remove the second layer for four counts while keeping the pulse unchanged.',
        'Restore the second layer on the next first count, then switch it to the intervening counts. Return to its original timing after a rest.',
      ),
      DailyPracticeVariation(
        'Reorganize without losing the anchor',
        'Build a pulse layer and a four-event directional layer. Practice changing the directional layer from every count to every second count while the anchor stays steady.',
        'Change only the directional layer, remove it, restore it, then exchange layer roles after a clear pause. Recover the original combination and identify the hardest handover.',
      ),
    ],
  ),
  DailyPracticeTheme(
    id: 'phrase-and-recall',
    title: 'Phrase & Recall',
    focus: 'Retrieve a movement phrase instead of continuously copying it.',
    category: ForgeCategory.retention,
    lessonId: 'common-quality-phrase-recall-adapt',
    warmup: 'Choose two easy gestures, such as hand open and small reach. Explore each comfortably and give each a short name before linking them slowly.',
    cooldown: 'Recall just the first comfortable gesture, make it smaller and let it finish. Rest without rehearsing and notice which memory cue was helpful.',
    conditioning: 'Repeat a familiar two-gesture phrase at an easy pace. Keep the sequence visible or named if needed; this round is not a memory test.',
    seated: 'Remain in your supported seated base and build every phrase from available hand, arm or other comfortable gestures; replace travel with a directional gesture.',
    supported: 'Maintain your usual stable support throughout. Build the phrase from free-hand gestures or partial pressure shifts without changing your support contact.',
    variations: [
      DailyPracticeVariation(
        'Remember one gesture',
        'Choose one comfortable gesture and give it a word or image. Try it once while looking at the cue, then rest.',
        'Look away from the cue and try the gesture again. Check afterwards; forgetting is information, not a failed assessment.',
      ),
      DailyPracticeVariation(
        'Recall a pair',
        'Choose two gestures and name them A and B. Practice A then B, pause for four natural breaths, and try the order without looking.',
        'Retrieve A then B after another short rest. Check the cue only after trying, and repeat the transition if the order changed.',
      ),
      DailyPracticeVariation(
        'Chunk four events',
        'Use open, reach, close, return or four accessible alternatives. Learn the first pair and second pair separately before joining them.',
        'Rest for four breaths, then recall all four events. If one transition is missing, rehearse that pair and retrieve the whole phrase again.',
      ),
      DailyPracticeVariation(
        'Join two chunks',
        'Make A from four familiar events and B from four different events. Name each chunk and rehearse only the A-to-B join before a full run.',
        'After a short rest retrieve A then B without a continuous cue. Check event order afterwards and repair the join rather than starting over repeatedly.',
      ),
      DailyPracticeVariation(
        'Retrieve after a distraction',
        'Learn an eight-event phrase in two chunks. Look around and name three objects, then attempt recall before checking your notes.',
        'Retrieve the phrase after a longer comfortable rest. Mark any missing event, repair only its neighboring transition, and try again without the cue.',
      ),
      DailyPracticeVariation(
        'Keep order under a change',
        'Retrieve a known eight-event phrase after a rest. Perform a smaller version with the same event order, avoiding any new balance demand.',
        'Alternate original-size and small versions from memory. Check whether a size change altered any event or transition, then restore the original.',
      ),
      DailyPracticeVariation(
        'Reorder whole chunks',
        'Create two named four-event chunks A and B. Retrieve A–B, rest, then retrieve B–A while keeping each chunk internally unchanged.',
        'Choose A–B–A or B–A–B before starting. Perform the chosen order without a running cue and check the two joins afterwards.',
      ),
      DailyPracticeVariation(
        'Reconstruct and adapt independently',
        'Write or name a three-chunk phrase, rehearse it and rest. Reconstruct it before reviewing the cue; locate and repair only the missing transitions.',
        'Retrieve the repaired phrase in a smaller size with a deliberate pause at one chunk boundary. Restore the original size and timing, then record the cue that helped retrieval.',
      ),
    ],
  ),
  DailyPracticeTheme(
    id: 'motif-and-contrast',
    title: 'Motif & Contrast',
    focus: 'Make one movement idea recognizable while changing its quality.',
    category: ForgeCategory.creativity,
    lessonId: 'common-make-communicate-prompted-improvisation',
    warmup: 'Explore one comfortable hand or arm pathway slowly. Try a small straight version and a small curved version without stretching farther.',
    cooldown: 'Choose the softest version of your motif. Let it become smaller, give it an unhurried ending and release hands and shoulders.',
    conditioning: 'Repeat one easy gesture with a relaxed, flowing quality. Keep the motif familiar; do not add new creative constraints during the work interval.',
    seated: 'Keep a stable seated base. Express pathway, size and texture through available gestures or focus; changes of level do not require standing or leaning.',
    supported: 'Keep a stable support contact and express the motif with a free region. Contrast timing, pathway or focus instead of leaning, turning or releasing support.',
    variations: [
      DailyPracticeVariation(
        'Explore one possibility',
        'Choose any comfortable gesture and try it once. Pause, then explore a slightly different pathway; there is no required shape or correct look.',
        'Choose the version you want to repeat and give it a clear ending. Notice one quality you enjoyed without judging difficulty.',
      ),
      DailyPracticeVariation(
        'Repeat a chosen idea',
        'Choose a short gesture as your motif. Perform it three times with the same beginning and ending, resting between attempts.',
        'Perform the motif, pause, and repeat it in a smaller size. Keep its pathway recognizable.',
      ),
      DailyPracticeVariation(
        'Contrast smooth and paused',
        'Perform a two-event motif smoothly, then repeat it with a pause between events. Keep the same pathway and comfortable range.',
        'Alternate smooth and paused versions, then finish with your preferred version. Identify the timing change that made the contrast clear.',
      ),
      DailyPracticeVariation(
        'Create inside a constraint',
        'Use one available region and two directions to make a four-event motif. Explore three orders while keeping the same region in charge.',
        'Select one order and repeat it. Replace only one direction, perform both versions, and notice what still identifies the motif.',
      ),
      DailyPracticeVariation(
        'Compose a return',
        'Make A as a flowing motif and B as a paused motif using the same comfortable gestures. Rehearse a clear ending for each.',
        'Perform A–B–A with deliberate joins. Change the final A to a smaller size while preserving its flowing identity.',
      ),
      DailyPracticeVariation(
        'Communicate an intention',
        'Choose an intention such as inviting or searching. Shape a motif through timing or orientation, then make a contrasting version without adding force.',
        'Perform the two versions without naming the intention first. Describe concrete differences in pause, focus or pathway rather than labeling one better.',
      ),
      DailyPracticeVariation(
        'Transform one variable at a time',
        'Create a repeatable four-event motif. Make one version with changed pauses and another with a changed pathway while holding other choices steady.',
        'Perform original, timing version, pathway version, original. Keep enough of the event structure that each transformation is recognizable.',
      ),
      DailyPracticeVariation(
        'Compose, revise and recover',
        'Compose a short A–B–A phrase with contrasting qualities and a clear ending. Revise one join or repetition to support an intention you choose.',
        'Perform the original and revised composition, then reconstruct the original. Explain which timing, focus or texture decision changed the message and why you kept or rejected it.',
      ),
    ],
  ),
];
