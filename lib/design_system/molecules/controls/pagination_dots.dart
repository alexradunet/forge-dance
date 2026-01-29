import 'package:flutter/material.dart';

import '../../../design_system/tokens/app_colors.dart';
import '../../../design_system/tokens/app_spacing.dart';

/// Pagination dots molecule - For carousels/sliders
class PaginationDots extends StatelessWidget {
  final int totalDots;
  final int activeIndex;
  final double dotSize;
  final double activeDotWidth;
  final Color? activeColor;
  final Color? inactiveColor;

  const PaginationDots({
    super.key,
    required this.totalDots,
    required this.activeIndex,
    this.dotSize = 8,
    this.activeDotWidth = 32,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final activeClr = activeColor ?? AppColors.forgeFire;
    final inactiveClr = inactiveColor ?? AppColors.gray700;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalDots, (index) {
        final isActive = index == activeIndex;
        return Container(
          margin: EdgeInsets.only(
            right: index < totalDots - 1 ? AppSpacing.sm : 0,
          ),
          width: isActive ? activeDotWidth : dotSize,
          height: dotSize,
          decoration: BoxDecoration(
            color: isActive ? activeClr : inactiveClr,
            borderRadius: BorderRadius.circular(dotSize / 2),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: activeClr.withOpacity(0.6),
                      blurRadius: 8,
                      offset: const Offset(0, 0),
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }
}
