import '../model/lesson.dart';

/// Static lesson content. Content ships with the app on purpose — only user
/// progress is persisted to Firestore. If content ever needs to change
/// independently of app releases, revisit this decision (documented in the
/// best-practices research report).
///
/// Rules for authoring:
/// - Lesson ids are globally unique (prefixed with the module id, except the
///   original hip-hop-foundations lessons whose ids predate the convention
///   and must NOT change — existing user progress references them).
/// - Every module ends with a boss lesson.
/// - Module numbering in `subtitle` follows catalog order.
const Module hipHopFoundations = Module(
  id: 'hip-hop-foundations',
  title: 'Hip Hop Foundations',
  subtitle: 'Module 1 • Path',
  category: ModuleCategory.fundamentals,
  tag: 'Hip Hop',
  imageUrl:
      'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=800&auto=format&fit=crop&q=80',
  lessons: [
    Lesson(
      id: 'history-of-hip-hop',
      title: 'History of Hip Hop',
      type: LessonType.theory,
      duration: '5 min',
      steps: [
        LessonStep(
          title: 'THE FOUR ELEMENTS',
          description:
              'Hip hop is a culture, not just a dance: DJing, MCing, graffiti, and breaking.',
          focus: 'Name all four elements and how dance fits among them.',
          breath: 'Relaxed nasal breathing — this step is for the mind.',
          energy: 'Low and curious; absorb before you move.',
        ),
        LessonStep(
          title: 'BIRTH OF BREAKING',
          description:
              'From Bronx block parties to the cypher: where the dance was born.',
          focus: 'Notice how the break in the music created the dancer.',
          breath: 'Steady four-count rhythm while you watch.',
          energy: 'Light marking — sketch what you see at half speed.',
        ),
        LessonStep(
          title: 'THE GROOVE LINEAGE',
          description:
              'Social dances feed hip hop: the bounce and rock live in everything.',
          focus: 'Spot the shared bounce across the eras shown.',
          breath: 'Let the music set your breathing pace.',
          energy: 'Sway along — feel the lineage in your body.',
        ),
        LessonStep(
          title: 'YOUR PLACE IN IT',
          description:
              'Every dancer adds to the culture. Set your intention before the first move.',
          focus: 'Say out loud what you want your dance to feel like.',
          breath: 'One deep reset breath to close the theory.',
          energy: 'Alert and ready — the movement starts next lesson.',
        ),
      ],
    ),
    Lesson(
      id: 'groove-basics',
      title: 'Groove Basics',
      type: LessonType.movement,
      duration: '15 min',
      steps: [
        LessonStep(
          title: 'FIND THE BEAT',
          description: 'Tune into the drums before anything else moves.',
          focus: 'Nod to the kick drum until it feels automatic.',
          breath: 'Inhale two counts, exhale two counts, locked to the beat.',
          energy: 'Minimal — just your head and shoulders riding the drums.',
        ),
        LessonStep(
          title: 'BOUNCE TECHNIQUE',
          description:
              'Follow the rhythm and stay loose. This fundamental movement is key to your flow.',
          focus: 'Keep your knees slightly bent and relaxed.',
          breath: 'Exhale on the downbeat.',
          energy: 'Direct your power from the core.',
        ),
        LessonStep(
          title: 'ARM SWING',
          description: 'Let the arms ride the bounce instead of fighting it.',
          focus: 'Swing from the shoulder, loose at the elbow.',
          breath: 'Keep the breath easy — tension shows up in the hands first.',
          energy: 'Relaxed weight; the arms follow the body.',
        ),
        LessonStep(
          title: 'FULL GROOVE',
          description: 'Stack beat, bounce, and arms into one groove.',
          focus: 'Let no single part steal the spotlight — blend everything.',
          breath: 'Breathe with the eight-count, not against it.',
          energy: 'Confident and social — groove like the room is full.',
        ),
      ],
    ),
    Lesson(
      id: 'bounce-and-rock',
      title: 'Bounce & Rock',
      type: LessonType.drill,
      duration: '10 min',
      steps: [
        LessonStep(
          title: 'ROCK THE BASICS',
          description: 'Half-speed rocks: chest leads, feet answer.',
          focus: 'Perfect placement beats speed — check each position.',
          breath: 'Exhale on every forward rock.',
          energy: 'Deliberate and controlled, around half power.',
        ),
        LessonStep(
          title: 'DOWN BOUNCE REPS',
          description: 'Drill the down bounce until it lives in the knees.',
          focus: 'Bounce down into the beat, never up off it.',
          breath: 'Match your breath to the eight-count.',
          energy: 'Working pace — strong but repeatable.',
        ),
        LessonStep(
          title: 'ROCK VARIATIONS',
          description: 'Side rocks, front rocks, quarter turns — same engine.',
          focus: 'Keep the bounce identical while the direction changes.',
          breath: 'Do not hold your breath through the turns.',
          energy: 'High output in short bursts; reset between sets.',
        ),
        LessonStep(
          title: 'SMOOTH COMBINE',
          description: 'Chain bounce and rock into one continuous phrase.',
          focus: 'Hide the seams — no visible resets between moves.',
          breath: 'Long exhales to settle the heart rate as you flow.',
          energy: 'Controlled burn — finish with your best three reps.',
        ),
      ],
    ),
    Lesson(
      id: 'freestyle-session',
      title: 'Freestyle Session',
      type: LessonType.experiment,
      duration: '20 min',
      steps: [
        LessonStep(
          title: 'PICK YOUR LOOP',
          description: 'Choose one track and one constraint to play against.',
          focus: 'Limit yourself to bounce and rock — nothing else.',
          breath: 'Relaxed breath; there are no wrong answers here.',
          energy: 'Curious and light.',
        ),
        LessonStep(
          title: 'GROOVE EXPLORATION',
          description: 'Move without judging the output.',
          focus: 'Follow what feels interesting, not what looks right.',
          breath: 'Keep breathing through the awkward moments.',
          energy: 'Loose and continuous — never stop moving.',
        ),
        LessonStep(
          title: 'KEEP THE GOLD',
          description: 'Catch the accidents worth keeping.',
          focus: 'Repeat your two favorite discoveries until they stick.',
          breath: 'Reset breath between repetitions.',
          energy: 'Focused — refine without stiffening up.',
        ),
        LessonStep(
          title: 'FOUR EIGHTS',
          description: 'Combine your discoveries into a short phrase.',
          focus: 'Chain the finds into four eight-counts you could repeat.',
          breath: 'Breathe with the phrase, not against it.',
          energy: 'Build to a confident finish.',
        ),
      ],
    ),
    Lesson(
      id: 'boss-showcase',
      title: 'Boss Showcase',
      type: LessonType.boss,
      steps: [
        LessonStep(
          title: 'WARM THE ENGINE',
          description: 'Prime everything the showcase needs.',
          focus: 'Touch every move from the module at least once.',
          breath: 'Big diaphragm breaths — calm the nerves.',
          energy: 'Rising — from stroll to ready.',
        ),
        LessonStep(
          title: 'RUN THE GAUNTLET',
          description: 'Beat, bounce, rock, and freestyle — full sequence, no stopping.',
          focus: 'Recover forward; mistakes stay in the past.',
          breath: 'Steady through transitions, sharp exhale on accents.',
          energy: 'Performance level.',
        ),
        LessonStep(
          title: 'PRESSURE ROUND',
          description: 'One more run with higher stakes.',
          focus: 'Add your own flavor on top of the technique.',
          breath: 'Exhale hard on the biggest hit.',
          energy: 'Everything you have.',
        ),
        LessonStep(
          title: 'VICTORY LAP',
          description: 'Own the result.',
          focus: 'One final freestyle to celebrate the new skill.',
          breath: 'Let the breath settle naturally.',
          energy: 'Joyful — you earned this one.',
        ),
      ],
    ),
  ],
);

