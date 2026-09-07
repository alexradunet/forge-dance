import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../learn/ui/view_model/learn_view_model.dart';
import '../../../method/ui/method_view_model.dart';
import '../../../practice/ui/practice_view_model.dart';
import '../../../profile/ui/view_model/profile_view_model.dart';
import '../../../workout/ui/view_model/workout_view_model.dart';
import '../../model/stats_rules.dart';
import '../../model/user_stats.dart';

part 'user_stats_provider.g.dart';

/// Participation stats and assessed mastery share one display projection.
/// Assessment changes never rewrite the learner's earned XP or activity history.
@riverpod
Future<UserStats> userStats(Ref ref) async {
  final learn = await ref.watch(learnViewModelProvider.future);
  final workout = await ref.watch(workoutViewModelProvider.future);
  final profileState = await ref.watch(profileViewModelProvider.future);
  final method = await ref.watch(methodViewModelProvider.future);
  final practice = await ref.watch(practiceViewModelProvider.future);
  final profile = profileState.profile;

  return buildUserStats(
    method: method,
    practiceDates: practice.map((record) => dateKey(record.performedAt)),
    modules: learn.modules,
    progress: learn.progress,
    workoutXp: workoutXpFrom(workout.workouts, workout.sessions.values),
    minimumXp: profile?.xp ?? 0,
    persistedStreak: profile?.streakCount ?? 0,
    lastActivityDate: profile?.lastActivityDate,
    now: DateTime.now(),
  );
}
