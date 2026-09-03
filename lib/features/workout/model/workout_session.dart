import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_session.freezed.dart';
part 'workout_session.g.dart';

/// A completed workout session. The deterministic document key means a workout
/// can award XP at most once per day on this device.
@freezed
abstract class WorkoutSession with _$WorkoutSession {
  const WorkoutSession._();

  const factory WorkoutSession({
    required String workoutId,

    /// Local date of the session, yyyy-MM-dd (see stats_rules.dateKey).
    required String date,
    DateTime? completedAt,
    int? awardedXp,
  }) = _WorkoutSession;

  factory WorkoutSession.fromJson(Map<String, Object?> json) =>
      _$WorkoutSessionFromJson(json);

  /// Stable local/export id for this session.
  String get docKey => '${date}_$workoutId';
}
