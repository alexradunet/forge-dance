import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_theme.dart';

/// Status badge atom - For "New", "Trending", "Locked" states
class StatusBadge extends StatelessWidget {
  final String label;
  final StatusBadgeType type;
  final Widget? icon;

  const StatusBadge({
    super.key,
    required this.label,
    this.type = StatusBadgeType.new_,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    Color? borderColor;

    switch (type) {
      case StatusBadgeType.new_:
        backgroundColor = AppColors.forgeFire;
        textColor = AppColors.crystalWhite;
        break;
      case StatusBadgeType.trending:
        backgroundColor = AppColors.crystalWhite;
        textColor = AppColors.gray950;
        break;
      case StatusBadgeType.locked:
        backgroundColor = AppColors.gray800;
        textColor = AppColors.gray400;
        borderColor = AppColors.gray700;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: borderColor != null
            ? Border.all(color: borderColor, width: 1)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            label.toUpperCase(),
            style: AppTheme.caption.copyWith(
              fontWeight: FontWeight.w600,
              color: textColor,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

enum StatusBadgeType {
  new_,
  trending,
  locked,
}
