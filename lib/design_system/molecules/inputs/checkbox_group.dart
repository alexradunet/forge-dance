import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_theme.dart';
import '../../../features/common/ui/widgets/material_ink_well.dart';

/// Checkbox group molecule - Multi-select with custom styling
class CheckboxGroupItem {
  final String label;
  final bool value;
  final String? id;

  CheckboxGroupItem({
    required this.label,
    required this.value,
    this.id,
  });
}

class CheckboxGroup extends StatefulWidget {
  final List<CheckboxGroupItem> items;
  final ValueChanged<List<String>>? onChanged;

  const CheckboxGroup({
    super.key,
    required this.items,
    this.onChanged,
  });

  @override
  State<CheckboxGroup> createState() => _CheckboxGroupState();
}

class _CheckboxGroupState extends State<CheckboxGroup> {
  late List<CheckboxGroupItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.items);
  }

  void _toggleItem(int index) {
    setState(() {
      _items[index] = CheckboxGroupItem(
        label: _items[index].label,
        value: !_items[index].value,
        id: _items[index].id,
      );
    });
    widget.onChanged?.call(
      _items.where((item) => item.value).map((item) => item.id ?? item.label).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(_items.length, (index) {
        final item = _items[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: MaterialInkWell(
            onTap: () => _toggleItem(index),
            radius: 12,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.gray800,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: item.value
                      ? AppColors.forgeFire.withOpacity(0.3)
                      : AppColors.gray700,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: item.value ? AppColors.forgeFire : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: item.value
                            ? AppColors.forgeFire
                            : AppColors.gray400,
                        width: 2,
                      ),
                    ),
                    child: item.value
                        ? const Icon(
                            Icons.check,
                            size: 16,
                            color: AppColors.crystalWhite,
                          )
                        : null,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      item.label,
                      style: AppTheme.body.copyWith(
                        fontWeight: item.value
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: item.value
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
