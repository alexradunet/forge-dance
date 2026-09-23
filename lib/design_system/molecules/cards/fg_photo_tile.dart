import 'package:flutter/material.dart';

import '../../design_system.dart';

/// One keyboard-accessible destination with a photo, not a nested button group.
class FgPhotoTile extends StatelessWidget {
  const FgPhotoTile({
    super.key,
    required this.image,
    required this.label,
    required this.title,
    required this.onTap,
  });

  final ImageProvider image;
  final String label;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => FgCard(
    immersive: true,
    shape: FgCardShape.editorial,
    padding: EdgeInsets.zero,
    onTap: onTap,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AspectRatio(
          aspectRatio: AppSizes.photoTileAspectRatio,
          child: FgPhoto(image: image),
        ),
        Padding(
          padding: AppSpacing.allLG,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: AppTypography.overline.copyWith(
                  color: Theme.of(context).forgeColors.onImmersiveMuted,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: AppTypography.h2.copyWith(
                        color: Theme.of(context).forgeColors.onImmersive,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  ExcludeSemantics(
                    child: Icon(
                      Icons.north_east,
                      size: AppSizes.iconMd,
                      color: Theme.of(context).forgeColors.onImmersive,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

/// A two-up photo strip that becomes a list for narrow windows or large text.
class FgPhotoTileLayout extends StatelessWidget {
  const FgPhotoTileLayout({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final columns =
          constraints.maxWidth < AppSizes.photoPairBreakpoint ||
              MediaQuery.textScalerOf(context).scale(1) > 1.5
          ? 1
          : 2;
      final width =
          (constraints.maxWidth - AppSpacing.md * (columns - 1)) / columns;
      return Wrap(
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.md,
        children: [
          for (final child in children) SizedBox(width: width, child: child),
        ],
      );
    },
  );
}
