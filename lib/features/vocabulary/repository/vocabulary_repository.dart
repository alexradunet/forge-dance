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
    relatedIds: ['rock', 'breath'],
  ),
];
