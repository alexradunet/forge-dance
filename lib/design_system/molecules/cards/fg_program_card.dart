import 'package:flutter/material.dart';

import '../../design_system.dart';

/// Readable, keyboard-accessible program preview with content-sized metadata.
class FgProgramCard extends StatelessWidget {
  const FgProgramCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.label,
    required this.details,
    required this.onTap,
    this.progress,
    this.locked = false,
  });

  final String title;
  final String imageUrl;
  final String label;
  final String details;
  final VoidCallback onTap;
  final double? progress;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).forgeColors;
    return FgCard(
      immersive: true,
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ExcludeSemantics(
            child: SizedBox(
              height: AppSizes.squareTileLg,
              child: FgImage(imageUrl: imageUrl, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: AppSpacing.allXXL,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (locked) ...[
                      Icon(
                        Icons.lock_outline,
                        color: colors.onImmersiveMuted,
                        size: AppSizes.iconSm,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                    ],
                    Expanded(
                      child: Text(
                        label,
                        style: AppTypography.bodySmall.copyWith(
                          color: colors.onImmersiveMuted,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  title.toUpperCase(),
                  style: AppTypography.h2.copyWith(color: colors.onImmersive),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  details,
                  style: AppTypography.bodySmall.copyWith(
                    color: colors.onImmersiveMuted,
                  ),
                ),
                if (!locked && progress != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  FgProgressBar(value: progress!),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Content-sized cards; narrow windows stack rather than clipping text.
class FgProgramCardLayout extends StatelessWidget {
  const FgProgramCardLayout({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final columns =
          ((constraints.maxWidth + AppSpacing.lg) /
                  (AppSizes.cardStandardWidth + AppSpacing.lg))
              .floor()
              .clamp(1, 3);
      final width =
          (constraints.maxWidth - AppSpacing.lg * (columns - 1)) / columns;
      return Wrap(
        spacing: AppSpacing.lg,
        runSpacing: AppSpacing.lg,
        children: [
          for (final child in children) SizedBox(width: width, child: child),
        ],
      );
    },
  );
}
