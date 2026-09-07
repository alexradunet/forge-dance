import '../../method/model/forge_method.dart';
import '../../method/repository/method_catalog.dart';
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
        total += progress[lesson.id]?.awardedXp ?? xpForLessonType(lesson.type);
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
    total += session.awardedXp ?? byId[session.workoutId]?.xp ?? 0;
  }
  return total;
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
  int minimumXp = 0,
  MethodProgress? method,
  Iterable<String> practiceDates = const [],
}) {
  final derivedXp = totalXpFrom(modules, progress) + workoutXp;
  final totalXp = derivedXp > minimumXp ? derivedXp : minimumXp;
  final mastery = method ?? MethodProgress();
  final beltIndex = mastery.earnedBeltIndex;
  final isMax = beltIndex == forgeBelts.length - 1;
  var activityStreak = persistedStreak;
  var activityDate = lastActivityDate;
  final today = dateKey(now);
  final newPracticeDates =
      practiceDates
          .where(
            (date) =>
                date.compareTo(today) <= 0 &&
                (lastActivityDate == null ||
                    date.compareTo(lastActivityDate) > 0),
          )
          .toSet()
          .toList()
        ..sort();
  for (final date in newPracticeDates) {
    final next = nextStreak(
      currentStreak: activityStreak,
      lastActivityDate: activityDate,
      now: DateTime.parse(date),
    );
    activityStreak = next.streak;
    activityDate = next.activityDate;
  }

  return UserStats(
    totalXp: totalXp,
    streakCount: displayStreak(
      persistedStreak: activityStreak,
      lastActivityDate: activityDate,
      now: now,
    ),
    level: beltIndex + 1,
    beltName: forgeBelts[beltIndex].name,
    nextBeltName: isMax ? null : forgeBelts[beltIndex + 1].name,
    levelProgress: mastery.nextBeltProgress,
  );
}
