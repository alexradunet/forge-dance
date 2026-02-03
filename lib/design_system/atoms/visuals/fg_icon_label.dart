import 'package:flutter/material.dart';
import '../../tokens/app_typography.dart';
import '../../tokens/app_colors.dart';

class FgIconLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? iconColor;
  final Color? labelColor;
  final Color? valueColor;

  const FgIconLabel({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
    this.labelColor,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 10,
              color: (iconColor ?? Colors.white).withOpacity(0.6),
            ),
            const SizedBox(width: 4),
            Text(
              label.toUpperCase(),
              style: AppTypography.label.copyWith(
                color: labelColor ?? AppColors.textDark,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.bodySmall.copyWith(
            color: valueColor ?? Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
