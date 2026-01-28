import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';

/// Linear progress atom - Segmented progress bar (5 segments) with Electric Blue
class LinearProgress extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final int segments;
  final Color? progressColor;
  final Color? backgroundColor;
  final double height;

  const LinearProgress({
    super.key,
    required this.progress,
    this.segments = 5,
    this.progressColor,
    this.backgroundColor,
    this.height = 12,
  });

  @override
  Widget build(BuildContext context) {
    final progressClr = progressColor ?? AppColors.electricBlue;
    final bgClr = backgroundColor ?? AppColors.gray700;
    final filledSegments = (progress * segments).floor();
    final partialSegment = (progress * segments) - filledSegments;

    return Row(
      children: List.generate(segments, (index) {
        final isFilled = index < filledSegments;
        final isPartial = index == filledSegments && partialSegment > 0;

        return Expanded(
          child: Container(
            height: height,
            margin: EdgeInsets.only(
              right: index < segments - 1 ? AppSpacing.xs : 0,
            ),
            decoration: BoxDecoration(
              color: isFilled
                  ? progressClr
                  : isPartial
                      ? progressClr.withOpacity(0.4)
                      : bgClr,
              borderRadius: BorderRadius.circular(4),
              boxShadow: isFilled
                  ? [
                      BoxShadow(
                        color: progressClr.withOpacity(0.5),
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
