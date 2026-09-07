import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/practice.dart';
import '../repository/practice_repository.dart';

part 'practice_view_model.g.dart';

@Riverpod(keepAlive: true)
class PracticeViewModel extends _$PracticeViewModel {
  @override
  Future<List<PracticeRecord>> build() =>
      ref.watch(practiceRepositoryProvider).getAll();

  Future<void> record(PracticeRecord record) =>
      _mutate(() => ref.read(practiceRepositoryProvider).record(record));

  Future<void> updateReflection(PracticeRecord record) => _mutate(
    () => ref.read(practiceRepositoryProvider).updateReflection(record),
  );

  Future<void> delete(String id) =>
      _mutate(() => ref.read(practiceRepositoryProvider).delete(id));

  Future<void> _mutate(Future<void> Function() operation) async {
    state = const AsyncLoading();
    try {
      await operation();
      state = AsyncData(await ref.read(practiceRepositoryProvider).getAll());
    } catch (error, stack) {
      state = AsyncError(error, stack);
      rethrow;
    }
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(practiceRepositoryProvider).getAll(),
    );
  }
}

@Riverpod(keepAlive: true)
class PracticePreferencesViewModel extends _$PracticePreferencesViewModel {
  @override
  Future<PracticePreferences> build() =>
      ref.watch(practiceRepositoryProvider).getPreferences();

  Future<void> save(PracticePreferences preferences) async {
    try {
      await ref.read(practiceRepositoryProvider).savePreferences(preferences);
      state = AsyncData(preferences);
    } catch (error, stack) {
      state = AsyncError(error, stack);
      rethrow;
    }
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(practiceRepositoryProvider).getPreferences(),
    );
  }
}
