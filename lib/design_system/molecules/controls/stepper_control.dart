import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_theme.dart';
import '../../atoms/buttons/icon_button.dart';

/// Stepper control molecule - For numeric adjustments
class StepperControl extends StatefulWidget {
  final int initialValue;
  final ValueChanged<int>? onValueChanged;
  final int min;
  final int max;
  final String label;
  final String? unit;

  const StepperControl({
    super.key,
    this.initialValue = 0,
    this.onValueChanged,
    this.min = 0,
    this.max = 999,
    required this.label,
    this.unit,
  });

  @override
  State<StepperControl> createState() => _StepperControlState();
}

class _StepperControlState extends State<StepperControl> {
  late int _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void _decrement() {
    if (_value > widget.min) {
      setState(() => _value--);
      widget.onValueChanged?.call(_value);
    }
  }

  void _increment() {
    if (_value < widget.max) {
      setState(() => _value++);
      widget.onValueChanged?.call(_value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.gray800,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray700, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.label.toUpperCase(),
                style: AppTheme.caption.copyWith(
                  color: AppColors.gray400,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                widget.unit != null ? '${widget.label} ${widget.unit}' : widget.label,
                style: AppTheme.h5.copyWith(
                  color: AppColors.crystalWhite,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: AppColors.gray950,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.gray700, width: 1),
            ),
            child: Row(
              children: [
                IconButtonAtom(
                  icon: Icons.remove,
                  onPressed: _decrement,
                  backgroundColor: AppColors.gray800,
                  iconColor: AppColors.crystalWhite,
                  size: 40,
                ),
                Container(
                  width: 48,
                  alignment: Alignment.center,
                  child: Text(
                    '$_value',
                    style: AppTheme.h2.copyWith(
                      color: AppColors.forgeFire,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                IconButtonAtom(
                  icon: Icons.add,
                  onPressed: _increment,
                  backgroundColor: AppColors.gray800,
                  iconColor: AppColors.crystalWhite,
                  size: 40,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
