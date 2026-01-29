import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../tokens/app_colors.dart';
import '../../tokens/app_typography.dart';
import '../../tokens/app_border_radius.dart';

/// Vertical Compact Card - Individual move units in 4:5 aspect ratio
/// Based on HTML mockup: forge.dance_home_dashboard_3 (01. Compact Card Vertical)
/// Used in 2-column grid layouts
class VerticalCompactCard extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final String? badgeText;
  final Color? badgeColor;
  final String? duration;
  final VoidCallback? onTap;

  const VerticalCompactCard({
    super.key,
    required this.title,
    this.imageUrl,
    this.badgeText,
    this.badgeColor,
    this.duration,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: AppBorderRadius.large,
          border: Border.all(
            color: AppColors.crystalWhite.withOpacity(0.1),
            width: 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: AspectRatio(
          aspectRatio: 4 / 5,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              if (imageUrl != null)
                CachedNetworkImage(
                  imageUrl: imageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: AppColors.bgDeep,
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.bgDeep,
                    child: const Icon(Icons.image, color: AppColors.textMuted),
                  ),
                )
              else
                Container(color: AppColors.bgDeep),

              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.bgDeep.withOpacity(0.9),
                    ],
                  ),
                ),
              ),

              // Badge (top right)
              if (badgeText != null)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.bgDeep.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: AppColors.crystalWhite.withOpacity(0.05),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      badgeText!,
                      style: AppTypography.overline.copyWith(
                        color: badgeColor ?? AppColors.forgeFire,
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

              // Content (bottom)
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.h6.copyWith(
                        color: AppColors.crystalWhite,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (duration != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            Icon(
                              Icons.timer,
                              size: 12,
                              color: AppColors.electricBlue,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              duration!,
                              style: AppTypography.caption.copyWith(
                                color: AppColors.textMuted,
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
