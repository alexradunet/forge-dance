import 'package:flutter/material.dart';

import '../../tokens/app_colors.dart';
import '../../tokens/app_typography.dart';
import '../../tokens/app_border_radius.dart';

/// Compact Card (Horizontal) - List item with progress segments and action
/// Based on HTML mockup: forge.dance_home_dashboard_8 (03. Compact Card)
/// Contains title, progress bar segments, XP reward, and CTA button
class CompactCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final int currentProgress;
  final int totalProgress;
  final String? rewardLabel;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData? actionIcon;

  const CompactCard({
    super.key,
    required this.title,
    this.subtitle,
    this.currentProgress = 0,
    this.totalProgress = 5,
    this.rewardLabel,
    this.actionLabel,
    this.onAction,
    this.actionIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: AppBorderRadius.xxLarge,
        border: Border.all(
          color: AppColors.crystalWhite.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.h6.copyWith(
                        color: AppColors.crystalWhite,
                      ),
                    ),
                    if (subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          subtitle!,
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Reward badge
              if (rewardLabel != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.bgDeep.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: AppColors.crystalWhite.withOpacity(0.05),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    rewardLabel!,
                    style: AppTypography.mono.copyWith(
                      color: AppColors.forgeFire,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          // Progress segments
          Row(
            children: List.generate(
              totalProgress,
              (index) => Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(
                    right: index < totalProgress - 1 ? 4 : 0,
                  ),
                  decoration: BoxDecoration(
                    color: index < currentProgress
                        ? AppColors.forgeFire
                        : AppColors.crystalWhite.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Action button
          if (actionLabel != null)
            GestureDetector(
              onTap: onAction,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.crystalWhite,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (actionIcon != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Icon(
                          actionIcon,
                          color: AppColors.bgDeep,
                          size: 16,
                        ),
                      ),
                    Text(
                      actionLabel!.toUpperCase(),
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.bgDeep,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
