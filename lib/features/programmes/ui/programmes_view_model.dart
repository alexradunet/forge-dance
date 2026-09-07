import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../learn/ui/view_model/learn_view_model.dart';
import '../repository/programme_catalog.dart';
import '../repository/programme_repository.dart';

part 'programmes_view_model.g.dart';

@riverpod
class ProgrammesViewModel extends _$ProgrammesViewModel {
  @override
  Future<Set<String>> build() =>
      ref.watch(programmeRepositoryProvider).getEnrolledIds();

  Future<void> enrol(String id) async {
    final programme = forgeProgrammes
        .where((item) => item.id == id)
        .firstOrNull;
    if (programme == null) throw ArgumentError.value(id, 'id');
    final learn = await ref.read(learnViewModelProvider.future);
    if (programme.unmetPrerequisites(learn).isNotEmpty) {
      throw StateError('Complete the programme prerequisites first');
    }
    await ref.read(programmeRepositoryProvider).enrol(id);
    await reload();
  }

  Future<void> leave(String id) async {
    await ref.read(programmeRepositoryProvider).leave(id);
    await reload();
  }

  Future<void> reload() async {
    state = await AsyncValue.guard(
      ref.read(programmeRepositoryProvider).getEnrolledIds,
    );
  }
}
