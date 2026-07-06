import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_stats.freezed.dart';

/// Display model for the gamification stats surfaces (home progress card,
/// stats page, level progression). Built by stats_rules.buildUserStats —
/// XP is derived from lesson progress, the streak from the persisted
/// profile fields.
@freezed
abstract class UserStats with _$UserStats {
  const factory UserStats({
    @Default(0) int totalXp,
    @Default(0) int streakCount,
    @Default(1) int level,
    @Default('White') String beltName,
    @Default(0) int xpIntoLevel,
    @Default(0) int xpForLevelSpan,
    int? nextLevelXp,
    @Default(0.0) double levelProgress,
  }) = _UserStats;
}
