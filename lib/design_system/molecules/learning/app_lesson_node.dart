import 'package:flutter/material.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_typography.dart';
import '../../tokens/app_spacing.dart';
import '../../atoms/app_icon.dart';
import '../../atoms/progress/app_progress_bar.dart';

enum AppLessonNodeType { theory, movement, drill, experiment }

enum AppLessonNodeStatus { completed, active, locked }

enum AppLessonNodeVariant { circular, box, checkpoint, branch }

class AppLessonNode extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? duration;
  final double? progress; // 0.0 to 1.0 for active state
  final AppLessonNodeType? type;
  final AppLessonNodeStatus status;
  final AppLessonNodeVariant variant;
  final VoidCallback? onTap;

  const AppLessonNode({
    super.key,
    required this.title,
    this.subtitle,
    required this.status,
    this.variant = AppLessonNodeVariant.circular,
    this.type,
    this.duration,
    this.progress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case AppLessonNodeVariant.circular:
        return _buildCircular();
      case AppLessonNodeVariant.box:
        return _buildBox(context);
      case AppLessonNodeVariant.checkpoint:
        return _buildCheckpoint();
      case AppLessonNodeVariant.branch:
        return _buildBranch();
    }
  }

  // --- CIRCULAR VARIANT (from original AppLessonNode) ---
  Widget _buildCircular() {
    final iconMap = {
      AppLessonNodeType.theory: Icons.menu_book,
      AppLessonNodeType.movement: Icons.directions_run,
      AppLessonNodeType.drill: Icons.fitness_center,
      AppLessonNodeType.experiment: Icons.science,
    };

    final isLocked = status == AppLessonNodeStatus.locked;
    final isActive = status == AppLessonNodeStatus.active;
    final isCompleted = status == AppLessonNodeStatus.completed;
    final icon = type != null ? iconMap[type]! : Icons.help_outline;

    return GestureDetector(
      onTap: !isLocked ? onTap : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              _buildNodeCircle(isActive, isLocked, icon),
              if (isCompleted) _buildStatusBadge(Icons.check, Colors.green),
              if (isLocked)
                _buildStatusBadge(Icons.lock, Colors.white.withOpacity(0.5),
                    isTop: true),
            ],
          ),
          const SizedBox(height: 12),
          if (isActive)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                'CURRENT',
                style: AppTypography.label.copyWith(
                  color: AppColors.forgeFire,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          Text(
            title.toUpperCase(),
            style: AppTypography.label.copyWith(
              color:
                  isLocked ? Colors.white.withOpacity(0.5) : AppColors.textMain,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          if (duration != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                duration!,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 10,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNodeCircle(bool isActive, bool isLocked, IconData icon) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive
            ? AppColors.bgDeep
            : (isLocked ? Colors.white.withOpacity(0.05) : AppColors.forgeFire),
        border: isActive
            ? Border.all(color: AppColors.forgeFire, width: 2)
            : (isLocked
                ? Border.all(color: Colors.white.withOpacity(0.1))
                : null),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.forgeFire.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                )
              ]
            : (status == AppLessonNodeStatus.completed
                ? [
                    BoxShadow(
                      color: AppColors.forgeFire.withOpacity(0.2),
                      blurRadius: 10,
                    )
                  ]
                : null),
      ),
      child: Center(
        child: AppIcon(
          icon: icon,
          size: 24,
          color: isLocked ? Colors.white.withOpacity(0.3) : AppColors.textMain,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(IconData icon, Color color, {bool isTop = false}) {
    return Positioned(
      right: -2,
      top: isTop ? -2 : null,
      bottom: !isTop ? -2 : null,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: isTop ? AppColors.bgDeep : color,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.bgDeep, width: 2),
        ),
        child: Center(
          child: Icon(
            icon,
            size: 10,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // --- BOX VARIANT (from legacy LessonNode) ---
  Widget _buildBox(BuildContext context) {
    Color nodeColor;
    IconData? icon;
    Color? iconColor;

    switch (status) {
      case AppLessonNodeStatus.completed:
        nodeColor = AppColors.forgeFire;
        icon = Icons.check;
        iconColor = AppColors.crystalWhite;
        break;
      case AppLessonNodeStatus.active:
        nodeColor = AppColors.electricBlue;
        icon = Icons.play_arrow;
        iconColor = AppColors.gray950;
        break;
      case AppLessonNodeStatus.locked:
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
          alignment: Alignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: nodeColor,
                shape: BoxShape.circle,
                border: status == AppLessonNodeStatus.active
                    ? Border.all(color: AppColors.electricBlue, width: 4)
                    : null,
                boxShadow: status != AppLessonNodeStatus.locked
                    ? [
                        BoxShadow(
                          color: nodeColor.withOpacity(0.4),
                          blurRadius: 15,
                        )
                      ]
                    : null,
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            if (status == AppLessonNodeStatus.active)
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
        Expanded(
          child: GestureDetector(
            onTap: status != AppLessonNodeStatus.locked ? onTap : null,
            child: Container(
              padding: EdgeInsets.all(
                status == AppLessonNodeStatus.active
                    ? AppSpacing.xl
                    : AppSpacing.lg,
              ),
              decoration: BoxDecoration(
                color: AppColors.gray800,
                borderRadius: BorderRadius.circular(12),
                border: status == AppLessonNodeStatus.active
                    ? const Border(
                        left:
                            BorderSide(color: AppColors.electricBlue, width: 4))
                    : Border.all(color: AppColors.gray700, width: 1),
                boxShadow: status == AppLessonNodeStatus.active
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
                  _buildBoxHeader(),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    title,
                    style: AppTypography.h4.copyWith(
                      color: status != AppLessonNodeStatus.locked
                          ? AppColors.textMain
                          : AppColors.textMuted,
                      fontSize: 20,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle!,
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.textMuted),
                    ),
                  ],
                  if (status == AppLessonNodeStatus.active &&
                      progress != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    AppProgressBar(value: progress!, height: 6),
                    const SizedBox(height: AppSpacing.sm),
                    _buildProgressText(),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBoxHeader() {
    return Row(
      children: [
        Text(
          status == AppLessonNodeStatus.completed
              ? 'COMPLETED'
              : status == AppLessonNodeStatus.active
                  ? 'IN PROGRESS'
                  : 'LOCKED',
          style: AppTypography.label.copyWith(
            color: status == AppLessonNodeStatus.completed
                ? AppColors.forgeFire
                : status == AppLessonNodeStatus.active
                    ? AppColors.electricBlue
                    : AppColors.textMuted,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            fontSize: 10,
          ),
        ),
        if (duration != null) ...[
          const SizedBox(width: AppSpacing.sm),
          Container(
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
                color: AppColors.textMuted, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            duration!,
            style: AppTypography.caption.copyWith(color: AppColors.textMuted),
          ),
        ],
      ],
    );
  }

  Widget _buildProgressText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Module ${((progress! * 4).floor() + 1)}/4',
          style: AppTypography.caption.copyWith(
            color: AppColors.textMuted,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        Text(
          '${(progress! * 100).toInt()}% Done',
          style: AppTypography.caption.copyWith(
            color: AppColors.textMain,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // --- CHECKPOINT VARIANT ---
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
            border: Border.all(color: AppColors.forgeFire, width: 2),
          ),
          child: const Icon(Icons.star, size: 10, color: AppColors.forgeFire),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            title,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
          ),
        ),
      ],
    );
  }

  // --- BRANCH VARIANT ---
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
              border: Border.all(color: AppColors.textMuted, width: 1),
            ),
            child: const Icon(Icons.call_split,
                size: 16, color: AppColors.textMuted),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            style: AppTypography.body.copyWith(color: AppColors.textMain),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
