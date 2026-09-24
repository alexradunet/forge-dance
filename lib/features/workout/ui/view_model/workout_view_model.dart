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
  DateTime? _pendingCompletionMoment;

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

  /// Abandons only the failed attempt's retry identity, never durable records.
  void abandonCompletion() {
    _pendingCompletionMoment = null;
  }

  /// Completes today's WOD. Returns true when XP was awarded (first
  /// completion today) — repeating the same WOD on the same day is free.
  Future<bool> completeWod({DateTime? now}) async {
    final current = state.value;
    if (current == null) return false;
    if (current.wodCompletedToday) return false;

    // A failed write may already have committed. Keep its daily record key
    // stable even when the user retries after midnight.
    final moment = _pendingCompletionMoment ??= now ?? DateTime.now();
    try {
      final result = await ref
          .read(trainingActivityProvider)
          .completeWorkout(workout: current.wod, now: moment);
      _pendingCompletionMoment = null;
      state = AsyncData(
        current.copyWith(
          sessions: {...current.sessions, result.record.docKey: result.record},
          projectionHealth: result.projection,
        ),
      );
      return result.status == CompletionStatus.completed;
    } catch (_) {
      // Keep the current circuit available for an idempotent retry.
      rethrow;
    }
  }
}
