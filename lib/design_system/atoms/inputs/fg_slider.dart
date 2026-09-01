import 'package:flutter/material.dart';

import '../../tokens/app_spacing.dart';
import '../typography/fg_label.dart';

/// Accessible range input backed by Flutter's Material slider.
///
/// Native keyboard, pointer, focus, and assistive increment/decrement behavior
/// are preserved. [semanticLabel] and [semanticFormatterCallback] remain
/// caller-owned so units and localized wording stay outside the design system.
class FgSlider extends StatelessWidget {
  const FgSlider({
    super.key,
    required this.value,
    required this.semanticLabel,
    this.min = 0,
    this.max = 100,
    this.onChanged,
    this.label,
    this.valueLabel,
    this.showBpmStyle = false,
    this.showTicks = false,
    this.divisions,
    this.isEnabled = true,
    this.semanticFormatterCallback,
    this.focusNode,
    this.autofocus = false,
  })  : assert(max > min),
        assert(value >= min && value <= max),
        assert(divisions == null || divisions > 0);

  final double value;
  final String semanticLabel;
  final double min;
  final double max;
  final ValueChanged<double>? onChanged;
  final String? label;
  final String? valueLabel;
  final bool showBpmStyle;
  final bool showTicks;
  final int? divisions;
  final bool isEnabled;
  final SemanticFormatterCallback? semanticFormatterCallback;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final effectiveOnChanged = isEnabled ? onChanged : null;
    final effectiveDivisions = divisions ?? (showTicks ? 4 : null);
    final semanticStep = (max - min) / (effectiveDivisions ?? 10);
    final increasedValue = (value + semanticStep).clamp(min, max);
    final decreasedValue = (value - semanticStep).clamp(min, max);
    String formatValue(double candidate) =>
        semanticFormatterCallback?.call(candidate) ??
        (candidate == value && valueLabel != null
            ? valueLabel!
            : candidate.toStringAsFixed(0));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null || valueLabel != null) ...[
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: AppSpacing.lg,
            runSpacing: AppSpacing.xs,
            children: [
              if (label != null) FgLabel(text: label!),
              if (valueLabel != null)
                Text(
                  valueLabel!,
                  style: showBpmStyle
                      ? theme.textTheme.titleLarge?.copyWith(
                          color: scheme.primary,
                          fontWeight: FontWeight.w700,
                        )
                      : theme.textTheme.labelLarge?.copyWith(
                          color: scheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        Semantics(
          label: semanticLabel,
          value: formatValue(value),
          increasedValue: formatValue(increasedValue),
          decreasedValue: formatValue(decreasedValue),
          enabled: effectiveOnChanged != null,
          slider: true,
          onIncrease: effectiveOnChanged != null && value < max
              ? () => effectiveOnChanged(increasedValue)
              : null,
          onDecrease: effectiveOnChanged != null && value > min
              ? () => effectiveOnChanged(decreasedValue)
              : null,
          child: ExcludeSemantics(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: showBpmStyle ? AppSpacing.sm : AppSpacing.xs,
                showValueIndicator: ShowValueIndicator.onlyForDiscrete,
              ),
              child: Slider(
                value: value,
                min: min,
                max: max,
                divisions: effectiveDivisions,
                label: valueLabel,
                onChanged: effectiveOnChanged,
                focusNode: focusNode,
                autofocus: autofocus,
              ),
            ),
          ),
        ),
        if (showTicks || showBpmStyle)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$min', style: theme.textTheme.labelSmall),
              Text('$max', style: theme.textTheme.labelSmall),
            ],
          ),
      ],
    );
  }
}
