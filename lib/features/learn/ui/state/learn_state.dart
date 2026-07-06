import 'package:freezed_annotation/freezed_annotation.dart';

import '../../model/lesson.dart';
import '../../model/lesson_progress.dart';

part 'learn_state.freezed.dart';

/// UI state for the learn feature: static module content combined with the
/// user's per-lesson progress. Lessons unlock sequentially — the current
/// lesson is the first one that isn't completed.
@freezed
abstract class LearnState with _$LearnState {
  const LearnState._();

  const factory LearnState({
    required Module module,
    @Default(<String, LessonProgress>{}) Map<String, LessonProgress> progress,
  }) = _LearnState;

  LessonStatus statusOf(Lesson lesson) =>
      progress[lesson.id]?.status ?? LessonStatus.notStarted;

  double progressOf(Lesson lesson) => progress[lesson.id]?.progress ?? 0.0;

  /// First non-completed lesson on the path, or null when all are done.
  Lesson? get currentLesson {
    for (final lesson in module.lessons) {
      if (statusOf(lesson) != LessonStatus.completed) return lesson;
    }
    return null;
  }

  /// Number of completed lessons in the module.
  int get completedCount => module.lessons
      .where((lesson) => statusOf(lesson) == LessonStatus.completed)
      .length;

  /// Fraction of the module completed, 0.0–1.0.
  double get moduleProgress => module.lessons.isEmpty
      ? 0.0
      : completedCount / module.lessons.length;
}
