import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/features/learn/model/lesson_progress.dart';
import 'package:forge_dance/features/learn/repository/lesson_catalog.dart';
import 'package:forge_dance/features/learn/repository/progress_repository.dart';
import 'package:forge_dance/features/profile/model/profile.dart';
import 'package:forge_dance/features/profile/repository/profile_repository.dart';
import 'package:forge_dance/features/stats/application/training_activity.dart';
import 'package:forge_dance/features/stats/model/stats_rules.dart';
import 'package:forge_dance/features/stats/model/projection_health.dart';
import 'package:forge_dance/features/workout/model/workout_session.dart';
import 'package:forge_dance/features/workout/repository/session_repository.dart';
import 'package:forge_dance/features/workout/repository/workout_catalog.dart';

class MemoryProgressRepository extends ProgressRepository {
  MemoryProgressRepository() : super(auth: null, firestore: null);
  final records = <String, LessonProgress>{};

  @override
  Future<Map<String, LessonProgress>> getAll() async => {...records};

  @override
  Future<({LessonProgress progress, bool created})> completeOnce(
    LessonProgress completion,
  ) async {
    final existing = records[completion.lessonId];
    if (existing?.status == LessonStatus.completed) {
      return (progress: existing!, created: false);
    }
    records[completion.lessonId] = completion;
    return (progress: completion, created: true);
  }
}

class MemorySessionRepository extends SessionRepository {
  MemorySessionRepository() : super(auth: null, firestore: null);
  final records = <String, WorkoutSession>{};

  @override
  Future<List<WorkoutSession>> getAll() async => records.values.toList();

  @override
  Future<({WorkoutSession session, bool created})> completeOnce(
    WorkoutSession completion,
  ) async {
    final existing = records[completion.docKey];
    if (existing != null) return (session: existing, created: false);
    records[completion.docKey] = completion;
    return (session: completion, created: true);
  }
}

class MemoryProfileRepository extends ProfileRepository {
  MemoryProfileRepository() : super(auth: null, firestore: null);
  Profile? value;
  bool failWrites = false;

  @override
  Future<Profile?> get() async => value;

  @override
  Future<void> update(Profile profile) async {
    if (failWrites) throw StateError('projection unavailable');
    value = profile;
  }
}

void main() {
  late MemoryProgressRepository progress;
  late MemorySessionRepository sessions;
  late MemoryProfileRepository profile;
  late TrainingActivity activity;

  setUp(() {
    progress = MemoryProgressRepository();
    sessions = MemorySessionRepository();
    profile = MemoryProfileRepository();
    activity = TrainingActivity(
      progressRepository: progress,
      sessionRepository: sessions,
      profileRepository: profile,
    );
  });

  test('first lesson completion preserves date and awarded XP on replay',
      () async {
    final lesson = allModules.first.lessons.first;
    final first = await activity.completeLesson(
      lesson: lesson,
      now: DateTime(2026, 7, 6),
    );
    final replay = await activity.completeLesson(
      lesson: lesson,
      now: DateTime(2026, 7, 9),
    );

    expect(first.status, CompletionStatus.completed);
    expect(replay.status, CompletionStatus.alreadyCompleted);
    expect(replay.record.completedDate, '2026-07-06');
    expect(replay.record.awardedXp, xpForLessonType(lesson.type));
    expect(profile.value?.streakCount, 1);
  });

  test('completion succeeds with a pending projection and repairs later',
      () async {
    profile.failWrites = true;
    final workout = allWorkouts.first;
    final result = await activity.completeWorkout(
      workout: workout,
      now: DateTime(2026, 7, 6),
    );

    expect(result.status, CompletionStatus.completed);
    expect(result.projection, ProjectionHealth.pendingRepair);
    expect(sessions.records, hasLength(1));

    profile.failWrites = false;
    expect(
      await activity.repairProjection(now: DateTime(2026, 7, 6)),
      ProjectionHealth.current,
    );
    expect(profile.value?.xp, workout.xp);
  });

  test('projection derives a consecutive streak across activity kinds',
      () async {
    await activity.completeLesson(
      lesson: allModules.first.lessons.first,
      now: DateTime(2026, 7, 6),
    );
    await activity.completeWorkout(
      workout: allWorkouts.first,
      now: DateTime(2026, 7, 7),
    );

    expect(profile.value?.streakCount, 2);
    expect(profile.value?.lastActivityDate, '2026-07-07');
  });
}
