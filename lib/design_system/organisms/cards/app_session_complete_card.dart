import 'package:flutter/material.dart';

import '../../tokens/app_colors.dart';
import '../../tokens/app_typography.dart';
import '../../atoms/fg_icon.dart';

class AppSessionCompleteCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<AppSessionStat> stats;

  const AppSessionCompleteCard({
    super.key,
    this.title = 'SESSION COMPLETE',
    this.subtitle = 'Great work! You crushed it.',
    this.stats = const [
      AppSessionStat(label: 'TIME', value: '25:00', icon: Icons.timer),
      AppSessionStat(
          label: 'EXERCISES', value: '5', icon: Icons.fitness_center),
      AppSessionStat(label: 'XP GAINED', value: '+350', icon: Icons.bolt),
    ],
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
            height: 300,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.forgeFire.withOpacity(0.1),
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
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: AppColors.forgeFire.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.forgeFire, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.forgeFire.withOpacity(0.3),
                        blurRadius: 30,
                      )
                    ],
                  ),
                  child: const FgIcon(
                    icon: Icons.emoji_events,
                    size: 48,
                    color: AppColors.forgeFire,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  title,
                  style: AppTypography.h2
                      .copyWith(color: AppColors.textMain, fontSize: 32),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textMain.withOpacity(0.7), fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                ...stats.map((stat) => _buildStatRow(stat)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(AppSessionStat stat) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: FgIcon(icon: stat.icon, size: 16, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Text(
                stat.label,
                style: AppTypography.label.copyWith(
                    color: AppColors.textMuted, fontSize: 10, letterSpacing: 1),
              ),
            ],
          ),
          Text(
            stat.value,
            style: AppTypography.h3
                .copyWith(color: AppColors.textMain, fontSize: 20),
          ),
        ],
      ),
    );
  }
}

class AppSessionStat {
  final String label;
  final String value;
  final IconData icon;

  const AppSessionStat({
    required this.label,
    required this.value,
    required this.icon,
  });
}
