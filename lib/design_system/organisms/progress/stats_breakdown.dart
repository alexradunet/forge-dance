import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_theme.dart';

/// Stats breakdown organism - XP display with trend indicators
class StatsBreakdown extends StatelessWidget {
  final int totalXP;
  final String? trend; // e.g., "+12%"
  final bool isPositiveTrend;
  final int weeklyGoal;
  final int rank;

  const StatsBreakdown({
    super.key,
    required this.totalXP,
    this.trend,
    this.isPositiveTrend = true,
    required this.weeklyGoal,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.gray800.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray700, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOTAL XP',
                    style: AppTheme.caption.copyWith(
                      color: AppColors.gray400,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        _formatNumber(totalXP),
                        style: AppTheme.h1.copyWith(
                          color: AppColors.crystalWhite,
                          fontSize: 48,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'pts',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppColors.gray400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (trend != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: (isPositiveTrend
                            ? AppColors.growthGreen
                            : AppColors.passionRed)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: (isPositiveTrend
                              ? AppColors.growthGreen
                              : AppColors.passionRed)
                          .withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPositiveTrend
                            ? Icons.trending_up
                            : Icons.trending_down,
                        size: 16,
                        color: isPositiveTrend
                            ? AppColors.growthGreen
                            : AppColors.passionRed,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        trend!,
                        style: AppTheme.caption.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isPositiveTrend
                              ? AppColors.growthGreen
                              : AppColors.passionRed,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.gray700,
                  Colors.transparent,
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'WEEKLY GOAL',
                    style: AppTheme.caption.copyWith(
                      color: AppColors.gray400,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _formatNumber(weeklyGoal),
                    style: AppTheme.h5.copyWith(
                      color: AppColors.crystalWhite,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'RANK',
                    style: AppTheme.caption.copyWith(
                      color: AppColors.gray400,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '#$rank',
                    style: AppTheme.h5.copyWith(
                      color: AppColors.forgeFire,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return number.toString();
  }
}
