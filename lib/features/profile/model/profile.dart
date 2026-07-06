import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';

part 'profile.g.dart';

@freezed
abstract class Profile with _$Profile {
  const factory Profile({
    @Default(null) String? id,
    @Default(null) String? email,
    @Default(null) String? name,
    @Default(null) String? job,
    @Default(null) String? avatar,
    @Default(null) int? diamond,
    // Gamification stats (denormalized onto the user doc; XP's source of
    // truth is lesson progress — see features/stats/model/stats_rules.dart).
    @Default(null) int? xp,
    @Default(null) int? streakCount,
    @Default(null) String? lastActivityDate,
  }) = _Profile;

  factory Profile.fromJson(Map<String, Object?> json) =>
      _$ProfileFromJson(json);
}
