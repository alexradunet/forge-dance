import 'package:flutter/material.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_border_radius.dart';
import '../../tokens/app_shadows.dart';

enum FgCardVariant {
  opaque, // Flat, solid background (surfaceCard)
  outlined, // Border only, transparent bg
  elevated, // Subtle shadow, solid bg
}

/// A surface atom used to contain related content.
class FgCard extends StatelessWidget {
  final Widget child;
  final FgCardVariant variant;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? color;

  const FgCard({
    super.key,
    required this.child,
    this.variant = FgCardVariant.opaque,
    this.padding,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppBorderRadius.defaultRadius,
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          decoration: _decoration,
          child: child,
        ),
      ),
    );
  }

  BoxDecoration get _decoration {
    final baseColor = color ?? AppColors.surfaceCard;

    switch (variant) {
      case FgCardVariant.opaque:
        return BoxDecoration(
          color: baseColor,
          borderRadius: AppBorderRadius.defaultRadius,
        );
      case FgCardVariant.outlined:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: AppBorderRadius.defaultRadius,
          border: Border.all(color: AppColors.gray700),
        );
      case FgCardVariant.elevated:
        return BoxDecoration(
          color: baseColor,
          borderRadius: AppBorderRadius.defaultRadius,
          boxShadow: [AppShadows.shadowMd],
        );
    }
  }
}
