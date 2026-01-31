import 'dart:ui';
import 'package:flutter/material.dart';
import '../../tokens/app_colors.dart';

/// A container with a frosted glass effect.
///
/// Uses [BackdropFilter] to blur the background and applies a semi-transparent
/// fill and border.
class FgGlassContainer extends StatelessWidget {
  final Widget child;
  final double blurSigma;
  final double opacity;
  final double borderRadius;
  final double borderWidth;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double? width;
  final double? height;

  const FgGlassContainer({
    super.key,
    required this.child,
    this.blurSigma = 10.0,
    this.opacity = 0.1,
    this.borderRadius = 16.0,
    this.borderWidth = 1.0,
    this.borderColor,
    this.padding,
    this.color,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: (color ?? AppColors.bgDeep).withOpacity(opacity),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor ?? Colors.white.withOpacity(0.1),
              width: borderWidth,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
