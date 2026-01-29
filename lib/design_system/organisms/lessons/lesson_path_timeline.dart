import 'package:flutter/material.dart';

import '/design_system/tokens/app_colors.dart';

/// Lesson node state for path display
enum LessonNodeState { completed, current, locked }

/// Lesson node type
enum LessonNodeType { theory, drill, movement, experiment, challenge }

/// Model for a lesson node in the path
class LessonNode {
  final String title;
  final LessonNodeType type;
  final LessonNodeState state;
  final String? duration;

  const LessonNode({
    required this.title,
    required this.type,
    this.state = LessonNodeState.locked,
    this.duration,
  });
}

/// Vertical lesson path with connected nodes
class LessonPathTimeline extends StatelessWidget {
  final List<LessonNode> nodes;
  final String? moduleTitle;
  final String? moduleSubtitle;
  final VoidCallback? onBackPressed;

  const LessonPathTimeline({
    super.key,
    required this.nodes,
    this.moduleTitle,
    this.moduleSubtitle,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < nodes.length; i++) ...[
          _LessonNodeWidget(
            node: nodes[i],
            isFirst: i == 0,
            isLast: i == nodes.length - 1,
            showTopLine: i > 0,
            showBottomLine: i < nodes.length - 1,
          ),
        ],
      ],
    );
  }
}

class _LessonNodeWidget extends StatelessWidget {
  final LessonNode node;
  final bool isFirst;
  final bool isLast;
  final bool showTopLine;
  final bool showBottomLine;

  const _LessonNodeWidget({
    required this.node,
    required this.isFirst,
    required this.isLast,
    required this.showTopLine,
    required this.showBottomLine,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = node.state == LessonNodeState.completed;
    final isCurrent = node.state == LessonNodeState.current;
    final isLocked = node.state == LessonNodeState.locked;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline line and node
          SizedBox(
            width: 56,
            child: Column(
              children: [
                // Top line
                if (showTopLine)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: isCompleted || isCurrent
                          ? AppColors.forgeFire.withOpacity(0.5)
                          : Colors.white.withOpacity(0.1),
                    ),
                  ),
                // Node circle
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.bgDeep,
                    border: Border.all(
                      color: isCompleted
                          ? AppColors.forgeFire
                          : isCurrent
                              ? AppColors.forgeFire
                              : Colors.white.withOpacity(0.2),
                      width: isCompleted || isCurrent ? 3 : 2,
                    ),
                    boxShadow: isCurrent
                        ? [
                            BoxShadow(
                              color: AppColors.forgeFire.withOpacity(0.4),
                              blurRadius: 15,
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: _buildNodeIcon(),
                  ),
                ),
                // Bottom line
                if (showBottomLine)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: isCompleted
                          ? AppColors.forgeFire.withOpacity(0.5)
                          : Colors.white.withOpacity(0.1),
                    ),
                  ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isCurrent
                      ? AppColors.surfaceDark.withOpacity(0.8)
                      : AppColors.surfaceDark.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isCurrent
                        ? AppColors.forgeFire.withOpacity(0.3)
                        : Colors.white.withOpacity(0.05),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            node.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isLocked
                                  ? AppColors.textMuted
                                  : Colors.white,
                            ),
                          ),
                          if (node.duration != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.timer_outlined,
                                    size: 12,
                                    color: AppColors.textMuted,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    node.duration!,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 3,
                                    height: 3,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.textMuted.withOpacity(0.5),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _getTypeLabel(),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isCurrent
                                          ? AppColors.forgeFire
                                          : AppColors.textMuted,
                                      fontWeight:
                                          isCurrent ? FontWeight.w600 : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Action indicator
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCurrent
                            ? AppColors.forgeFire.withOpacity(0.1)
                            : null,
                        border: Border.all(
                          color: isCurrent
                              ? AppColors.forgeFire.withOpacity(0.5)
                              : Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          isCompleted
                              ? Icons.check
                              : isCurrent
                                  ? Icons.play_arrow
                                  : Icons.lock,
                          size: 12,
                          color: isCompleted
                              ? Colors.white.withOpacity(0.4)
                              : isCurrent
                                  ? AppColors.forgeFire
                                  : Colors.white.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNodeIcon() {
    final isCompleted = node.state == LessonNodeState.completed;
    final isCurrent = node.state == LessonNodeState.current;
    final isLocked = node.state == LessonNodeState.locked;

    if (isCompleted) {
      return Icon(
        Icons.check,
        size: 18,
        color: AppColors.forgeFire,
      );
    }

    if (isLocked) {
      return Icon(
        Icons.lock,
        size: 16,
        color: AppColors.textMuted,
      );
    }

    // Current or other states - show type icon
    return Icon(
      _getTypeIcon(),
      size: 18,
      color: isCurrent ? AppColors.forgeFire : AppColors.textMuted,
    );
  }

  IconData _getTypeIcon() {
    switch (node.type) {
      case LessonNodeType.theory:
        return Icons.self_improvement;
      case LessonNodeType.drill:
        return Icons.fitness_center;
      case LessonNodeType.movement:
        return Icons.directions_run;
      case LessonNodeType.experiment:
        return Icons.waves;
      case LessonNodeType.challenge:
        return Icons.emoji_events;
    }
  }

  String _getTypeLabel() {
    switch (node.type) {
      case LessonNodeType.theory:
        return 'Theory';
      case LessonNodeType.drill:
        return 'Drill';
      case LessonNodeType.movement:
        return 'Movement';
      case LessonNodeType.experiment:
        return 'Experiment';
      case LessonNodeType.challenge:
        return 'Challenge';
    }
  }
}
