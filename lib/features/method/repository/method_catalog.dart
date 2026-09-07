import '../model/forge_method.dart';

const forgeBelts = <MethodBelt>[
  MethodBelt(
    index: 0,
    name: 'White',
    description: 'Entry: no assessment required. Explore a safe, accessible starting point.',
  ),
  MethodBelt(
    index: 1,
    name: 'Yellow',
    description: 'Find a pulse, initiate movement, transfer support, combine two parts, recall and make a short phrase.',
  ),
  MethodBelt(
    index: 2,
    name: 'Orange',
    description: 'Contrast timing and movement, connect pathways, recall chunks and vary a motif intentionally.',
  ),
  MethodBelt(
    index: 3,
    name: 'Blue',
    description: 'Use subdivisions, isolations and directional patterns in a recalled phrase with personal choices.',
  ),
  MethodBelt(
    index: 4,
    name: 'Violet',
    description: 'Change timing, dynamics and coordination while retaining the identity of a composition.',
  ),
  MethodBelt(
    index: 5,
    name: 'Red',
    description: 'Layer rhythms and initiations, recover independently and develop a structured improvisation.',
  ),
  MethodBelt(
    index: 6,
    name: 'Brown',
    description: 'Adapt a complex phrase to contrasting constraints and communicate deliberate compositional choices.',
  ),
  MethodBelt(
    index: 7,
    name: 'Black',
    description: 'Integrate and revise a personal study across all six core categories; a FORGE milestone, not a universal dance rank.',
  ),
];

const _safe =
    'Choose a clear surface and comfortable range. Use a seated or supported base, hand pathways instead of steps, or eye/head gestures where useful. A visual or tactile pulse may replace sound. Stop for pain, dizziness or unusual breathlessness; do not mark a criterion you could not demonstrate.';
const _control =
    'Stay within your chosen comfortable range and use your stop signal without losing a safe base.';

