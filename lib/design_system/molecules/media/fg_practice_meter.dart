import 'package:flutter/material.dart';

import '../../design_system.dart';

/// A quiet, content-sized practice readout. Counts change without decorative
/// animation. The strip is visual; [status] supplies its accessible equivalent.
class FgPracticeMeter extends StatelessWidget {
  const FgPracticeMeter({
    super.key,
    required this.elapsed,
    required this.elapsedSemanticLabel,
    required this.target,
    required this.status,
    required this.metadata,
    required this.progress,
    this.activeCount,
    this.firstCount = 1,
    this.lastCount = 8,
    this.announceStatus = false,
  }) : assert(firstCount >= 1 && lastCount <= 8 && firstCount <= lastCount);

  final String elapsed;
  final String elapsedSemanticLabel;
  final String target;
  final String status;
  final String metadata;
  final double progress;
  final int? activeCount;
  final int firstCount;
  final int lastCount;
  final bool announceStatus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          liveRegion: announceStatus,
          child: Text(status, style: theme.textTheme.titleMedium),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          elapsed,
          semanticsLabel: elapsedSemanticLabel,
          style: AppTypography.poster.copyWith(
            color: context.forgeForeground,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(target, style: theme.textTheme.bodySmall),
        const SizedBox(height: AppSpacing.md),
        FgProgressBar(value: progress.clamp(0, 1)),
        const SizedBox(height: AppSpacing.lg),
        ExcludeSemantics(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final minimum =
                  AppSizes.rhythmCountWidth *
                  MediaQuery.textScalerOf(context).scale(1);
              final columns =
                  constraints.maxWidth >= minimum * 8 + AppSpacing.xs * 7
                  ? 8
                  : 4;
              final width =
                  (constraints.maxWidth - AppSpacing.xs * (columns - 1)) /
                  columns;
              return Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  for (var count = 1; count <= 8; count++)
                    SizedBox(
                      width: width,
                      child: DecoratedBox(
                        key: ValueKey('practice-count-$count'),
                        decoration: BoxDecoration(
                          color: activeCount == count
                              ? scheme.primary
                              : context.forgeSurfaceColor,
                          borderRadius: AppBorderRadius.small,
                          border: Border.all(
                            color: count >= firstCount && count <= lastCount
                                ? scheme.outline
                                : scheme.outlineVariant,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.sm,
                          ),
                          child: Text(
                            '$count',
                            textAlign: TextAlign.center,
                            style: AppTypography.monoLarge.copyWith(
                              color: activeCount == count
                                  ? scheme.onPrimary
                                  : context.forgeMutedForeground,
                              decoration:
                                  count < firstCount || count > lastCount
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          metadata,
          style: theme.textTheme.bodySmall?.copyWith(
            color: context.forgeMutedForeground,
          ),
        ),
      ],
    );
  }
}
