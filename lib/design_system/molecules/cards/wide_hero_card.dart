import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../tokens/app_colors.dart';
import '../../tokens/app_typography.dart';
import '../../tokens/app_border_radius.dart';
import '../../tokens/app_shadows.dart';
import '../../tokens/app_spacing.dart';

/// Wide Hero Card - Featured content with immersive gradient overlay
/// Based on HTML mockup: forge.dance_home_dashboard_8 (01. Wide Hero Card)
/// Aspect ratio: 16:9 with gradient mask from bottom
class WideHeroCard extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final String? badgeText;
  final String? viewCount;
  final VoidCallback? onTap;
  final Widget? customBadge;

  const WideHeroCard({
    super.key,
    required this.title,
    this.imageUrl,
    this.badgeText,
    this.viewCount,
    this.onTap,
    this.customBadge,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: AppBorderRadius.xxLarge,
          border: Border.all(
            color: AppColors.crystalWhite.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: const [AppShadows.shadowLg],
        ),
        clipBehavior: Clip.antiAlias,
        child: AspectRatio(
          aspectRatio: 16 / 9,
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
                      AppColors.bgDeep.withOpacity(0.4),
                      AppColors.bgDeep.withOpacity(0.9),
                    ],
                    stops: const [0.0, 0.4, 1.0],
                  ),
                ),
              ),

              // Content
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge
                    if (badgeText != null || customBadge != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: customBadge ??
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.forgeFire.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                badgeText!.toUpperCase(),
                                style: AppTypography.overline.copyWith(
                                  color: AppColors.crystalWhite,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                      ),

                    // Title
                    Text(
                      title,
                      style: AppTypography.h2.copyWith(
                        color: AppColors.crystalWhite,
                      ),
                    ),

                    // View count
                    if (viewCount != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.visibility,
                              size: 14,
                              color: AppColors.neutral300,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              viewCount!,
                              style: AppTypography.caption.copyWith(
                                color: AppColors.neutral300,
                                fontWeight: FontWeight.w500,
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
