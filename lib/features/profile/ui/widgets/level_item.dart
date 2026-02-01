import 'package:flutter/material.dart';
import '../../../../design_system/tokens/app_colors.dart';
import '../../model/level_model.dart';

class LevelItem extends StatelessWidget {
  final DanceLevel level;
  final VoidCallback onTap;

  const LevelItem({
    super.key,
    required this.level,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: level.isCurrent
                ? AppColors.forgeFire
                : (level.isCompleted
                    ? Colors.white.withOpacity(0.1)
                    : Colors.transparent),
            width: level.isCurrent ? 2 : 1,
          ),
          boxShadow: [
            if (level.isCurrent)
              BoxShadow(
                color: AppColors.forgeFire.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Belt Color Strip
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              height: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: level.color,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: level.color.withOpacity(0.5),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ),

            // Level Name
            Positioned(
              top: 12,
              left: 12,
              right: 12,
              child: Text(
                level.name.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: level.isLocked
                      ? AppColors.textMuted.withOpacity(0.5)
                      : Colors.white,
                  letterSpacing: 1,
                ),
              ),
            ),

            // Icon/Status
            if (level.isLocked)
              Icon(
                Icons.lock_outline,
                color: AppColors.textMuted.withOpacity(0.3),
                size: 24,
              )
            else if (level.isCompleted)
              Icon(
                Icons.check_circle_outline,
                color: AppColors.growthGreen.withOpacity(0.5),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
