import 'package:flutter/material.dart';
import '../../tokens/app_colors.dart';

/// A customized circular progress indicator.
///
/// Used for loading states in buttons, overlays, or small content areas.
/// For skeleton loading, use [FgShimmer].
class FgSpinner extends StatelessWidget {
  final double size;
  final Color? color;
  final double strokeWidth;
  final Color? trackColor;

  const FgSpinner({
    super.key,
    this.size = 24,
    this.color,
    this.strokeWidth = 3,
    this.trackColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation(color ?? AppColors.forgeFire),
        backgroundColor: trackColor ?? Colors.transparent,
      ),
    );
  }
}
