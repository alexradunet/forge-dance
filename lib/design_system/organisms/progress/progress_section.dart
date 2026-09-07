import 'package:flutter/material.dart';

import '../../atoms/buttons/fg_button.dart';
import '../../atoms/progress/fg_progress_bar.dart';
import '../../atoms/surfaces/fg_card.dart';
import '../../theme/forge_theme_extensions.dart';
import '../../tokens/app_sizes.dart';
import '../../tokens/app_spacing.dart';

enum FgStatTone { primary, secondary, success, reward, neutral }

/// Responsive progress summary composed from Forge cards and progress atoms.
class FgProgressSection extends StatelessWidget {
  const FgProgressSection({
    super.key,
    required this.title,
    required this.stats,
    this.actionLabel,
    this.onAction,
    this.levelProgress,
    this.onProgressTap,
    this.immersive = false,
  });

  final String title;
  final bool immersive;
  final String? actionLabel;
  final VoidCallback? onAction;
  final List<FgStatData> stats;
  final FgProgressData? levelProgress;
  final VoidCallback? onProgressTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: context.forgeForeground,
                ),
              ),
            ),
            if (actionLabel != null && onAction != null)
              FgButton(
                text: actionLabel!,
                variant: FgButtonVariant.ghost,
                size: FgButtonSize.sm,
                onPressed: onAction,
              ),
          ],
        ),
        if (stats.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns =
                  ((constraints.maxWidth + AppSpacing.md) /
                          (AppSizes.cardCompactWidth + AppSpacing.md))
                      .floor()
                      .clamp(1, 3);
              return Column(
                children: [
                  for (var row = 0; row < stats.length; row += columns) ...[
                    if (row > 0) const SizedBox(height: AppSpacing.md),
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (var column = 0; column < columns; column++) ...[
                            if (column > 0)
                              const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: row + column < stats.length
                                  ? FgCard(
                                      immersive: immersive,
                                      child: _StatContent(
                                        stat: stats[row + column],
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
        if (levelProgress != null) ...[
          const SizedBox(height: AppSpacing.md),
          FgCard(
            variant: immersive ? FgCardVariant.opaque : FgCardVariant.elevated,
            immersive: immersive,
            onTap: onProgressTap,
            child: _ProgressContent(progress: levelProgress!),
          ),
        ],
      ],
    );
  }
}

class _StatContent extends StatelessWidget {
  const _StatContent({required this.stat});

  final FgStatData stat;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final forgeColors = theme.forgeColors;
    final accent = switch (stat.tone) {
      FgStatTone.primary => scheme.primary,
      FgStatTone.secondary => scheme.secondary,
      FgStatTone.success => forgeColors.success,
      FgStatTone.reward => forgeColors.reward,
      FgStatTone.neutral => scheme.onSurfaceVariant,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (stat.icon != null) ...[
          Icon(stat.icon, color: accent, size: AppSizes.iconLg),
          const SizedBox(height: AppSpacing.sm),
        ],
        Text(
          '${stat.value}${stat.unit ?? ''}',
          style: theme.textTheme.titleLarge?.copyWith(
            color: context.forgeForeground,
            fontWeight: FontWeight.w700,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          stat.label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: context.forgeMutedForeground,
          ),
        ),
      ],
    );
  }
}

class _ProgressContent extends StatelessWidget {
  const _ProgressContent({required this.progress});

  final FgProgressData progress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ratio = progress.target <= 0
        ? 0.0
        : (progress.current / progress.target).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: AppSpacing.lg,
          runSpacing: AppSpacing.xs,
          children: [
            Text(
              progress.label,
              style: theme.textTheme.titleMedium?.copyWith(
                color: context.forgeForeground,
              ),
            ),
            Text(
              progress.valueLabel,
              style: theme.textTheme.labelLarge?.copyWith(
                color: context.forgeMutedForeground,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        FgProgressBar(value: ratio),
        if (progress.message != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            progress.message!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: context.forgeMutedForeground,
            ),
          ),
        ],
      ],
    );
  }
}

@immutable
class FgStatData {
  const FgStatData({
    required this.label,
    required this.value,
    this.unit,
    this.icon,
    this.tone = FgStatTone.primary,
  });

  final String label;
  final String value;
  final String? unit;
  final IconData? icon;
  final FgStatTone tone;
}

@immutable
class FgProgressData {
  const FgProgressData({
    required this.label,
    required this.current,
    required this.target,
    required this.valueLabel,
    this.message,
  });

  final String label;
  final double current;
  final double target;
  final String valueLabel;
  final String? message;
}
