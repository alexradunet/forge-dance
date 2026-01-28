import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_theme.dart';
import '../../molecules/cards/stat_card.dart';
import '../../atoms/progress/linear_progress.dart';

/// Progress section organism - Combines stat cards, progress bars, level indicators
class ProgressSection extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final List<StatCardData> stats;
  final ProgressData? levelProgress;

  const ProgressSection({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
    required this.stats,
    this.levelProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTheme.h5.copyWith(
                color: AppColors.crystalWhite,
              ),
            ),
            if (actionLabel != null && onAction != null)
              TextButton(
                onPressed: onAction,
                child: Text(
                  actionLabel!,
                  style: AppTheme.bodySmall.copyWith(
                    color: AppColors.gray400,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        // Stat cards
        if (stats.isNotEmpty)
          Row(
            children: List.generate(stats.length, (index) {
              final stat = stats[index];
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index < stats.length - 1 ? AppSpacing.md : 0,
                  ),
                  child: StatCard(
                    label: stat.label,
                    value: stat.value,
                    unit: stat.unit,
                    icon: stat.icon,
                    iconColor: stat.iconColor,
                  ),
                ),
              );
            }),
          ),
        // Level progress card
        if (levelProgress != null) ...[
          const SizedBox(height: AppSpacing.md),
          Container(
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
                      levelProgress!.label,
                      style: AppTheme.h6.copyWith(
                        color: AppColors.crystalWhite,
                      ),
                    ),
                    Text(
                      '${levelProgress!.current} / ${levelProgress!.target} XP',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppColors.gray400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                LinearProgress(
                  progress: levelProgress!.current / levelProgress!.target,
                  segments: 5,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  levelProgress!.message,
                  style: AppTheme.bodySmall.copyWith(
                    color: AppColors.gray400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class StatCardData {
  final String label;
  final String value;
  final String? unit;
  final String? icon;
  final Color? iconColor;

  StatCardData({
    required this.label,
    required this.value,
    this.unit,
    this.icon,
    this.iconColor,
  });
}

class ProgressData {
  final String label;
  final int current;
  final int target;
  final String message;

  ProgressData({
    required this.label,
    required this.current,
    required this.target,
    required this.message,
  });
}