// Published v1 rubrics are immutable: future edits that change pass criteria
// must publish a new ID/version and retain this catalogue for historical proof.
final List<MethodAssessment> forgeAssessments = List.unmodifiable([
  ..._category(ForgeCategory.rhythm, 'common-time-weight-find-pulse', [
    (
      'Find the pulse',
      'Choose a comfortable steady pulse; tap or move for two eight-count phrases.',
      'Keep one chosen movement aligned to eight consecutive pulses.',
      'Stop for four pulses and re-enter on the next phrase start.',
    ),
    (
      'Accent and pause',
      'Repeat a simple pulse phrase, then add an accent and a deliberate pause.',
      'Keep the pulse while making the first event of each four-pulse group distinct.',
      'Leave a two-pulse silence and return without speeding up.',
    ),
    (
      'Subdivide the beat',
      'Alternate whole-pulse and half-pulse actions at your comfortable tempo.',
      'Show eight whole-pulse actions followed by sixteen even half-pulse actions.',
      'Return to whole pulses at the phrase boundary without adding a beat.',
    ),
    (
      'Offbeat choices',
      'Build a phrase with pulse actions and actions between pulses.',
      'Place four chosen accents between the main pulses while maintaining an underlying pulse.',
      'Repeat the phrase with the same accent and silence placements.',
    ),
    (
      'Layer rhythmic motifs',
      'Use two available movement channels to contrast a pulse and a rhythmic motif.',
      'Maintain a steady pulse in one channel while another repeats a short accent pattern.',
      'Switch the channel roles at a phrase boundary without losing the underlying pulse.',
    ),
    (
      'Adapt the time structure',
      'Perform your motif over two contrasting comfortable timing structures.',
      'Keep the motif recognizable in even grouping and a chosen uneven grouping such as 3+2.',
      'Identify and demonstrate where the phrase begins and resolves in each structure.',
    ),
    (
      'Interpret a score',
      'Create a timing score using pulse, silence, density and a deliberate tempo change.',
      'Perform the scored transitions twice with intentional, recognizable timing landmarks.',
      'Explain one expressive timing choice and revise it audibly or visibly while preserving the score structure.',
    ),
  ]),
  ..._category(ForgeCategory.bodyControl, 'common-ready-body-body-map', [
    (
      'Initiate and settle',
      'Choose one available body area and explore a small movement with a quiet return.',
      'Initiate three movements clearly from the chosen body area.',
      'Return to a stable resting position after each movement without forcing range.',
    ),
    (
      'Separate two areas',
      'Explore two available areas separately, then connect them.',
      'Move each chosen area while the other remains intentionally quiet.',
      'Connect the areas in a repeatable first-then-second sequence.',
    ),
    (
      'Isolation pathway',
      'Trace a three-part initiation pathway using available body areas.',
      'Make each of the three initiation points distinguishable.',
      'Reverse the pathway without losing the order or comfortable alignment.',
    ),
    (
      'Contrast dynamics',
      'Repeat one pathway with sustained and sharply defined movement.',
      'Make both sustained and accented versions clearly distinguishable.',
      'Keep the initiation order and ending position consistent in both versions.',
    ),
    (
      'Control a wave',
      'Pass a movement through three available areas with continuous breath.',
      'Show a continuous sequential transfer rather than moving every area together.',
      'Pause the transfer at a chosen area and resume without restarting the whole pathway.',
    ),
    (
      'Redirect initiation',
      'Adapt a known phrase by changing its initiation and scale.',
      'Perform the phrase beginning in two different available areas.',
      'Make a small and a larger comfortable version without unwanted momentum or breath holding.',
    ),
    (
      'Refine a movement study',
      'Compose a controlled study with isolation, sequential and simultaneous movement.',
      'Make all three relationships distinct and connect them with deliberate transitions.',
      'Identify one unwanted movement, revise it and repeat the refined version.',
    ),
  ]),
  ..._category(ForgeCategory.footwork, 'common-time-weight-transfer-weight', [
    (
      'Transfer and return',
      'Use supported weight shifts, seated pressure shifts or hand placements as your base pattern.',
      'Clearly transfer support or pressure from one chosen contact to another four times.',
      'Return to the starting base with control and no rushed correction.',
    ),
    (
      'Connect a base pattern',
      'Link a side-return and forward-return pattern in your available space.',
      'Perform both pathways in a repeatable order with clear contact placement.',
      'Keep a comfortable pulse while returning to the same starting base.',
    ),
    (
      'Change direction',
      'Create a four-action contact pattern with two directions.',
      'Repeat the pattern in both directional orders without crossing into unsafe space.',
      'Distinguish a contact/touch from a committed transfer of support or pressure.',
    ),
    (
      'Travel and face',
      'Use a small travelling or hand-pathway pattern while changing orientation.',
      'Change facing or pathway orientation without unintentionally changing the order.',
      'Reverse the travel/pathway direction and finish in a planned safe base.',
    ),
    (
      'Vary the contact rhythm',
      'Keep a familiar contact pathway and change its rhythm.',
      'Perform the same pathway with even timing and with a held contact plus quicker contacts.',
      'Keep support transfers intentional through each timing change.',
    ),
    (
      'Navigate a constraint',
      'Mark a small safe zone and adapt a contact phrase to its boundary.',
      'Preserve the contact sequence while reducing travel or using an in-place equivalent.',
      'Choose and demonstrate an alternative route around a marked obstacle without breaking the phrase.',
    ),
    (
      'Design a pathway study',
      'Create a contact study combining direction, facing, rhythm and level within available range.',
      'Repeat the study with recognizable pathways and controlled transitions.',
      'Adapt it to a second safe space or base of support and explain which pathway relationships were preserved.',
    ),
  ]),
  ..._category(
    ForgeCategory.coordination,
    'common-space-coordination-parts-together',
    [
      (
        'Combine two parts',
        'Choose two available movement channels; practise each, then combine.',
        'Demonstrate each part separately in a short repeated pattern.',
        'Perform both together for one eight-count phrase with a clear start and stop.',
      ),
      (
        'Same and opposite',
        'Explore matching and contrasting directions with your two chosen channels.',
        'Show matching directions and then opposite directions intentionally.',
        'Switch between the two relationships without dropping either part.',
      ),
      (
        'Sequence independent parts',
        'Let one channel repeat while the other traces a two-part pathway.',
        'Maintain the repeating action throughout the pathway.',
        'Reverse the pathway while preserving the repeating action.',
      ),
      (
        'Change a layer',
        'Build a two-layer phrase with one planned change.',
        'Change the speed or direction of one layer while the other remains unchanged.',
        'Return both layers to the original relationship at a chosen landmark.',
      ),
      (
        'Switch attention',
        'Choose an anchor pattern and an independent contrast pattern.',
        'Perform both patterns then deliberately exchange which channel holds the anchor.',
        'Recover the pair after a planned pause without restarting the full phrase.',
      ),
      (
        'Respond within a phrase',
        'Use a pre-set visual, sound or self-given cue to change one layer.',
        'Respond to the cue while maintaining the other layer.',
        'Demonstrate two different cue responses with the same stable anchor.',
      ),
      (
        'Orchestrate layers',
        'Compose a study that moves between unison, opposition and independent layering.',
        'Keep each relationship distinguishable through planned transitions.',
        'Simplify one layer and then restore it without losing the overall phrase structure.',
      ),
    ],
  ),
  ..._category(ForgeCategory.retention, 'common-quality-phrase-learn-phrase', [
    (
      'Recall a short phrase',
      'Learn three available actions, look away from the source and wait one minute.',
      'Perform all three actions in the learned order without following a demonstration.',
      'Repeat the phrase with the same start and finish; personal mnemonic cues are allowed.',
    ),
    (
      'Connect two chunks',
      'Learn two three-action chunks and practise their connection; pause for two minutes.',
      'Recall both chunks without live copying.',
      'Make the connection without stopping to look up the next action.',
    ),
    (
      'Recall after a break',
      'Learn a phrase with a timing change, take a five-minute break doing something else.',
      'Retrieve the complete action order without replaying the source.',
      'Retain the timing change and planned ending after the break.',
    ),
    (
      'Recall and reorient',
      'Retrieve a known phrase and face another direction or change your seated pathway orientation.',
      'Preserve action order and phrase landmarks in the new orientation.',
      'Return to the original orientation without relearning from the demonstration.',
    ),
    (
      'Recover from a landmark',
      'Choose beginning, middle and ending landmarks in a familiar phrase.',
      'Start from each landmark without first performing the full phrase.',
      'Resume from the next landmark after a planned interruption.',
    ),
    (
      'Retrieve next day',
      'Return at least one day after learning a phrase; record both dates in notes.',
      'Recall order, timing landmarks and ending before consulting the source.',
      'Adapt one direction or dynamic while retaining the original phrase identity.',
    ),
    (
      'Maintain and revise',
      'Retrieve a study learned at least a week earlier; record learning and recall dates in notes.',
      'Recall its sections and transitions before reviewing your earlier record.',
      'Introduce a deliberate revision, then demonstrate both original and revised versions without confusing their order.',
    ),
  ]),
  ..._category(
    ForgeCategory.creativity,
    'common-make-communicate-prompted-improvisation',
    [
      (
        'Make a choice',
        'Choose two available actions and create a short personal phrase.',
        'Choose an order and repeat it so the phrase is recognizable.',
        'Make a deliberate ending rather than stopping by accident.',
      ),
      (
        'Vary a motif',
        'Take your short phrase and change one movement property.',
        'Make a recognizable variation in size, direction or dynamic.',
        'Return to the original motif and describe the choice you changed.',
      ),
      (
        'Use a constraint',
        'Improvise with a chosen constraint such as curved pathways or sustained motion.',
        'Make at least three distinct movement choices that follow the constraint.',
        'Choose one idea from the improvisation and repeat it as a motif.',
      ),
      (
        'Compose contrast',
        'Arrange an A section and a contrasting B section using available actions.',
        'Make the contrast clear through timing, space or dynamics.',
        'Connect A to B and return to A with an intentional transition.',
      ),
      (
        'Develop an idea',
        'Build a beginning, development and ending from one movement idea.',
        'Transform the idea in two different ways without losing its recognizable relationship.',
        'Choose a climax or quiet focal moment and place it intentionally.',
      ),
      (
        'Communicate and revise',
        'Choose an intention and describe it before performing a short study.',
        'Use at least two movement properties to support the chosen intention.',
        'Review your own observation or private recording and revise a specific choice to clarify the intention.',
      ),
      (
        'Author a personal study',
        'Create a study with motif, contrast, transformation and a deliberate ending.',
        'Perform the study twice with recognizable structure and room for intentional variation.',
        'Describe your influences without claiming ownership of a culture, identify a revision and demonstrate how it changes the study.',
      ),
    ],
  ),
  ..._category(ForgeCategory.mobility, 'common-ready-body-bases-breath', [
    (
      'Map comfortable range',
      'Explore two available joints or movement areas slowly, with support if useful.',
      'Identify a comfortable range for each area without pushing through pain.',
      'Return from each exploration under control with continuous breath.',
    ),
    (
      'Connect ranges',
      'Link two comfortable movement ranges into an easy transition.',
      'Keep the transition smooth without forcing either endpoint.',
      'Choose a smaller-range alternative and demonstrate equal control.',
    ),
    (
      'Explore directions',
      'Explore forward/back and side-to-side pathways using available areas.',
      'Keep each pathway within a self-selected comfortable boundary.',
      'Notice a restriction and adapt the direction or support before discomfort.',
    ),
    (
      'Move across a phrase',
      'Apply your comfortable ranges to a short familiar phrase.',
      'Maintain breath and chosen alignment through all transitions.',
      'Reduce one movement range without losing phrase timing.',
    ),
    (
      'Vary the support',
      'Use two safe support arrangements, such as seated and supported seated reach.',
      'Select a comfortable movement range for each support arrangement.',
      'Transition or reset between arrangements safely without treating greater range as better.',
    ),
    (
      'Adapt to readiness',
      'Recheck your comfortable range before repeating a familiar mobility phrase.',
      'Adjust at least one pathway to today’s available range and explain why.',
      'Keep the adjusted version controlled through both outward and return movement.',
    ),
    (
      'Direct a mobility routine',
      'Assemble a personal preparation and recovery sequence for a chosen practice.',
      'Include gradual exploration, relevant comfortable pathways and a calm finish.',
      'Demonstrate an alternative for a restricted area and identify your stop signals.',
    ),
  ]),
  ..._category(ForgeCategory.capacity, 'common-ready-body-bases-breath', [
    (
      'Pace and recover',
      'Choose a gentle seated, supported or standing phrase; work for a comfortable interval up to one minute.',
      'Choose an effort where comfortable speech or your usual breath check remains possible.',
      'Pause when needed and describe how you know you are ready to continue.',
    ),
    (
      'Repeat a comfortable interval',
      'Choose two short work intervals separated by a self-paced recovery.',
      'Keep movement quality and comfortable breathing in both intervals.',
      'Adjust the second interval or recovery using your first interval response.',
    ),
    (
      'Balance work and recovery',
      'Plan three brief intervals at a personally sustainable pace.',
      'Keep the chosen action controlled without rushing near the end.',
      'Use planned or additional rests before movement quality deteriorates.',
    ),
    (
      'Pace a varied phrase',
      'Alternate easier and more demanding versions within a short phrase.',
      'Make effort changes deliberately without breath holding or painful impact.',
      'Return to the easier version as soon as your breath/effort check asks for it.',
    ),
    (
      'Choose an interval plan',
      'Set a short personal work/recovery plan using your recent practice notes.',
      'Complete or safely shorten each interval based on current effort rather than a score.',
      'Record the actual work and rest choices and explain one pacing decision.',
    ),
    (
      'Adapt on a low-readiness day',
      'Demonstrate a reduced-effort version of your usual practice plan.',
      'Reduce duration, range or complexity while preserving the practice goal.',
      'Use a mid-session check to continue, reduce or stop with a clear reason.',
    ),
    (
      'Manage sustainable practice',
      'Plan and perform a personal session with preparation, paced work and recovery.',
      'Maintain chosen technique and effort boundaries or intentionally scale down when needed.',
      'Use your recovery response to propose a realistic next session; longer or harder work is not required.',
    ),
  ]),
  for (var level = 1; level <= 7; level++) _integrated(level),
]);

