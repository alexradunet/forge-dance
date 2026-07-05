import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/lesson_progress.dart';
import '../../repository/lesson_catalog.dart';
import '../../repository/progress_repository.dart';
import '../state/learn_state.dart';

part 'learn_view_model.g.dart';

@riverpod
class LearnViewModel extends _$LearnViewModel {
  late ProgressRepository _repository;

  @override
  FutureOr<LearnState> build() async {
    _repository = ref.read(progressRepositoryProvider);
    return LearnState(
      module: hipHopFoundations,
      progress: await _repository.getAll(),
    );
  }

  /// Marks a lesson as started (no-op if it is already completed).
  Future<void> startLesson(String lessonId) async {
    final current = state.valueOrNull;
    if (current == null) return;
    if (current.progress[lessonId]?.status == LessonStatus.completed) return;

    await _applyProgress(
      current,
      LessonProgress(lessonId: lessonId, status: LessonStatus.inProgress),
    );
  }

  /// Marks a lesson as completed, unlocking the next one on the path.
  Future<void> completeLesson(String lessonId) async {
    final current = state.valueOrNull;
    if (current == null) return;

    await _applyProgress(
      current,
      LessonProgress(
        lessonId: lessonId,
        status: LessonStatus.completed,
        progress: 1.0,
      ),
    );
  }

  Future<void> _applyProgress(
    LearnState previous,
    LessonProgress update,
  ) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() => _repository.upsert(update));

    if (result is AsyncError) {
      state = AsyncError(result.error, result.stackTrace);
      return;
    }

    state = AsyncData(
      previous.copyWith(
        progress: {...previous.progress, update.lessonId: update},
      ),
    );
  }
}
