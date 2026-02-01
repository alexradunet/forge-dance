import 'package:flutter/material.dart';

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

class DanceLevel {
  final int id;
  final String name;
  final Color color;
  final LevelStatus status;
  final List<LevelRequirement> requirements;

  const DanceLevel({
    required this.id,
    required this.name,
    required this.color,
    required this.status,
    required this.requirements,
  });

  bool get isLocked => status == LevelStatus.locked;
  bool get isCurrent => status == LevelStatus.current;
  bool get isCompleted => status == LevelStatus.completed;

  // Static definition of all levels
  static List<DanceLevel> getAllLevels() {
    return [
      const DanceLevel(
        id: 1,
        name: 'White',
        color: Colors.white,
        status: LevelStatus.completed,
        requirements: [
          LevelRequirement(description: 'Complete Intro Course', isMet: true),
          LevelRequirement(description: 'Learn Basic bounce', isMet: true),
        ],
      ),
      const DanceLevel(
        id: 2,
        name: 'Yellow',
        color: Color(0xFFFFEB3B), // Yellow
        status: LevelStatus.completed,
        requirements: [
          LevelRequirement(description: 'Master 3 Toprocks', isMet: true),
          LevelRequirement(description: 'Attend 5 Sessions', isMet: true),
        ],
      ),
      const DanceLevel(
        id: 3,
        name: 'Orange',
        color: Color(0xFFFF9800), // Orange
        status: LevelStatus.completed,
        requirements: [
          LevelRequirement(description: 'Learn 6-Step', isMet: true),
          LevelRequirement(description: 'Practice 10 hours', isMet: true),
        ],
      ),
      const DanceLevel(
        id: 4,
        name: 'Blue',
        color: Color(0xFF2196F3), // Blue
        status: LevelStatus.current,
        requirements: [
          LevelRequirement(description: 'Master Windmill', isMet: false),
          LevelRequirement(description: 'Win a Battle', isMet: false),
          LevelRequirement(description: 'Create a Set', isMet: true),
        ],
      ),
      const DanceLevel(
        id: 5,
        name: 'Violet',
        color: Color(0xFF9C27B0), // Violet
        status: LevelStatus.locked,
        requirements: [
          LevelRequirement(description: 'Master Headspin', isMet: false),
          LevelRequirement(description: 'Judge a Battle', isMet: false),
        ],
      ),
      const DanceLevel(
        id: 6,
        name: 'Red',
        color: Color(0xFFF44336), // Red
        status: LevelStatus.locked,
        requirements: [
          LevelRequirement(description: 'Master Airflare', isMet: false),
          LevelRequirement(description: 'Win National Battle', isMet: false),
        ],
      ),
      const DanceLevel(
        id: 7,
        name: 'Brown',
        color: Color(0xFF795548), // Brown
        status: LevelStatus.locked,
        requirements: [
          LevelRequirement(description: 'Teach 50 Students', isMet: false),
          LevelRequirement(description: 'Community Contribution', isMet: false),
        ],
      ),
      const DanceLevel(
        id: 8,
        name: 'Black',
        color: Color(0xFF000000), // Black
        status: LevelStatus.locked,
        requirements: [
          LevelRequirement(description: 'Legendary Status', isMet: false),
          LevelRequirement(description: 'Hall of Fame', isMet: false),
        ],
      ),
    ];
  }
}
