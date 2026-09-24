import '../../programmes/model/programme.dart';
import '../../programmes/repository/programme_catalog.dart';
import '../model/lesson.dart';

/// Foundation lessons are browsed through the paths that already contain them,
/// not duplicated as a second parallel catalogue. Other modules remain paths.
({List<Programme> programmes, List<Module> modules}) learningCatalogue(
  String query,
  List<Module> modules,
) {
  final normalized = query.trim().toLowerCase();
  final guidedLessonIds = {
    for (final programme in forgeProgrammes)
      for (final session in programme.sessions) session.lessonId,
  };
  bool matches(Iterable<String> values) =>
      values.any((value) => value.toLowerCase().contains(normalized));
  return (
    programmes: [
      for (final programme in forgeProgrammes)
        if (matches([
          programme.title,
          programme.description,
          for (final module in modules)
            if (module.lessons.any(
              (lesson) => programme.sessions.any(
                (session) => session.lessonId == lesson.id,
              ),
            )) ...[
              module.title,
              module.tag,
              for (final lesson in module.lessons)
                if (programme.sessions.any(
                  (session) => session.lessonId == lesson.id,
                ))
                  lesson.title,
            ],
        ]))
          programme,
    ],
    modules: [
      for (final module in modules)
        if (!module.lessons.every(
              (lesson) => guidedLessonIds.contains(lesson.id),
            ) &&
            matches([
              module.title,
              module.tag,
              ...module.lessons.map((lesson) => lesson.title),
            ]))
          module,
    ],
  );
}
