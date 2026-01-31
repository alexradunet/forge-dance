import 'package:flutter/material.dart';

import '../../tokens/app_colors.dart';

class FgProgressBar extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final double height;
  final Color? color;
  final Color? backgroundColor;
  final int? segments;
  final double spacing;
  final bool isCumulative;

  const FgProgressBar({
    super.key,
    required this.value,
    this.height = 8,
    this.color,
    this.backgroundColor,
    this.segments,
    this.spacing = 8,
    this.isCumulative = true,
  });

  /// Factory for segmented progress using integer steps
  factory FgProgressBar.segmented({
    required int total,
    required int current,
    double height = 8,
    Color? color,
    Color? backgroundColor,
    double spacing = 8,
    bool isCumulative = true,
    Key? key,
  }) {
    return FgProgressBar(
      key: key,
      value: total > 0 ? (current + 1) / total : 0,
      segments: total,
      height: height,
      color: color,
      backgroundColor: backgroundColor,
      spacing: spacing,
      isCumulative: isCumulative,
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? AppColors.forgeFire;
    final trackColor = backgroundColor ?? activeColor.withOpacity(0.2);

    if (segments != null && segments! > 0) {
      return _buildSegmented(activeColor, trackColor);
    }

    return _buildContinuous(activeColor, trackColor);
  }

  Widget _buildContinuous(Color activeColor, Color trackColor) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: trackColor,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: value.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: activeColor,
            borderRadius: BorderRadius.circular(height / 2),
          ),
        ),
      ),
    );
  }

  Widget _buildSegmented(Color activeColor, Color trackColor) {
    final filledSegments = (value * segments!).round();

    return Row(
      children: List.generate(segments!, (index) {
        final bool isActive = isCumulative
            ? index < filledSegments
            : index == (filledSegments - 1);

        return Expanded(
          child: Container(
            height: height,
            margin: EdgeInsets.only(
              right: index < segments! - 1 ? spacing : 0,
            ),
            decoration: BoxDecoration(
              color: isActive ? activeColor : trackColor,
              borderRadius: BorderRadius.circular(height / 2),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: activeColor.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 0),
                      ),
                    ]
                  : null,
            ),
          ),
        );
      }),
    );
  }
}
