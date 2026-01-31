import 'package:flutter/material.dart';

import '../../tokens/app_colors.dart';
import '../../tokens/app_typography.dart';
import '../../tokens/app_border_radius.dart';

enum AppBadgeVariant {
  solid,
  outline,
  subtle,
}

enum AppBadgeShape {
  standard,
  pill,
}

enum AppBadgeColor {
  brand,
  success,
  warning,
  error,
  neutral,
  purple,
  blue,
  rose,
  gold,
}

class AppBadge extends StatelessWidget {
  final String text;
  final AppBadgeVariant variant;
  final AppBadgeColor color;
  final AppBadgeShape shape;
  final IconData? icon;
  final VoidCallback? onTap;
  final double fontSize;

  const AppBadge({
    super.key,
    required this.text,
    this.variant = AppBadgeVariant.solid,
    this.color = AppBadgeColor.brand,
    this.shape = AppBadgeShape.standard,
    this.icon,
    this.onTap,
    this.fontSize = 10,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getColors();
    final borderRadius = shape == AppBadgeShape.pill
        ? BorderRadius.circular(999)
        : AppBorderRadius.small;

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 12, color: colors.foreground),
          const SizedBox(width: 4),
        ],
        Text(
          text.toUpperCase(),
          style: AppTypography.label.copyWith(
            color: colors.foreground,
            fontWeight: FontWeight.w700,
            fontSize: fontSize,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: borderRadius,
          border: colors.border != null
              ? Border.all(color: colors.border!, width: 1)
              : null,
        ),
        child: content,
      ),
    );
  }

  _BadgeColors _getColors() {
    final baseColor = _getBaseColor();

    switch (variant) {
      case AppBadgeVariant.solid:
        return _BadgeColors(
          background: baseColor,
          foreground: _getSolidForeground(baseColor),
        );
      case AppBadgeVariant.outline:
        return _BadgeColors(
          background: Colors.transparent,
          foreground: baseColor,
          border: baseColor,
        );
      case AppBadgeVariant.subtle:
        // Adjust for visibility on dark background
        final isNeutral = color == AppBadgeColor.neutral;
        return _BadgeColors(
          background: isNeutral
              ? AppColors.crystalWhite.withOpacity(0.05)
              : baseColor.withOpacity(0.15),
          foreground: isNeutral
              ? AppColors.crystalWhite.withOpacity(0.8)
              : baseColor.withOpacity(0.9), // Slightly lighter for readability
        );
    }
  }

  Color _getBaseColor() {
    switch (color) {
      case AppBadgeColor.brand:
        return AppColors.forgeFire;
      case AppBadgeColor.success:
        return AppColors.growthGreen;
      case AppBadgeColor.warning:
        return AppColors.warningAmber;
      case AppBadgeColor.error:
        return AppColors.passionRed;
      case AppBadgeColor.neutral:
        return AppColors.gray400;
      case AppBadgeColor.purple:
        return AppColors.hipHopPurple;
      case AppBadgeColor.blue:
        return AppColors.breakingBlue;
      case AppBadgeColor.rose:
        return AppColors.latinRose;
      case AppBadgeColor.gold:
        return AppColors.legendGold;
    }
  }

  Color _getSolidForeground(Color bg) {
    if (color == AppBadgeColor.warning ||
        color == AppBadgeColor.success ||
        color == AppBadgeColor.gold) {
      return AppColors.gray950;
    }
    return AppColors.crystalWhite;
  }
}

class _BadgeColors {
  final Color background;
  final Color foreground;
  final Color? border;

  _BadgeColors({
    required this.background,
    required this.foreground,
    this.border,
  });
}
