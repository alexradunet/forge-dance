import 'package:flutter/material.dart';

import '../../tokens/app_colors.dart';
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
    final color = _color(Theme.of(context).colorScheme);
    final label = uppercase ? text.toUpperCase() : text;

    return Semantics(
      label: text,
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: AppSizes.iconXs, color: color),
              const SizedBox(width: AppSpacing.xs),
            ],
            Text.rich(
              TextSpan(
                text: label,
                style: AppTypography.overline.copyWith(color: color),
                children: [
                  if (isRequired)
                    TextSpan(
                      text: ' *',
                      style: AppTypography.overline.copyWith(
                        color: AppColors.passionRed,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _color(ColorScheme colors) {
    return switch (tone) {
      FgLabelTone.neutral => colors.onSurfaceVariant,
      FgLabelTone.accent => colors.primary,
      FgLabelTone.error => colors.error,
      FgLabelTone.disabled => colors.onSurface.withAlpha(97),
    };
  }
}
