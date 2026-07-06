import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../generated/locale_keys.g.dart';
import '../../stats/model/stats_rules.dart';

enum LevelStatus {
  locked,
  current,
  completed,
}

class LevelRequirement {
  final String description;
  final bool isMet;

  const LevelRequirement({
    required this.description,
    this.isMet = false,
  });
}

/// A belt on the mastery ladder. Statuses and progress are derived from the
/// user's real XP (see features/stats/model/stats_rules.dart) — there is no
/// mock level data anymore.
class DanceLevel {
  final int id;
  final String name;
  final Color color;
  final LevelStatus status;
  final List<LevelRequirement> requirements;

  /// 0.0–1.0 progress towards the NEXT belt (1.0 once passed).
  final double progress;

  /// Cumulative XP needed to reach this belt.
  final int xpThreshold;

  const DanceLevel({
    required this.id,
    required this.name,
    required this.color,
    required this.status,
    required this.requirements,
    this.progress = 0.0,
    this.xpThreshold = 0,
  });

  bool get isLocked => status == LevelStatus.locked;
  bool get isCurrent => status == LevelStatus.current;
  bool get isCompleted => status == LevelStatus.completed;

  static const List<Color> _beltColors = [
    Colors.white,
    Color(0xFFFFEB3B), // Yellow
    Color(0xFFFF9800), // Orange
    Color(0xFF2196F3), // Blue
    Color(0xFF9C27B0), // Violet
    Color(0xFFF44336), // Red
    Color(0xFF795548), // Brown
    Color(0xFF000000), // Black
  ];

  /// Builds the full belt ladder for a user with [totalXp].
  static List<DanceLevel> buildAll({required int totalXp}) {
    final currentIndex = beltIndexForXp(totalXp);

    return [
      for (var i = 0; i < beltNames.length; i++)
        DanceLevel(
          id: i + 1,
          name: beltNames[i],
          color: _beltColors[i],
          status: i < currentIndex
              ? LevelStatus.completed
              : i == currentIndex
                  ? LevelStatus.current
                  : LevelStatus.locked,
          progress: _progressTowardsNext(totalXp, i, currentIndex),
          xpThreshold: beltThresholds[i],
          requirements: [
            LevelRequirement(
              description: LocaleKeys.reachXpRequirement
                  .tr(args: ['${beltThresholds[i]}']),
              isMet: totalXp >= beltThresholds[i],
            ),
          ],
        ),
    ];
  }

  static double _progressTowardsNext(int totalXp, int index, int currentIndex) {
    if (index < currentIndex) return 1.0;
    if (index > currentIndex) return 0.0;
    if (index == beltThresholds.length - 1) return 1.0; // max belt

    final span = beltThresholds[index + 1] - beltThresholds[index];
    if (span <= 0) return 1.0;
    return (totalXp - beltThresholds[index]) / span;
  }
}
