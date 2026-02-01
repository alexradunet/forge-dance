import 'package:flutter/material.dart';
import '../../tokens/app_colors.dart';

class LessonTimelineTrack extends StatelessWidget {
  final double width;
  final Gradient? gradient;

  const LessonTimelineTrack({
    super.key,
    this.width = 2,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        gradient: gradient ??
            LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.forgeFire.withOpacity(0.8),
                AppColors.forgeFire,
                Colors.white.withOpacity(0.05),
              ],
              stops: const [0.0, 0.4, 0.8],
            ),
        boxShadow: [
          BoxShadow(
            color: AppColors.forgeFire.withOpacity(0.5),
            blurRadius: 10,
          ),
        ],
      ),
    );
  }
}
