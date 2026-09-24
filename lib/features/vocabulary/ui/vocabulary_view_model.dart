import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../learn/model/lesson_progress.dart';
import '../../learn/ui/view_model/learn_view_model.dart';
import '../model/vocabulary_entry.dart';
import '../repository/vocabulary_repository.dart';

part 'vocabulary_view_model.g.dart';

@immutable
class VocabularyFilters {
  VocabularyFilters({
    this.query = '',
    Set<VocabularyKind> kinds = const {},
    Set<String> styles = const {},
  }) : kinds = Set.unmodifiable(kinds),
       styles = Set.unmodifiable(styles);

  final String query;
  final Set<VocabularyKind> kinds;
  final Set<String> styles;
  bool get hasSelections => kinds.isNotEmpty || styles.isNotEmpty;
}

@riverpod
class VocabularyViewModel extends _$VocabularyViewModel {
  @override
  VocabularyFilters build() => VocabularyFilters();

  void reset() => state = VocabularyFilters();

  void clearFilters() => state = VocabularyFilters(query: state.query);

  void search(String query) => state = VocabularyFilters(
    query: query,
    kinds: state.kinds,
    styles: state.styles,
  );

  void toggleKind(VocabularyKind kind) {
    final kinds = {...state.kinds};
    if (!kinds.remove(kind)) kinds.add(kind);
    state = VocabularyFilters(
      query: state.query,
      kinds: kinds,
      styles: state.styles,
    );
  }

  void toggleStyle(String style) {
    final styles = {...state.styles};
    if (!styles.remove(style)) styles.add(style);
    state = VocabularyFilters(
      query: state.query,
      kinds: state.kinds,
      styles: styles,
    );
  }
}

@riverpod
List<VocabularyEntry> vocabularyResults(Ref ref) {
  final filters = ref.watch(vocabularyViewModelProvider);
  return const VocabularyRepository().search(
    query: filters.query,
    kinds: filters.kinds,
    styles: filters.styles,
  );
}

@riverpod
Set<String> vocabularyIntroducedIds(Ref ref) {
  final learn = ref.watch(learnViewModelProvider).value;
  return {
    for (final entry in const VocabularyRepository().entries)
      if (learn?.progress[entry.lessonId] case final progress?
          when progress.status != LessonStatus.notStarted)
        entry.id,
  };
}