const Module bodyControl1 = Module(
  id: 'body-control-1',
  title: 'Body Control I',
  subtitle: 'Module 2 • Path',
  category: ModuleCategory.fundamentals,
  tag: 'Rhythm',
  imageUrl:
      'https://images.unsplash.com/photo-1550525811-e5869dd03032?w=800&q=80',
  lessons: [
    Lesson(id: 'body-control-1-center-posture', title: 'Center & Posture', type: LessonType.theory, duration: '4 min'),
    Lesson(id: 'body-control-1-chest-isolations', title: 'Chest Isolations', type: LessonType.movement, duration: '10 min'),
    Lesson(id: 'body-control-1-hip-isolations', title: 'Hip Isolations', type: LessonType.movement, duration: '10 min'),
    Lesson(id: 'body-control-1-shoulder-rolls', title: 'Shoulder Rolls', type: LessonType.drill, duration: '8 min'),
    Lesson(id: 'body-control-1-head-neck', title: 'Head & Neck Control', type: LessonType.drill, duration: '8 min'),
    Lesson(id: 'body-control-1-wave-basics', title: 'Wave Basics', type: LessonType.movement, duration: '12 min'),
    Lesson(id: 'body-control-1-isolation-combos', title: 'Isolation Combos', type: LessonType.experiment, duration: '15 min'),
    Lesson(id: 'body-control-1-control-showcase', title: 'Control Showcase', type: LessonType.boss),
  ],
);

