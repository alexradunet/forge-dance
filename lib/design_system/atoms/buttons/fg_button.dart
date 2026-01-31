import 'package:flutter/material.dart';

// import '../../../../design_system/tokens/app_border_radius.dart'; // Unused
import '../../../../design_system/tokens/app_colors.dart';
import '../../../../design_system/tokens/app_spacing.dart';
import '../../../../design_system/tokens/app_typography.dart';
// import '../../../../design_system/tokens/app_shadows.dart'; // Unused

enum FgButtonVariant {
  primary, // ForgeFire, Shadow
  secondary, // Outline ElectricBlue
  tertiary, // SurfaceLight (Filled)
  ghost, // Transparent, Text only
  destructive, // Red
}

enum FgButtonSize {
  sm, // H: 32
  md, // H: 40
  lg, // H: 48
  xl, // H: 56
}

enum FgButtonShape {
  rounded, // Default radius
  pill, // High radius (24+)
  circle, // Circular (for FAB/Icon)
}

class FgButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final FgButtonVariant variant;
  final FgButtonSize size;
  final FgButtonShape? shape; // Defaults based on variant/size
  final bool isLoading;
  final bool isEnabled;
  final double? width;
  final double? height;
  final bool expand; // If true, width = infinity

  // Style Overrides
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;

  const FgButton({
    super.key,
    this.text,
    this.onPressed,
    this.icon,
    this.variant = FgButtonVariant.primary,
    this.size = FgButtonSize.md,
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
        (shape == FgButtonShape.circle) ? BoxShape.circle : BoxShape.rectangle;

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
          decoration: variant == FgButtonVariant.ghost &&
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
      case FgButtonVariant.primary:
        return AppColors.forgeFire;
      case FgButtonVariant.secondary: // Was Outline
        return Colors.transparent;
      case FgButtonVariant.tertiary: // Was Secondary
        return AppColors.surfaceLight;
      case FgButtonVariant.ghost:
        return Colors.transparent;
      case FgButtonVariant.destructive:
        return AppColors.passionRed;
    }
  }

  Color _getForegroundColor() {
    if (textColor != null) return textColor!;
    switch (variant) {
      case FgButtonVariant.primary:
      case FgButtonVariant.destructive:
        return AppColors.textMain;
      case FgButtonVariant.secondary:
        return AppColors.electricBlue;
      case FgButtonVariant.tertiary:
        return AppColors.textMain;
      case FgButtonVariant.ghost:
        return AppColors.electricBlue;
    }
  }

  Color? _getBorderColor() {
    if (borderColor != null) return borderColor!;
    if (variant == FgButtonVariant.secondary) return AppColors.electricBlue;
    return null;
  }

  double _getHeight() {
    if (height != null) return height!;
    switch (size) {
      case FgButtonSize.sm:
        return 32.0;
      case FgButtonSize.md:
        return 40.0;
      case FgButtonSize.lg:
        return 48.0;
      case FgButtonSize.xl:
        return 56.0;
    }
  }

  double _getIconSize() {
    switch (size) {
      case FgButtonSize.sm:
        return 16;
      case FgButtonSize.md:
        return 18;
      case FgButtonSize.lg:
        return 20;
      case FgButtonSize.xl:
        return 24;
    }
  }

  EdgeInsets _getPadding() {
    if (text == null) return EdgeInsets.zero; // Icon only
    switch (size) {
      case FgButtonSize.sm:
        return const EdgeInsets.symmetric(horizontal: AppSpacing.md);
      case FgButtonSize.md:
        return const EdgeInsets.symmetric(horizontal: AppSpacing.lg);
      case FgButtonSize.lg:
        return const EdgeInsets.symmetric(horizontal: AppSpacing.lg);
      case FgButtonSize.xl:
        return const EdgeInsets.symmetric(horizontal: AppSpacing.xxl);
    }
  }

  BorderRadius _getBorderRadius(double height) {
    if (shape != null) {
      if (shape == FgButtonShape.pill)
        return BorderRadius.circular(height / 2);
      if (shape == FgButtonShape.rounded)
        return BorderRadius.circular(12); // Default rounded
      // Circle is handled in decoration
    }
    // Defaults
    if (variant == FgButtonVariant.primary)
      return BorderRadius.circular(24); // Matches PrimaryButton
    if (variant == FgButtonVariant.secondary)
      return BorderRadius.circular(12); // Matches SecondaryButton
    return BorderRadius.circular(12);
  }

  List<BoxShadow>? _getShadow(Color bgColor) {
    if (variant == FgButtonVariant.primary && isEnabled && !isLoading) {
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
