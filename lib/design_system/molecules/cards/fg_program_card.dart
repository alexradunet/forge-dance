import 'package:flutter/material.dart';

import '../../design_system.dart';

/// Editorial preview for a module or guided route. Metadata is content-sized;
/// a photo is optional, and the entire card is one native keyboard action.
class FgProgramCard extends StatelessWidget {
  const FgProgramCard({
    super.key,
    required this.title,
    required this.label,
    required this.onTap,
    this.imageUrl,
    this.image,
    this.summary,
    this.details,
    this.actionLabel,
    this.progress,
    this.locked = false,
    this.isSelected = false,
    this.focusNode,
    this.autofocus = false,
  }) : assert(image == null || imageUrl == null, 'Choose one image source.');

  final String title;
  final String? imageUrl;
  final ImageProvider? image;
  final String label;
  final String? summary;
  final String? details;
  final String? actionLabel;
  final VoidCallback onTap;
  final double? progress;
  final bool locked;
  final bool isSelected;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).forgeColors;
    return FgCard(
      immersive: true,
      shape: FgCardShape.editorial,
      padding: EdgeInsets.zero,
      onTap: onTap,
      isSelected: isSelected,
      focusNode: focusNode,
      autofocus: autofocus,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (image != null || imageUrl != null)
            ExcludeSemantics(
              child: SizedBox(
                height: AppSizes.squareTileLg,
                child: image != null
                    ? FgPhoto(image: image!)
                    : FgImage(imageUrl: imageUrl!, fit: BoxFit.cover),
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
                      ExcludeSemantics(
                        child: Icon(
                          Icons.lock_outline,
                          color: colors.onImmersiveMuted,
                          size: AppSizes.iconSm,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                    ],
                    Expanded(
                      child: Text(
                        label,
                        style: AppTypography.overline.copyWith(
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
                if (summary != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    summary!,
                    style: AppTypography.body.copyWith(
                      color: colors.onImmersiveMuted,
                    ),
                  ),
                ],
                if (details != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    details!,
                    style: AppTypography.bodySmall.copyWith(
                      color: colors.onImmersiveMuted,
                    ),
                  ),
                ],
                if (!locked && progress != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  FgProgressBar(value: progress!),
                ],
                if (actionLabel != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          actionLabel!,
                          style: AppTypography.bodySmall.copyWith(
                            color: colors.onImmersive,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      ExcludeSemantics(
                        child: Icon(
                          Icons.arrow_forward,
                          size: AppSizes.iconSm,
                          color: colors.onImmersive,
                        ),
                      ),
                    ],
                  ),
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
