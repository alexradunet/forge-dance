import 'package:flutter/material.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_typography.dart';
import '../../tokens/app_border_radius.dart';

/// Interactive filter chip.
///
/// Used for filtering lists, selecting options (e.g. dance styles), or tags.
class FgFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool>? onSelected;
  final IconData? icon;
  final bool isEnabled;

  const FgFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    this.onSelected,
    this.icon,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    // Colors
    final backgroundColor =
        isSelected ? AppColors.forgeFire.withOpacity(0.15) : AppColors.gray800;

    final borderColor = isSelected ? AppColors.forgeFire : AppColors.gray600;

    final textColor = isSelected ? AppColors.textMain : AppColors.textMuted;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isEnabled ? () => onSelected?.call(!isSelected) : null,
        borderRadius: AppBorderRadius.pill,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isEnabled ? backgroundColor : AppColors.gray900,
            borderRadius: AppBorderRadius.pill,
            border: Border.all(
              color: isEnabled ? borderColor : AppColors.gray800,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: textColor,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: AppTheme.bodySmall.copyWith(
                  color: textColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
