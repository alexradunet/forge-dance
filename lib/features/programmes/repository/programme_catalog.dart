import '../../learn/model/lesson.dart';
import '../../learn/repository/lesson_catalog.dart';
import '../../method/model/forge_method.dart';
import '../../practice/model/practice.dart';
import '../model/programme.dart';

ProgrammeSession _session(
  Lesson lesson,
  int day,
  ForgeCategory category, {
  int minutes = 4,
  int bpm = 70,
  String? prompt,
}) => ProgrammeSession(
  lessonId: lesson.id,
  schedule: 'Session $day • ${lesson.duration} lesson + $minutes min practice',
  practice: PracticeBlock(
    id: 'programme-${lesson.id}',
    title: lesson.title,
    category: category,
    level: 1,
    minutes: minutes,
    bpm: bpm,
    lessonId: lesson.id,
    cues: [
      if (prompt != null) prompt,
      ...stepsFor(lesson).map((step) => step.description),
    ],
    adaptation: 'Choose standing, seated, or supported movement. Reduce range or tempo and rest whenever needed. Stop for pain, dizziness, unusual breathlessness, or instability.',
  ),
);

List<ProgrammeSession> _sessions(
  List<Module> modules,
  ForgeCategory category, {
  int minutes = 4,
}) {
  var index = 0;
  return [
    for (final module in modules)
      for (final lesson in module.lessons)
        _session(lesson, ++index, category, minutes: minutes),
  ];
}

/// All titles, instructions and schedules are bundled instructional content,
/// matching the English lesson catalogue. A session never bypasses lesson locks.
final List<Programme> forgeProgrammes = [
  Programme(
    id: 'find-the-beat',
    title: 'Find the Beat',
    description: 'Build a safe base, locate a steady pulse, then preserve accents and pauses. Sound is optional: visual or felt timing cues work too.',
    schedule: '2 weeks • 3 sessions per week • Leave a rest day between sessions when useful. Repeat any session before moving on.',
    prerequisiteLessonIds: const [],
    intendedGains: const {
      ForgeCategory.rhythm:
          'Maintain a comfortable pulse and recall a short timing pattern.',
      ForgeCategory.bodyControl: 'Start and stop over a stable, chosen base.',
    },
    sessions: _sessions([readyBody, timeAndWeight], ForgeCategory.rhythm),
    assessmentId: 'rhythm-1-v1',
  ),
  Programme(
    id: 'move-with-control',
    title: 'Move with Control',
    description: 'Separate initiation, control the return, and connect two available body areas without increasing range or forcing isolation.',
    schedule: '3 weeks • 2 sessions per week • Begin each session with a familiar easy action and finish with a quiet reset.',
    prerequisiteLessonIds: const ['common-ready-body-bases-breath'],
    intendedGains: const {
      ForgeCategory.bodyControl:
          'Recover to a stable base with deliberate movement quality.',
      ForgeCategory.coordination:
          'Combine two simple patterns at a manageable tempo.',
    },
    sessions: _sessions([
      timeAndWeight,
      spaceAndCoordination,
    ], ForgeCategory.bodyControl),
    assessmentId: 'bodyControl-1-v1',
  ),
  Programme(
    id: 'first-freestyle',
    title: 'First Freestyle',
    description: 'Learn a repeatable phrase, change one quality, then make and communicate your own short choices. Stillness and small gestures are valid material.',
    schedule: '3 weeks • 2 sessions per week • Revisit your previous motif briefly before each new session.',
    prerequisiteLessonIds: const ['common-space-coordination-parts-together'],
    intendedGains: const {
      ForgeCategory.creativity:
          'Respond to a constraint and choose a distinct movement variation.',
      ForgeCategory.retention: 'Recall a short motif independently rather than continuously copying.',
    },
    sessions: _sessions(
      [qualityAndPhrase, makeAndCommunicate],
      ForgeCategory.creativity,
      minutes: 5,
    ),
    assessmentId: 'creativity-1-v1',
  ),
  Programme(
    id: 'movement-foundations',
    title: 'Movement Foundations',
    description: 'Follow the complete common foundation from a usable practice space to timing, spatial choice, phrase recall, composition and relationship.',
    schedule: '6 weeks • 3 sessions per week • One foundation module per week. Take extra weeks or repeat lessons at your own pace.',
    prerequisiteLessonIds: const [],
    intendedGains: const {
      ForgeCategory.rhythm: 'Choose and maintain useful timing cues.',
      ForgeCategory.bodyControl: 'Initiate, stop and recover comfortably.',
      ForgeCategory.footwork: 'Transfer support before changing direction.',
      ForgeCategory.coordination: 'Connect available body areas.',
      ForgeCategory.retention: 'Recall and adapt a short phrase.',
      ForgeCategory.creativity: 'Compose and communicate deliberate choices.',
    },
    sessions: _sessions(commonFoundationModules, ForgeCategory.coordination),
    assessmentId: 'integrated-1-v1',
  ),
  Programme(
    id: 'dance-endurance',
    title: 'Dance Endurance',
    description: 'Practice sustainable, self-paced movement using familiar pulse, transfer and pattern material. Rest is part of the session; duration is not a fitness gate or a belt requirement.',
    schedule: '1–2 weeks • 3 sessions with recovery days • In the practice timer alternate up to 30 seconds of easy movement with 30 seconds of rest. Shorten either interval as needed.',
    prerequisiteLessonIds: const ['common-ready-body-bases-breath'],
    intendedGains: const {
      ForgeCategory.capacity:
          'Notice effort, choose rest early and recover comfortably.',
      ForgeCategory.rhythm:
          'Keep an easy timing cue without increasing intensity.',
    },
    sessions: [
      for (var i = 0; i < timeAndWeight.lessons.length; i++)
        _session(
          timeAndWeight.lessons[i],
          i + 1,
          ForgeCategory.capacity,
          minutes: 4 + i,
          bpm: 60,
          prompt: 'Alternate comfortable movement and rest. Keep an effort at which you can speak comfortably or use your usual effort signal. Seated and supported versions are equally valid. Stop early whenever needed.',
        ),
    ],
    assessmentId: 'capacity-1-v1',
  ),
];
