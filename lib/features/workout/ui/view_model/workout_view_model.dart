import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../stats/application/training_activity.dart';
import '../../../stats/model/stats_rules.dart';
import '../../repository/session_repository.dart';
import '../../repository/workout_catalog.dart';
import '../state/workout_state.dart';

part 'workout_view_model.g.dart';

@riverpod
class WorkoutViewModel extends _$WorkoutViewModel {
  late SessionRepository _repository;

  @override
  FutureOr<WorkoutState> build() async {
    _repository = ref.read(sessionRepositoryProvider);
    final now = DateTime.now();
    final sessions = await _repository.getAll();

    return WorkoutState(
      workouts: allWorkouts,
      wodId: wodFor(now).id,
      todayKey: dateKey(now),
      sessions: {for (final session in sessions) session.docKey: session},
    );
  }

  /// Completes today's WOD. Returns true when XP was awarded (first
  /// completion today) — repeating the same WOD on the same day is free.
  Future<bool> completeWod() async {
    final current = state.valueOrNull;
    if (current == null) return false;
    if (current.wodCompletedToday) return false;

    state = const AsyncValue.loading();
    try {
      final result = await ref
          .read(trainingActivityProvider)
          .completeWorkout(workout: current.wod);
      state = AsyncData(current.copyWith(
        sessions: {...current.sessions, result.record.docKey: result.record},
        projectionHealth: result.projection,
      ));
      return result.status == CompletionStatus.completed;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      return false;
    }
  }
}
