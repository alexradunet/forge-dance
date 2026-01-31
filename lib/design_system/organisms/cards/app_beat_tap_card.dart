import 'package:flutter/material.dart';

import 'app_interactive_card.dart';
import '../../molecules/cards/app_stat_card.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_typography.dart';
import '../../atoms/app_icon.dart';

class AppBeatTapCard extends StatelessWidget {
  final String title;
  final String rhythm;
  final int bpm;
  final int streak;

  const AppBeatTapCard({
    super.key,
    this.title = 'BEAT PRACTICE',
    this.rhythm = 'Syncopated 8ths',
    this.bpm = 112,
    this.streak = 12,
  });

  @override
  Widget build(BuildContext context) {
    return AppInteractiveCard(
      title: title,
      backgroundImage:
          'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?w=800&auto=format&fit=crop&q=80',
      tags: const ['RHYTHM', 'PRACTICE'],
      backContent: _buildBackContent(),
      child: _buildFooter(),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStat('BPM', bpm.toString(), Icons.speed),
        _buildStat('STREAK', streak.toString(), Icons.local_fire_department),
      ],
    );
  }

  Widget _buildStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Text(
          label,
          style: AppTypography.label
              .copyWith(color: AppColors.textMuted, fontSize: 9),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            AppIcon(icon: icon, size: 14, color: AppColors.forgeFire),
            const SizedBox(width: 4),
            Text(
              value,
              style: AppTypography.h4
                  .copyWith(color: AppColors.textMain, fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBackContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RHYTHM TIPS',
          style: AppTypography.h4.copyWith(color: AppColors.forgeFire),
        ),
        const SizedBox(height: 16),
        Text(
          'Focus on the 2nd and 4th beats to find the groove. Keep your movements sharp and on time.',
          style: AppTypography.bodySmall.copyWith(color: AppColors.textMain),
        ),
      ],
    );
  }
}
