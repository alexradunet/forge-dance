import 'package:flutter/material.dart';

import '../../../design_system/tokens/app_colors.dart';
import '../../../design_system/tokens/app_spacing.dart';
import '../../../design_system/tokens/app_typography.dart';
import '../../atoms/badges/app_badge.dart';
import '../../../features/common/ui/widgets/material_ink_well.dart';

/// Exercise card molecule - Library card variant for exercise items
class ExerciseCard extends StatelessWidget {
  final String title;
  final String? style;
  final int? level;
  final String? duration;
  final String? thumbnailUrl;
  final VoidCallback? onTap;

  const ExerciseCard({
    super.key,
    required this.title,
    this.style,
    this.level,
    this.duration,
    this.thumbnailUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialInkWell(
      onTap: onTap,
      radius: 16,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.gray800,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: thumbnailUrl != null
                  ? Image.network(
                      thumbnailUrl!,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildPlaceholder(),
                    )
                  : _buildPlaceholder(),
            ),
            // Content
            Padding(
              padding: AppSpacing.card,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: AppTheme.h5.copyWith(
                      color: AppColors.crystalWhite,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  // Metadata
                  Row(
                    children: [
                      if (style != null) ...[
                        Text(
                          style!,
                          style: AppTheme.bodySmall.copyWith(
                            color: AppColors.gray400,
                          ),
                        ),
                        if (level != null) ...[
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            '•',
                            style: AppTheme.bodySmall.copyWith(
                              color: AppColors.gray400,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                        ],
                      ],
                      if (level != null)
                        if (level != null)
                          AppBadge(
                            text: _getBadgeText(level!),
                            color: _getBadgeColor(level!),
                            variant: AppBadgeVariant.solid,
                            shape: AppBadgeShape.pill,
                          ),
                    ],
                  ),
                  if (duration != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: AppColors.gray400,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          duration!,
                          style: AppTheme.caption.copyWith(
                            color: AppColors.gray400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 120,
      width: double.infinity,
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
          size: 32,
          color: AppColors.gray600,
        ),
      ),
    );
  }

  AppBadgeColor _getBadgeColor(int level) {
    if (level <= 2) return AppBadgeColor.success;
    if (level <= 4) return AppBadgeColor.warning;
    return AppBadgeColor.brand;
  }

  String _getBadgeText(int level) {
    if (level <= 2) return 'BEG';
    if (level <= 4) return 'INT';
    return 'ADV';
  }
}
