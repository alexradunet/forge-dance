import 'package:flutter/material.dart';

import '../../tokens/app_sizes.dart';

/// Standard filter control with native selection, focus, and keyboard behavior.
class FgFilterChip extends StatelessWidget {
  const FgFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    this.onSelected,
    this.icon,
    this.isEnabled = true,
    this.focusNode,
    this.autofocus = false,
  });

  final String label;
  final bool isSelected;
  final ValueChanged<bool>? onSelected;
  final IconData? icon;
  final bool isEnabled;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final isInteractive = isEnabled && onSelected != null;

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: AppSizes.comfortableTouchTarget,
      ),
      child: FilterChip(
        focusNode: focusNode,
        autofocus: autofocus,
        label: Text(label),
        avatar: icon == null ? null : Icon(icon, size: AppSizes.iconSm),
        selected: isSelected,
        onSelected: isInteractive ? onSelected : null,
        materialTapTargetSize: MaterialTapTargetSize.padded,
        visualDensity: VisualDensity.standard,
        showCheckmark: true,
      ),
    );
  }
}
