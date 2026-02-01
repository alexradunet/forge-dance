import 'package:flutter/material.dart';
import '../../atoms/visuals/fg_lesson_timeline_track.dart';
import '../../molecules/lessons/fg_lesson_timeline_standard_node.dart';
import '../../molecules/lessons/fg_lesson_timeline_movement_card.dart';
import '../../molecules/lessons/fg_lesson_timeline_boss_node.dart';
import 'lesson_node_models.dart';

export 'lesson_node_models.dart';

class LessonPathTimeline extends StatelessWidget {
  final List<LessonNode> nodes;
  final Function(String)? onNavigate;

  const LessonPathTimeline({
    super.key,
    required this.nodes,
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Central Gradient Line
        const Positioned.fill(
          child: Center(
            child: FgLessonTimelineTrack(),
          ),
        ),

        // Nodes
        Column(
          children: nodes.map((node) => _buildNode(context, node)).toList(),
        ),
      ],
    );
  }

  Widget _buildNode(BuildContext context, LessonNode node) {
    switch (node.type) {
      case LessonNodeType.boss:
        return FgLessonTimelineBossNode(node: node);
      case LessonNodeType.movement:
        return FgLessonTimelineMovementCard(
          node: node,
          onNavigate: onNavigate,
        );
      case LessonNodeType.theory:
      case LessonNodeType.drill:
      case LessonNodeType.experiment:
        final isTextLeft = node.type == LessonNodeType.theory;
        return FgLessonTimelineStandardNode(
          node: node,
          isTextLeft: isTextLeft,
        );
    }
  }
}