const Module isolationsMaster = Module(
  id: 'isolations-master',
  title: 'Isolations Master',
  subtitle: 'Module 3 • Path',
  category: ModuleCategory.fundamentals,
  tag: 'Tech',
  imageUrl:
      'https://images.unsplash.com/photo-1547153760-18fc86324498?w=800&q=80',
  lessons: [
    Lesson(id: 'isolations-master-theory', title: 'Isolation Theory', type: LessonType.theory, duration: '5 min'),
    Lesson(id: 'isolations-master-arm-waves', title: 'Arm Waves', type: LessonType.movement, duration: '12 min'),
    Lesson(id: 'isolations-master-leg-isolations', title: 'Leg Isolations', type: LessonType.drill, duration: '10 min'),
    Lesson(id: 'isolations-master-full-body-flow', title: 'Full-Body Flow', type: LessonType.experiment, duration: '15 min'),
    Lesson(id: 'isolations-master-boss', title: 'Isolation Boss', type: LessonType.boss),
  ],
);

const Module footworkFundamentals = Module(
  id: 'footwork-fundamentals',
  title: 'Footwork Fundamentals',
  subtitle: 'Module 4 • Path',
  category: ModuleCategory.fundamentals,
  tag: 'Technique',
  imageUrl:
      'https://images.unsplash.com/photo-1716996642138-e655f2a8dcd5?w=800&auto=format&fit=crop&q=80',
  lessons: [
    Lesson(id: 'footwork-fundamentals-weight-transfer', title: 'Weight Transfer', type: LessonType.theory, duration: '5 min'),
    Lesson(id: 'footwork-fundamentals-step-touch', title: 'Step Touch Patterns', type: LessonType.movement, duration: '10 min'),
    Lesson(id: 'footwork-fundamentals-kick-ball-change', title: 'Kick Ball Change', type: LessonType.movement, duration: '10 min'),
    Lesson(id: 'footwork-fundamentals-speed-ladders', title: 'Speed Ladders', type: LessonType.drill, duration: '8 min'),
    Lesson(id: 'footwork-fundamentals-freestyle', title: 'Footwork Freestyle', type: LessonType.experiment, duration: '12 min'),
    Lesson(id: 'footwork-fundamentals-boss', title: 'Footwork Boss', type: LessonType.boss),
  ],
);

const Module topRock = Module(
  id: 'top-rock',
  title: 'Top Rock',
  subtitle: 'Module 5 • Path',
  category: ModuleCategory.streetStyles,
  tag: 'Breaking',
  imageUrl:
      'https://images.unsplash.com/photo-1535525153412-5a42439a210d?w=800&q=80',
  lessons: [
    Lesson(id: 'top-rock-history', title: 'Top Rock History', type: LessonType.theory, duration: '5 min'),
    Lesson(id: 'top-rock-indian-step', title: 'Indian Step', type: LessonType.movement, duration: '12 min'),
    Lesson(id: 'top-rock-side-step', title: 'Side Step', type: LessonType.movement, duration: '10 min'),
    Lesson(id: 'top-rock-cross-step-drills', title: 'Cross Step Drills', type: LessonType.drill, duration: '10 min'),
    Lesson(id: 'top-rock-cypher-entry', title: 'Cypher Entry', type: LessonType.boss),
  ],
);

