import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../learn/model/lesson.dart';
import '../../learn/model/lesson_progress.dart';
import '../../learn/repository/lesson_catalog.dart';
import '../../learn/repository/progress_repository.dart';
import '../../profile/model/profile.dart';
import '../../profile/repository/profile_repository.dart';
import '../../workout/model/workout.dart';
import '../../workout/model/workout_session.dart';
import '../../workout/repository/session_repository.dart';
import '../../workout/repository/workout_catalog.dart';
import '../model/stats_rules.dart';
import '../model/projection_health.dart';

part 'training_activity.g.dart';

enum CompletionStatus { completed, alreadyCompleted }

typedef CompletionResult<T> = ({
  T record,
  CompletionStatus status,
  ProjectionHealth projection,
});

@Riverpod(keepAlive: true)
TrainingActivity trainingActivity(Ref ref) => TrainingActivity(
      progressRepository: ref.watch(progressRepositoryProvider),
      sessionRepository: ref.watch(sessionRepositoryProvider),
      profileRepository: ref.watch(profileRepositoryProvider),
    );

/// Owns durable Training Activity completion and repairable stats projection.
class TrainingActivity {
  const TrainingActivity({
    required this._progressRepository,
    required this._sessionRepository,
    required this._profileRepository,
  });

  final ProgressRepository _progressRepository;
  final SessionRepository _sessionRepository;
  final ProfileRepository _profileRepository;

  Future<CompletionResult<LessonProgress>> completeLesson({
    required Lesson lesson,
    DateTime? now,
  }) async {
    final moment = now ?? DateTime.now();
    final write = await _progressRepository.completeOnce(
      LessonProgress(
        lessonId: lesson.id,
        status: LessonStatus.completed,
        progress: 1,
        completedDate: dateKey(moment),
        awardedXp: xpForLessonType(lesson.type),
      ),
    );
    return (
      record: write.progress,
      status: write.created
          ? CompletionStatus.completed
          : CompletionStatus.alreadyCompleted,
      projection: await _repairProjection(now: moment),
    );
  }

  Future<CompletionResult<WorkoutSession>> completeWorkout({
    required Workout workout,
    DateTime? now,
  }) async {
    final moment = now ?? DateTime.now();
    final write = await _sessionRepository.completeOnce(
      WorkoutSession(
        workoutId: workout.id,
        date: dateKey(moment),
        awardedXp: workout.xp,
      ),
    );
    return (
      record: write.session,
      status: write.created
          ? CompletionStatus.completed
          : CompletionStatus.alreadyCompleted,
      projection: await _repairProjection(now: moment),
    );
  }

  Future<ProjectionHealth> repairProjection({DateTime? now}) =>
      _repairProjection(now: now ?? DateTime.now());

  Future<ProjectionHealth> _repairProjection({required DateTime now}) async {
    try {
      final progress = await _progressRepository.getAll();
      final sessions = await _sessionRepository.getAll();
      final profile = await _profileRepository.get();
      final dates = <String>{
        for (final item in progress.values)
          if (item.status == LessonStatus.completed &&
              (item.completedDate != null || item.updatedAt != null))
            item.completedDate ?? dateKey(item.updatedAt!),
        for (final session in sessions) session.date,
      };
      final hasIncompleteHistory = progress.values.any(
        (item) =>
            item.status == LessonStatus.completed &&
            item.completedDate == null &&
            item.updatedAt == null,
      );
      final projectedXp = totalXpFrom(allModules, progress) +
          workoutXpFrom(allWorkouts, sessions);
      final streak = _streakFrom(dates);
      await _profileRepository.update(
        (profile ?? const Profile()).copyWith(
          xp: hasIncompleteHistory
              ? _max(projectedXp, profile?.xp ?? 0)
              : projectedXp,
          streakCount: hasIncompleteHistory
              ? _max(streak.count, profile?.streakCount ?? 0)
              : streak.count,
          lastActivityDate: streak.lastDate ?? profile?.lastActivityDate,
        ),
      );
      return ProjectionHealth.current;
    } catch (_) {
      return ProjectionHealth.pendingRepair;
    }
  }

  ({int count, String? lastDate}) _streakFrom(Set<String> dates) {
    if (dates.isEmpty) return (count: 0, lastDate: null);
    final sorted = dates.toList()..sort();
    var count = 1;
    for (var index = sorted.length - 1; index > 0; index--) {
      final current = DateTime.parse(sorted[index]);
      if (dateKey(current.subtract(const Duration(days: 1))) !=
          sorted[index - 1]) {
        break;
      }
      count++;
    }
    return (count: count, lastDate: sorted.last);
  }

  int _max(int first, int second) => first > second ? first : second;
}
