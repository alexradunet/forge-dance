import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../tokens/app_colors.dart';
import '../../tokens/app_typography.dart';
import '../../tokens/app_border_radius.dart';

/// Tall Feature Card - Instructor profile / Deep dive in story format (9:14)
/// Based on HTML mockup: forge.dance_home_dashboard_3 (03. Tall Feature Card)
class TallFeatureCard extends StatelessWidget {
  final String name;
  final String? nickname;
  final String? tagline;
  final String? imageUrl;
  final Color? accentColor;
  final List<TallFeatureCardStat>? stats;
  final VoidCallback? onTap;

  const TallFeatureCard({
    super.key,
    required this.name,
    this.nickname,
    this.tagline,
    this.imageUrl,
    this.accentColor,
    this.stats,
    this.onTap,
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
            color: glowColor.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: glowColor.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 0,
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: AspectRatio(
          aspectRatio: 9 / 14,
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
                    child: const Icon(Icons.person,
                        size: 64, color: AppColors.textMuted),
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
                      AppColors.bgDeep.withOpacity(0.2),
                      AppColors.bgDeep,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),

              // Content
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Instructor badge with live dot
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.crystalWhite.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    AppColors.crystalWhite.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              'INSTRUCTOR',
                              style: AppTypography.mono.copyWith(
                                color: AppColors.crystalWhite,
                                fontSize: 9,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Animated dot
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppColors.hipHopGlow,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Name with nickname
                      Text(
                        name.split(' ').first,
                        style: AppTypography.h1.copyWith(
                          color: AppColors.crystalWhite,
                          height: 0.85,
                        ),
                      ),
                      if (nickname != null)
                        Text(
                          '"$nickname"',
                          style: AppTypography.h1.copyWith(
                            color: glowColor,
                            height: 0.85,
                          ),
                        ),
                      if (name.split(' ').length > 1)
                        Text(
                          name.split(' ').skip(1).join(' '),
                          style: AppTypography.h1.copyWith(
                            color: AppColors.crystalWhite,
                            height: 0.85,
                          ),
                        ),

                      // Tagline
                      if (tagline != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Container(
                            padding: const EdgeInsets.only(left: 12),
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: glowColor,
                                  width: 2,
                                ),
                              ),
                            ),
                            child: Text(
                              tagline!,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.neutral300,
                                fontWeight: FontWeight.w300,
                                height: 1.4,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),

                      // Stats row
                      if (stats != null && stats!.isNotEmpty)
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
                                for (int i = 0; i < stats!.length; i++) ...[
                                  if (i > 0)
                                    Container(
                                      width: 1,
                                      height: 32,
                                      color: AppColors.crystalWhite
                                          .withOpacity(0.1),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                    ),
                                  _buildStatItem(stats![i]),
                                ],
                              ],
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
      ),
    );
  }

  Widget _buildStatItem(TallFeatureCardStat stat) {
    return Column(
      children: [
        Text(
          stat.value,
          style: AppTypography.h6.copyWith(
            color: AppColors.crystalWhite,
          ),
        ),
        Text(
          stat.label.toUpperCase(),
          style: AppTypography.overline.copyWith(
            color: AppColors.textMuted,
            fontSize: 8,
          ),
        ),
      ],
    );
  }
}

/// Stat item for TallFeatureCard
class TallFeatureCardStat {
  final String value;
  final String label;

  const TallFeatureCardStat({
    required this.value,
    required this.label,
  });
}
