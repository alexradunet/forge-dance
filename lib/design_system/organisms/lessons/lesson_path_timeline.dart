import 'package:flutter/material.dart';
import '../../tokens/app_colors.dart';

enum LessonNodeType { theory, drill, movement, experiment }

enum LessonNodeState { completed, current, locked }

class LessonNode {
  final String title;
  final LessonNodeType type;
  final LessonNodeState state;
  final String duration;

  const LessonNode({
    required this.title,
    required this.type,
    required this.state,
    required this.duration,
  });
}

class LessonPathTimeline extends StatelessWidget {
  final List<LessonNode> nodes;

  const LessonPathTimeline({super.key, required this.nodes});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: nodes.length,
      separatorBuilder: (context, index) => _buildConnector(nodes[index].state),
      itemBuilder: (context, index) {
        return _buildNodeItem(nodes[index]);
      },
    );
  }

  Widget _buildConnector(LessonNodeState state) {
    return Container(
      margin: const EdgeInsets.only(left: 24),
      height: 24,
      width: 2,
      color: state == LessonNodeState.completed
          ? AppColors.forgeFire
          : Colors.white.withOpacity(0.1),
    );
  }

  Widget _buildNodeItem(LessonNode node) {
    final bool isLocked = node.state == LessonNodeState.locked;
    final bool isCompleted = node.state == LessonNodeState.completed;
    final bool isCurrent = node.state == LessonNodeState.current;

    Color iconColor;
    Color contentColor;

    if (isCompleted) {
      iconColor = AppColors.forgeFire;
      contentColor = Colors.white;
    } else if (isCurrent) {
      iconColor = AppColors.legendGold;
      contentColor = Colors.white;
    } else {
      iconColor = AppColors.textMuted;
      contentColor = AppColors.textMuted;
    }

    return Row(
      children: [
        // Status Icon
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            shape: BoxShape.circle,
            border: Border.all(
              color: isCurrent ? AppColors.legendGold : Colors.transparent,
              width: 2,
            ),
          ),
          child: Center(
            child: Icon(
              isCompleted
                  ? Icons.check
                  : isLocked
                      ? Icons.lock
                      : Icons.play_arrow,
              color: iconColor,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 16),

        // Content
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark.withOpacity(isLocked ? 0.3 : 0.8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isCurrent
                    ? AppColors.legendGold.withOpacity(0.5)
                    : Colors.white.withOpacity(0.05),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        node.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: contentColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${node.type.name.toUpperCase()} • ${node.duration}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isCurrent)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.legendGold.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'START',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.legendGold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
