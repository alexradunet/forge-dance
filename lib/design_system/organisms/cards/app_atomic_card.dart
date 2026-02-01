import 'package:flutter/material.dart';

import 'app_interactive_card.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_typography.dart';
import '../../atoms/icons/fg_icon.dart';

class AppAtomicCard extends StatelessWidget {
  final String title;
  final String category;
  final String imageUrl;
  final String level;
  final String bodyPart;
  final String intensity;
  final VoidCallback? onTap;

  const AppAtomicCard({
    super.key,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.level,
    required this.bodyPart,
    required this.intensity,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppInteractiveCard(
      title: title,
      backgroundImage: imageUrl,
      level: level,
      backContent: _buildBackContent(),
      backFooter: _buildFooter(),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStat('INTENSITY', intensity, Icons.speed),
        _buildStat('FOCUS', bodyPart, Icons.accessibility_new),
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
            FgIcon(icon: icon, size: 14, color: AppColors.forgeFire),
            const SizedBox(width: 4),
            Text(
              value.toUpperCase(),
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
          'CORE MOVEMENTS',
          style: AppTypography.h4.copyWith(color: AppColors.forgeFire),
        ),
        const SizedBox(height: 16),
        _buildStep('1', 'Establish a solid base with centered weight'),
        _buildStep('2', 'Initiate the movement from your core'),
        _buildStep('3', 'Extend through the limbs with sharp control'),
      ],
    );
  }

  Widget _buildStep(String num, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$num.',
            style: AppTypography.mono.copyWith(
                color: AppColors.forgeFire, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style:
                  AppTypography.bodySmall.copyWith(color: AppColors.textMain),
            ),
          ),
        ],
      ),
    );
  }
}
