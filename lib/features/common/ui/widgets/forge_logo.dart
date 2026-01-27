import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_theme.dart';

/// FORGE.DANCE Logo Widget
/// Displays the orange square icon with flame, followed by "FORGE." in white and "DANCE" in orange
class ForgeLogo extends StatelessWidget {
  final double? iconSize;
  final double? fontSize;
  final bool showFullText;

  const ForgeLogo({
    super.key,
    this.iconSize,
    this.fontSize,
    this.showFullText = true,
  });

  @override
  Widget build(BuildContext context) {
    final iconSizeValue = iconSize ?? 32.0;
    final fontSizeValue = fontSize ?? 18.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Orange square with flame icon
        Container(
          width: iconSizeValue,
          height: iconSizeValue,
          decoration: BoxDecoration(
            color: AppColors.forgeFire,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            Icons.local_fire_department,
            size: iconSizeValue * 0.6,
            color: AppColors.crystalWhite,
          ),
        ),
        if (showFullText) ...[
          const SizedBox(width: 8),
          Text(
            'FORGE.',
            style: AppTheme.h6.copyWith(
              fontSize: fontSizeValue,
              fontWeight: FontWeight.w600,
              color: AppColors.crystalWhite,
            ),
          ),
          Text(
            'DANCE',
            style: AppTheme.h6.copyWith(
              fontSize: fontSizeValue,
              fontWeight: FontWeight.w600,
              color: AppColors.forgeFire,
            ),
          ),
        ],
      ],
    );
  }
}
