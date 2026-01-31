import 'package:flutter/material.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_typography.dart';
import '../../tokens/app_shadows.dart';

/// Displays a user's level (XP tier).
///
/// Used in Profile, Leaderboards, and Headers.
class FgLevelBadge extends StatelessWidget {
  final int level;
  final double size;
  final bool showGlow;

  const FgLevelBadge({
    super.key,
    required this.level,
    this.size = 24,
    this.showGlow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.legendGold,
        shape: BoxShape.circle,
        boxShadow: showGlow ? [AppShadows.glowGold] : null,
        border: Border.all(
          color: Colors.white.withOpacity(0.8),
          width: 1.5,
        ),
      ),
      child: Text(
        level.toString(),
        style: AppTheme.label.copyWith(
          color: AppColors.gray950,
          fontWeight: FontWeight.bold,
          fontSize: size * 0.5,
        ),
      ),
    );
  }
}