const Module boogaloo = Module(
  id: 'boogaloo',
  title: 'Boogaloo',
  subtitle: 'Module 6 • Path',
  category: ModuleCategory.streetStyles,
  tag: 'Popping',
  imageUrl:
      'https://images.unsplash.com/photo-1547481887-a26e2cacb2f2?w=800&q=80',
  lessons: [
    Lesson(id: 'boogaloo-roots', title: 'Boogaloo Roots', type: LessonType.theory, duration: '5 min'),
    Lesson(id: 'boogaloo-rolls-twists', title: 'Rolls & Twists', type: LessonType.movement, duration: '12 min'),
    Lesson(id: 'boogaloo-old-man-groove', title: 'Old Man Groove', type: LessonType.drill, duration: '10 min'),
    Lesson(id: 'boogaloo-jam', title: 'Boogaloo Jam', type: LessonType.boss),
  ],
);

const Module house = Module(
  id: 'house',
  title: 'House',
  subtitle: 'Module 7 • Path',
  category: ModuleCategory.streetStyles,
  tag: 'House',
  imageUrl:
      'https://images.unsplash.com/photo-1504609813442-a8924e83f76e?w=800&q=80',
  lessons: [
    Lesson(id: 'house-culture', title: 'House Culture', type: LessonType.theory, duration: '5 min'),
    Lesson(id: 'house-jack-basics', title: 'Jack Basics', type: LessonType.movement, duration: '10 min'),
    Lesson(id: 'house-farmer-loose-legs', title: 'Farmer & Loose Legs', type: LessonType.movement, duration: '12 min'),
    Lesson(id: 'house-skating-drills', title: 'Skating Drills', type: LessonType.drill, duration: '10 min'),
    Lesson(id: 'house-lofting-freestyle', title: 'Lofting Freestyle', type: LessonType.experiment, duration: '15 min'),
    Lesson(id: 'house-club-floor-boss', title: 'Club Floor Boss', type: LessonType.boss),
  ],
);

const Module breakingBasics = Module(
  id: 'breaking-basics',
  title: 'Breaking Basics',
  subtitle: 'Module 8 • Path',
  category: ModuleCategory.streetStyles,
  tag: 'Power Moves',
  imageUrl:
      'https://images.unsplash.com/photo-1506411393232-79727bc447af?w=800&auto=format&fit=crop&q=80',
  lessons: [
    Lesson(id: 'breaking-basics-101', title: 'Breaking 101', type: LessonType.theory, duration: '5 min'),
    Lesson(id: 'breaking-basics-six-step', title: 'Six Step', type: LessonType.movement, duration: '12 min'),
    Lesson(id: 'breaking-basics-three-step', title: 'Three Step', type: LessonType.movement, duration: '10 min'),
    Lesson(id: 'breaking-basics-freeze-basics', title: 'Freeze Basics', type: LessonType.movement, duration: '12 min'),
    Lesson(id: 'breaking-basics-power-prep', title: 'Power Prep Drills', type: LessonType.drill, duration: '10 min'),
    Lesson(id: 'breaking-basics-downrock-combos', title: 'Downrock Combos', type: LessonType.experiment, duration: '15 min'),
    Lesson(id: 'breaking-basics-first-cypher', title: 'First Cypher', type: LessonType.boss),
  ],
);

const Module urbanFlow = Module(
  id: 'urban-flow',
  title: 'Urban Flow',
  subtitle: 'Module 9 • Path',
  category: ModuleCategory.choreography,
  tag: 'New Arrival',
  imageUrl:
      'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?w=800&q=80',
  lessons: [
    Lesson(id: 'urban-flow-musicality', title: 'Musicality Basics', type: LessonType.theory, duration: '6 min'),
    Lesson(id: 'urban-flow-eight-count-blocks', title: 'Eight-Count Blocks', type: LessonType.movement, duration: '12 min'),
    Lesson(id: 'urban-flow-texture-dynamics', title: 'Texture & Dynamics', type: LessonType.movement, duration: '12 min'),
    Lesson(id: 'urban-flow-transition-drills', title: 'Transition Drills', type: LessonType.drill, duration: '10 min'),
    Lesson(id: 'urban-flow-combo-a', title: 'Combo A', type: LessonType.movement, duration: '15 min'),
    Lesson(id: 'urban-flow-combo-b', title: 'Combo B', type: LessonType.movement, duration: '15 min'),
    Lesson(id: 'urban-flow-freestyle-bridge', title: 'Freestyle Bridge', type: LessonType.experiment, duration: '12 min'),
    Lesson(id: 'urban-flow-full-routine', title: 'Full Routine', type: LessonType.boss),
  ],
);

