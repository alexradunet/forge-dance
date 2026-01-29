import 'package:flutter/material.dart';

import '../../tokens/app_colors.dart';
import '../../tokens/app_typography.dart';

/// Category tag presets for dance styles and content categorization
enum CategoryTagPreset {
  hipHop,
  breaking,
  latin,
  house,
  contemporary,
  popping,
  locking,
  krump,
  custom,
}

/// Get color for category tag preset
Color _getPresetColor(CategoryTagPreset preset) {
  switch (preset) {
    case CategoryTagPreset.hipHop:
      return AppColors.hipHopPurple;
    case CategoryTagPreset.breaking:
      return AppColors.breakingBlue;
    case CategoryTagPreset.latin:
      return AppColors.latinRose;
    case CategoryTagPreset.house:
      return AppColors.crystalWhite.withOpacity(0.7);
    case CategoryTagPreset.contemporary:
      return AppColors.electricBlue;
    case CategoryTagPreset.popping:
      return AppColors.legendGold;
    case CategoryTagPreset.locking:
      return AppColors.growthGreen;
    case CategoryTagPreset.krump:
      return AppColors.passionRed;
    case CategoryTagPreset.custom:
      return AppColors.textMuted;
  }
}

/// Category tag atom - Minimalist content categorization labels
/// Based on HTML mockup: forge.dance_home_dashboard_11 (04. Category Tags)
class CategoryTag extends StatelessWidget {
  final String label;
  final Color? color;
  final CategoryTagPreset? preset;
  final VoidCallback? onTap;
  final bool isSelectable;
  final bool isSelected;

  const CategoryTag({
    super.key,
    required this.label,
    this.color,
    this.preset,
    this.onTap,
    this.isSelectable = false,
    this.isSelected = false,
  });

  /// Convenience constructor for preset dance style tags
  factory CategoryTag.preset({
    Key? key,
    required CategoryTagPreset preset,
    String? customLabel,
    VoidCallback? onTap,
    bool isSelectable = false,
    bool isSelected = false,
  }) {
    final label = customLabel ?? _getPresetLabel(preset);
    return CategoryTag(
      key: key,
      label: label,
      preset: preset,
      color: _getPresetColor(preset),
      onTap: onTap,
      isSelectable: isSelectable,
      isSelected: isSelected,
    );
  }

  static String _getPresetLabel(CategoryTagPreset preset) {
    switch (preset) {
      case CategoryTagPreset.hipHop:
        return 'Hip Hop';
      case CategoryTagPreset.breaking:
        return 'Breaking';
      case CategoryTagPreset.latin:
        return 'Latin';
      case CategoryTagPreset.house:
        return 'House';
      case CategoryTagPreset.contemporary:
        return 'Contemporary';
      case CategoryTagPreset.popping:
        return 'Popping';
      case CategoryTagPreset.locking:
        return 'Locking';
      case CategoryTagPreset.krump:
        return 'Krump';
      case CategoryTagPreset.custom:
        return 'Custom';
    }
  }

  @override
  Widget build(BuildContext context) {
    final tagColor = color ?? (preset != null ? _getPresetColor(preset!) : AppColors.textMuted);
    final isNeutral = tagColor == AppColors.crystalWhite.withOpacity(0.7);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        decoration: BoxDecoration(
          color: isSelected
              ? tagColor.withOpacity(0.3)
              : isNeutral
                  ? AppColors.crystalWhite.withOpacity(0.05)
                  : tagColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected
                ? tagColor
                : isNeutral
                    ? AppColors.crystalWhite.withOpacity(0.1)
                    : tagColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Text(
          label.toUpperCase(),
          style: AppTypography.overline.copyWith(
            color: isNeutral ? AppColors.crystalWhite.withOpacity(0.7) : tagColor,
            fontWeight: FontWeight.w700,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}

/// Category tag group - Multiple tags in a row with selection support
class CategoryTagGroup extends StatelessWidget {
  final List<CategoryTagPreset> presets;
  final List<String>? customLabels;
  final Set<CategoryTagPreset>? selectedPresets;
  final ValueChanged<CategoryTagPreset>? onToggle;
  final bool isMultiSelect;

  const CategoryTagGroup({
    super.key,
    required this.presets,
    this.customLabels,
    this.selectedPresets,
    this.onToggle,
    this.isMultiSelect = true,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(
        presets.length,
        (index) {
          final preset = presets[index];
          final isSelected = selectedPresets?.contains(preset) ?? false;
          return CategoryTag.preset(
            preset: preset,
            customLabel: customLabels != null && index < customLabels!.length
                ? customLabels![index]
                : null,
            isSelectable: onToggle != null,
            isSelected: isSelected,
            onTap: onToggle != null ? () => onToggle!(preset) : null,
          );
        },
      ),
    );
  }
}
