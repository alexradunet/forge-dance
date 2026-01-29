import 'package:flutter/material.dart';

import '../../../../design_system/tokens/app_colors.dart';

/// Stats card displaying a single metric (streak, XP, rank, etc.)
class ProfileStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;

  const ProfileStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.iconColor = AppColors.forgeFire,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.textMuted,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: iconColor,
              ),
              const SizedBox(width: 4),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Stats row used in profile header
class ProfileStatsRow extends StatelessWidget {
  final int streak;
  final String totalFP;
  final String rank;

  const ProfileStatsRow({
    super.key,
    required this.streak,
    required this.totalFP,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ProfileStatCard(
            label: 'Streak',
            value: streak.toString(),
            icon: Icons.local_fire_department,
            iconColor: AppColors.forgeFire,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ProfileStatCard(
            label: 'Total FP',
            value: totalFP,
            icon: Icons.bolt,
            iconColor: AppColors.electricBlue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ProfileStatCard(
            label: 'Rank',
            value: rank,
            icon: Icons.emoji_events,
            iconColor: AppColors.legendGold,
          ),
        ),
      ],
    );
  }
}
