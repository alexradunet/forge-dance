import 'package:flutter/material.dart';

import '../../theme/forge_theme_extensions.dart';
import '../../tokens/app_spacing.dart';

enum FgProgressBarSize { sm, md, lg }

enum FgProgressBarTone { primary, secondary, success, reward }

/// Theme-aware linear or segmented progress indicator.
class FgProgressBar extends StatelessWidget {
  const FgProgressBar({
    super.key,
    required this.value,
    this.size = FgProgressBarSize.md,
    this.tone = FgProgressBarTone.primary,
    this.semanticLabel,
  })  : segments = null,
        isCumulative = true;

  const FgProgressBar.segmented({
    super.key,
    required int total,
    required int current,
    this.size = FgProgressBarSize.md,
    this.tone = FgProgressBarTone.primary,
    this.semanticLabel,
    this.isCumulative = true,
  })  : value = total > 0 ? (current + 1) / total : 0,
        segments = total;

  final double value;
  final FgProgressBarSize size;
  final FgProgressBarTone tone;
  final String? semanticLabel;
  final int? segments;
  final bool isCumulative;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final forgeColors = theme.forgeColors;
    final activeColor = switch (tone) {
      FgProgressBarTone.primary => scheme.primary,
      FgProgressBarTone.secondary => scheme.secondary,
      FgProgressBarTone.success => forgeColors.success,
      FgProgressBarTone.reward => forgeColors.reward,
    };
    final trackColor = scheme.surfaceContainerHighest;
    final normalizedValue = value.clamp(0.0, 1.0);
    final height = switch (size) {
      FgProgressBarSize.sm => AppSpacing.xs,
      FgProgressBarSize.md => AppSpacing.sm,
      FgProgressBarSize.lg => AppSpacing.md,
    };
    final valueLabel = '${(normalizedValue * 100).round()}%';

    return Semantics(
      label: semanticLabel,
      value: valueLabel,
      readOnly: true,
      child: ExcludeSemantics(
        child: segments == null || segments! <= 0
            ? LinearProgressIndicator(
                value: normalizedValue,
                minHeight: height,
                color: activeColor,
                backgroundColor: trackColor,
                borderRadius: BorderRadius.circular(height / 2),
              )
            : _SegmentedProgress(
                value: normalizedValue,
                segments: segments!,
                height: height,
                activeColor: activeColor,
                trackColor: trackColor,
                isCumulative: isCumulative,
              ),
      ),
    );
  }
}

class _SegmentedProgress extends StatelessWidget {
  const _SegmentedProgress({
    required this.value,
    required this.segments,
    required this.height,
    required this.activeColor,
    required this.trackColor,
    required this.isCumulative,
  });

  final double value;
  final int segments;
  final double height;
  final Color activeColor;
  final Color trackColor;
  final bool isCumulative;

  @override
  Widget build(BuildContext context) {
    final filledSegments = (value * segments).round();

    return Row(
      children: [
        for (var index = 0; index < segments; index++) ...[
          if (index > 0) const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Container(
              height: height,
              decoration: BoxDecoration(
                color: isCumulative
                    ? (index < filledSegments ? activeColor : trackColor)
                    : (index == filledSegments - 1
                        ? activeColor
                        : trackColor),
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
