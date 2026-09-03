import 'package:freezed_annotation/freezed_annotation.dart';

import '../../model/lesson.dart';
import '../../model/lesson_progress.dart';
import '../../model/library_projection.dart';
import '../../../stats/model/projection_health.dart';

part 'learn_state.freezed.dart';

/// UI state for the learn feature: the static module catalog combined with
/// the user's per-lesson progress (lesson ids are globally unique, so one
/// flat progress map covers every module). This module owns prerequisite and
/// sequential lesson availability; widgets only render these queries.
@freezed
abstract class LearnState with _$LearnState {
  const LearnState._();

  const factory LearnState({
    required List<Module> modules,
    required String activeModuleId,
    @Default(<String, LessonProgress>{}) Map<String, LessonProgress> progress,
    @Default(ProjectionHealth.current) ProjectionHealth projectionHealth,
  }) = _LearnState;

  /// The module currently open in the lesson path / player.
  Module get activeModule => modules.firstWhere(
    (module) => module.id == activeModuleId,
    orElse: () => modules.first,
  );

  LessonStatus statusOf(Lesson lesson) =>
      progress[lesson.id]?.status ?? LessonStatus.notStarted;

  Lesson? lessonById(String lessonId) {
    for (final module in modules) {
      for (final lesson in module.lessons) {
        if (lesson.id == lessonId) return lesson;
      }
    }
    return null;
  }

  /// Required lessons not yet completed for [module], in catalog order.
  List<String> unmetPrerequisiteLessonIds(Module module) => module
      .prerequisiteLessonIds
      .where((lessonId) => progress[lessonId]?.status != LessonStatus.completed)
      .toList(growable: false);

  /// Existing progress grandfathers a module so catalog evolution never
  /// strands a returning dancer behind a newly introduced prerequisite.
  bool isModuleUnlocked(Module module) =>
      hasStartedModule(module) || unmetPrerequisiteLessonIds(module).isEmpty;

  bool canOpenLesson(String lessonId) {
    for (final module in modules) {
      final index = module.lessons.indexWhere(
        (lesson) => lesson.id == lessonId,
      );
      if (index < 0) continue;
      if (!isModuleUnlocked(module)) return false;
      if (statusOf(module.lessons[index]) == LessonStatus.completed) {
        return true;
      }
      return index == 0 ||
          statusOf(module.lessons[index - 1]) == LessonStatus.completed;
    }
    return false;
  }

  double lessonProgressOf(Lesson lesson) =>
      progress[lesson.id]?.progress ?? 0.0;

  /// First non-completed lesson in [module], or null when all are done.
  Lesson? currentLessonIn(Module module) {
    for (final lesson in module.lessons) {
      if (statusOf(lesson) != LessonStatus.completed) return lesson;
    }
    return null;
  }

  int completedCountIn(Module module) => module.lessons
      .where((lesson) => statusOf(lesson) == LessonStatus.completed)
      .length;

  /// Fraction of [module] completed, 0.0–1.0.
  double moduleProgressOf(Module module) => module.lessons.isEmpty
      ? 0.0
      : completedCountIn(module) / module.lessons.length;

  bool hasStartedModule(Module module) => module.lessons.any(
    (lesson) => statusOf(lesson) != LessonStatus.notStarted,
  );

  // Active-module shortcuts (what the path, player, and home hero render).
  Lesson? get currentLesson => currentLessonIn(activeModule);
  int get completedCount => completedCountIn(activeModule);
  double get moduleProgress => moduleProgressOf(activeModule);

  /// Modules the user is partway through (for the continue-training rail).
  /// Active module first; falls back to just the active module for a fresh
  /// user so the rail is never empty.
  List<Module> get inProgressModules {
    final started =
        modules
            .where((m) => hasStartedModule(m) && moduleProgressOf(m) < 1.0)
            .toList()
          ..sort((a, b) {
            if (a.id == activeModuleId) return -1;
            if (b.id == activeModuleId) return 1;
            return 0;
          });
    return started.isEmpty ? [activeModule] : started;
  }

  /// Untouched, currently available modules for the recommended rail.
  List<Module> get recommendedModules => modules
      .where(
        (module) =>
            module.id != activeModuleId &&
            !hasStartedModule(module) &&
            isModuleUnlocked(module),
      )
      .take(3)
      .toList();

  LibraryProjection get library => LibraryProjection([
    for (final module in modules)
      for (final lesson in module.lessons)
        if (statusOf(lesson) != LessonStatus.notStarted)
          (module: module, lesson: lesson, status: statusOf(lesson)),
  ]);
}
