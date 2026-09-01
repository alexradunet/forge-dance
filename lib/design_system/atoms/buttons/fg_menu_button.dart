import 'package:flutter/material.dart';

import '../../tokens/app_sizes.dart';

@immutable
class FgMenuItem<T> {
  const FgMenuItem({
    required this.value,
    required this.label,
    this.isSelected = false,
    this.isEnabled = true,
  });

  final T value;
  final String label;
  final bool isSelected;
  final bool isEnabled;
}

/// Icon-triggered Material menu with caller-owned semantics and typed values.
class FgMenuButton<T> extends StatelessWidget {
  const FgMenuButton({
    super.key,
    required this.icon,
    required this.semanticLabel,
    required this.items,
    required this.onSelected,
    this.isEnabled = true,
  });

  final IconData icon;
  final String semanticLabel;
  final List<FgMenuItem<T>> items;
  final ValueChanged<T> onSelected;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Semantics(
        label: semanticLabel,
        button: true,
        enabled: isEnabled,
        child: PopupMenuButton<T>(
          icon: ExcludeSemantics(
            child: Icon(icon, size: AppSizes.iconLg),
          ),
          enabled: isEnabled,
          onSelected: onSelected,
          itemBuilder: (context) => [
            for (final item in items)
              CheckedPopupMenuItem<T>(
                value: item.value,
                checked: item.isSelected,
                enabled: item.isEnabled,
                child: Text(item.label),
              ),
          ],
        ),
      ),
    );
  }
}
