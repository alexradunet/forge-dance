import 'dart:ui' show Rect;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/ui/providers/app_theme_mode_provider.dart';
import '../../../learn/ui/view_model/learn_view_model.dart';
import '../../../method/ui/method_view_model.dart';
import '../../../practice/ui/practice_view_model.dart';
import '../../../profile/ui/view_model/profile_view_model.dart';
import '../../../programmes/ui/programmes_view_model.dart';
import '../../../workout/ui/view_model/workout_view_model.dart';
import '../../repository/portable_backup_repository.dart';

part 'data_transfer_view_model.g.dart';

@riverpod
class DataTransferViewModel extends _$DataTransferViewModel {
  @override
  FutureOr<void> build() {}

  Future<void> exportBackup(Rect shareOrigin) => _run(
    () => ref
        .read(portableBackupRepositoryProvider)
        .saveBackup(shareOrigin: shareOrigin),
  );

  Future<Map<String, Object?>?> prepareRestore() async {
    Map<String, Object?>? backup;
    await _run(() async {
      backup = await ref.read(portableBackupRepositoryProvider).pickBackup();
    });
    return backup;
  }

  Future<void> restore(Map<String, Object?> backup) => _run(() async {
    await ref.read(portableBackupRepositoryProvider).restore(backup);
    ref.invalidate(learnViewModelProvider);
    ref.invalidate(workoutViewModelProvider);
    ref.invalidate(methodViewModelProvider);
    ref.invalidate(practiceViewModelProvider);
    ref.invalidate(practicePreferencesViewModelProvider);
    ref.invalidate(programmesViewModelProvider);
    ref.invalidate(appThemeModeProvider);
    await ref.read(profileViewModelProvider.notifier).refreshProfile();
  });

  Future<void> _run(Future<void> Function() action) async {
    if (state.isLoading) throw StateError('A transfer is already in progress.');
    state = const AsyncLoading();
    try {
      await action();
      if (ref.mounted) state = const AsyncData(null);
    } catch (error, stack) {
      if (ref.mounted) state = AsyncError(error, stack);
      rethrow;
    }
  }
}
