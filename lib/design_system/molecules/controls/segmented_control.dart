import 'package:flutter/material.dart';

import '../../../design_system/tokens/app_colors.dart';
import '../../../design_system/tokens/app_spacing.dart';
import '../../../design_system/tokens/app_typography.dart';
import '../../../features/common/ui/widgets/material_ink_well.dart';

/// Segmented control molecule - Binary/ternary state selector
class SegmentedControl<T> extends StatelessWidget {
  final List<T> options;
  final T selectedValue;
  final ValueChanged<T> onSelectionChanged;
  final String Function(T)? labelBuilder;

  const SegmentedControl({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onSelectionChanged,
    this.labelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.gray800,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: List.generate(options.length, (index) {
          final option = options[index];
          final isSelected = option == selectedValue;
          final label = labelBuilder?.call(option) ?? option.toString();

          return Expanded(
            child: MaterialInkWell(
              onTap: () => onSelectionChanged(option),
              radius: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm + 2,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.forgeFire : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.forgeFire.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    label,
                    style: AppTheme.bodySmall.copyWith(
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: isSelected
                          ? AppColors.crystalWhite
                          : AppColors.gray400,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
