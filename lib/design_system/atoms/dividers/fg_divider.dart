import 'package:flutter/material.dart';

import '../../theme/forge_theme_extensions.dart';

enum FgDividerTone { neutral, primary, secondary, success, reward }

/// Decorative divider with semantic theme-owned tones.
class FgDivider extends StatelessWidget {
  const FgDivider({
    super.key,
    this.isVertical = false,
    this.tone = FgDividerTone.neutral,
    this.thickness = 1,
  });

  const FgDivider.horizontal({
    super.key,
    this.tone = FgDividerTone.neutral,
    this.thickness = 1,
  }) : isVertical = false;

  const FgDivider.vertical({
    super.key,
    this.tone = FgDividerTone.neutral,
    this.thickness = 1,
  }) : isVertical = true;

  final bool isVertical;
  final FgDividerTone tone;
  final double thickness;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final forgeColors = theme.forgeColors;
    final color = switch (tone) {
      FgDividerTone.neutral => scheme.outlineVariant,
      FgDividerTone.primary => scheme.primary,
      FgDividerTone.secondary => scheme.secondary,
      FgDividerTone.success => forgeColors.success,
      FgDividerTone.reward => forgeColors.reward,
    };

    return ExcludeSemantics(
      child: SizedBox(
        width: isVertical ? thickness : double.infinity,
        height: isVertical ? double.infinity : thickness,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: isVertical ? Alignment.topCenter : Alignment.centerLeft,
              end: isVertical ? Alignment.bottomCenter : Alignment.centerRight,
              colors: [
                color.withValues(alpha: 0),
                color,
                color.withValues(alpha: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
