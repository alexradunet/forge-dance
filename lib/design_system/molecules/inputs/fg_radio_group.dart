import 'package:flutter/material.dart';

import '../../atoms/surfaces/fg_card.dart';
import '../../tokens/app_spacing.dart';

@immutable
class FgRadioGroupItem<T> {
  const FgRadioGroupItem({
    required this.label,
    required this.value,
    this.description,
    this.leading,
    this.isEnabled = true,
  });

  final String label;
  final T value;
  final String? description;
  final Widget? leading;
  final bool isEnabled;
}

/// Controlled single-select group using Flutter's current [RadioGroup] API.
///
/// Arrow-key navigation and single-selection semantics come from the shared
/// group ancestor rather than independent gesture detectors.
class FgRadioGroup<T> extends StatelessWidget {
  const FgRadioGroup({
    super.key,
    required this.items,
    this.selectedValue,
    this.onChanged,
    this.semanticLabel,
  });

  final List<FgRadioGroupItem<T>> items;
  final T? selectedValue;
  final ValueChanged<T>? onChanged;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      container: semanticLabel != null,
      child: RadioGroup<T>(
        groupValue: selectedValue,
        onChanged: (value) {
          if (value != null) onChanged?.call(value);
        },
        child: Column(
          children: [
            for (var index = 0; index < items.length; index++) ...[
              FgCard(
                variant: FgCardVariant.outlined,
                padding: EdgeInsets.zero,
                child: RadioListTile<T>.adaptive(
                  value: items[index].value,
                  title: Text(items[index].label),
                  subtitle: items[index].description == null
                      ? null
                      : Text(items[index].description!),
                  secondary: items[index].leading,
                  selected: items[index].value == selectedValue,
                  enabled: items[index].isEnabled && onChanged != null,
                  contentPadding: AppSpacing.horizontal,
                ),
              ),
              if (index < items.length - 1)
                const SizedBox(height: AppSpacing.md),
            ],
          ],
        ),
      ),
    );
  }
}
