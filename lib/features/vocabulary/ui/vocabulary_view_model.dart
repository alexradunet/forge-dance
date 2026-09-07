import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../learn/model/lesson_progress.dart';
import '../../learn/ui/view_model/learn_view_model.dart';
import '../model/vocabulary_entry.dart';
import '../repository/vocabulary_repository.dart';

part 'vocabulary_view_model.g.dart';

@immutable
class VocabularyFilters {
  const VocabularyFilters({this.query = '', this.kind, this.style});
  final String query;
  final VocabularyKind? kind;
  final String? style;
}

@riverpod
class VocabularyViewModel extends _$VocabularyViewModel {
  @override
  VocabularyFilters build() => const VocabularyFilters();

  void search(String query) => state = VocabularyFilters(
    query: query,
    kind: state.kind,
    style: state.style,
  );
  void selectKind(VocabularyKind? kind) => state = VocabularyFilters(
    query: state.query,
    kind: kind,
    style: state.style,
  );
  void selectStyle(String? style) => state = VocabularyFilters(
    query: state.query,
    kind: state.kind,
    style: style,
  );
}

@riverpod
List<VocabularyEntry> vocabularyResults(Ref ref) {
  final filters = ref.watch(vocabularyViewModelProvider);
  return const VocabularyRepository().search(
    query: filters.query,
    kind: filters.kind,
    style: filters.style,
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
