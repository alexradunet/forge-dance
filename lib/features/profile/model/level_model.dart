import 'package:flutter/material.dart';

import '../../method/model/forge_method.dart';
import '../../method/repository/method_catalog.dart';

enum LevelStatus { locked, current, completed }

class LevelRequirement {
  final String description;
  final bool isMet;

  const LevelRequirement({required this.description, this.isMet = false});
}

/// A display projection of an evidence-earned FORGE belt.
class DanceLevel {
  final int id;
  final String name;
  final Color color;
  final LevelStatus status;
  final List<LevelRequirement> requirements;

  /// 0.0–1.0 progress towards the NEXT belt (1.0 once passed).
  final double progress;

  const DanceLevel({
    required this.id,
    required this.name,
    required this.color,
    required this.status,
    required this.requirements,
    this.progress = 0.0,
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

  static List<DanceLevel> buildAll({required MethodProgress progress}) {
    final currentIndex = progress.earnedBeltIndex;
    return [
      for (final belt in forgeBelts)
        DanceLevel(
          id: belt.index + 1,
          name: belt.name,
          color: _beltColors[belt.index],
          status: belt.index < currentIndex
              ? LevelStatus.completed
              : belt.index == currentIndex
              ? LevelStatus.current
              : LevelStatus.locked,
          progress: belt.index <= currentIndex
              ? 1
              : _requirementProgress(progress, belt.index),
          requirements: [
            for (final requirement in progress.requirementsForBelt(belt.index))
              LevelRequirement(
                description: requirement.description,
                isMet: requirement.isMet,
              ),
          ],
        ),
    ];
  }

  static double _requirementProgress(MethodProgress progress, int index) {
    final requirements = progress.requirementsForBelt(index);
    if (requirements.isEmpty) return 0;
    return requirements.where((requirement) => requirement.isMet).length /
        requirements.length;
  }
}
