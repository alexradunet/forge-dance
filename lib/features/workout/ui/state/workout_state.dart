import 'package:freezed_annotation/freezed_annotation.dart';

import '../../model/workout.dart';
import '../../model/workout_session.dart';

part 'workout_state.freezed.dart';

/// UI state for the training feature: the workout catalog, today's WOD, and
/// the user's completed sessions keyed by doc id ({date}_{workoutId}).
@freezed
abstract class WorkoutState with _$WorkoutState {
  const WorkoutState._();

  const factory WorkoutState({
    required List<Workout> workouts,
    required String wodId,
    required String todayKey,
    @Default(<String, WorkoutSession>{}) Map<String, WorkoutSession> sessions,
  }) = _WorkoutState;

  /// Today's workout of the day.
  Workout get wod => workouts.firstWhere(
        (workout) => workout.id == wodId,
        orElse: () => workouts.first,
      );

  bool get wodCompletedToday => sessions.containsKey('${todayKey}_$wodId');

  int get completedSessionCount => sessions.length;
}
