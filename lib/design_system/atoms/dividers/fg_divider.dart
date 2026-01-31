import 'package:flutter/material.dart';

import '../../../../design_system/tokens/app_colors.dart';

/// Gradient divider atom - Horizontal/vertical with Forge Fire gradient
class FgDivider extends StatelessWidget {
  final bool isVertical;
  final Color? startColor;
  final Color? endColor;
  final double thickness;

  const FgDivider({
    super.key,
    this.isVertical = false,
    this.startColor,
    this.endColor,
    this.thickness = 1.0,
  });

  const FgDivider.horizontal({
    super.key,
    Color? startColor,
    Color? endColor,
    this.thickness = 1.0,
  })  : isVertical = false,
        startColor = startColor ?? Colors.transparent,
        endColor = endColor ?? AppColors.forgeFire;

  const FgDivider.vertical({
    super.key,
    Color? startColor,
    Color? endColor,
    this.thickness = 1.0,
  })  : isVertical = true,
        startColor = startColor ?? Colors.transparent,
        endColor = endColor ?? AppColors.forgeFire;

  @override
  Widget build(BuildContext context) {
    final start = startColor ?? Colors.transparent;
    final end = endColor ?? AppColors.forgeFire;

    if (isVertical) {
      return Container(
        width: thickness,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [start, end, start],
          ),
        ),
      );
    }

    return Container(
      height: thickness,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [start, end, start],
        ),
        boxShadow: [
          BoxShadow(
            color: end.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 0),
          ),
        ],
      ),
    );
  }
}
