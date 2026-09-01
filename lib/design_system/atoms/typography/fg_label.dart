import 'package:flutter/material.dart';

import '../../theme/forge_theme_extensions.dart';

import '../../tokens/app_sizes.dart';
import '../../tokens/app_spacing.dart';
import '../../tokens/app_typography.dart';

enum FgLabelTone { neutral, accent, error, disabled }

/// Compact semantic label used by fields and small interface sections.
class FgLabel extends StatelessWidget {
  const FgLabel({
    super.key,
    required this.text,
    this.isRequired = false,
    this.icon,
    this.tone = FgLabelTone.neutral,
    this.uppercase = true,
  });

  final String text;
  final bool isRequired;
  final IconData? icon;
  final FgLabelTone tone;
  final bool uppercase;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = _color(context, scheme);
    final label = uppercase ? text.toUpperCase() : text;

    return Semantics(
      label: text,
      isRequired: isRequired,
      child: ExcludeSemantics(
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSpacing.xs,
          children: [
            if (icon != null) Icon(icon, size: AppSizes.iconXs, color: color),
            Text.rich(
              TextSpan(
                text: label,
                style: AppTypography.overline.copyWith(color: color),
                children: [
                  if (isRequired)
                    TextSpan(
                      text: ' *',
                      style: AppTypography.overline.copyWith(
                        color: scheme.error,
                      ),
                    ),
                ],
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Color _color(BuildContext context, ColorScheme scheme) {
    return switch (tone) {
      FgLabelTone.neutral => context.forgeMutedForeground,
      FgLabelTone.accent => scheme.primary,
      FgLabelTone.error => scheme.error,
      FgLabelTone.disabled => context.forgeForeground.withValues(alpha: 0.38),
    };
  }
}
