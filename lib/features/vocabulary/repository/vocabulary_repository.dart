import '../../learn/model/lesson.dart';
import '../../learn/repository/lesson_catalog.dart';
import '../../method/model/forge_method.dart';
import '../../practice/model/practice.dart';
import '../model/vocabulary_entry.dart';

/// Bundled English reference content, like the lesson catalog. No IO or locks.
class VocabularyRepository {
  const VocabularyRepository();

  List<VocabularyEntry> get entries => _entries;

  VocabularyEntry? byId(String id) {
    for (final entry in entries) {
      if (entry.id == id) return entry;
    }
    return null;
  }

  List<String> get styles =>
      entries.map((entry) => entry.style).toSet().toList()..sort();

  List<VocabularyEntry> search({
    String query = '',
    VocabularyKind? kind,
    String? style,
  }) {
    final normalized = query.trim().toLowerCase();
    return entries
        .where(
          (entry) =>
              (kind == null || entry.kind == kind) &&
              (style == null || entry.style == style) &&
              [
                entry.name,
                entry.definition,
                ...entry.aliases,
              ].any((text) => text.toLowerCase().contains(normalized)),
        )
        .toList();
  }

  /// Include module gates and earlier units; use LearnState for actual access,
  /// including its policy for returning learners with grandfathered progress.
  List<Lesson> prerequisitesFor(VocabularyEntry entry) {
    final module = allModules.firstWhere(
      (module) => module.id == entry.moduleId,
    );
    final index = module.lessons.indexWhere(
      (lesson) => lesson.id == entry.lessonId,
    );
    final ids = {
      ...module.prerequisiteLessonIds,
      ...module.lessons.take(index).map((lesson) => lesson.id),
    };
    return [
      for (final module in allModules)
        for (final lesson in module.lessons)
          if (ids.contains(lesson.id)) lesson,
    ];
  }

  PracticeBlock practiceFor(VocabularyEntry entry, {bool harder = false}) =>
      PracticeBlock(
        id: 'vocabulary-${entry.id}-${harder ? 'variation' : 'supported'}',
        title: entry.name,
        category: entry.category,
        level: 1,
        minutes: 3,
        bpm: harder ? 80 : 60,
        lessonId: entry.lessonId,
        vocabularyId: entry.id,
        cues: [
          entry.cue,
          harder ? entry.harderPractice : entry.easierPractice,
          entry.practice,
          'Pause and recall the pattern without a model. Note what stayed clear and what you would change.',
        ],
        adaptation: entry.easierPractice,
      );
}

