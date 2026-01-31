import 'package:flutter/material.dart';

// import '../../../../design_system/tokens/app_border_radius.dart'; // Unused
import '../../../../design_system/tokens/app_colors.dart';
import '../../../../design_system/tokens/app_spacing.dart';
import '../../../../design_system/tokens/app_typography.dart';
// import '../../../../design_system/tokens/app_shadows.dart'; // Unused

enum AppButtonVariant {
  primary, // ForgeFire, Shadow
  secondary, // Outline ElectricBlue
  tertiary, // SurfaceLight (Filled)
  ghost, // Transparent, Text only
  destructive, // Red
}

enum AppButtonSize {
  sm, // H: 32
  md, // H: 40
  lg, // H: 48
  xl, // H: 56
}

enum AppButtonShape {
  rounded, // Default radius
  pill, // High radius (24+)
  circle, // Circular (for FAB/Icon)
}

class AppButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final AppButtonShape? shape; // Defaults based on variant/size
  final bool isLoading;
  final bool isEnabled;
  final double? width;
  final double? height;
  final bool expand; // If true, width = infinity

  // Style Overrides
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;

  const AppButton({
    super.key,
    this.text,
    this.onPressed,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.md,
    this.shape,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.height,
    this.expand = false,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = _getBackgroundColor();
    final fgColor = _getForegroundColor();
    final brdColor = _getBorderColor();
    final buttonHeight = height ?? _getHeight();
    final buttonWidth = expand ? double.infinity : width;
    final padding = _getPadding();
    final borderRadius = _getBorderRadius(buttonHeight);
    final boxShape =
        (shape == AppButtonShape.circle) ? BoxShape.circle : BoxShape.rectangle;

    return Opacity(
      opacity: isEnabled ? 1.0 : 0.5,
      child: Container(
        width: buttonWidth,
        height: buttonHeight,
        decoration: BoxDecoration(
          color: isEnabled ? bgColor : AppColors.gray800,
          shape: boxShape,
          borderRadius: boxShape == BoxShape.circle ? null : borderRadius,
          border: brdColor != null
              ? Border.all(
                  color: isEnabled ? brdColor : AppColors.gray600, width: 2)
              : null,
          boxShadow: _getShadow(bgColor),
        ),
        child: Material(
          color: Colors.transparent,
          clipBehavior: Clip.antiAlias, // Important for ripples
          borderRadius: boxShape == BoxShape.circle ? null : borderRadius,
          type: boxShape == BoxShape.circle
              ? MaterialType.circle
              : MaterialType.canvas,
          child: InkWell(
            onTap: isEnabled && !isLoading ? onPressed : null,
            borderRadius: boxShape == BoxShape.circle ? null : borderRadius,
            customBorder:
                boxShape == BoxShape.circle ? const CircleBorder() : null,
            child: Container(
              // Ensure content is centered and sized correctly
              padding: (text == null) ? EdgeInsets.zero : padding,
              alignment: Alignment.center,
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

    final children = <Widget>[];

    if (icon != null) {
      children.add(IconTheme(
        data: IconThemeData(
          color: color,
          size: _getIconSize(),
        ),
        child: icon!,
      ));
    }

    if (text != null) {
      if (children.isNotEmpty) {
        children.add(const SizedBox(width: AppSpacing.sm));
      }
      children.add(Text(
        text!,
        style: AppTypography.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          decoration: variant == AppButtonVariant.ghost &&
                  text != null &&
                  _isLinkStyle()
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

  bool _isLinkStyle() => false; // Helper hook if we add Link variant later

  Color _getBackgroundColor() {
    if (backgroundColor != null) return backgroundColor!;
    switch (variant) {
      case AppButtonVariant.primary:
        return AppColors.forgeFire;
      case AppButtonVariant.secondary: // Was Outline
        return Colors.transparent;
      case AppButtonVariant.tertiary: // Was Secondary
        return AppColors.surfaceLight;
      case AppButtonVariant.ghost:
        return Colors.transparent;
      case AppButtonVariant.destructive:
        return AppColors.passionRed;
    }
  }

  Color _getForegroundColor() {
    if (textColor != null) return textColor!;
    switch (variant) {
      case AppButtonVariant.primary:
      case AppButtonVariant.destructive:
        return AppColors.textMain;
      case AppButtonVariant.secondary:
        return AppColors.electricBlue;
      case AppButtonVariant.tertiary:
        return AppColors.textMain;
      case AppButtonVariant.ghost:
        return AppColors.electricBlue;
    }
  }

  Color? _getBorderColor() {
    if (borderColor != null) return borderColor!;
    if (variant == AppButtonVariant.secondary) return AppColors.electricBlue;
    return null;
  }

  double _getHeight() {
    if (height != null) return height!;
    switch (size) {
      case AppButtonSize.sm:
        return 32.0;
      case AppButtonSize.md:
        return 40.0;
      case AppButtonSize.lg:
        return 48.0;
      case AppButtonSize.xl:
        return 56.0;
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.sm:
        return 16;
      case AppButtonSize.md:
        return 18;
      case AppButtonSize.lg:
        return 20;
      case AppButtonSize.xl:
        return 24;
    }
  }

  EdgeInsets _getPadding() {
    if (text == null) return EdgeInsets.zero; // Icon only
    switch (size) {
      case AppButtonSize.sm:
        return const EdgeInsets.symmetric(horizontal: AppSpacing.md);
      case AppButtonSize.md:
        return const EdgeInsets.symmetric(horizontal: AppSpacing.lg);
      case AppButtonSize.lg:
        return const EdgeInsets.symmetric(horizontal: AppSpacing.lg);
      case AppButtonSize.xl:
        return const EdgeInsets.symmetric(horizontal: AppSpacing.xxl);
    }
  }

  BorderRadius _getBorderRadius(double height) {
    if (shape != null) {
      if (shape == AppButtonShape.pill)
        return BorderRadius.circular(height / 2);
      if (shape == AppButtonShape.rounded)
        return BorderRadius.circular(12); // Default rounded
      // Circle is handled in decoration
    }
    // Defaults
    if (variant == AppButtonVariant.primary)
      return BorderRadius.circular(24); // Matches PrimaryButton
    if (variant == AppButtonVariant.secondary)
      return BorderRadius.circular(12); // Matches SecondaryButton
    return BorderRadius.circular(12);
  }

  List<BoxShadow>? _getShadow(Color bgColor) {
    if (variant == AppButtonVariant.primary && isEnabled && !isLoading) {
      return [
        BoxShadow(
          color: bgColor.withOpacity(0.3),
          blurRadius: 15,
          offset: const Offset(0, 4),
        )
      ];
    }
    return null;
  }
}