const Module contemporaryFusion = Module(
  id: 'contemporary-fusion',
  title: 'Contemporary Fusion',
  subtitle: 'Module 10 • Path',
  category: ModuleCategory.choreography,
  tag: 'Advanced',
  imageUrl:
      'https://images.unsplash.com/photo-1518834107812-67b0b7c58434?w=800&q=80',
  lessons: [
    Lesson(id: 'contemporary-fusion-concepts', title: 'Fusion Concepts', type: LessonType.theory, duration: '6 min'),
    Lesson(id: 'contemporary-fusion-floor-work', title: 'Floor Work Basics', type: LessonType.movement, duration: '12 min'),
    Lesson(id: 'contemporary-fusion-momentum-release', title: 'Momentum & Release', type: LessonType.movement, duration: '12 min'),
    Lesson(id: 'contemporary-fusion-balance-drills', title: 'Balance Drills', type: LessonType.drill, duration: '10 min'),
    Lesson(id: 'contemporary-fusion-contact-improv', title: 'Contact Improv', type: LessonType.experiment, duration: '15 min'),
    Lesson(id: 'contemporary-fusion-phrase-building', title: 'Phrase Building', type: LessonType.movement, duration: '15 min'),
    Lesson(id: 'contemporary-fusion-showcase', title: 'Fusion Showcase', type: LessonType.boss),
  ],
);

/// The full catalog, in display order. The first module is the default
/// active module for new users.
const List<Module> allModules = [
  hipHopFoundations,
  bodyControl1,
  isolationsMaster,
  footworkFundamentals,
  topRock,
  boogaloo,
  house,
  breakingBasics,
  urbanFlow,
  contemporaryFusion,
];

/// Effective steps for a lesson: hand-authored steps when the catalog has
/// them, otherwise the type-specific default set below. Every lesson type
/// trains differently, so every default set does too.
List<LessonStep> stepsFor(Lesson lesson) =>
    lesson.steps.isEmpty ? defaultStepsFor(lesson.type) : lesson.steps;

List<LessonStep> defaultStepsFor(LessonType type) {
  switch (type) {
    case LessonType.theory:
      return _theorySteps;
    case LessonType.drill:
      return _drillSteps;
    case LessonType.movement:
      return _movementSteps;
    case LessonType.experiment:
      return _experimentSteps;
    case LessonType.boss:
      return _bossSteps;
  }
}

const List<LessonStep> _theorySteps = [
  LessonStep(
    title: 'WATCH & ABSORB',
    description: 'Take the concept in before you try to move with it.',
    focus: 'Watch the full demonstration once without moving.',
    breath: 'Slow nasal breathing keeps the mind receptive.',
    energy: 'Save it — this step is about understanding, not output.',
  ),
  LessonStep(
    title: 'KEY CONCEPTS',
    description: 'Break the idea into pieces you can name.',
    focus: 'Say each concept out loud in your own words.',
    breath: 'Steady rhythm — in for four counts, out for four.',
    energy: 'Stay relaxed; tension blocks learning.',
  ),
  LessonStep(
    title: 'CONNECT THE DOTS',
    description: 'Relate the new idea to moves you already own.',
    focus: 'Find one move you know that already uses this idea.',
    breath: 'Breathe naturally while you visualize.',
    energy: 'Light marking only — half-speed sketches of the idea.',
  ),
  LessonStep(
    title: 'RECALL CHECK',
    description: 'Close the loop before moving on.',
    focus: 'Explain the concept from memory, no rewatching.',
    breath: 'One deep reset breath before you test yourself.',
    energy: 'Finish alert — this check cements the knowledge.',
  ),
];

