import 'package:flutter/material.dart';

import '../../theme/forge_theme_extensions.dart';
import '../../tokens/app_border_radius.dart';
import '../../tokens/app_sizes.dart';
import '../../tokens/app_spacing.dart';
import '../../tokens/app_typography.dart';

/// Compact countdown panel. The caller owns the clock and its transitions.
class FgTimerControl extends StatelessWidget {
  const FgTimerControl({
    super.key,
    required this.remaining,
    required this.total,
    required this.running,
    required this.actionLabel,
    required this.semanticLabel,
    required this.onToggle,
  });
  final int remaining;
  final int total;
  final bool running;
  final String actionLabel;
  final String semanticLabel;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.forgeColors;
    return Semantics(
      label: semanticLabel,
      button: true,
      onTap: onToggle,
      child: ExcludeSemantics(
        child: Material(
          color: colors.immersiveSurface,
          shape: RoundedRectangleBorder(
            borderRadius: AppBorderRadius.extraLarge,
            side: BorderSide(color: colors.onImmersive.withValues(alpha: 0.12)),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onToggle,
            child: Padding(
              padding: AppSpacing.allLG,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${remaining}s',
                              style: AppTypography.h4.copyWith(
                                color: colors.onImmersive,
                                fontFeatures: const [
                                  FontFeature.tabularFigures(),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              actionLabel,
                              style: AppTypography.bodySmall.copyWith(
                                color: colors.onImmersiveMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Container(
                        width: AppSizes.comfortableTouchTarget,
                        height: AppSizes.comfortableTouchTarget,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          remaining == 0
                              ? Icons.check_rounded
                              : running
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: theme.colorScheme.onPrimary,
                          size: AppSizes.iconLg,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  LinearProgressIndicator(
                    value: total <= 0 ? 1 : (1 - remaining / total).clamp(0, 1),
                    minHeight: AppSpacing.xs,
                    borderRadius: AppBorderRadius.large,
                    color: theme.colorScheme.primary,
                    backgroundColor: colors.onImmersiveMuted.withValues(
                      alpha: 0.18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
