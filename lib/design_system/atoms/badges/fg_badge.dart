import 'package:flutter/material.dart';

import '../../tokens/app_colors.dart';
import '../../tokens/app_typography.dart';
import '../../tokens/app_border_radius.dart';
import '../../theme/forge_theme_extensions.dart';

enum FgBadgeVariant { solid, outline, subtle }

enum FgBadgeShape { standard, pill }

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
    final colors = _getColors(context);
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
        Flexible(
          child: Text(
            text.toUpperCase(),
            style: AppTypography.label.copyWith(
              color: colors.foreground,
              fontWeight: FontWeight.w700,
              fontSize: fontSize,
              letterSpacing: 0.5,
            ),
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

  _BadgeColors _getColors(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final forge = theme.forgeColors;
    final baseColor = switch (color) {
      FgBadgeColor.brand => scheme.primary,
      FgBadgeColor.success => forge.success,
      FgBadgeColor.warning => forge.warning,
      FgBadgeColor.error => scheme.error,
      FgBadgeColor.neutral => scheme.surfaceContainerHighest,
      FgBadgeColor.gold => forge.reward,
      _ => _getBaseColor(),
    };
    final foreground = switch (color) {
      FgBadgeColor.brand => scheme.onPrimary,
      FgBadgeColor.success => forge.onSuccess,
      FgBadgeColor.warning => forge.onWarning,
      FgBadgeColor.error => scheme.onError,
      FgBadgeColor.neutral => scheme.onSurface,
      FgBadgeColor.gold => forge.onReward,
      // Durable category hues still need a readable paired foreground.
      _ => baseColor.computeLuminance() > 0.179 ? Colors.black : Colors.white,
    };
    return switch (variant) {
      FgBadgeVariant.solid => _BadgeColors(
        background: baseColor,
        foreground: foreground,
      ),
      FgBadgeVariant.outline => _BadgeColors(
        background: Colors.transparent,
        foreground: scheme.onSurface,
        border: baseColor,
      ),
      FgBadgeVariant.subtle => _BadgeColors(
        background: baseColor.withValues(alpha: 0.12),
        foreground: scheme.onSurface,
      ),
    };
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
