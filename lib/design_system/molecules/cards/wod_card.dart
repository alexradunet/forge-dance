import 'package:flutter/material.dart';
import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

import '../../../design_system/tokens/app_colors.dart';
import '../../../design_system/tokens/app_spacing.dart';
import '../../../design_system/tokens/app_typography.dart';
import '../../atoms/badges/app_badge.dart';
import '../../atoms/buttons/app_button.dart';

/// WOD card molecule - Featured workout card with image, tags, metadata
class WODCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final int? level;
  final String? duration;
  final String? focus;
  final int? forgePoints;
  final VoidCallback? onStart;

  const WODCard({
    super.key,
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.level,
    this.duration,
    this.focus,
    this.forgePoints,
    this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: imageUrl != null
                ? Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildPlaceholder(),
                  )
                : _buildPlaceholder(),
          ),
          // Dark overlay for text readability
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
          // Content
          Padding(
            padding: AppSpacing.card,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tags
                Row(
                  children: [
                    AppBadge(
                      text: 'Workout of the Day',
                      variant: AppBadgeVariant.solid,
                      color: AppBadgeColor.brand,
                    ),
                  ],
                ),
                const Spacer(),
                // Title
                Text(
                  title.toUpperCase(),
                  style: AppTheme.h2.copyWith(
                    fontSize: 32,
                    color: AppColors.crystalWhite,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!.toUpperCase(),
                    style: AppTheme.h1.copyWith(
                      fontSize: 48,
                      height: 0.9,
                      color: AppColors.crystalWhite,
                    ),
                  ),
                const SizedBox(height: AppSpacing.sm),
                // Details
                Row(
                  children: [
                    if (level != null) ...[
                      Row(
                        children: [
                          const Icon(
                            Icons.bar_chart,
                            size: 16,
                            color: AppColors.gray300,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            'Level $level',
                            style: AppTheme.bodySmall.copyWith(
                              color: AppColors.gray300,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Text(
                        '•',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppColors.gray300,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                    ],
                    if (duration != null)
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 16,
                            color: AppColors.gray300,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            duration!,
                            style: AppTheme.bodySmall.copyWith(
                              color: AppColors.gray300,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                // Start Workout Button
                if (onStart != null)
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      text: 'START WORKOUT',
                      variant: AppButtonVariant.primary,
                      onPressed: onStart,
                      icon: const Icon(
                        Icons.bolt,
                        size: 20,
                        color: AppColors.crystalWhite,
                      ),
                      width: double.infinity,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.gray800,
            AppColors.gray950,
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.music_note,
          size: 64,
          color: AppColors.gray600,
        ),
      ),
    );
  }
}
