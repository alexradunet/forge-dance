import 'package:flutter/material.dart';

import '../../../design_system/tokens/app_colors.dart';
import '../../../design_system/tokens/app_spacing.dart';
import '../../../design_system/tokens/app_typography.dart';
import '../../../features/common/ui/widgets/material_ink_well.dart';

/// Radio group molecule - Single-select with custom styling
class FgRadioGroupItem<T> {
  final String label;
  final T value;

  FgRadioGroupItem({
    required this.label,
    required this.value,
  });
}

class RadioGroup<T> extends StatelessWidget {
  final List<FgRadioGroupItem<T>> items;
  final T? selectedValue;
  final ValueChanged<T>? onChanged;

  const RadioGroup({
    super.key,
    required this.items,
    this.selectedValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(items.length, (index) {
        final item = items[index];
        final isSelected = item.value == selectedValue;

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: MaterialInkWell(
            onTap: () => onChanged?.call(item.value),
            radius: 12,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.gray800,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? AppColors.forgeFire.withOpacity(0.3)
                      : AppColors.gray700,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.forgeFire
                            : AppColors.gray400,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? Center(
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: AppColors.forgeFire,
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      item.label,
                      style: AppTheme.body.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected
                            ? AppColors.crystalWhite
                            : AppColors.gray400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
