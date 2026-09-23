import '../../method/model/forge_method.dart';
import '../model/practice.dart';
import 'daily_practice_catalog.dart';

/// Everyone receives the same civil-date theme; earned FORGE belt selects the
/// variation. Practice never awards a belt or completes the referenced lesson.
PracticePlan buildPracticePlan({
  required DateTime date,
  required MethodProgress progress,
  required int minutes,
  required bool gentle,
  required bool includeConditioning,
  PracticeSupport support = PracticeSupport.standing,
}) {
  if (minutes < 10 || minutes > 60) {
    throw ArgumentError.value(minutes, 'minutes', 'Choose 10–60 minutes.');
  }
  final theme = dailyPracticeThemeFor(date);
  final dateKey =
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
  final beltIndex = progress.earnedBeltIndex;
  final level = (beltIndex - (gentle ? 1 : 0)).clamp(0, 7);
  final variation = theme.variations[level];
  final supportCue = switch (support) {
    PracticeSupport.standing => 'Use a comfortable standing base with a stable chair or wall within reach. Keep movements low-impact and your space clear.',
    PracticeSupport.seated => theme.seated,
    PracticeSupport.supported => theme.supported,
  };
  final adaptation = [
    supportCue,
    if (gentle) 'Use the gentler variation with small comfortable movements and equal work and rest. Your earned belt is unchanged.',
    'Reduce range, tempo or layers whenever useful. Rest is part of practice.',
  ].join(' ');
  // Keep recovery proportional to the session and reserve the remaining budget
  // for two focused work blocks, plus an optional easy conditioning block.
  final recoveryMinutes = (minutes ~/ 10).clamp(2, 5);
  final conditioningMinutes = includeConditioning ? minutes ~/ 5 : 0;
  final workMinutes = minutes - recoveryMinutes * 2 - conditioningMinutes;
  final drillMinutes = (workMinutes + 1) ~/ 2;
  final applicationMinutes = workMinutes ~/ 2;
  final tempo = gentle ? 50 : 60;

  PracticeBlock block({
    required String role,
    required String title,
    required ForgeCategory category,
    required int duration,
    required String cue,
    bool recovery = false,
  }) => PracticeBlock(
    // Scheduled date belongs in metadata, not the comparison identity. Version
    // authored content deliberately if a future revision changes the exercise.
    id: '${theme.id}-v1-$role-l$level-${support.name}-${gentle ? 'gentle' : 'regular'}',
    workoutId: theme.id,
    workoutDate: dateKey,
    title: title,
    category: category,
    level: level,
    minutes: duration,
    bpm: recovery ? 50 : tempo,
    lessonId: theme.lessonId,
    cues: [
      supportCue,
      cue,
      if (gentle && !recovery) 'Use short comfortable attempts, then rest for at least as long. Finish the round early if control changes.',
      'Breathe normally. Pause between attempts and stop for pain, dizziness or unusual breathlessness.',
    ],
    adaptation: adaptation,
  );

  return PracticePlan(
    workoutId: theme.id,
    title: theme.title,
    focus: theme.focus,
    dateKey: dateKey,
    beltIndex: beltIndex,
    blocks: [
      block(
        role: 'warmup',
        title: 'Warm up · ${theme.title}',
        category: ForgeCategory.mobility,
        duration: recoveryMinutes,
        cue: theme.warmup,
        recovery: true,
      ),
      block(
        role: 'drill',
        title: variation.title,
        category: theme.category,
        duration: drillMinutes,
        cue: variation.drill,
      ),
      block(
        role: 'application',
        title: 'Apply · ${variation.title}',
        category: theme.category,
        duration: applicationMinutes,
        cue: variation.application,
      ),
      if (includeConditioning)
        block(
          role: 'conditioning',
          title: 'Easy conditioning · ${theme.title}',
          category: ForgeCategory.capacity,
          duration: conditioningMinutes,
          cue:
              '${theme.conditioning} '
              'Move for up to ${gentle || level == 0 ? 20 : 30} seconds, then rest for ${gentle || level == 0 ? 40 : 30} seconds. '
              'Repeat only while you can speak a full sentence comfortably; shorten the work or rest longer whenever needed. The timer includes rest.',
        ),
      block(
        role: 'cooldown',
        title: 'Cool down · ${theme.title}',
        category: ForgeCategory.mobility,
        duration: recoveryMinutes,
        cue: theme.cooldown,
        recovery: true,
      ),
    ],
  );
}
