import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_theme.dart';

/// Activity chart molecule - 7-day bar chart
class ActivityChart extends StatelessWidget {
  final List<double> values; // 0.0 to 1.0 for each day
  final List<String> labels;
  final Color? barColor;

  const ActivityChart({
    super.key,
    required this.values,
    this.labels = const ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
    this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    final barClr = barColor ?? AppColors.forgeFire;
    final maxHeight = 120.0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.gray800.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray700, width: 1),
      ),
      child: Column(
        children: [
          SizedBox(
            height: maxHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(values.length, (index) {
                final value = values[index];
                final height = maxHeight * value;
                final isMax = value == values.reduce((a, b) => a > b ? a : b);

                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: double.infinity,
                        height: height,
                        margin: EdgeInsets.only(
                          right: index < values.length - 1 ? AppSpacing.xs : 0,
                        ),
                        decoration: BoxDecoration(
                          color: value > 0
                              ? (isMax ? barClr : barClr.withOpacity(value))
                              : AppColors.gray700,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: isMax && value > 0
                              ? [
                                  BoxShadow(
                                    color: barClr.withOpacity(0.5),
                                    blurRadius: 8,
                                    offset: const Offset(0, 0),
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(labels.length, (index) {
              final isMax = values[index] ==
                  values.reduce((a, b) => a > b ? a : b);
              return Expanded(
                child: Text(
                  labels[index],
                  textAlign: TextAlign.center,
                  style: AppTheme.caption.copyWith(
                    color: isMax
                        ? AppColors.crystalWhite
                        : AppColors.gray400,
                    fontWeight: isMax ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
