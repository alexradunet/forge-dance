import 'package:flutter/material.dart';
import '../../tokens/app_colors.dart';

/// A gradient overlay often used for text readability over images.
///
/// Typical usages:
/// - "Fade to Black" at the bottom of a screen.
/// - Scrim behind a top navigation bar.
class FgGradientOverlay extends StatelessWidget {
  final List<Color> colors;
  final List<double>? stops;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final double? width;
  final double? height;
  final Widget? child;

  const FgGradientOverlay({
    super.key,
    required this.colors,
    this.stops,
    this.begin = Alignment.topCenter,
    this.end = Alignment.bottomCenter,
    this.width,
    this.height,
    this.child,
  });

  /// Standard "Fade to Bottom" black gradient.
  /// Useful for bottom-aligned text on hero images.
  factory FgGradientOverlay.fadeToBottom({
    double height = 200,
    double opacity = 1.0,
  }) {
    return FgGradientOverlay(
      height: height,
      colors: [
        AppColors.bgDeep.withOpacity(0),
        AppColors.bgDeep.withOpacity(opacity),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  /// Standard "Fade to Top" black gradient.
  /// Useful for top headers on hero images.
  factory FgGradientOverlay.fadeToTop({
    double height = 120,
    double opacity = 0.8,
  }) {
    return FgGradientOverlay(
      height: height,
      colors: [
        AppColors.bgDeep.withOpacity(opacity),
        AppColors.bgDeep.withOpacity(0),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          stops: stops,
          begin: begin,
          end: end,
        ),
      ),
      child: child,
    );
  }
}
