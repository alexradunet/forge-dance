// THROWAWAY: read-only projection for the mobile roadmap design comparison.
import '../../../programmes/model/programme.dart';
import '../../../programmes/repository/programme_catalog.dart';
import '../../model/lesson.dart';
import '../../model/lesson_progress.dart';
import '../../repository/lesson_catalog.dart';
import '../state/learn_state.dart';

class RoadmapPrototypeData {
  RoadmapPrototypeData(this.learn, this.focusId);
  final LearnState learn;
  final String? focusId;

  Programme? get focus =>
      forgeProgrammes.where((p) => p.id == focusId).firstOrNull;
  List<Module> get spine => [
    for (final foundation in commonFoundationModules)
      for (final module in learn.modules)
        if (module.id == foundation.id) module,
  ];

  Module? ownerOf(String lessonId) => learn.modules
      .where((module) => module.lessons.any((lesson) => lesson.id == lessonId))
      .firstOrNull;

  // A multi-prerequisite branch is placed after its latest catalogue parent.
  // All actual prerequisites remain visible; layout never changes access rules.
  Module? parentOf(Module module) {
    final parents = module.prerequisiteLessonIds.map(ownerOf).nonNulls.toList()
      ..sort(
        (a, b) => learn.modules.indexOf(a).compareTo(learn.modules.indexOf(b)),
      );
    return parents.lastOrNull;
  }

  List<Module> branchesOf(Module module) => learn.modules
      .where(
        (candidate) =>
            !spine.contains(candidate) && parentOf(candidate)?.id == module.id,
      )
      .toList();

  List<Module> get independent => learn.modules
      .where((module) => !spine.contains(module) && parentOf(module) == null)
      .toList();

  bool inFocus(Module module) =>
      focus?.sessions.any(
        (session) =>
            module.lessons.any((lesson) => lesson.id == session.lessonId),
      ) ??
      false;

  bool lessonInFocus(Lesson lesson) =>
      focus?.sessions.any((session) => session.lessonId == lesson.id) ?? false;

  ({Module module, Lesson lesson})? get next {
    final focused = focus;
    if (focused != null) {
      for (final session in focused.sessions) {
        final module = ownerOf(session.lessonId);
        final lesson = learn.lessonById(session.lessonId);
        if (module != null &&
            lesson != null &&
            learn.statusOf(lesson) != LessonStatus.completed &&
            learn.canOpenLesson(lesson.id)) {
          return (module: module, lesson: lesson);
        }
      }
      return null;
    }
    final ordered = [...learn.inProgressModules, ...spine, ...learn.modules];
    for (final module in ordered) {
      final lesson = learn.currentLessonIn(module);
      if (lesson != null && learn.canOpenLesson(lesson.id)) {
        return (module: module, lesson: lesson);
      }
    }
    return null;
  }

  String status(Module module) {
    if (learn.moduleProgressOf(module) == 1) return 'Studied';
    if (!learn.isModuleUnlocked(module)) return 'Locked';
    if (learn.hasStartedModule(module)) return 'In progress';
    return 'Available';
  }

  String requirements(Module module) => learn
      .unmetPrerequisiteLessonIds(module)
      .map((id) => learn.lessonById(id)?.title ?? id)
      .join(' · ');
}
