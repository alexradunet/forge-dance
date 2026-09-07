import 'package:flutter/material.dart';

import '../../design_system.dart';

/// Photo-led feature card with an overlapping, content-sized information panel.
/// Only the explicit action is interactive, avoiding nested tap targets.
class FgSessionCard extends StatelessWidget {
  const FgSessionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.label,
    required this.action,
  });

  final String title;
  final String subtitle;
  final String imageUrl;
  final String label;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).forgeColors;
    return ForgeSurfaceScope(
      surface: ForgeSurface.immersive,
      child: ClipRRect(
        borderRadius: AppBorderRadius.xxLarge,
        child: ColoredBox(
          color: AppColors.surfaceCard,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 4 / 3,
                    child: FgImage(imageUrl: imageUrl, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: AppSpacing.lg,
                    left: AppSpacing.lg,
                    right: AppSpacing.lg,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FgBadge(
                        text: label,
                        variant: FgBadgeVariant.solid,
                        color: FgBadgeColor.brand,
                        shape: FgBadgeShape.pill,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: AppSpacing.xxl,
                      decoration: const BoxDecoration(
                        color: AppColors.surfaceCard,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(AppSpacing.xxl),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  0,
                  AppSpacing.xl,
                  AppSpacing.xl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      title,
                      style: AppTypography.h1.copyWith(
                        color: colors.onImmersive,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      subtitle,
                      style: AppTypography.body.copyWith(
                        color: colors.onImmersiveMuted,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    action,
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
