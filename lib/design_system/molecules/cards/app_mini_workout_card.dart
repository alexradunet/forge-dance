import 'package:flutter/material.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_typography.dart';
import '../../atoms/icons/fg_icon.dart';

class AppMiniWorkoutCard extends StatelessWidget {
  final String title;
  final String duration;
  final String intensity;
  final VoidCallback? onTap;

  const AppMiniWorkoutCard({
    super.key,
    required this.title,
    required this.duration,
    required this.intensity,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Background decoration
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 80,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.forgeFire.withOpacity(0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.forgeFire.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: AppColors.forgeFire.withOpacity(0.4)),
                    ),
                    child: const FgIcon(
                      icon: Icons.fitness_center,
                      size: 20,
                      color: AppColors.forgeFire,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title.toUpperCase(),
                    style: AppTypography.h5.copyWith(
                      color: AppColors.textMain,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildMetaItem(Icons.timer_outlined, duration),
                      const SizedBox(width: 8),
                      // If space is tight, we might hide intensity or show icon only
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaItem(IconData icon, String text) {
    return Row(
      children: [
        FgIcon(icon: icon, size: 12, color: AppColors.textMuted),
        const SizedBox(width: 4),
        Text(
          text,
          style: AppTypography.label
              .copyWith(color: AppColors.textMuted, fontSize: 10),
        ),
      ],
    );
  }
}
