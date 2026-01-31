import 'package:flutter/material.dart';

import '../../tokens/app_colors.dart';
import '../../tokens/app_typography.dart';
import '../../tokens/app_border_radius.dart';

enum FgBadgeVariant {
  solid,
  outline,
  subtle,
}

enum FgBadgeShape {
  standard,
  pill,
}

enum FgBadgeColor {
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

class FgBadge extends StatelessWidget {
  final String text;
  final FgBadgeVariant variant;
  final FgBadgeColor color;
  final FgBadgeShape shape;
  final IconData? icon;
  final VoidCallback? onTap;
  final double fontSize;

  const FgBadge({
    super.key,
    required this.text,
    this.variant = FgBadgeVariant.solid,
    this.color = FgBadgeColor.brand,
    this.shape = FgBadgeShape.standard,
    this.icon,
    this.onTap,
    this.fontSize = 10,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getColors();
    final borderRadius = shape == FgBadgeShape.pill
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
      case FgBadgeVariant.solid:
        return _BadgeColors(
          background: baseColor,
          foreground: _getSolidForeground(baseColor),
        );
      case FgBadgeVariant.outline:
        return _BadgeColors(
          background: Colors.transparent,
          foreground: baseColor,
          border: baseColor,
        );
      case FgBadgeVariant.subtle:
        // Adjust for visibility on dark background
        final isNeutral = color == FgBadgeColor.neutral;
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
      case FgBadgeColor.brand:
        return AppColors.forgeFire;
      case FgBadgeColor.success:
        return AppColors.growthGreen;
      case FgBadgeColor.warning:
        return AppColors.warningAmber;
      case FgBadgeColor.error:
        return AppColors.passionRed;
      case FgBadgeColor.neutral:
        return AppColors.gray400;
      case FgBadgeColor.purple:
        return AppColors.hipHopPurple;
      case FgBadgeColor.blue:
        return AppColors.breakingBlue;
      case FgBadgeColor.rose:
        return AppColors.latinRose;
      case FgBadgeColor.gold:
        return AppColors.legendGold;
    }
  }

  Color _getSolidForeground(Color bg) {
    if (color == FgBadgeColor.warning ||
        color == FgBadgeColor.success ||
        color == FgBadgeColor.gold) {
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
