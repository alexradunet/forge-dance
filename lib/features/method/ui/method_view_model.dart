import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/forge_method.dart';
import '../repository/method_repository.dart';

part 'method_view_model.g.dart';

@Riverpod(keepAlive: true)
class MethodViewModel extends _$MethodViewModel {
  @override
  Future<MethodProgress> build() => ref.watch(methodRepositoryProvider).get();

  Future<void> recordAssessment(AssessmentAttempt attempt) async {
    // Preserve the visible progress on failure; the form retains the learner's
    // selections and reports the error. Never publish an unpersisted award.
    final progress = await ref
        .read(methodRepositoryProvider)
        .recordAssessment(attempt);
    state = AsyncData(progress);
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(methodRepositoryProvider).get(),
    );
  }
}
