import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../learn/ui/view_model/learn_view_model.dart';
import '../../profile/ui/view_model/profile_view_model.dart';
import '../model/stats_rules.dart';

part 'stats_coordinator.g.dart';

@Riverpod(keepAlive: true)
StatsCoordinator statsCoordinator(Ref ref) => StatsCoordinator(ref);

/// Cross-feature orchestration for gamification stats (same pattern as
/// SessionCoordinator): after a training event, derive total XP from lesson
/// progress, advance the streak, and persist both onto the user doc through
/// the profile view model.
class StatsCoordinator {
  const StatsCoordinator(this._ref);

  final Ref _ref;

  /// Called by LearnViewModel after a progress write succeeds. Best-effort:
  /// callers must not fail the training flow if stats syncing fails.
  Future<void> recordTrainingActivity({DateTime? now}) async {
    final learn = _ref.read(learnViewModelProvider).valueOrNull;
    if (learn == null) return;

    final profileState = await _ref.read(profileViewModelProvider.future);
    final profile = profileState.profile;

    final result = nextStreak(
      currentStreak: profile?.streakCount ?? 0,
      lastActivityDate: profile?.lastActivityDate,
      now: now ?? DateTime.now(),
    );

    await _ref.read(profileViewModelProvider.notifier).updateProfile(
          xp: totalXpFrom(learn.modules, learn.progress),
          streakCount: result.streak,
          lastActivityDate: result.activityDate,
        );
  }
}
