import 'package:flutter/material.dart';
import '../../tokens/app_colors.dart';
import '../../organisms/lessons/lesson_node_models.dart';
import '../../atoms/status/fg_lesson_timeline_indicator.dart';

class FgLessonTimelineStandardNode extends StatelessWidget {
  final LessonNode node;
  final bool isTextLeft;

  const FgLessonTimelineStandardNode({
    super.key,
    required this.node,
    this.isTextLeft = true,
  });

  @override
  Widget build(BuildContext context) {
    final isLocked = node.state == LessonNodeState.locked;

    return Container(
      margin: const EdgeInsets.only(bottom: 48),
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Center Icon
          FgLessonTimelineIndicator(state: node.state),

          // Text Content
          Align(
            alignment:
                isTextLeft ? Alignment.centerLeft : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 0.45,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: isTextLeft
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    node.type.name.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'Bebas Neue',
                      fontSize: 12,
                      color:
                          isLocked ? AppColors.textMuted : AppColors.forgeFire,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    node.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isLocked ? AppColors.textMuted : Colors.white,
                      height: 1.2,
                    ),
                    textAlign: isTextLeft ? TextAlign.right : TextAlign.left,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
