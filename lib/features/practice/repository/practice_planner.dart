import '../../method/model/forge_method.dart';
import '../model/practice.dart';

/// Every category uses its own demonstrated level, never the overall belt or XP.
/// Lessons are references: practising a drill does not unlock or complete them.
PracticePlan buildPracticePlan({
  required MethodProgress progress,
  required int minutes,
  required bool gentle,
  required bool includeConditioning,
  PracticeSupport support = PracticeSupport.standing,
}) {
  if (minutes < 10 || minutes > 60) {
    throw ArgumentError.value(minutes, 'minutes', 'Choose 10–60 minutes.');
  }
  final categories = <ForgeCategory>[
    ForgeCategory.mobility,
    ForgeCategory.bodyControl,
    ForgeCategory.footwork,
    ForgeCategory.rhythm,
    ForgeCategory.coordination,
    ForgeCategory.retention,
    ForgeCategory.creativity,
    if (includeConditioning) ForgeCategory.capacity,
    ForgeCategory.mobility,
  ];
  final durations = List.filled(categories.length, 1);
  // Preserve both recovery bookends, then distribute remaining time over work.
  var remaining = minutes - categories.length;
  if (remaining > 0) {
    durations[0]++;
    remaining--;
  }
  if (remaining > 0) {
    durations[durations.length - 1]++;
    remaining--;
  }
  for (var i = 0; i < remaining; i++) {
    durations[1 + i % (categories.length - 2)]++;
  }
  final blocks = <PracticeBlock>[];
  final assessedCategories = progress.attempts
      .map((attempt) => attempt.assessment.category)
      .toSet();
  for (var index = 0; index < categories.length; index++) {
    final category = categories[index];
    final assessed = progress.levelFor(category);
    final level =
        (assessed == 0 ? 1 : assessed - (gentle && assessed > 1 ? 1 : 0)).clamp(
          1,
          7,
        );
    final variant = _variants[category]![level - 1];
    final coolingDown = index == categories.length - 1;
    final supportCue = switch (support) {
      PracticeSupport.standing => 'Use a comfortable standing base; keep a chair or wall within reach and avoid impact.',
      PracticeSupport.seated => 'Use a stable chair with supported feet or your usual seated base. Replace steps with hand taps or comfortable pressure shifts; remain seated.',
      PracticeSupport.supported => 'Keep contact with a stable wall, chair or your usual mobility aid. Use partial transfers and gestures rather than unsupported balance.',
    };
    final tempo = gentle ? 50 + level * 4 : 60 + level * 6;
    blocks.add(
      PracticeBlock(
        id: '${coolingDown ? 'cooldown' : category.name}-l$level-${support.name}-${gentle ? 'gentle' : 'regular'}',
        title: coolingDown ? 'Cool down · breath and release' : variant.$1,
        category: category,
        level: level,
        minutes: durations[index],
        bpm: coolingDown ? 50 : tempo,
        lessonId: _lessons[category]!,
        cues: coolingDown
            ? [
                'Let the movement become smaller, then settle into your chosen base.',
                'Breathe normally; release hands and shoulders without forcing a stretch.',
                'Notice how you feel and choose one observation to record.',
              ]
            : [
                supportCue,
                variant.$2,
                if (gentle) 'Work in short comfortable rounds with an equal rest. Reduce range and stop before fatigue changes your control.',
                if (category == ForgeCategory.capacity) 'Use the talk test: keep enough ease to speak a full sentence. Rest whenever needed; never push through pain or dizziness.',
                'Pause between attempts, notice one detail, then repeat. Stop if there is pain, dizziness or unusual breathlessness.',
              ],
        adaptation: [
          if (assessed == 0)
            assessedCategories.contains(category)
                ? 'Working toward level 1: beginner exploration, not an earned level.'
                : 'Not assessed: safe beginner exploration, not an earned level.',
          if (gentle && assessed > 1) 'Reduced one level for a gentler day; your assessed capability is unchanged.',
          supportCue,
          'Reduce size, tempo or layers whenever useful. Rest is part of practice.',
        ].join(' '),
      ),
    );
  }
  return PracticePlan(blocks: blocks);
}

const _lessons = <ForgeCategory, String>{
  ForgeCategory.mobility: 'common-ready-body-bases-breath',
  ForgeCategory.bodyControl: 'common-ready-body-body-map',
  ForgeCategory.footwork: 'common-time-weight-transfer-weight',
  ForgeCategory.rhythm: 'common-time-weight-find-pulse',
  ForgeCategory.coordination: 'common-space-coordination-parts-together',
  ForgeCategory.retention: 'common-quality-phrase-recall-adapt',
  ForgeCategory.creativity: 'common-make-communicate-prompted-improvisation',
  ForgeCategory.capacity: 'common-ready-body-bases-breath',
};

