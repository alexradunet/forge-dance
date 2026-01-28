import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';

/// Circular progress atom - Dual-ring progress indicator
class CircularProgress extends StatelessWidget {
  final double outerProgress; // 0.0 to 1.0
  final double innerProgress; // 0.0 to 1.0
  final Color? outerColor;
  final Color? innerColor;
  final double size;
  final Widget? child;

  const CircularProgress({
    super.key,
    required this.outerProgress,
    required this.innerProgress,
    this.outerColor,
    this.innerColor,
    this.size = 120,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final outerClr = outerColor ?? AppColors.forgeFire;
    final innerClr = innerColor ?? AppColors.electricBlue;
    final strokeWidth = size * 0.08;
    final radius = (size - strokeWidth) / 2;
    final outerCircumference = 2 * math.pi * radius;
    final innerRadius = radius * 0.7;
    final innerCircumference = 2 * math.pi * innerRadius;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer ring
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: outerProgress,
              strokeWidth: strokeWidth,
              strokeCap: StrokeCap.round,
              valueColor: AlwaysStoppedAnimation<Color>(outerClr),
              backgroundColor: AppColors.gray800,
            ),
          ),
          // Inner ring
          SizedBox(
            width: size * 0.7,
            height: size * 0.7,
            child: CircularProgressIndicator(
              value: innerProgress,
              strokeWidth: strokeWidth * 0.75,
              strokeCap: StrokeCap.round,
              valueColor: AlwaysStoppedAnimation<Color>(innerClr),
              backgroundColor: AppColors.gray800,
            ),
          ),
          // Center content
          if (child != null) child!,
        ],
      ),
    );
  }
}
