import 'package:flutter/material.dart';

import '../../design_system.dart';

/// A numbered practice round, or a focused active stage. Keeps safety/cues in
/// the visible content rather than treating them as decoration or hidden detail.
class FgRoundPanel extends StatelessWidget {
  const FgRoundPanel({
    super.key,
    required this.label,
    required this.child,
    this.active = false,
  });

  final String label;
  final Widget child;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: context.forgeSurfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: AppBorderRadius.small,
        side: BorderSide(
          color: active ? scheme.primary : scheme.outlineVariant,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: AppSpacing.allLG,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                ExcludeSemantics(
                  child: Icon(
                    active ? Icons.graphic_eq : Icons.north_east,
                    color: scheme.primary,
                    size: AppSizes.iconMd,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    label,
                    style: AppTypography.overline.copyWith(
                      color: context.forgeMutedForeground,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            child,
          ],
        ),
      ),
    );
  }
}
