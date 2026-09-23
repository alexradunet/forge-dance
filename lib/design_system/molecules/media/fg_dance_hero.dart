import 'package:flutter/material.dart';

import '../../design_system.dart';

/// Photo-led editorial invitation. Copy stays on an opaque surface, never on
/// unpredictable image pixels. Media is decorative; the action owns semantics.
/// At wide constraints the poster becomes a two-column composition.
class FgDanceHero extends StatelessWidget {
  const FgDanceHero({
    super.key,
    required this.image,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.action,
  });

  final ImageProvider image;
  final String eyebrow;
  final String title;
  final String subtitle;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide =
            constraints.maxWidth >= AppSizes.editorialBreakpoint &&
            MediaQuery.textScalerOf(context).scale(1) < 1.6;
        final photo = AspectRatio(
          aspectRatio: wide ? 1 : AppSizes.posterImageAspectRatio,
          child: ExcludeSemantics(
            child: Image(
              image: image,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => ColoredBox(
                color: theme.colorScheme.surfaceContainer,
                child: Icon(
                  Icons.music_note,
                  size: AppSizes.iconHuge,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
        );
        final copy = Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: ColoredBox(
                  color: theme.colorScheme.primary,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    child: Text(
                      eyebrow,
                      style: AppTypography.overline.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Semantics(
                header: true,
                child: Text(
                  title,
                  style: AppTypography.poster.copyWith(
                    color: context.forgeForeground,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: context.forgeMutedForeground,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              action,
            ],
          ),
        );
        return Material(
          color: context.forgeSurfaceColor,
          shape: const RoundedRectangleBorder(
            borderRadius: AppBorderRadius.small,
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              if (wide)
                Row(
                  children: [
                    Expanded(child: copy),
                    Expanded(child: photo),
                  ],
                )
              else ...[
                photo,
                copy,
              ],
              ColoredBox(
                color: theme.colorScheme.primary,
                child: const SizedBox(
                  height: AppSpacing.xs,
                  width: double.infinity,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
