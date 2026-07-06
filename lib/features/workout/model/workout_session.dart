import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_session.freezed.dart';
part 'workout_session.g.dart';

/// A completed workout session, stored at
/// `users/{uid}/sessions/{date}_{workoutId}` — the deterministic doc id
/// means a workout can award XP at most once per day (enforced by
/// firestore.rules).
@freezed
abstract class WorkoutSession with _$WorkoutSession {
  const WorkoutSession._();

  const factory WorkoutSession({
    required String workoutId,

    /// Local date of the session, yyyy-MM-dd (see stats_rules.dateKey).
    required String date,
    DateTime? completedAt,
  }) = _WorkoutSession;

  factory WorkoutSession.fromJson(Map<String, Object?> json) =>
      _$WorkoutSessionFromJson(json);

  /// Firestore document id for this session.
  String get docKey => '${date}_$workoutId';
}
