import 'package:flutter/material.dart';

import '../../tokens/app_colors.dart';

import '../../tokens/app_typography.dart';
import '../../atoms/badges/fg_badge.dart';
import '../../atoms/progress/fg_progress_bar.dart';
import '../../atoms/buttons/fg_button.dart';
import '../../atoms/fg_icon.dart';

enum AppModuleCardType {
  small,
  medium,
  large, // default
  hero,
}

class AppModuleCard extends StatelessWidget {
  final String title;
  final String category;
  final String imageUrl;
  final double progress;
  final int completedLessons;
  final int totalLessons;
  final AppModuleCardType type;
  final String? description;
  final String? duration;
  final String? badge;
  final VoidCallback? onTap;

  const AppModuleCard({
    super.key,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.progress,
    required this.completedLessons,
    required this.totalLessons,
    this.type = AppModuleCardType.large,
    this.description,
    this.duration,
    this.badge,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case AppModuleCardType.small:
        return _buildSmall(context);
      case AppModuleCardType.medium:
        return _buildMedium(context);
      case AppModuleCardType.large:
        return _buildLarge(context);
      case AppModuleCardType.hero:
        return _buildHero(context);
    }
  }

  Widget _buildSmall(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            _buildBackgroundImage(),
            _buildGradientOverlay(0.4, 0.6),
            Positioned(
              top: 12,
              left: 12,
              child: FgBadge(
                text: category,
                variant: FgBadgeVariant.solid,
                color: FgBadgeColor.brand,
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.h4
                        .copyWith(color: AppColors.textMain, fontSize: 18),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$completedLessons/$totalLessons Lessons',
                        style: AppTypography.caption
                            .copyWith(color: AppColors.textMuted, fontSize: 9),
                      ),
                      Text(
                        '${progress.toInt()}%',
                        style: AppTypography.caption
                            .copyWith(color: AppColors.textMain, fontSize: 9),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  FgProgressBar(value: progress / 100, height: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedium(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            _buildBackgroundImage(),
            _buildGradientOverlay(0.4, 0.6),
            Positioned(
              top: 12,
              left: 12,
              child: FgBadge(
                  text: category, fontSize: 8, color: FgBadgeColor.brand),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.h4
                        .copyWith(color: AppColors.textMain, fontSize: 18),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$completedLessons/$totalLessons Lessons',
                        style: AppTypography.label
                            .copyWith(color: AppColors.textMuted, fontSize: 9),
                      ),
                      Text(
                        '${progress.toInt()}%',
                        style: AppTypography.label
                            .copyWith(color: AppColors.textMain, fontSize: 9),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  FgProgressBar(value: progress / 100, height: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLarge(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            _buildBackgroundImage(),
            _buildGradientOverlay(0.4, 0.6),
            Positioned(
              top: 16,
              left: 16,
              child: FgBadge(text: category, color: FgBadgeColor.brand),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.h3
                        .copyWith(color: AppColors.textMain, fontSize: 24),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$completedLessons/$totalLessons Lessons',
                        style: AppTypography.label
                            .copyWith(color: AppColors.textMuted, fontSize: 10),
                      ),
                      Text(
                        '${progress.toInt()}%',
                        style: AppTypography.label
                            .copyWith(color: AppColors.textMain, fontSize: 10),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  FgProgressBar(value: progress / 100, height: 6),
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
        width: double.infinity,
        height: 320,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            _buildBackgroundImage(opacity: 0.7),
            _buildGradientOverlay(0.6, 0.8),
            Positioned(
              top: 16,
              left: 16,
              child: FgBadge(text: category, color: FgBadgeColor.brand),
            ),
            if (badge != null)
              Positioned(
                top: 16,
                right: 16,
                child: FgBadge(
                  text: badge!,
                  fontSize: 9,
                  color: FgBadgeColor.brand,
                  shape: FgBadgeShape.pill,
                ),
              ),
            Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (description != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        description!,
                        style: AppTypography.bodySmall
                            .copyWith(color: Colors.white.withOpacity(0.8)),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  Text(
                    title,
                    style: AppTypography.h1
                        .copyWith(color: AppColors.textMain, fontSize: 48),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  FgButton(
                    text:
                        'START TRAINING${duration != null ? ' • $duration' : ''}',
                    variant: FgButtonVariant.primary,
                    icon: const FgIcon(icon: Icons.play_arrow),
                    width: double.infinity,
                    onPressed: onTap,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundImage({double opacity = 0.6}) {
    return Positioned.fill(
      child: Opacity(
        opacity: opacity,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildGradientOverlay(double midOpacity, double bottomOpacity) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              AppColors.bgDeep.withOpacity(midOpacity),
              AppColors.bgDeep.withOpacity(bottomOpacity),
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
      ),
    );
  }
}
