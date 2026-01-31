import 'package:flutter/material.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_typography.dart';
import '../../atoms/app_icon.dart';

enum AppLessonNodeType { theory, movement, drill, experiment }

enum AppLessonNodeStatus { completed, active, locked }

class AppLessonNode extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? duration;
  final double? progress; // 0.0 to 1.0 for active state
  final AppLessonNodeType? type;
  final AppLessonNodeStatus status;
  final VoidCallback? onTap;

  const AppLessonNode({
    super.key,
    required this.title,
    this.subtitle,
    required this.status,
    this.type,
    this.duration,
    this.progress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
}
