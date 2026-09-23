import 'package:flutter/material.dart';

import '../../design_system.dart';

/// A compact photo beside meaningful content, stacking for narrow/large text.
/// [imageLabel] makes placeholder photography explicit rather than instructional.
class FgPhotoHeading extends StatelessWidget {
  const FgPhotoHeading({
    super.key,
    required this.image,
    required this.imageLabel,
    required this.title,
    required this.subtitle,
    this.editorial = false,
  });

  final ImageProvider image;
  final String imageLabel;
  final String title;
  final String subtitle;
  final bool editorial;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final stacked =
          constraints.maxWidth < AppSizes.cardStandardWidth ||
          MediaQuery.textScalerOf(context).scale(1) > 1.5;
      final photo = ClipRRect(
        borderRadius: AppBorderRadius.medium,
        child: AspectRatio(
          aspectRatio: stacked ? AppSizes.posterImageAspectRatio : 1,
          child: FgPhoto(image: image),
        ),
      );
      final copy = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            imageLabel.toUpperCase(),
            style: AppTypography.overline.copyWith(
              color: context.forgeMutedForeground,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Semantics(
            header: true,
            child: Text(
              title,
              style:
                  (editorial
                          ? AppTypography.h2
                          : Theme.of(context).textTheme.titleMedium)
                      ?.copyWith(color: context.forgeForeground),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: context.forgeMutedForeground),
          ),
        ],
      );
      if (stacked) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            photo,
            const SizedBox(height: AppSpacing.md),
            copy,
          ],
        );
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: AppSizes.photoThumbnail, child: photo),
          const SizedBox(width: AppSpacing.lg),
          Expanded(child: copy),
        ],
      );
    },
  );
}
