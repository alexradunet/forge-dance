import 'package:flutter/material.dart';

import '../../atoms/buttons/fg_filter_chip.dart';
import '../../atoms/typography/fg_label.dart';
import '../../tokens/app_spacing.dart';
import 'forge_bottom_sheet.dart';

/// Sectioned filter sheet composed from Forge selection and modal primitives.
class FgFilterSheet extends StatefulWidget {
  const FgFilterSheet({
    super.key,
    required this.title,
    required this.resetLabel,
    required this.applyLabel,
    required this.sections,
    required this.selectedFilters,
    required this.onFilterSelected,
    this.onReset,
    this.onApply,
  });

  final String title;
  final String resetLabel;
  final String applyLabel;
  final Map<String, List<String>> sections;
  final Map<String, String> selectedFilters;
  final void Function(String section, String value) onFilterSelected;
  final VoidCallback? onReset;
  final VoidCallback? onApply;

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String resetLabel,
    required String applyLabel,
    required Map<String, List<String>> sections,
    required Map<String, String> selectedFilters,
    required void Function(String section, String value) onFilterSelected,
    VoidCallback? onReset,
    VoidCallback? onApply,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) => FgFilterSheet(
        title: title,
        resetLabel: resetLabel,
        applyLabel: applyLabel,
        sections: sections,
        selectedFilters: selectedFilters,
        onFilterSelected: onFilterSelected,
        onReset: onReset,
        onApply: onApply,
      ),
    );
  }

  @override
  State<FgFilterSheet> createState() => _FgFilterSheetState();
}

class _FgFilterSheetState extends State<FgFilterSheet> {
  late Map<String, String> _selectedFilters;

  @override
  void initState() {
    super.initState();
    _selectedFilters = {...widget.selectedFilters};
  }

  @override
  void didUpdateWidget(covariant FgFilterSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedFilters != widget.selectedFilters) {
      _selectedFilters = {...widget.selectedFilters};
    }
  }

  void _select(String section, String value) {
    setState(() => _selectedFilters[section] = value);
    widget.onFilterSelected(section, value);
  }

  @override
  Widget build(BuildContext context) {
    return ForgeBottomSheet(
      title: widget.title,
      resetLabel: widget.onReset == null ? null : widget.resetLabel,
      onReset: widget.onReset,
      actionLabel: widget.onApply == null ? null : widget.applyLabel,
      onAction: widget.onApply,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final entry in widget.sections.entries) ...[
            FgLabel(text: entry.key),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final item in entry.value)
                  FgFilterChip(
                    label: item,
                    isSelected: _selectedFilters[entry.key] == item,
                    onSelected: (_) => _select(entry.key, item),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ],
      ),
    );
  }
}
