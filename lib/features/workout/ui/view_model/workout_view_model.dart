import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../constants/constants.dart';
import '../../../stats/application/stats_coordinator.dart';
import '../../../stats/model/stats_rules.dart';
import '../../model/workout_session.dart';
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

    final session = WorkoutSession(
      workoutId: current.wodId,
      date: current.todayKey,
    );

    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() => _repository.complete(session));

    if (result is AsyncError) {
      state = AsyncError(result.error, result.stackTrace);
      return false;
    }

    state = AsyncData(
      current.copyWith(
        sessions: {...current.sessions, session.docKey: session},
      ),
    );

    // Best-effort stats sync (XP + streak) — must not fail the workout flow.
    try {
      await ref.read(statsCoordinatorProvider).recordTrainingActivity();
    } catch (error) {
      debugPrint(
          '${Constants.tag} [WorkoutViewModel] stats sync failed: $error');
    }
    return true;
  }
}