// Authored complexity changes: speed alone is never the progression.
const _variants = <ForgeCategory, List<(String, String)>>{
  ForgeCategory.mobility: [
    (
      'Arrive · comfortable range',
      'Check your space. Slowly open and close your hands, then circle shoulders within a comfortable range while breathing normally.',
    ),
    (
      'Warm up · connected range',
      'Link a comfortable shoulder glide and arm reach. Return to a relaxed base between each pair.',
    ),
    (
      'Warm up · changing planes',
      'Trace a small forward arc then a side arc with an available joint. Keep transitions smooth rather than seeking a larger range.',
    ),
    (
      'Warm up · range and return',
      'Alternate two comfortable reach directions with a controlled return. Change the initiating area while keeping support stable.',
    ),
    (
      'Warm up · coordinated range',
      'Link three available joint actions through a gentle wave. Isolate any transition that feels rushed.',
    ),
    (
      'Warm up · adaptive range',
      'Repeat your warm-up phrase in two sizes. Keep both comfortable and preserve uninterrupted breathing through transitions.',
    ),
    (
      'Warm up · self-directed preparation',
      'Choose a sequence that prepares today’s planned directions and joints. Recheck comfort and deliberately reduce any restricted transition.',
    ),
  ],
  ForgeCategory.bodyControl: [
    (
      'Body map · one area',
      'Move one shoulder or hand while the other areas rest comfortably. Return to neutral and repeat on the other side.',
    ),
    (
      'Control · separate initiations',
      'Alternate shoulder and rib or hand initiations. Pause between them so each beginning is clear.',
    ),
    (
      'Control · connected isolations',
      'Connect two chosen initiations without moving everything at once. Reverse their order after a rest.',
    ),
    (
      'Control · direction changes',
      'Send a small isolation through forward, side and return. Keep its pathway clear as you change the initiating area.',
    ),
    (
      'Control · contrasting qualities',
      'Repeat an isolation phrase smoothly, then with clear stops. Keep the same pathway and an easy base.',
    ),
    (
      'Control · independent layers',
      'Sustain a small repeating action in one available area while changing another area’s direction. Simplify one layer when needed.',
    ),
    (
      'Control · deliberate transformation',
      'Create a three-initiation phrase. Change its lead area and texture while preserving the original pathway, then describe the difference.',
    ),
  ],
  ForgeCategory.footwork: [
    (
      'Weight · shift and return',
      'Shift a small amount toward one supported side, pause, and return. Use hand pressure shifts or taps when seated; no foot has to leave the floor.',
    ),
    (
      'Weight · side and forward',
      'Alternate a side transfer and a forward transfer or hand tap. Reset to your chosen base between directions.',
    ),
    (
      'Footwork · step-touch pathway',
      'Use side, together, side, together at an easy pace, or mirror the sequence with hands. Finish each transfer before beginning the next.',
    ),
    (
      'Footwork · directional phrase',
      'Connect side, return, forward, return. Change facing only within a cleared space; seated gestures can mark each direction.',
    ),
    (
      'Footwork · timing variation',
      'Repeat your four-event pathway once evenly and once with a pause. Preserve clear transfers or tap order rather than adding speed.',
    ),
    (
      'Footwork · recovery choices',
      'Change one direction in a familiar pathway on your own cue. Return cleanly to the beginning without hurried crossing steps.',
    ),
    (
      'Footwork · adaptable pathways',
      'Create two pathways using familiar transfers. Switch between them on a chosen cue while preserving timing, support and a clear recovery.',
    ),
  ],
  ForgeCategory.rhythm: [
    (
      'Pulse · tap and pause',
      'Tap an available hand or foot on each click for eight counts. Stop for four, then begin again with the pulse.',
    ),
    (
      'Pulse · accents',
      'Keep eight steady taps and make the first of each group of four distinct. Repeat without making the other taps faster.',
    ),
    (
      'Rhythm · sound and silence',
      'Repeat tap, tap, rest, tap over four counts. Keep the silent count the same length as the others.',
    ),
    (
      'Rhythm · subdivisions',
      'Alternate four single taps with four pairs of even half-beat taps. Return to the main beat without speeding it up.',
    ),
    (
      'Rhythm · displaced accents',
      'Keep steady taps while moving the accent from count one to count two, then three. Preserve the underlying pulse.',
    ),
    (
      'Rhythm · contrasting patterns',
      'Switch between an even four-count phrase and tap-rest-tap-tap on your own cue. Keep the pulse stable through the change.',
    ),
    (
      'Rhythm · interpret and return',
      'Choose a rhythmic motif, vary its pauses and accents for two phrases, then reproduce the original exactly. Use a visual pulse if preferred.',
    ),
  ],
  ForgeCategory.coordination: [
    (
      'Coordinate · alternate sides',
      'Alternate a left and right hand tap slowly. Keep the pattern small and clear before introducing any other action.',
    ),
    (
      'Coordinate · shared timing',
      'Combine an easy base pulse with a hand opening on each pulse. Practice the two parts separately whenever needed.',
    ),
    (
      'Coordinate · opposite sides',
      'Match a hand gesture to the opposite-side foot tap or second available region. Repeat four events, rest, and restart.',
    ),
    (
      'Coordinate · layered phrase',
      'Keep a repeating four-event base pattern while changing the upper gesture every two events. Use two available regions in any position.',
    ),
    (
      'Coordinate · independent timing',
      'Keep one area pulsing on each count while another moves every second count. Swap the roles after a rest.',
    ),
    (
      'Coordinate · layer switching',
      'Sustain one repeating layer while changing the second layer’s pathway. Return to the original without interrupting the first.',
    ),
    (
      'Coordinate · chosen complexity',
      'Build two independent layers, then change one layer’s timing on your cue. Remove and restore a layer while keeping the remaining one clear.',
    ),
  ],
  ForgeCategory.retention: [
    (
      'Recall · two actions',
      'Choose two easy gestures and name them aloud or mentally. Perform them, rest for four breaths, then recall their order without looking.',
    ),
    (
      'Recall · four events',
      'Build four familiar events in two pairs. Practice each pair, connect them, then recall once after a short pause.',
    ),
    (
      'Recall · connect chunks',
      'Learn two four-event chunks of your own available actions. Rest, join them from memory, and identify the transition needing a cue.',
    ),
    (
      'Recall · delayed retrieval',
      'Perform an eight-event phrase, take a short unrelated rest, then retrieve it before reviewing. Repair only the missing transition.',
    ),
    (
      'Recall · one changed condition',
      'Retrieve a familiar phrase after a break, then change its facing or size. Preserve event order in the changed version.',
    ),
    (
      'Recall · alternate structures',
      'Create A and B from familiar chunks. Recall A–B, rest, then recall B–A without a continuous model.',
    ),
    (
      'Recall · independent reconstruction',
      'Recall a previously practised phrase before reviewing notes. Identify any missing event, repair it, and repeat with one safe changed condition.',
    ),
  ],
  ForgeCategory.creativity: [
    (
      'Explore · one gesture',
      'Choose one comfortable gesture. Try it small and slightly larger, with a pause between versions. There is no required look.',
    ),
    (
      'Explore · two choices',
      'Choose two available areas and alternate who leads. Notice a movement you would like to repeat.',
    ),
    (
      'Create · contrasting textures',
      'Make a short motif and repeat it once smooth and once with clear pauses. Change quality rather than pushing range.',
    ),
    (
      'Create · a constraint',
      'Explore using one area and two directions. Keep one choice fixed while changing the other, then name what changed.',
    ),
    (
      'Compose · A and B',
      'Create two short motifs with contrasting timing. Perform A–B–A and repeat the structure with a deliberate ending.',
    ),
    (
      'Create · communicate intent',
      'Choose an intention and express it using timing, focus or texture. Make a contrasting version and name concrete movement differences.',
    ),
    (
      'Create · revise and explain',
      'Compose a short repeatable phrase from your own motifs. Revise one compositional choice, perform both versions, and record why you preferred one.',
    ),
  ],
  ForgeCategory.capacity: [
    (
      'Conditioning · easy intervals',
      'Alternate twenty seconds of comfortable taps or small supported steps with forty seconds of rest. Keep breathing easy.',
    ),
    (
      'Conditioning · steady short rounds',
      'Alternate thirty seconds of comfortable familiar movement with thirty seconds of rest. Keep enough ease to speak a full sentence.',
    ),
    (
      'Conditioning · sustained phrase',
      'Use forty seconds of a familiar low-impact phrase, then forty seconds of rest. Shorten the round if timing or control changes.',
    ),
    (
      'Conditioning · two easy phrases',
      'Alternate two familiar phrases for up to a minute, then rest for a minute. Keep transitions controlled rather than increasing speed.',
    ),
    (
      'Conditioning · varied easy work',
      'Use a minute of familiar low-impact movement with a change of direction halfway, then a minute of rest. Reduce range before fatigue changes control.',
    ),
    (
      'Conditioning · self-regulated rounds',
      'Alternate ninety seconds of comfortable familiar phrases with ninety seconds of rest. Use the talk test and end a round early when needed.',
    ),
    (
      'Conditioning · sustainable sequence',
      'Choose a familiar sequence for up to two minutes, then rest equally. Record when control or breathing called for a reduction; duration is not a score.',
    ),
  ],
};
