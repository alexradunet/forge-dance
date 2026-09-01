import 'package:flutter/material.dart';

import '../../atoms/buttons/fg_button.dart';
import '../../theme/forge_theme_extensions.dart';
import '../../tokens/app_sizes.dart';
import '../../tokens/app_spacing.dart';

enum FgEmptyTone { primary, neutral, error, success, reward }

/// Semantic empty or feedback state with an optional recovery action.
class FgEmpty extends StatelessWidget {
  const FgEmpty({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.actionLabel,
    this.onAction,
    this.tone = FgEmptyTone.primary,
  });

  final IconData icon;
  final String title;
  final String? description;
  final String? actionLabel;
  final VoidCallback? onAction;
  final FgEmptyTone tone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final forgeColors = theme.forgeColors;
    final accent = switch (tone) {
      FgEmptyTone.primary => scheme.primary,
      FgEmptyTone.neutral => scheme.onSurfaceVariant,
      FgEmptyTone.error => scheme.error,
      FgEmptyTone.success => forgeColors.success,
      FgEmptyTone.reward => forgeColors.reward,
    };

    return Padding(
      padding: AppSpacing.allXXL,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ExcludeSemantics(
            child: Container(
              width: AppSizes.squareTileSm,
              height: AppSizes.squareTileSm,
              decoration: BoxDecoration(
                color: scheme.surfaceContainer,
                shape: BoxShape.circle,
                border: Border.all(color: accent.withValues(alpha: 0.32)),
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: AppSizes.iconHuge, color: accent),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            title,
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          if (description != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              description!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: AppSpacing.xxl),
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSizes.cardStandardWidth,
              ),
              child: FgButton(
                text: actionLabel!,
                onPressed: onAction,
                expand: true,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
