import 'package:flutter/material.dart';

import '../../tokens/app_spacing.dart';
import '../buttons/fg_icon_button.dart';
import '../typography/fg_label.dart';

/// Accessible integer stepper composed from Forge icon actions.
///
/// Callers own both action labels so assistive wording stays localized and
/// names the quantity being adjusted.
class FgStepper extends StatelessWidget {
  const FgStepper({
    super.key,
    required this.value,
    required this.decrementSemanticsLabel,
    required this.incrementSemanticsLabel,
    this.min = 0,
    this.max = 100,
    this.step = 1,
    this.onChanged,
    this.label,
    this.unit,
    this.isEnabled = true,
    this.showBounds = false,
  })  : assert(max >= min),
        assert(value >= min && value <= max),
        assert(step > 0);

  final int value;
  final String decrementSemanticsLabel;
  final String incrementSemanticsLabel;
  final int min;
  final int max;
  final int step;
  final ValueChanged<int>? onChanged;
  final String? label;
  final String? unit;
  final bool isEnabled;
  final bool showBounds;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canDecrement = isEnabled && onChanged != null && value - step >= min;
    final canIncrement = isEnabled && onChanged != null && value + step <= max;
    final displayValue = '$value${unit == null ? '' : ' $unit'}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          FgLabel(text: label!),
          const SizedBox(height: AppSpacing.md),
        ],
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            FgIconButton(
              icon: Icons.remove,
              semanticLabel: decrementSemanticsLabel,
              onPressed: canDecrement ? () => onChanged!(value - step) : null,
              isEnabled: canDecrement,
              variant: FgIconButtonVariant.secondary,
            ),
            Semantics(
              label: label,
              value: displayValue,
              readOnly: true,
              child: ExcludeSemantics(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: AppSpacing.huge4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        displayValue,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                      if (showBounds)
                        Text(
                          '$min – $max',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            FgIconButton(
              icon: Icons.add,
              semanticLabel: incrementSemanticsLabel,
              onPressed: canIncrement ? () => onChanged!(value + step) : null,
              isEnabled: canIncrement,
              variant: FgIconButtonVariant.secondary,
            ),
          ],
        ),
      ],
    );
  }
}
