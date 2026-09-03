import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../profile/ui/view_model/profile_view_model.dart';
import '../../stats/application/training_activity.dart';

part 'session_coordinator.g.dart';

@Riverpod(keepAlive: true)
SessionCoordinator sessionCoordinator(Ref ref) {
  final coordinator = SessionCoordinator(ref);
  unawaited(ref.read(trainingActivityProvider).repairProjection());
  return coordinator;
}

/// Coordinates local-only app session work.
class SessionCoordinator {
  const SessionCoordinator(this._ref);

  final Ref _ref;

  Future<void> repairLocalProgressProjection() async {
    await _ref.read(trainingActivityProvider).repairProjection();
  }

  Future<void> clearLocalProfile() async {
    _ref.read(profileViewModelProvider.notifier).clearProfile();
  }
}
