import 'package:flutter/material.dart';

import '../../atoms/surfaces/fg_card.dart';
import '../../tokens/app_spacing.dart';

@immutable
class FgCheckboxGroupItem {
  const FgCheckboxGroupItem({
    required this.label,
    required this.value,
    this.id,
    this.description,
    this.isEnabled = true,
  });

  final String label;
  final bool value;
  final String? id;
  final String? description;
  final bool isEnabled;
}

/// Controlled multi-select group using Flutter's native checkbox behavior.
class FgCheckboxGroup extends StatelessWidget {
  const FgCheckboxGroup({
    super.key,
    required this.items,
    this.onChanged,
    this.semanticLabel,
  });

  final List<FgCheckboxGroupItem> items;
  final ValueChanged<List<String>>? onChanged;
  final String? semanticLabel;

  void _toggle(int index) {
    final nextSelection = <String>[
      for (var itemIndex = 0; itemIndex < items.length; itemIndex++)
        if (itemIndex == index ? !items[itemIndex].value : items[itemIndex].value)
          items[itemIndex].id ?? items[itemIndex].label,
    ];
    onChanged?.call(nextSelection);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      container: semanticLabel != null,
      child: Column(
        children: [
          for (var index = 0; index < items.length; index++) ...[
            FgCard(
              variant: FgCardVariant.outlined,
              padding: EdgeInsets.zero,
              child: CheckboxListTile.adaptive(
                value: items[index].value,
                onChanged: items[index].isEnabled && onChanged != null
                    ? (_) => _toggle(index)
                    : null,
                title: Text(items[index].label),
                subtitle: items[index].description == null
                    ? null
                    : Text(items[index].description!),
                enabled: items[index].isEnabled,
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: AppSpacing.horizontal,
              ),
            ),
            if (index < items.length - 1)
              const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}
