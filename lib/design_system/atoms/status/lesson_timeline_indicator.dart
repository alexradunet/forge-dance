import 'package:flutter/material.dart';
import '../../tokens/app_colors.dart';
import '../../organisms/lessons/lesson_node_models.dart';

class LessonTimelineIndicator extends StatelessWidget {
  final LessonNodeState state;
  final double size;

  const LessonTimelineIndicator({
    super.key,
    required this.state,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = state == LessonNodeState.completed;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.bgDeep,
        shape: BoxShape.circle,
        border: Border.all(
          color:
              isCompleted ? AppColors.forgeFire : Colors.white.withOpacity(0.2),
          width: isCompleted ? 3 : 2,
        ),
        boxShadow: isCompleted
            ? [
                BoxShadow(
                    color: AppColors.forgeFire.withOpacity(0.4), blurRadius: 12)
              ]
            : null,
      ),
      child: Center(
        child: Icon(
          isCompleted ? Icons.check : Icons.lock,
          color: isCompleted ? AppColors.forgeFire : AppColors.textMuted,
          size: size * 0.5,
        ),
      ),
    );
  }
}
