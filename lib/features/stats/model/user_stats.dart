import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_stats.freezed.dart';

/// Participation and mastery remain separate: XP comes from activity while
/// belt identity and promotion progress come from FORGE assessment evidence.
@freezed
abstract class UserStats with _$UserStats {
  const factory UserStats({
    @Default(0) int totalXp,
    @Default(0) int streakCount,
    @Default(1) int level,
    @Default('White') String beltName,
    String? nextBeltName,
    @Default(0.0) double levelProgress,
  }) = _UserStats;
}
