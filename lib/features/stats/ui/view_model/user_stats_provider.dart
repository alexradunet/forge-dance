import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../learn/ui/view_model/learn_view_model.dart';
import '../../../profile/ui/view_model/profile_view_model.dart';
import '../../model/stats_rules.dart';
import '../../model/user_stats.dart';

part 'user_stats_provider.g.dart';

/// Single derived source for every stats surface (home card, stats page,
/// level progression). Rebuilds automatically whenever lesson progress or
/// the persisted profile stats change.
@riverpod
Future<UserStats> userStats(Ref ref) async {
  final learn = await ref.watch(learnViewModelProvider.future);
  final profileState = await ref.watch(profileViewModelProvider.future);
  final profile = profileState.profile;

  return buildUserStats(
    modules: learn.modules,
    progress: learn.progress,
    persistedStreak: profile?.streakCount ?? 0,
    lastActivityDate: profile?.lastActivityDate,
    now: DateTime.now(),
  );
}
