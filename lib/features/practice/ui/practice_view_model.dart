import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../method/ui/method_view_model.dart';
import '../model/practice.dart';
import '../model/workout_session.dart';
import '../repository/practice_planner.dart';
import '../repository/practice_repository.dart';

part 'practice_view_model.g.dart';

/// Re-evaluate the shared calendar at local midnight, not after 24 hours.
@riverpod
DateTime dailyPracticeDate(Ref ref) {
  final now = DateTime.now();
  final midnight = DateTime(now.year, now.month, now.day + 1);
  final timer = Timer(midnight.difference(now), ref.invalidateSelf);
  ref.onDispose(timer.cancel);
  return DateTime(now.year, now.month, now.day);
}

@riverpod
PracticePlan? dailyPracticePlan(Ref ref) {
  final date = ref.watch(dailyPracticeDateProvider);
  final progress = ref.watch(methodViewModelProvider).value;
  final preferences = ref.watch(practicePreferencesViewModelProvider).value;
  if (progress == null || preferences == null) return null;
  return buildPracticePlan(
    date: date,
    progress: progress,
    minutes: preferences.minutes,
    gentle: preferences.gentle,
    includeConditioning: preferences.includeConditioning,
    support: preferences.support,
  );
}

/// Capture the persistence intent when the route starts, independent of later
/// plan/provider changes. The factory also permits isolated monotonic test clocks.
@riverpod
WorkoutSession Function(PracticePlan) workoutSessionFactory(Ref ref) {
  return (plan) => WorkoutSession(
    plan: plan,
    save: ref.read(practiceViewModelProvider.notifier).record,
  );
}

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
