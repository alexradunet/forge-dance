import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../tokens/app_colors.dart';
import '../../tokens/app_typography.dart';
import '../../tokens/app_border_radius.dart';

/// Hero Square Card - Major challenges and WODs (1:1 Large)
/// Based on HTML mockup: forge.dance_home_dashboard_12 (03. Hero Card Large Square)
class HeroSquareCard extends StatelessWidget {
  final String title;
  final String? titleSecondLine;
  final String? badgeText;
  final String? seriesLabel;
  final String? imageUrl;
  final List<HeroSquareCardInfo>? infoItems;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData? actionIcon;
  final String? premiumLabel;

  const HeroSquareCard({
    super.key,
    required this.title,
    this.titleSecondLine,
    this.badgeText,
    this.seriesLabel,
    this.imageUrl,
    this.infoItems,
    this.actionLabel,
    this.onAction,
    this.actionIcon,
    this.premiumLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: AppBorderRadius.xxLarge,
        border: Border.all(
          color: AppColors.crystalWhite.withOpacity(0.1),
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
                    AppColors.bgDeep.withOpacity(0.5),
                    AppColors.bgDeep,
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
            ),

            // Premium badge (top right)
            if (premiumLabel != null)
              Positioned(
                top: 20,
                right: 20,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.bgDeep.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.crystalWhite.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star,
                        color: AppColors.legendGold,
                        size: 12,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        premiumLabel!,
                        style: AppTypography.mono.copyWith(
                          color: AppColors.legendGold,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Content (bottom)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge and series
                    Row(
                      children: [
                        if (badgeText != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.forgeFire,
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
                        if (badgeText != null && seriesLabel != null)
                          const SizedBox(width: 8),
                        if (seriesLabel != null)
                          Text(
                            seriesLabel!,
                            style: AppTypography.mono.copyWith(
                              color: AppColors.crystalWhite.withOpacity(0.8),
                              fontSize: 10,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Title
                    Text(
                      title,
                      style: AppTypography.h1.copyWith(
                        color: AppColors.crystalWhite,
                        fontSize: 56,
                        height: 0.85,
                      ),
                    ),
                    if (titleSecondLine != null)
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            AppColors.crystalWhite,
                            AppColors.neutral400,
                          ],
                        ).createShader(bounds),
                        child: Text(
                          titleSecondLine!,
                          style: AppTypography.h1.copyWith(
                            color: AppColors.crystalWhite,
                            fontSize: 56,
                            height: 0.85,
                          ),
                        ),
                      ),

                    // Info items
                    if (infoItems != null && infoItems!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Container(
                          padding: const EdgeInsets.only(top: 16),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color:
                                    AppColors.crystalWhite.withOpacity(0.1),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              for (int i = 0; i < infoItems!.length; i++) ...[
                                Row(
                                  children: [
                                    Icon(
                                      infoItems![i].icon,
                                      color: AppColors.forgeFire,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      infoItems![i].text,
                                      style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.neutral300,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                if (i < infoItems!.length - 1)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Container(
                                      width: 4,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: AppColors.crystalWhite
                                            .withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                              ],
                            ],
                          ),
                        ),
                      ),

                    // Action button
                    if (actionLabel != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: GestureDetector(
                          onTap: onAction,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: AppColors.crystalWhite,
                              borderRadius: BorderRadius.circular(12),
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
                                      size: 18,
                                    ),
                                  ),
                                Text(
                                  actionLabel!.toUpperCase(),
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.bgDeep,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Info item for HeroSquareCard
class HeroSquareCardInfo {
  final IconData icon;
  final String text;

  const HeroSquareCardInfo({
    required this.icon,
    required this.text,
  });
}
