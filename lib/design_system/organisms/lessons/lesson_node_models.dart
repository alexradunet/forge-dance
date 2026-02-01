enum LessonNodeType { theory, drill, movement, experiment, boss }

enum LessonNodeState { completed, current, locked }

class LessonNode {
  final String title;
  final LessonNodeType type;
  final LessonNodeState state;
  final String duration;
  final String difficulty;
  final double progress; // 0.0 to 1.0

  const LessonNode({
    required this.title,
    required this.type,
    required this.state,
    required this.duration,
    this.difficulty = 'Beginner',
    this.progress = 0.0,
  });
}
