import 'package:flutter/material.dart';

import '../../tokens/app_colors.dart';
import '../../tokens/app_typography.dart';
import '../../tokens/app_border_radius.dart';

/// Small Square Tile - Category icons and minimal labeling (1:1)
/// Based on HTML mockup: forge.dance_home_dashboard_12 (01. Small Square Tile)
class SquareTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color? accentColor;
  final VoidCallback? onTap;
  final double size;

  const SquareTile({
    super.key,
    required this.label,
    required this.icon,
    this.accentColor,
    this.onTap,
    this.size = 112,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? AppColors.forgeFire;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: AppBorderRadius.large,
          border: Border.all(
            color: AppColors.crystalWhite.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            // Hover gradient (always visible as subtle)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color.withOpacity(0.05),
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: AppBorderRadius.large,
                ),
              ),
            ),

            // Content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon container
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.crystalWhite.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Label
                  Text(
                    label.toUpperCase(),
                    style: AppTypography.overline.copyWith(
                      color: AppColors.crystalWhite,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
