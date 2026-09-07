import 'package:flutter/material.dart';

import '../../theme/forge_theme_extensions.dart';
import '../../tokens/app_sizes.dart';
import '../../tokens/app_spacing.dart';
import '../../tokens/app_typography.dart';

/// Determinate countdown with an explicit, keyboard-accessible play/pause action.
/// The caller owns the clock; rebuilding this control never starts a timer.
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
    final colors = Theme.of(context).forgeColors;
    return Semantics(
      label: semanticLabel,
      button: true,
      onTap: onToggle,
      child: ExcludeSemantics(
        child: Material(
          color: colors.immersiveSurface,
          shape: const StadiumBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xxl,
                vertical: AppSpacing.md,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: AppSizes.squareTileMd,
                        maxHeight: AppSizes.squareTileMd,
                      ),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CircularProgressIndicator(
                              value: total <= 0
                                  ? 1
                                  : (1 - remaining / total).clamp(0, 1),
                              color: Theme.of(context).colorScheme.primary,
                              backgroundColor: colors.onImmersiveMuted
                                  .withValues(alpha: 0.2),
                              strokeWidth: AppSpacing.xs,
                            ),
                            Center(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '${remaining}s',
                                  style: AppTypography.h2.copyWith(
                                    color: colors.onImmersive,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        remaining == 0
                            ? Icons.check_rounded
                            : running
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: colors.onImmersive,
                        size: AppSizes.iconMd,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Flexible(
                        child: Text(
                          actionLabel,
                          textAlign: TextAlign.center,
                          style: AppTypography.label.copyWith(
                            color: colors.onImmersive,
                          ),
                        ),
                      ),
                    ],
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
