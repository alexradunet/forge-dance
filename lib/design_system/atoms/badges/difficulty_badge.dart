import 'package:flutter/material.dart';

import '../../../../design_system/tokens/app_colors.dart';
import '../../../../design_system/tokens/app_spacing.dart';
import '../../../../design_system/tokens/app_typography.dart';

/// Difficulty badge atom - For "Beg", "Int", "Adv" with solid/outlined variants
class DifficultyBadge extends StatelessWidget {
  final DifficultyLevel level;
  final bool isOutlined;

  const DifficultyBadge({
    super.key,
    required this.level,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final label = level.name.toUpperCase().substring(0, 3);
    Color backgroundColor;
    Color textColor;
    Color? borderColor;

    switch (level) {
      case DifficultyLevel.beginner:
        backgroundColor = AppColors.growthGreen;
        textColor = AppColors.gray950;
        break;
      case DifficultyLevel.intermediate:
        backgroundColor = AppColors.warningAmber;
        textColor = AppColors.gray950;
        break;
      case DifficultyLevel.advanced:
        backgroundColor = AppColors.forgeFire;
        textColor = AppColors.crystalWhite;
        break;
    }

    if (isOutlined) {
      final bg = backgroundColor;
      backgroundColor = Colors.transparent;
      borderColor = bg;
      textColor = bg;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
        border: borderColor != null
            ? Border.all(color: borderColor, width: 1)
            : null,
      ),
      child: Text(
        label,
        style: AppTheme.caption.copyWith(
          fontWeight: FontWeight.w800,
          color: textColor,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

enum DifficultyLevel {
  beginner,
  intermediate,
  advanced,
}
