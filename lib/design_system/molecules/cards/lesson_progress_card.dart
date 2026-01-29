import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../tokens/app_colors.dart';
import '../../tokens/app_typography.dart';
import '../../tokens/app_border_radius.dart';

/// Lesson Progress Card - Module card with progress tracking
/// Based on HTML mockup: forge.dance_home_dashboard_5 (Fundamentals section)
/// Shows course/module with image, progress bar, and lesson count
class LessonProgressCard extends StatelessWidget {
  final String title;
  final String? categoryLabel;
  final Color categoryColor;
  final String? imageUrl;
  final int completedLessons;
  final int totalLessons;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const LessonProgressCard({
    super.key,
    required this.title,
    this.categoryLabel,
    this.categoryColor = AppColors.forgeFire,
    this.imageUrl,
    this.completedLessons = 0,
    this.totalLessons = 1,
    this.onTap,
    this.width = 280,
    this.height = 180,
  });

  double get progressPercentage =>
      totalLessons > 0 ? (completedLessons / totalLessons).clamp(0.0, 1.0) : 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: AppBorderRadius.xxLarge,
          border: Border.all(
            color: AppColors.crystalWhite.withAlpha((0.05 * 255).round()),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.3 * 255).round()),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            if (imageUrl != null)
              CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                color:
                    Colors.black.withAlpha((0.4 * 255).round()), // Dim overlay
                colorBlendMode: BlendMode.darken,
                placeholder: (context, url) => Container(
                  color: AppColors.bgDeep,
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.bgDeep,
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
                    AppColors.bgDeep.withAlpha((0.4 * 255).round()),
                    AppColors.bgDeep,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category badge
                  if (categoryLabel != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: progressPercentage > 0
                            ? categoryColor.withAlpha((0.9 * 255).round())
                            : AppColors.crystalWhite
                                .withAlpha((0.1 * 255).round()),
                        borderRadius: BorderRadius.circular(6),
                        border: progressPercentage > 0
                            ? null
                            : Border.all(
                                color: AppColors.crystalWhite
                                    .withAlpha((0.2 * 255).round()),
                                width: 1,
                              ),
                        boxShadow: progressPercentage > 0
                            ? [
                                BoxShadow(
                                  color: categoryColor
                                      .withAlpha((0.4 * 255).round()),
                                  blurRadius: 8,
                                  spreadRadius: 0,
                                ),
                              ]
                            : null,
                      ),
                      child: Text(
                        categoryLabel!,
                        style: AppTypography.overline.copyWith(
                          color: AppColors.crystalWhite,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                  const Spacer(),

                  // Title
                  Text(
                    title,
                    style: AppTypography.h2.copyWith(
                      color: AppColors.crystalWhite,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Progress info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$completedLessons/$totalLessons Lessons',
                        style: AppTypography.monoSmall.copyWith(
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        '${(progressPercentage * 100).toInt()}%',
                        style: AppTypography.monoSmall.copyWith(
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Progress bar
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color:
                          AppColors.crystalWhite.withAlpha((0.1 * 255).round()),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: Stack(
                        children: [
                          FractionallySizedBox(
                            widthFactor: progressPercentage,
                            child: Container(
                              decoration: BoxDecoration(
                                color: categoryColor,
                                boxShadow: progressPercentage > 0
                                    ? [
                                        BoxShadow(
                                          color: categoryColor.withAlpha(
                                              (0.6 * 255).round()),
                                          blurRadius: 6,
                                          spreadRadius: 0,
                                        ),
                                      ]
                                    : null,
                              ),
                            ),
                          ),
                          // Shimmer effect for active progress
                          if (progressPercentage > 0 && progressPercentage < 1)
                            Positioned.fill(
                              child: _ShimmerOverlay(),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShimmerOverlay extends StatefulWidget {
  @override
  State<_ShimmerOverlay> createState() => _ShimmerOverlayState();
}

class _ShimmerOverlayState extends State<_ShimmerOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            (_controller.value * 3 - 1.5) * 200,
            0,
          ),
          child: Container(
            width: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.crystalWhite.withAlpha((0.2 * 255).round()),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Vertical lesson card variant for smaller grids
class VerticalLessonCard extends StatelessWidget {
  final String title;
  final String? categoryLabel;
  final Color categoryColor;
  final String? imageUrl;
  final String? duration;
  final bool isBookmarked;
  final VoidCallback? onTap;
  final VoidCallback? onBookmarkTap;

  const VerticalLessonCard({
    super.key,
    required this.title,
    this.categoryLabel,
    this.categoryColor = AppColors.forgeFire,
    this.imageUrl,
    this.duration,
    this.isBookmarked = false,
    this.onTap,
    this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          color: AppColors.neutral900,
          borderRadius: AppBorderRadius.extraLarge,
          border: Border.all(
            color: AppColors.crystalWhite.withAlpha((0.05 * 255).round()),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.2 * 255).round()),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            SizedBox(
              height: 112,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (imageUrl != null)
                    CachedNetworkImage(
                      imageUrl: imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.bgDeep,
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.bgDeep,
                      ),
                    )
                  else
                    Container(color: AppColors.bgDeep),

                  // Gradient
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.neutral900,
                        ],
                      ),
                    ),
                  ),

                  // Bookmark button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onBookmarkTap,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha((0.6 * 255).round()),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.crystalWhite
                                .withAlpha((0.1 * 255).round()),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: isBookmarked
                              ? AppColors.forgeFire
                              : AppColors.crystalWhite,
                          size: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category
                  if (categoryLabel != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        categoryLabel!.toUpperCase(),
                        style: AppTypography.overline.copyWith(
                          color: categoryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                    ),

                  // Title
                  Text(
                    title,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.crystalWhite,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Duration
                  if (duration != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            color: AppColors.textMuted,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            duration!,
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textMuted,
                              fontSize: 10,
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
    );
  }
}
