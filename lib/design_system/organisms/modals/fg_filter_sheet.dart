import 'package:flutter/material.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_typography.dart';

/// Standard Filter Bottom Sheet matching the web design.
/// Features sectioned filters (Difficulty, Style, Type) with selectable chips.
class FgFilterSheet extends StatefulWidget {
  final Map<String, List<String>> sections;
  final Map<String, String> selectedFilters;
  final Function(String section, String value) onFilterSelected;
  final VoidCallback? onReset;
  final VoidCallback? onApply;

  const FgFilterSheet({
    super.key,
    required this.sections,
    required this.selectedFilters,
    required this.onFilterSelected,
    this.onReset,
    this.onApply,
  });

  /// Static helper to show the filter sheet
  static Future<void> show({
    required BuildContext context,
    required Map<String, List<String>> sections,
    required Map<String, String> selectedFilters,
    required Function(String section, String value) onFilterSelected,
    VoidCallback? onReset,
    VoidCallback? onApply,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => FgFilterSheet(
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
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF161616),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'FILTERS',
                  style: AppTypography.h4.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: AppColors.textMuted,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(color: Colors.white10),

          // Sections
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.sections.entries.map((entry) {
                  return _buildSection(entry.key, entry.value);
                }).toList(),
              ),
            ),
          ),

          // Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                if (widget.onReset != null)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: widget.onReset,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.white.withOpacity(0.1)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('RESET'),
                    ),
                  ),
                if (widget.onReset != null && widget.onApply != null)
                  const SizedBox(width: 16),
                if (widget.onApply != null)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: widget.onApply,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.forgeFire,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('APPLY FILTERS'),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: AppTypography.overline.copyWith(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) {
            final isSelected = widget.selectedFilters[title] == item;
            return GestureDetector(
              onTap: () => widget.onFilterSelected(title, item),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.forgeFire.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.forgeFire
                        : Colors.white.withOpacity(0.1),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  item,
                  style: AppTypography.bodySmall.copyWith(
                    color: isSelected ? Colors.white : AppColors.textMuted,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
