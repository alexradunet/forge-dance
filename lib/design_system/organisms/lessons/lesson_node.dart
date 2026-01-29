import 'package:flutter/material.dart';

import '../../../design_system/tokens/app_colors.dart';
import '../../../design_system/tokens/app_spacing.dart';
import '../../../design_system/tokens/app_typography.dart';
import '../../atoms/progress/linear_progress.dart';

/// Lesson node organism - Timeline component with states (completed, active, locked)
class LessonNode extends StatelessWidget {
  final String title;
  final LessonNodeState state;
  final String? subtitle;
  final String? duration;
  final double? progress; // 0.0 to 1.0 for active state
  final VoidCallback? onTap;
  final bool isCheckpoint;
  final bool isBranch;

  const LessonNode({
    super.key,
    required this.title,
    required this.state,
    this.subtitle,
    this.duration,
    this.progress,
    this.onTap,
    this.isCheckpoint = false,
    this.isBranch = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCheckpoint) {
      return _buildCheckpoint();
    }

    if (isBranch) {
      return _buildBranch();
    }

    return _buildStandardNode();
  }

  Widget _buildStandardNode() {
    Color nodeColor;
    IconData? icon;
    Color? iconColor;

    switch (state) {
      case LessonNodeState.completed:
        nodeColor = AppColors.forgeFire;
        icon = Icons.check;
        iconColor = AppColors.crystalWhite;
        break;
      case LessonNodeState.active:
        nodeColor = AppColors.electricBlue;
        icon = Icons.play_arrow;
        iconColor = AppColors.gray950;
        break;
      case LessonNodeState.locked:
        nodeColor = AppColors.gray800;
        icon = Icons.lock;
        iconColor = AppColors.gray400;
        break;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Node indicator
        Stack(
          children: [
            Container(
              width: isCheckpoint ? 16 : 32,
              height: isCheckpoint ? 16 : 32,
              decoration: BoxDecoration(
                color: nodeColor,
                shape: BoxShape.circle,
                border: state == LessonNodeState.active
                    ? Border.all(
                        color: AppColors.electricBlue,
                        width: 4,
                      )
                    : null,
                boxShadow: state != LessonNodeState.locked
                    ? [
                        BoxShadow(
                          color: nodeColor.withOpacity(0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 0),
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                      icon,
                      size: isCheckpoint ? 14 : 20,
                      color: iconColor,
                    ),
            ),
            // Pulse animation for active
            if (state == LessonNodeState.active)
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(seconds: 2),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Container(
                    width: 32 + (value * 16),
                    height: 32 + (value * 16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.electricBlue.withOpacity(1 - value),
                        width: 2,
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
        const SizedBox(width: AppSpacing.md),
        // Content
        Expanded(
          child: GestureDetector(
            onTap: state != LessonNodeState.locked ? onTap : null,
            child: Container(
              padding: EdgeInsets.all(
                state == LessonNodeState.active
                    ? AppSpacing.xl
                    : AppSpacing.lg,
              ),
              decoration: BoxDecoration(
                color: AppColors.gray800,
                borderRadius: BorderRadius.circular(12),
                border: state == LessonNodeState.active
                    ? Border(
                        left: BorderSide(
                          color: AppColors.electricBlue,
                          width: 4,
                        ),
                      )
                    : Border.all(
                        color: AppColors.gray700,
                        width: 1,
                      ),
                boxShadow: state == LessonNodeState.active
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            state == LessonNodeState.completed
                                ? 'COMPLETED'
                                : state == LessonNodeState.active
                                    ? 'IN PROGRESS'
                                    : 'LOCKED',
                            style: AppTheme.caption.copyWith(
                              color: state == LessonNodeState.completed
                                  ? AppColors.forgeFire
                                  : state == LessonNodeState.active
                                      ? AppColors.electricBlue
                                      : AppColors.gray400,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                          ),
                          if (duration != null) ...[
                            const SizedBox(width: AppSpacing.sm),
                            Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: AppColors.gray400,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              duration!,
                              style: AppTheme.caption.copyWith(
                                color: AppColors.gray400,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    title,
                    style: AppTheme.h5.copyWith(
                      color: state != LessonNodeState.locked
                          ? AppColors.crystalWhite
                          : AppColors.gray400,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle!,
                      style: AppTheme.bodySmall.copyWith(
                        color: AppColors.gray400,
                      ),
                    ),
                  ],
                  // Progress bar for active state
                  if (state == LessonNodeState.active && progress != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    LinearProgress(
                      progress: progress!,
                      segments: 5,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Module ${((progress! * 4).floor() + 1)}/4',
                          style: AppTheme.caption.copyWith(
                            color: AppColors.gray400,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          '${(progress! * 100).toInt()}% Done',
                          style: AppTheme.caption.copyWith(
                            color: AppColors.crystalWhite,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckpoint() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: AppColors.gray800,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.forgeFire,
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.star,
            size: 10,
            color: AppColors.forgeFire,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            title,
            style: AppTheme.bodySmall.copyWith(
              color: AppColors.gray400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBranch() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.gray800,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray700, width: 1),
      ),
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.gray800,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.gray400, width: 1),
            ),
            child: const Icon(
              Icons.call_split,
              size: 16,
              color: AppColors.gray400,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            style: AppTheme.body.copyWith(
              color: AppColors.crystalWhite,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

enum LessonNodeState {
  completed,
  active,
  locked,
}
