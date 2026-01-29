import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../tokens/app_colors.dart';
import '../../tokens/app_typography.dart';
import '../../tokens/app_border_radius.dart';

/// Medium Square Card - Style discovery and rich media (1:1)
/// Based on HTML mockup: forge.dance_home_dashboard_12 (02. Medium Square Card)
class MediumSquareCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? badgeText;
  final Color? badgeColor;
  final String? imageUrl;
  final VoidCallback? onTap;

  const MediumSquareCard({
    super.key,
    required this.title,
    this.subtitle,
    this.badgeText,
    this.badgeColor,
    this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgDeep,
          borderRadius: AppBorderRadius.extraLarge,
          border: Border.all(
            color: AppColors.crystalWhite.withOpacity(0.05),
            width: 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: AspectRatio(
          aspectRatio: 1,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              if (imageUrl != null)
                CachedNetworkImage(
                  imageUrl: imageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Container(color: AppColors.bgDeep),
                  errorWidget: (context, url, error) =>
                      Container(color: AppColors.bgDeep),
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
                      Colors.transparent,
                      AppColors.bgDeep.withOpacity(0.9),
                    ],
                    stops: const [0.0, 0.3, 1.0],
                  ),
                ),
              ),

              // Hover arrow (top right)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.crystalWhite.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_outward,
                    size: 14,
                    color: AppColors.crystalWhite,
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
                    if (badgeText != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          badgeText!.toUpperCase(),
                          style: AppTypography.overline.copyWith(
                            color: badgeColor ?? AppColors.forgeFire,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    Text(
                      title,
                      style: AppTypography.h5.copyWith(
                        color: AppColors.crystalWhite,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          subtitle!,
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textMuted,
                            fontSize: 9,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