const _entries = [
  VocabularyEntry(
    id: 'bounce',
    name: 'Bounce',
    kind: VocabularyKind.move,
    style: 'Hip hop',
    aliases: ['Down bounce'],
    definition: 'A repeated, relaxed bending and releasing action that lets the body ride the beat.',
    cue: 'Keep the bend small and comfortable. Let the upper body respond rather than stiffening it.',
    commonMistake: 'Forcing a deep bend or locking the knees on the release.',
    practice: 'Try eight gentle pulses at a comfortable tempo, then pause. Seated dancers can explore a small torso pulse instead. Keep breathing freely.',
    moduleId: 'hip-hop-foundations',
    lessonId: 'groove-basics',
    category: ForgeCategory.rhythm,
    context: 'Bounce is a foundational groove in hip-hop social dance. Its feel comes from a relaxed relationship to the music, not from how low you bend. Names and timing vary between communities and teachers.',
    easierPractice: 'Sit on a stable chair or keep support nearby. Use four very small torso pulses, then rest; keep both feet supported.',
    harderPractice: 'Keep the same small bounce for two eight-count phrases. Add a quiet arm gesture on alternating pulses without losing the timing, then pause.',
    relatedIds: ['pulse', 'rock'],
  ),
  VocabularyEntry(
    id: 'breath',
    name: 'Breath',
    kind: VocabularyKind.concept,
    style: 'Foundations',
    definition: 'Continuous breathing supports movement and helps you notice effort and tension.',
    cue: 'Choose a comfortable base and let the breath continue as you move.',
    commonMistake: 'Holding your breath to concentrate or forcing it into an uncomfortable count.',
    practice: 'Rest in a supported position. Notice a few easy breaths, then add a small arm or torso movement without changing your breathing.',
    moduleId: 'common-ready-body',
    lessonId: 'common-ready-body-bases-breath',
    category: ForgeCategory.bodyControl,
    context: 'Breath awareness supports many dance practices. It is a way to notice effort, not a prescribed breathing technique or a medical exercise.',
    easierPractice: 'Use a supported seated or resting base. Notice natural breathing without changing its speed or depth; add one small hand movement only if comfortable.',
    harderPractice: 'Move between three comfortable shapes while breathing naturally. Pause between shapes, then recall their order without bracing or holding your breath.',
    relatedIds: ['weight-transfer'],
  ),
  VocabularyEntry(
    id: 'pulse',
    name: 'Pulse',
    kind: VocabularyKind.concept,
    style: 'Foundations',
    aliases: ['Beat', 'Steady beat'],
    definition: 'A steady recurring timing cue. It can be heard, seen, or felt; not all music or movement has a regular pulse.',
    cue: 'Keep the action simple enough that the timing stays clear.',
    commonMistake:
        'Following every musical detail instead of a steady timing cue.',
    practice: 'Tap, nod, or gesture with a comfortable repeating cue for eight pulses. Pause and restart. Use sound, a visual cue, or a felt rhythm.',
    moduleId: 'common-time-weight',
    lessonId: 'common-time-weight-find-pulse',
    category: ForgeCategory.rhythm,
    context: 'Pulse is a timing reference across many dance and music traditions. A regular beat is useful here but is not a requirement of all music or dance.',
    easierPractice: 'Choose a visual cue or slow click. Tap one finger for four pulses, pause, and restart. No standing or sound production is required.',
    harderPractice: 'Maintain eight pulses, leave four silent counts while continuing internally, then return to the cue. Repeat at a second comfortable tempo.',
    relatedIds: ['rhythm', 'bounce'],
  ),
  VocabularyEntry(
    id: 'rhythm',
    name: 'Rhythm',
    kind: VocabularyKind.concept,
    style: 'Foundations',
    aliases: ['Timing pattern'],
    definition: 'The arrangement of events, durations, accents, and pauses. A rhythm can sit over a pulse without matching every beat.',
    cue: 'Preserve the order of events before adding speed or complexity.',
    commonMistake: 'Removing the pauses or making every event the same length.',
    practice: 'Make a short tap–tap–pause pattern using a hand, foot, or gesture. Repeat it, wait briefly, then recall it without a model.',
    moduleId: 'common-time-weight',
    lessonId: 'common-time-weight-rhythm-patterns',
    category: ForgeCategory.rhythm,
    context: 'Rhythm organizes movement through duration, accent and silence. Counts are one learning tool; spoken syllables, gesture and felt timing are equally useful.',
    easierPractice: 'Tap twice and pause with one hand or another available input. Repeat slowly with a visible cue; keep the same order.',
    harderPractice: 'Create a four-event pattern with a deliberate pause. Recall it after a short break, then perform it with a different body area without changing the event order.',
    relatedIds: ['pulse'],
  ),
  VocabularyEntry(
    id: 'rock',
    name: 'Rock',
    kind: VocabularyKind.move,
    style: 'Hip hop',
    aliases: ['Body rock'],
    definition: 'A rhythmic back-and-forth or side-to-side action of the body, often combined with a groove.',
    cue: 'Start with a small range and keep the return as controlled as the outward movement.',
    commonMistake:
        'Leaning beyond your support or holding tension in the shoulders.',
    practice: 'From a stable standing or seated base, rock gently side to side for eight counts. Pause, then try a smaller range. Keep support available.',
    moduleId: 'hip-hop-foundations',
    lessonId: 'bounce-and-rock',
    category: ForgeCategory.bodyControl,
    context: 'A rock appears in hip-hop grooves as a controlled, rhythmic shift. This entry describes a small body-rock exploration, not a substitute for the distinct techniques of rocking or breaking traditions.',
    easierPractice: 'Remain seated or supported with both feet grounded. Explore a tiny side-to-side torso action and return to center after each side.',
    harderPractice: 'Alternate forward-back and side-to-side rocks over two eight-count phrases. Keep each return controlled and add direction changes only within your base.',
    relatedIds: ['bounce', 'weight-transfer'],
  ),
  VocabularyEntry(
    id: 'weight-transfer',
    name: 'Weight transfer',
    kind: VocabularyKind.concept,
    style: 'Foundations',
    aliases: ['Weight shift'],
    definition: 'A change in which support carries your weight, making another contact point available to move.',
    cue:
        'Move your center toward support before freeing another contact point.',
    commonMistake:
        'Moving a foot before the other side is ready to support you.',
    practice: 'With support nearby, shift gently side to side and pause on each side. Keep both feet or hands supported and use partial shifts if that suits you.',
    moduleId: 'common-time-weight',
    lessonId: 'common-time-weight-transfer-weight',
    category: ForgeCategory.footwork,
    context: 'Transferring support makes stepping and directional change possible in many styles. The principle also applies to seated or assisted movement without requiring full single-leg balance.',
    easierPractice: 'Use a stable chair, wall or mobility aid. Keep all contact points supported, make a partial side shift, and return to center.',
    harderPractice: 'Shift, free one contact point only if stable, step or gesture, and return. Combine side and forward directions with a deliberate pause before each change.',
    relatedIds: ['rock', 'breath'],
  ),
];
