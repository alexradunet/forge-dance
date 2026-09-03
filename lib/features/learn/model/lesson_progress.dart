import 'package:freezed_annotation/freezed_annotation.dart';

part 'lesson_progress.freezed.dart';
part 'lesson_progress.g.dart';

/// Serialized by name ('notStarted' | 'inProgress' | 'completed').
enum LessonStatus { notStarted, inProgress, completed }

/// A user's local progress on one lesson.
@freezed
abstract class LessonProgress with _$LessonProgress {
  const factory LessonProgress({
    required String lessonId,
    @Default(LessonStatus.notStarted) LessonStatus status,
    @Default(0.0) double progress,
    DateTime? updatedAt,
    String? completedDate,
    int? awardedXp,
  }) = _LessonProgress;

  factory LessonProgress.fromJson(Map<String, Object?> json) =>
      _$LessonProgressFromJson(json);
}
