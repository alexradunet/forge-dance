import 'package:flutter/material.dart';

import '../../tokens/app_colors.dart';
import '../../tokens/app_border_radius.dart';
import '../../tokens/app_spacing.dart';
import '../../tokens/app_typography.dart';
import '../../tokens/app_shadows.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final bool hasGlow;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.boxShadow,
    this.hasGlow = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardBorderRadius = borderRadius ?? AppBorderRadius.large;
    final cardBoxShadow = boxShadow ??
        (hasGlow ? [AppShadows.glowPrimary] : [AppShadows.shadowCard]);

    Widget content = Container(
      padding: padding ?? AppSpacing.allLG,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surfaceCard,
        borderRadius: cardBorderRadius,
        border: border ?? Border.all(color: AppColors.neutral800, width: 1),
        boxShadow: cardBoxShadow,
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: cardBorderRadius,
          child: content,
        ),
      );
    }

    return content;
  }
}

class AppCardHeader extends StatelessWidget {
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;

  const AppCardHeader({
    super.key,
    this.title,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null) ...[
                  DefaultTextStyle(
                    style: AppTypography.h4.copyWith(color: AppColors.textMain),
                    child: title!,
                  ),
                ],
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  DefaultTextStyle(
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.textMuted),
                    child: subtitle!,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class AppCardContent extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const AppCardContent({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: child,
    );
  }
}

class AppCardFooter extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const AppCardFooter({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(top: AppSpacing.lg),
      child: child,
    );
  }
}
