import 'package:freezed_annotation/freezed_annotation.dart';

part 'lesson.freezed.dart';

/// Kind of lesson node on a module path. Mirrors the design system's
/// LessonNodeType, but the domain owns its own vocabulary — screens map
/// between the two.
enum LessonType { theory, drill, movement, experiment, boss }

/// Display label for a lesson type (content vocabulary, not translated —
/// lesson content ships in English like the catalog itself).
extension LessonTypeLabel on LessonType {
  String get label {
    switch (this) {
      case LessonType.theory:
        return 'Theory';
      case LessonType.drill:
        return 'Drill';
      case LessonType.movement:
        return 'Movement';
      case LessonType.experiment:
        return 'Experiment';
      case LessonType.boss:
        return 'Boss Battle';
    }
  }
}

/// One step inside a lesson, with its technique breakdown (shown on the
/// back of the player card). Tips are content vocabulary — English, like
/// lesson titles.
@freezed
abstract class LessonStep with _$LessonStep {
  const factory LessonStep({
    required String title,
    @Default('') String description,
    @Default('') String focus,
    @Default('') String breath,
    @Default('') String energy,
  }) = _LessonStep;
}

/// A single lesson inside a module. Lesson *content* ships with the app
/// (see lesson_catalog.dart); only user progress lives in Firestore.
/// Lessons with an empty [steps] list fall back to the type-specific
/// default steps (lesson_catalog.stepsFor).
@freezed
abstract class Lesson with _$Lesson {
  const factory Lesson({
    required String id,
    required String title,
    required LessonType type,
    @Default('') String duration,
    @Default('Beginner') String difficulty,
    @Default(<LessonStep>[]) List<LessonStep> steps,
  }) = _Lesson;
}

/// Catalog shelf a module belongs to (drives the explore sections).
enum ModuleCategory { fundamentals, streetStyles, choreography }

/// An ordered path of lessons.
@freezed
abstract class Module with _$Module {
  const factory Module({
    required String id,
    required String title,
    required String subtitle,
    required ModuleCategory category,
    required List<Lesson> lessons,
    @Default('') String tag,
    @Default('') String imageUrl,
  }) = _Module;
}