const List<LessonStep> _drillSteps = [
  LessonStep(
    title: 'SLOW REPS',
    description: 'Groove the pattern at half speed.',
    focus: 'Perfect placement beats speed — check every position.',
    breath: 'Exhale on each accent to stay loose.',
    energy: 'Deliberate and controlled, around half power.',
  ),
  LessonStep(
    title: 'TEMPO REPS',
    description: 'Bring the drill up to music speed.',
    focus: 'Keep the quality you built at half speed.',
    breath: 'Match your breath to the eight-count.',
    energy: 'Working pace — strong but repeatable.',
  ),
  LessonStep(
    title: 'PRESSURE REPS',
    description: 'Push slightly past comfortable speed.',
    focus: 'Hold the technique together as the tempo climbs.',
    breath: 'Do not hold your breath under pressure.',
    energy: 'High output in short bursts; rest between sets.',
  ),
  LessonStep(
    title: 'CLEAN FINISH',
    description: 'End on your best three reps.',
    focus: 'Quality over quantity — stop while it is sharp.',
    breath: 'Long exhales to bring the heart rate down.',
    energy: 'Controlled burn — leave one rep in the tank.',
  ),
];

const List<LessonStep> _movementSteps = [
  LessonStep(
    title: 'GROOVE IN',
    description: 'Connect to the music before the technique.',
    focus: 'Lock your bounce to the drums first.',
    breath: 'Let the beat set your breathing rhythm.',
    energy: 'Easy sway — warm the body into it.',
  ),
  LessonStep(
    title: 'SHAPE THE MOVE',
    description: 'Build the movement piece by piece.',
    focus: 'Isolate the core mechanic before adding style.',
    breath: 'Exhale on the downbeat.',
    energy: 'Medium — clarity over power.',
  ),
  LessonStep(
    title: 'STYLE PASS',
    description: 'Make the move yours.',
    focus: 'Add texture: levels, angles, pauses.',
    breath: 'Breathe into the pauses to stay grounded.',
    energy: 'Play with dynamics — soft to sharp.',
  ),
  LessonStep(
    title: 'FULL FLOW',
    description: 'Run it in time with full expression.',
    focus: 'Commit fully — no checking, just dancing.',
    breath: 'Power the accents from the core with sharp exhales.',
    energy: 'Perform it like the cypher is watching.',
  ),
];

const List<LessonStep> _experimentSteps = [
  LessonStep(
    title: 'SET THE PLAYGROUND',
    description: 'Define loose rules for the exploration.',
    focus: 'Pick one constraint to push against.',
    breath: 'Relaxed breath — there are no wrong answers here.',
    energy: 'Curious and light.',
  ),
  LessonStep(
    title: 'EXPLORE',
    description: 'Move without judging the output.',
    focus: 'Follow what feels interesting, not what looks right.',
    breath: 'Keep breathing through the awkward moments.',
    energy: 'Loose and continuous — never stop moving.',
  ),
  LessonStep(
    title: 'CAPTURE',
    description: 'Keep what worked.',
    focus: 'Repeat your two favorite discoveries until they stick.',
    breath: 'Reset breath between repetitions.',
    energy: 'Focused — refine without stiffening up.',
  ),
  LessonStep(
    title: 'REMIX',
    description: 'Combine the discoveries into a phrase.',
    focus: 'Chain your finds into four eight-counts.',
    breath: 'Breathe with the phrase, not against it.',
    energy: 'Build to a confident finish.',
  ),
];

const List<LessonStep> _bossSteps = [
  LessonStep(
    title: 'WARM THE ENGINE',
    description: 'Prime everything the showcase needs.',
    focus: 'Touch every move from the module at least once.',
    breath: 'Big diaphragm breaths — calm the nerves.',
    energy: 'Rising — from stroll to ready.',
  ),
  LessonStep(
    title: 'RUN THE GAUNTLET',
    description: 'The full sequence, no stopping.',
    focus: 'Recover forward — mistakes stay in the past.',
    breath: 'Steady through transitions, sharp exhale on accents.',
    energy: 'Performance level.',
  ),
  LessonStep(
    title: 'PRESSURE ROUND',
    description: 'One more run with higher stakes.',
    focus: 'Add your own flavor on top of the technique.',
    breath: 'Exhale hard on the biggest hit.',
    energy: 'Everything you have.',
  ),
  LessonStep(
    title: 'VICTORY LAP',
    description: 'Own the result.',
    focus: 'One final freestyle to celebrate the new skill.',
    breath: 'Let the breath settle naturally.',
    energy: 'Joyful — you earned this one.',
  ),
];
