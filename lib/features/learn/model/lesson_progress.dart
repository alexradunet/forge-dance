import 'package:freezed_annotation/freezed_annotation.dart';

part 'lesson_progress.freezed.dart';
part 'lesson_progress.g.dart';

/// Serialized by name ('notStarted' | 'inProgress' | 'completed') — the
/// firestore.rules status whitelist must stay in sync with these names.
enum LessonStatus { notStarted, inProgress, completed }

/// A user's progress on one lesson. Stored at
/// `users/{uid}/progress/{lessonId}` — the document id always equals
/// [lessonId] (enforced by firestore.rules).
@freezed
abstract class LessonProgress with _$LessonProgress {
  const factory LessonProgress({
    required String lessonId,
    @Default(LessonStatus.notStarted) LessonStatus status,
    @Default(0.0) double progress,
    DateTime? updatedAt,
  }) = _LessonProgress;

  factory LessonProgress.fromJson(Map<String, Object?> json) =>
      _$LessonProgressFromJson(json);
}
