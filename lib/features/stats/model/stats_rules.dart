import '../../learn/model/lesson.dart';
import '../../learn/model/lesson_progress.dart';
import '../../workout/model/workout.dart';
import '../../workout/model/workout_session.dart';
import 'user_stats.dart';

/// Pure gamification rules — no IO, no Flutter. Everything here is trivially
/// unit-testable (see test/stats_test.dart), mirroring the computeRedirect
/// pattern.

/// XP awarded for completing a lesson, by type.
int xpForLessonType(LessonType type) {
  switch (type) {
    case LessonType.theory:
      return 20;
    case LessonType.drill:
      return 30;
    case LessonType.movement:
      return 40;
    case LessonType.experiment:
      return 50;
    case LessonType.boss:
      return 100;
  }
}

/// Total XP is fully derivable from completed lessons — the persisted `xp`
/// field on the user doc is a denormalized mirror, never the source of truth.
int totalXpFrom(List<Module> modules, Map<String, LessonProgress> progress) {
  var total = 0;
  for (final module in modules) {
    for (final lesson in module.lessons) {
      if (progress[lesson.id]?.status == LessonStatus.completed) {
        total += xpForLessonType(lesson.type);
      }
    }
  }
  return total;
}

/// XP earned from completed workout sessions, priced by the catalog (a
/// session whose workout no longer exists earns nothing). Sessions are
/// deduplicated at the storage layer (one doc per workout per day).
int workoutXpFrom(List<Workout> workouts, Iterable<WorkoutSession> sessions) {
  final byId = {for (final workout in workouts) workout.id: workout};
  var total = 0;
  for (final session in sessions) {
    total += byId[session.workoutId]?.xp ?? 0;
  }
  return total;
}

/// Belt names, in order. Content vocabulary (like lesson titles) — not
/// translated. Colors live in the profile feature's DanceLevel model.
const List<String> beltNames = [
  'White',
  'Yellow',
  'Orange',
  'Blue',
  'Violet',
  'Red',
  'Brown',
  'Black',
];

/// Cumulative XP required to REACH each belt. Calibrated to the catalog:
/// Yellow ≈ one completed module, Black == every lesson in the catalog
/// (test/stats_test.dart enforces that the last threshold equals the total
/// XP available, so catalog changes force a deliberate re-calibration here).
const List<int> beltThresholds = [0, 240, 550, 900, 1300, 1750, 2250, 2810];

/// 0-based belt index for a given XP total.
int beltIndexForXp(int xp) {
  var index = 0;
  for (var i = 0; i < beltThresholds.length; i++) {
    if (xp >= beltThresholds[i]) index = i;
  }
  return index;
}

/// yyyy-MM-dd in local time — the persisted activity-date format.
String dateKey(DateTime moment) {
  final y = moment.year.toString().padLeft(4, '0');
  final m = moment.month.toString().padLeft(2, '0');
  final d = moment.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

/// Streak transition for a training activity happening at [now].
/// Same day → unchanged (min 1); consecutive day → +1; gap or first
/// activity → reset to 1.
({int streak, String activityDate}) nextStreak({
  required int currentStreak,
  required String? lastActivityDate,
  required DateTime now,
}) {
  final today = dateKey(now);
  if (lastActivityDate == today) {
    return (streak: currentStreak < 1 ? 1 : currentStreak, activityDate: today);
  }

  final yesterday = dateKey(DateTime(now.year, now.month, now.day - 1));
  if (lastActivityDate == yesterday) {
    return (streak: currentStreak + 1, activityDate: today);
  }

  return (streak: 1, activityDate: today);
}

/// What the UI should show as the streak: the persisted count only survives
/// while the streak is alive (activity today or yesterday); otherwise 0.
int displayStreak({
  required int persistedStreak,
  required String? lastActivityDate,
  required DateTime now,
}) {
  final today = dateKey(now);
  final yesterday = dateKey(DateTime(now.year, now.month, now.day - 1));
  if (lastActivityDate == today || lastActivityDate == yesterday) {
    return persistedStreak;
  }
  return 0;
}

/// Compact XP formatting for stat cards: 840 → "840", 2470 → "2.5k".
String formatXp(int xp) {
  if (xp < 1000) return '$xp';
  return '${(xp / 1000).toStringAsFixed(1)}k';
}

/// Combines derived XP (lessons + workout sessions) with the persisted
/// streak into the display model.
UserStats buildUserStats({
  required List<Module> modules,
  required Map<String, LessonProgress> progress,
  required int persistedStreak,
  required String? lastActivityDate,
  required DateTime now,
  int workoutXp = 0,
}) {
  final totalXp = totalXpFrom(modules, progress) + workoutXp;
  final beltIndex = beltIndexForXp(totalXp);
  final isMax = beltIndex == beltThresholds.length - 1;
  final xpIntoLevel = totalXp - beltThresholds[beltIndex];
  final span = isMax ? 0 : beltThresholds[beltIndex + 1] - beltThresholds[beltIndex];

  return UserStats(
    totalXp: totalXp,
    streakCount: displayStreak(
      persistedStreak: persistedStreak,
      lastActivityDate: lastActivityDate,
      now: now,
    ),
    level: beltIndex + 1,
    beltName: beltNames[beltIndex],
    xpIntoLevel: xpIntoLevel,
    xpForLevelSpan: span,
    nextLevelXp: isMax ? null : beltThresholds[beltIndex + 1],
    levelProgress: span == 0 ? 1.0 : xpIntoLevel / span,
  );
}
