import 'package:flutter/material.dart';

import '../../tokens/app_colors.dart';
import '../../tokens/app_typography.dart';
import '../../tokens/app_border_radius.dart';

enum AppBadgeVariant {
  defaultVariant,
  secondary,
  destructive,
  outline,
}

class AppBadge extends StatelessWidget {
  final String text;
  final AppBadgeVariant variant;
  final IconData? icon;
  final VoidCallback? onTap;
  final double fontSize;

  const AppBadge({
    super.key,
    required this.text,
    this.variant = AppBadgeVariant.defaultVariant,
    this.icon,
    this.onTap,
    this.fontSize = 10,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = _getBackgroundColor();
    final fgColor = _getForegroundColor();
    final borderColor = _getBorderColor();

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 12, color: fgColor),
          const SizedBox(width: 4),
        ],
        Text(
          text,
          style: AppTypography.label.copyWith(
            color: fgColor,
            fontWeight: FontWeight.w600,
            fontSize: fontSize,
          ),
        ),
      ],
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: AppBorderRadius.small,
          border: borderColor != null
              ? Border.all(color: borderColor, width: 1)
              : null,
        ),
        child: content,
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (variant) {
      case AppBadgeVariant.defaultVariant:
        return AppColors.forgeFire;
      case AppBadgeVariant.secondary:
        return AppColors.surfaceLight;
      case AppBadgeVariant.destructive:
        return AppColors.passionRed;
      case AppBadgeVariant.outline:
        return Colors.transparent;
    }
  }

  Color _getForegroundColor() {
    switch (variant) {
      case AppBadgeVariant.defaultVariant:
      case AppBadgeVariant.secondary:
      case AppBadgeVariant.destructive:
        return AppColors.textMain;
      case AppBadgeVariant.outline:
        return AppColors.textMain;
    }
  }

  Color? _getBorderColor() {
    if (variant == AppBadgeVariant.outline) {
      return AppColors.neutral700;
    }
    return null;
  }
}
