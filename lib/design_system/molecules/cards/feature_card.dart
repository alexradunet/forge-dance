import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../tokens/app_colors.dart';
import '../../tokens/app_typography.dart';
import '../../tokens/app_border_radius.dart';
import '../../tokens/app_shadows.dart';

/// Feature Card (Horizontal) - Curriculum modules with glowing border
/// Based on HTML mockup: forge.dance_home_dashboard_8 (02. Feature Card)
/// Has colored glow border and play icon action
class FeatureCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? categoryLabel;
  final String? imageUrl;
  final Color? accentColor;
  final VoidCallback? onTap;
  final Widget? trailing;

  const FeatureCard({
    super.key,
    required this.title,
    this.subtitle,
    this.categoryLabel,
    this.imageUrl,
    this.accentColor,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final glowColor = accentColor ?? AppColors.mysticPurple;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: AppBorderRadius.xxLarge,
          border: Border.all(
            color: glowColor.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: glowColor.withOpacity(0.15),
              blurRadius: 15,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Main content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Thumbnail
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.bgDeep,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.crystalWhite.withOpacity(0.05),
                        width: 1,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: imageUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: AppColors.bgDeep,
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: AppColors.bgDeep,
                              child: Icon(
                                Icons.image,
                                color: AppColors.textMuted,
                                size: 24,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.play_arrow,
                            color: glowColor,
                            size: 32,
                          ),
                  ),

                  const SizedBox(width: 16),

                  // Text content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Category label with animated dot
                        if (categoryLabel != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                Text(
                                  categoryLabel!.toUpperCase(),
                                  style: AppTypography.overline.copyWith(
                                    color: glowColor,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: glowColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Title
                        Text(
                          title,
                          style: AppTypography.h5.copyWith(
                            color: AppColors.crystalWhite,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        // Subtitle
                        if (subtitle != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              subtitle!,
                              style: AppTypography.caption.copyWith(
                                color: AppColors.textMuted,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Trailing widget or play button
                  trailing ??
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: glowColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: glowColor.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          color: glowColor,
                          size: 18,
                        ),
                      ),
                ],
              ),
            ),

            // Inner glow ring
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: AppBorderRadius.xxLarge,
                  border: Border.all(
                    color: glowColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
