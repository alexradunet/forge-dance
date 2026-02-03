import 'dart:ui';
import 'package:flutter/material.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_shadows.dart';

enum FgIconButtonVariant {
  primary,
  secondary,
  glass,
  ghost,
}

enum FgIconButtonSize {
  sm, // 32px
  md, // 40px
  lg, // 48px
  xl, // 56px
}

/// A standard icon-only button used throughout the application.
///
/// Variants:
/// - [primary]: Solid Forge Fire color.
/// - [secondary]: Solid Electric Blue color.
/// - [glass]: Frosted glass effect (for overlays).
/// - [ghost]: Transparent background (for minimal actions).
class FgIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final FgIconButtonVariant variant;
  final FgIconButtonSize size;
  final Color? color; // Custom override for icon color
  final bool isLoading;
  final bool isEnabled;

  const FgIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.variant = FgIconButtonVariant.glass,
    this.size = FgIconButtonSize.md,
    this.color,
    this.isLoading = false,
    this.isEnabled = true,
  });

  /// Factory for a standard "Back" button
  factory FgIconButton.back({
    VoidCallback? onPressed,
    FgIconButtonVariant variant = FgIconButtonVariant.glass,
    Color? color,
  }) {
    return FgIconButton(
      icon: Icons.arrow_back_ios_new,
      onPressed: onPressed,
      variant: variant,
      size: FgIconButtonSize.md,
      color: color,
    );
  }

  /// Factory for a standard "Close" button
  factory FgIconButton.close({
    VoidCallback? onPressed,
    FgIconButtonVariant variant = FgIconButtonVariant.glass,
    Color? color,
  }) {
    return FgIconButton(
      icon: Icons.close,
      onPressed: onPressed,
      variant: variant,
      size: FgIconButtonSize.md,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget buttonContent = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: _dimesnion,
      height: _dimesnion,
      decoration: _decoration,
      child: isLoading
          ? const Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              ),
            )
          : Icon(
              icon,
              size: _iconSize,
              color: _iconColor,
            ),
    );

    if (variant == FgIconButtonVariant.glass) {
      buttonContent = ClipRRect(
        borderRadius: BorderRadius.circular(_dimesnion / 2),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: buttonContent,
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isEnabled && !isLoading ? onPressed : null,
        borderRadius: BorderRadius.circular(_dimesnion / 2),
        child: buttonContent,
      ),
    );
  }

  double get _dimesnion {
    switch (size) {
      case FgIconButtonSize.sm:
        return 32;
      case FgIconButtonSize.md:
        return 40;
      case FgIconButtonSize.lg:
        return 48;
      case FgIconButtonSize.xl:
        return 56;
    }
  }

  double get _iconSize {
    switch (size) {
      case FgIconButtonSize.sm:
        return 16;
      case FgIconButtonSize.md:
        return 20;
      case FgIconButtonSize.lg:
        return 24;
      case FgIconButtonSize.xl:
        return 28;
    }
  }

  BoxDecoration? get _decoration {
    if (variant == FgIconButtonVariant.ghost) return null;

    final base = BoxDecoration(
      shape: BoxShape.circle,
      boxShadow: isEnabled ? [AppShadows.shadowSm] : null,
    );

    if (!isEnabled) {
      return base.copyWith(color: AppColors.gray800);
    }

    switch (variant) {
      case FgIconButtonVariant.primary:
        return base.copyWith(
          color: AppColors.forgeFire,
          boxShadow: [AppShadows.glowPrimary],
        );
      case FgIconButtonVariant.secondary:
        return base.copyWith(
          color: AppColors.electricBlue,
          boxShadow: [AppShadows.glowBlue],
        );
      case FgIconButtonVariant.glass:
        return base.copyWith(
          color: AppColors.gray900.withOpacity(0.4),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        );
      case FgIconButtonVariant.ghost:
        return null;
    }
  }

  Color get _iconColor {
    if (color != null) return color!;
    if (!isEnabled) return AppColors.gray500;

    switch (variant) {
      case FgIconButtonVariant.primary:
      case FgIconButtonVariant.secondary:
        return AppColors.textMain;
      case FgIconButtonVariant.glass:
        return AppColors.textMain;
      case FgIconButtonVariant.ghost:
        return AppColors.textMain;
    }
  }
}
