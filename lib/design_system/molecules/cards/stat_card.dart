import 'package:flutter/material.dart';

import '../../../design_system/tokens/app_colors.dart';
import '../../../design_system/tokens/app_spacing.dart';
import '../../../design_system/tokens/app_typography.dart';

/// Stat card molecule - For streak, level, XP displays
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? unit;
  final String? icon;
  final Color? iconColor;
  final Widget? trailing;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.unit,
    this.icon,
    this.iconColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final icnColor = iconColor ?? AppColors.forgeFire;

    return Container(
      padding: AppSpacing.card,
      decoration: BoxDecoration(
        color: AppColors.gray800,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTheme.bodySmall.copyWith(
                  color: AppColors.gray400,
                ),
              ),
              if (icon != null)
                Text(
                  icon!,
                  style: TextStyle(
                    fontSize: 20,
                    color: icnColor,
                  ),
                )
              else if (trailing != null)
                trailing!,
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: AppTheme.h3.copyWith(
                  color: AppColors.crystalWhite,
                ),
              ),
              if (unit != null) ...[
                const SizedBox(width: AppSpacing.xs),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    unit!,
                    style: AppTheme.bodySmall.copyWith(
                      color: AppColors.gray400,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
