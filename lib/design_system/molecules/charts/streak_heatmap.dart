import 'package:flutter/material.dart';

import '../../../design_system/tokens/app_colors.dart';
import '../../../design_system/tokens/app_spacing.dart';
import '../../../design_system/tokens/app_typography.dart';

/// Streak heatmap molecule - 7x7 grid with intensity colors
class StreakHeatmap extends StatelessWidget {
  final List<List<double>> values; // 7x7 grid, 0.0 to 1.0
  final String title;
  final int streakDays;

  const StreakHeatmap({
    super.key,
    required this.values,
    this.title = 'Daily Contribution',
    this.streakDays = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.gray800.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray700, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTheme.body.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.crystalWhite,
                ),
              ),
              if (streakDays > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.forgeFire.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '$streakDays Day Streak',
                    style: AppTheme.caption.copyWith(
                      color: AppColors.forgeFire,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: AppSpacing.xs,
              mainAxisSpacing: AppSpacing.xs,
            ),
            itemCount: 49, // 7x7
            itemBuilder: (context, index) {
              final row = index ~/ 7;
              final col = index % 7;
              final value = row < values.length && col < values[row].length
                  ? values[row][col]
                  : 0.0;

              Color color;
              if (value == 0) {
                color = AppColors.gray800;
              } else if (value < 0.25) {
                color = AppColors.forgeFire.withOpacity(0.2);
              } else if (value < 0.5) {
                color = AppColors.forgeFire.withOpacity(0.4);
              } else if (value < 0.75) {
                color = AppColors.forgeFire.withOpacity(0.8);
              } else {
                color = AppColors.forgeFire;
              }

              return Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: value > 0
                        ? AppColors.forgeFire.withOpacity(0.3)
                        : AppColors.gray700,
                    width: 1,
                  ),
                  boxShadow: value > 0.75
                      ? [
                          BoxShadow(
                            color: AppColors.forgeFire.withOpacity(0.5),
                            blurRadius: 8,
                            offset: const Offset(0, 0),
                          ),
                        ]
                      : null,
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Less',
                style: AppTheme.caption.copyWith(
                  color: AppColors.gray400,
                ),
              ),
              Text(
                'More',
                style: AppTheme.caption.copyWith(
                  color: AppColors.gray400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
