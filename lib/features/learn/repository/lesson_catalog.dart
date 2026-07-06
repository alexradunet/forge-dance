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
    ),
    Lesson(
      id: 'groove-basics',
      title: 'Groove Basics',
      type: LessonType.movement,
      duration: '15 min',
      steps: [
        'FIND THE BEAT',
        'BOUNCE TECHNIQUE',
        'ARM SWING',
        'FULL GROOVE',
      ],
    ),
    Lesson(
      id: 'bounce-and-rock',
      title: 'Bounce & Rock',
      type: LessonType.drill,
      duration: '10 min',
    ),
    Lesson(
      id: 'freestyle-session',
      title: 'Freestyle Session',
      type: LessonType.experiment,
      duration: '20 min',
    ),
    Lesson(
      id: 'boss-showcase',
      title: 'Boss Showcase',
      type: LessonType.boss,
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
