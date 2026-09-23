import 'package:flutter/material.dart';

import '../../design_system.dart';

/// Full-bleed editorial poster with content-driven height. A protected copy
/// scrim guarantees contrast even over a white image; high contrast is opaque.
/// Photography never conveys an exercise cue or becomes a separate tap target.
class FgDanceHero extends StatelessWidget {
  const FgDanceHero({
    super.key,
    required this.image,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.action,
    this.imageLabel,
    this.compact = false,
  });

  final ImageProvider image;
  final String eyebrow;
  final String title;
  final String subtitle;
  final Widget action;
  final String? imageLabel;
  final bool compact;

  /// Minimum opacity behind every line of copy, independent of the photograph.
  static const copyScrimOpacity = 0.88;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.forgeColors;
    final highContrast = MediaQuery.highContrastOf(context);
    return ForgeSurfaceScope(
      surface: ForgeSurface.immersive,
      child: Material(
        color: colors.immersiveBackground,
        shape: const RoundedRectangleBorder(
          borderRadius: AppBorderRadius.extraLarge,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(child: FgPhoto(image: image)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: AppSpacing.allLG,
                  child: Align(
                    alignment: AlignmentDirectional.topStart,
                    child: ColoredBox(
                      color: colors.immersiveBackground,
                      child: Padding(
                        padding: AppSpacing.allSM,
                        child: Text(
                          (imageLabel ?? eyebrow).toUpperCase(),
                          style: AppTypography.overline.copyWith(
                            color: colors.onImmersive,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: compact
                      ? AppSizes.photoRevealCompact
                      : AppSizes.photoReveal,
                ),
                // The transition is outside the copy's bounds, so even the first
                // glyph has the same tested minimum scrim as the last one.
                SizedBox(
                  height: AppSpacing.xl,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          colors.immersiveBackground.withValues(alpha: 0),
                          colors.immersiveBackground.withValues(
                            alpha: highContrast ? 1 : copyScrimOpacity,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        colors.immersiveBackground.withValues(
                          alpha: highContrast ? 1 : copyScrimOpacity,
                        ),
                        colors.immersiveBackground,
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.xl,
                      AppSpacing.sm,
                      AppSpacing.xl,
                      AppSpacing.xl,
                    ),
                    child: DefaultTextStyle.merge(
                      style: TextStyle(color: colors.onImmersive),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            eyebrow.toUpperCase(),
                            style: AppTypography.overline.copyWith(
                              color: colors.onImmersiveMuted,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Semantics(
                            header: true,
                            child: Text(
                              title,
                              style:
                                  (compact
                                          ? AppTypography.h2
                                          : AppTypography.h1)
                                      .copyWith(color: colors.onImmersive),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            subtitle,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colors.onImmersiveMuted,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          action,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
