import 'package:flutter/material.dart';

import '../../../../design_system/tokens/app_border_radius.dart';
import '../../../../design_system/tokens/app_colors.dart';
import '../../../../design_system/tokens/app_spacing.dart';
import '../../../../design_system/tokens/app_typography.dart';
import '../../../../design_system/tokens/app_shadows.dart';

enum AppButtonVariant {
  primary,
  destructive,
  outline,
  secondary,
  ghost,
  link,
}

enum AppButtonSize {
  sm,
  defaultSize,
  lg,
  icon,
}

class AppButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final bool isEnabled;
  final double? width;

  const AppButton({
    super.key,
    this.text,
    this.onPressed,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.defaultSize,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = _getBackgroundColor();
    final fgColor = _getForegroundColor();
    final borderColor = _getBorderColor();
    final buttonHeight = _getHeight();
    final padding = _getPadding();
    final borderRadius = _getBorderRadius();

    return Opacity(
      opacity: isEnabled ? 1.0 : 0.5,
      child: Container(
        width: width,
        height: buttonHeight,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: borderRadius,
          border: borderColor != null ? Border.all(color: borderColor) : null,
          boxShadow:
              variant == AppButtonVariant.primary && isEnabled && !isLoading
                  ? [AppShadows.glowPrimary]
                  : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled && !isLoading ? onPressed : null,
            borderRadius: borderRadius,
            child: Padding(
              padding: padding,
              child: _buildContent(fgColor),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(Color color) {
    if (isLoading) {
      return Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      );
    }

    final List<Widget> children = [];

    if (icon != null) {
      children.add(IconTheme(
        data: IconThemeData(
            color: color, size: size == AppButtonSize.sm ? 16 : 18),
        child: icon!,
      ));
    }

    if (text != null && size != AppButtonSize.icon) {
      if (children.isNotEmpty) {
        children.add(const SizedBox(width: AppSpacing.sm));
      }
      children.add(Text(
        text!,
        style: AppTypography.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          decoration: variant == AppButtonVariant.link
              ? TextDecoration.underline
              : null,
        ),
      ));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  Color _getBackgroundColor() {
    switch (variant) {
      case AppButtonVariant.primary:
        return AppColors.forgeFire;
      case AppButtonVariant.destructive:
        return AppColors.passionRed;
      case AppButtonVariant.secondary:
        return AppColors.surfaceLight;
      case AppButtonVariant.outline:
      case AppButtonVariant.ghost:
      case AppButtonVariant.link:
        return Colors.transparent;
    }
  }

  Color _getForegroundColor() {
    switch (variant) {
      case AppButtonVariant.primary:
      case AppButtonVariant.destructive:
        return AppColors.textMain;
      case AppButtonVariant.secondary:
        return AppColors.textMain;
      case AppButtonVariant.outline:
      case AppButtonVariant.ghost:
        return AppColors.textMain;
      case AppButtonVariant.link:
        return AppColors.forgeFire;
    }
  }

  Color? _getBorderColor() {
    if (variant == AppButtonVariant.outline) {
      return AppColors.neutral700;
    }
    return null;
  }

  double _getHeight() {
    switch (size) {
      case AppButtonSize.sm:
        return 32.0;
      case AppButtonSize.defaultSize:
        return 40.0;
      case AppButtonSize.lg:
        return 48.0;
      case AppButtonSize.icon:
        return 40.0;
    }
  }

  EdgeInsets _getPadding() {
    if (size == AppButtonSize.icon) return EdgeInsets.zero;

    switch (size) {
      case AppButtonSize.sm:
        return const EdgeInsets.symmetric(horizontal: AppSpacing.md);
      case AppButtonSize.defaultSize:
        return const EdgeInsets.symmetric(horizontal: AppSpacing.lg);
      case AppButtonSize.lg:
        return const EdgeInsets.symmetric(horizontal: AppSpacing.xxl);
      case AppButtonSize.icon:
        return EdgeInsets.zero;
    }
  }

  BorderRadius _getBorderRadius() {
    return AppBorderRadius.medium;
  }
}
