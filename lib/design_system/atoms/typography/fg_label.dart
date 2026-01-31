import 'package:flutter/material.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_typography.dart';

/// A standard label atom for inputs or sections.
class FgLabel extends StatelessWidget {
  final String text;
  final bool isRequired;
  final IconData? icon;
  final Color? color;

  const FgLabel({
    super.key,
    required this.text,
    this.isRequired = false,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = color ?? AppColors.textMuted;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 6),
        ],
        RichText(
          text: TextSpan(
            text: text,
            style: AppTheme.label.copyWith(color: textColor),
            children: [
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: AppTheme.label.copyWith(color: AppColors.passionRed),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
