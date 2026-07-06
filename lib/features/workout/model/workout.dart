import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout.freezed.dart';

/// A single timed exercise inside a workout.
@freezed
abstract class WorkoutExercise with _$WorkoutExercise {
  const factory WorkoutExercise({
    required String name,
    @Default(45) int seconds,
  }) = _WorkoutExercise;
}

/// A daily training session (WOD). Content ships with the app like the
/// lesson catalog; only completions are persisted to Firestore.
@freezed
abstract class Workout with _$Workout {
  const factory Workout({
    required String id,
    required String title,
    required String description,
    required List<WorkoutExercise> exercises,
    @Default('Drill') String style,
    @Default('Intermediate') String difficulty,
    @Default('') String imageUrl,
    @Default(40) int xp,
    @Default(25) int estimatedMinutes,
  }) = _Workout;
}
