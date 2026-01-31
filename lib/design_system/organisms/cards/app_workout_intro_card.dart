import 'package:flutter/material.dart';

import '../../tokens/app_colors.dart';
import '../../tokens/app_typography.dart';
import '../../atoms/icons/fg_icon.dart';

class AppWorkoutIntroCard extends StatelessWidget {
  final String title;
  final String duration;
  final String intensity;
  final String description;

  const AppWorkoutIntroCard({
    super.key,
    required this.title,
    required this.duration,
    required this.intensity,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(32),
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
            height: 200,
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
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.forgeFire.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: AppColors.forgeFire.withOpacity(0.4)),
                  ),
                  child: const FgIcon(
                    icon: Icons.fitness_center,
                    size: 40,
                    color: AppColors.forgeFire,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  title.toUpperCase(),
                  style: AppTypography.h2
                      .copyWith(color: AppColors.textMain, fontSize: 32),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildMetaItem(Icons.timer_outlined, duration),
                    const SizedBox(width: 16),
                    _buildMetaItem(Icons.bolt, '$intensity Intensity'),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  description,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMain.withOpacity(0.7),
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                _buildStatsGrid(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaItem(IconData icon, String text) {
    return Row(
      children: [
        FgIcon(icon: icon, size: 16, color: AppColors.textMuted),
        const SizedBox(width: 4),
        Text(
          text,
          style: AppTypography.label
              .copyWith(color: AppColors.textMuted, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('5', 'EXERCISES'),
          _divider(),
          _buildStatItem('350', 'CALORIES'),
          _divider(),
          _buildStatItem('EXP', 'LEVEL UP'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String val, String label) {
    return Column(
      children: [
        Text(val,
            style: AppTypography.h3
                .copyWith(color: AppColors.textMain, fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTypography.label.copyWith(
              color: AppColors.textMuted, fontSize: 10, letterSpacing: 1),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
        height: 40, width: 1, color: Colors.white.withOpacity(0.1));
  }
}
