import 'lesson.dart';
import 'lesson_progress.dart';

typedef LibraryEntry = ({
  Module module,
  Lesson lesson,
  LessonStatus status,
});

/// Consolidates the Library read model inside the Learn module.
class LibraryProjection {
  const LibraryProjection(this.entries);

  final List<LibraryEntry> entries;

  List<String> get difficulties => _values((entry) => entry.lesson.difficulty);
  List<String> get styles => _values((entry) => entry.module.tag);
  List<String> get types => _values((entry) => entry.lesson.type.label);

  List<LibraryEntry> matching({
    String query = '',
    String? difficulty,
    String? style,
    String? type,
  }) {
    final normalized = query.trim().toLowerCase();
    return entries.where((entry) {
      final matchesQuery = normalized.isEmpty ||
          entry.lesson.title.toLowerCase().contains(normalized) ||
          entry.module.title.toLowerCase().contains(normalized);
      return matchesQuery &&
          (difficulty == null || entry.lesson.difficulty == difficulty) &&
          (style == null || entry.module.tag == style) &&
          (type == null || entry.lesson.type.label == type);
    }).toList();
  }

  List<String> _values(String Function(LibraryEntry entry) select) {
    final values = entries
        .map(select)
        .where((value) => value.isNotEmpty)
        .toSet()
      ..remove('All');
    return values.toList()..sort();
  }
}
