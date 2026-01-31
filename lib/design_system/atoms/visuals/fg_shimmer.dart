import 'package:flutter/material.dart';
import '../../tokens/app_colors.dart';

/// Standard shimmer loading effect.
///
/// Wraps content or creates a placeholder shape with a shimmer animation.
class FgShimmer extends StatefulWidget {
  final double? width;
  final double? height;
  final ShapeBorder shape;
  final Color baseColor;
  final Color highlightColor;
  final Widget? child;

  const FgShimmer({
    super.key,
    this.width,
    this.height,
    this.shape = const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8))),
    this.baseColor = AppColors.gray800,
    this.highlightColor = AppColors.gray700,
    this.child,
  });

  /// Circular shimmer (e.g., Avatar)
  factory FgShimmer.circle({
    double? size,
    Color? baseColor,
    Color? highlightColor,
  }) {
    return FgShimmer(
      width: size,
      height: size,
      shape: const CircleBorder(),
      baseColor: baseColor ?? AppColors.gray800,
      highlightColor: highlightColor ?? AppColors.gray700,
    );
  }

  /// Rectangular/Card shimmer
  factory FgShimmer.rect({
    double? width,
    double? height,
    double borderRadius = 8.0,
    Color? baseColor,
    Color? highlightColor,
  }) {
    return FgShimmer(
      width: width,
      height: height,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius)),
      baseColor: baseColor ?? AppColors.gray800,
      highlightColor: highlightColor ?? AppColors.gray700,
    );
  }

  @override
  State<FgShimmer> createState() => _FgShimmerState();
}

class _FgShimmerState extends State<FgShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: ShapeDecoration(
            shape: widget.shape,
            gradient: LinearGradient(
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: const [0.1, 0.5, 0.9],
              begin: const Alignment(-1.0, -0.3),
              end: const Alignment(1.0, 0.3),
              transform: _SlidingGradientTransform(_controller.value),
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform(this.slidePercent);

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(
        bounds.width * (slidePercent * 2 - 1), 0.0, 0.0);
  }
}
