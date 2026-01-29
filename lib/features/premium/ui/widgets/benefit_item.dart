import 'package:flutter/material.dart';

import '/design_system/tokens/app_colors.dart';
import '/design_system/tokens/app_typography.dart';

class BenefitItem extends StatelessWidget {
  final Icon icon;
  final String title;
  final String description;

  const BenefitItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon,
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTheme.h6.copyWith(color: AppColors.crystalWhite),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: AppTheme.bodySmall.copyWith(color: AppColors.crystalWhite),
            ),
          ],
        ),
      ],
    );
  }
}