List<MethodAssessment> _category(
  ForgeCategory category,
  String lessonId,
  List<(String, String, String, String)> rows,
) => [
  for (var index = 0; index < rows.length; index++)
    MethodAssessment(
      id: '${category.name}-${index + 1}-v1',
      category: category,
      level: index + 1,
      title: rows[index].$1,
      instructions: rows[index].$2,
      linkedLessonId: lessonId,
      adaptation: _safe,
      criteria: List.unmodifiable([
        AssessmentCriterion(id: 'task', text: rows[index].$3),
        AssessmentCriterion(id: 'repeat', text: rows[index].$4),
        const AssessmentCriterion(id: 'safe', text: _control),
      ]),
    ),
];

const _integratedTasks = [
  (
    'Connect your first phrase',
    'Combine three chosen actions over two eight-count phrases. Recall once without a live demonstration, then change the ending.',
    'Keep a comfortable pulse, clear initiation and intentional support/contact changes.',
    'Coordinate two available parts, recall the order and demonstrate your own ending.',
  ),
  (
    'Contrast and connect',
    'Create two connected chunks using a contact pathway, pulse accent and a personal motif variation.',
    'Keep the accent, two-area initiation and contact pathway recognizable through the connection.',
    'Switch between matching and opposite coordination, recall both chunks and show the motif variation.',
  ),
  (
    'Shape a recalled phrase',
    'After a five-minute break, retrieve a phrase with subdivisions, a three-part initiation and two contact directions.',
    'Make subdivision changes, initiation order and contact direction changes intentional.',
    'Maintain an anchor layer, recall the timing landmark and include three choices from a creative constraint.',
  ),
  (
    'Transform A–B–A',
    'Perform an A–B–A composition, then reorient it within your safe space.',
    'Preserve offbeat accents, dynamic contrast and controlled facing/pathway changes.',
    'Change one coordination layer, recall the reoriented phrase and make A/B contrast and transitions distinct.',
  ),
  (
    'Develop and recover',
    'Develop one motif with layered rhythm, sequential initiation and a varied contact rhythm; interrupt and resume at a landmark.',
    'Show independent rhythmic layers, a controlled sequential transfer and intentional contact timing.',
    'Exchange coordination roles, resume from the landmark and resolve the developed creative idea.',
  ),
  (
    'Adapt with intention',
    'Retrieve a phrase learned on a previous day and adapt it to a different space, timing structure and expressive intention.',
    'Keep the motif recognizable across timing structures, initiation changes and a constrained contact pathway.',
    'Respond to a chosen cue without losing an anchor; retain phrase landmarks and demonstrate an expressive revision.',
  ),
  (
    'Present a personal study',
    'Retrieve a study learned at least a week earlier; perform, review and revise its timing, pathways and expressive choices. Record learning and recall dates.',
    'Integrate a timing score, distinguishable body relationships and an adaptable contact pathway with controlled transitions.',
    'Orchestrate unison/opposition/independent layers, distinguish original from revised recall and communicate your motif, influences and revision.',
  ),
];

MethodAssessment _integrated(int level) {
  final task = _integratedTasks[level - 1];
  return MethodAssessment(
    id: 'integrated-$level-v1',
    category: null,
    level: level,
    title: task.$1,
    instructions: task.$2,
    linkedLessonId: 'common-relate-connect-capstone-pathway',
    adaptation: _safe,
    criteria: List.unmodifiable([
      AssessmentCriterion(id: 'movement', text: task.$3),
      AssessmentCriterion(id: 'composition', text: task.$4),
      const AssessmentCriterion(
        id: 'repeat',
        text: 'Repeat the complete study without following a live demonstration; identify one specific success and one next practice focus in your notes.',
      ),
      const AssessmentCriterion(id: 'safe', text: _control),
    ]),
  );
}
