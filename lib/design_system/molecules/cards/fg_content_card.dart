import 'package:flutter/material.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_typography.dart';
import '../../tokens/app_border_radius.dart';

import '../../atoms/visuals/fg_image.dart';
import '../../atoms/progress/fg_progress_bar.dart';
import '../../atoms/badges/fg_badge.dart';

enum FgContentCardVariant {
  standard, // Vertical: Image Top, Content Bottom (Immersive)
  compact, // Minimal vertical (Immersive)
  hero, // Large featured
}

class FgContentCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final List<String>? tags;
  final double? rating;
  final String? duration;
  final double? progress;
  final String? footerLabel;
  final VoidCallback? onTap;
  final FgContentCardVariant variant;
  final double? width;
  final double? height;
  final Widget? action;

  const FgContentCard({
    super.key,
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.tags,
    this.rating,
    this.duration,
    this.progress,
    this.footerLabel,
    this.onTap,
    this.variant = FgContentCardVariant.standard,
    this.width,
    this.height,
    this.action,
  });

  const FgContentCard.compact({
    super.key,
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.tags,
    this.rating,
    this.progress,
    this.footerLabel,
    this.duration,
    this.onTap,
    this.width,
    this.height,
    this.action,
  }) : variant = FgContentCardVariant.compact;

  const FgContentCard.hero({
    super.key,
    required this.title,
    this.subtitle,
    required this.imageUrl,
    this.tags,
    this.onTap,
    this.height,
    this.action,
  })  : variant = FgContentCardVariant.hero,
        rating = null,
        duration = null,
        progress = null,
        footerLabel = null,
        width = double.infinity;

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case FgContentCardVariant.compact:
        // Compact behaves like standard/immersive but with smaller default dimensions
        return _buildImmersive(context, defaultWidth: 160, defaultHeight: 160);
      case FgContentCardVariant.hero:
        return _buildHero(context);
      case FgContentCardVariant.standard:
        return _buildImmersive(context, defaultWidth: 280, defaultHeight: 170);
    }
  }

  Widget _buildImmersive(BuildContext context,
      {required double defaultWidth, required double defaultHeight}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? defaultWidth,
        height: height ?? defaultHeight,
        decoration: BoxDecoration(
          color: AppColors.surfaceCard, // or bg-surface-dark
          borderRadius: AppBorderRadius.xxLarge, // rounded-3xl (24px)
          border: Border.all(color: Colors.white.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Background Image
            if (imageUrl != null)
              Positioned.fill(
                child: Opacity(
                  opacity: 0.6,
                  child: FgImage(
                    imageUrl: imageUrl!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            // Gradient Overlay
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.bgDeep.withOpacity(0.4),
                      AppColors.bgDeep,
                    ],
                    stops: const [0.0, 0.4, 1.0],
                  ),
                ),
              ),
            ),

            // Top Content (Tags)
            if (tags != null && tags!.isNotEmpty)
              Positioned(
                top: 12,
                left: 12,
                child: FgBadge(
                  text: tags!.first.toUpperCase(),
                  variant: FgBadgeVariant.solid,
                  // Logic to toggle color based on tag content could go here
                  // For now defaulting to brand/accent
                  color: tags!.first.toLowerCase().contains('mobility')
                      ? FgBadgeColor.warning
                      : (tags!.first.toLowerCase().contains('technique')
                          ? FgBadgeColor.success
                          : FgBadgeColor.blue),
                  fontSize: 8, // Requested 8px
                ),
              ),

            // Resume/Status Badge (Top Right)
            if (progress != null && progress! > 0 && progress! < 1)
              Positioned(
                top: 12,
                right: 12,
                child: FgBadge(
                  text: 'RESUME',
                  variant: FgBadgeVariant.solid,
                  color: FgBadgeColor.warning,
                  shape: FgBadgeShape.pill,
                  fontSize: 8,
                ),
              ),

            // Bottom Content
            Positioned(
              bottom: 12, // slightly up from bottom edge
              left: 12,
              right: 12,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.toUpperCase(),
                    style: AppTypography.h1.copyWith(
                      // Bebas Neue via H1
                      fontSize: 18, // Requested text-lg
                      height: 1.1,
                      letterSpacing: 0.5,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6), // mb-1.5 (6px)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (footerLabel != null)
                        Text(
                          footerLabel!,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textMuted,
                            fontSize: 9, // Requested 9px
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      if (progress != null)
                        Text(
                          '${(progress! * 100).toInt()}%',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textMuted,
                            fontSize: 9, // Requested 9px
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6), // mb-1.5 space before bar
                  if (progress != null)
                    FgProgressBar(
                      value: progress!,
                      height: 4,
                      backgroundColor: Colors.white.withOpacity(0.1),
                      color: AppColors.forgeFire,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 280,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: AppBorderRadius.xxLarge,
          color: AppColors.surfaceCard,
          border: Border.all(color: Colors.white.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            if (imageUrl != null)
              Positioned.fill(
                child: Opacity(
                  opacity: 0.6,
                  child: FgImage(
                    imageUrl: imageUrl!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.bgDeep.withOpacity(0.4),
                      AppColors.bgDeep,
                    ],
                    stops: const [0.0, 0.4, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (tags != null && tags!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: FgBadge(
                        text: tags!.first.toUpperCase(),
                        variant: FgBadgeVariant.solid,
                        color: tags!.first.toLowerCase().contains('mobility')
                            ? FgBadgeColor.warning
                            : (tags!.first.toLowerCase().contains('technique')
                                ? FgBadgeColor.success
                                : FgBadgeColor.brand),
                        fontSize: 10,
                      ),
                    ),
                  Text(
                    title.toUpperCase(),
                    style: AppTypography.h1.copyWith(
                      fontSize: 32,
                      color: Colors.white,
                      height: 1.0,
                      letterSpacing: 1.0,
                    ),
                  ),
                  if (subtitle != null && action == null) ...[
                    const SizedBox(height: 8),
                    Text(
                      subtitle!,
                      style: AppTypography.body.copyWith(
                        color: AppColors.textMuted,
                        height: 1.4,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (subtitle != null && action != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      subtitle!,
                      style: AppTypography.body.copyWith(
                        color: AppColors.textMuted,
                        height: 1.4,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    action!,
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
