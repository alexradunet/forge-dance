import 'package:flutter/material.dart';

import '../../theme/forge_theme_extensions.dart';
import '../../tokens/app_sizes.dart';
import '../../tokens/app_spacing.dart';
import '../../tokens/app_typography.dart';

/// Compact editorial header. Slots participate in layout rather than
/// overlapping the title, including at larger accessibility text sizes.
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.leftSlot,
    this.rightSlot,
    this.isTransparent = true,
    this.onBack,
    this.compact = false,
  });

  final String title;
  final String? subtitle;
  final Widget? leftSlot;
  final Widget? rightSlot;
  final bool isTransparent;
  final VoidCallback? onBack;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).forgeColors;
    return ColoredBox(
      color: isTransparent ? Colors.transparent : colors.immersiveBackground,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.lg,
          ),
          child: Row(
            children: [
              if (onBack != null) ...[
                BackButton(color: colors.onImmersive, onPressed: onBack),
                const SizedBox(width: AppSpacing.sm),
              ],
              if (leftSlot != null) ...[
                leftSlot!,
                const SizedBox(width: AppSpacing.md),
              ],
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.toUpperCase(),
                      maxLines: compact ? 2 : null,
                      overflow: compact ? TextOverflow.ellipsis : null,
                      style: (compact ? AppTypography.h4 : AppTypography.h2)
                          .copyWith(color: colors.onImmersive),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        subtitle!,
                        maxLines: compact ? 1 : null,
                        overflow: compact ? TextOverflow.ellipsis : null,
                        style: AppTypography.bodySmall.copyWith(
                          color: colors.onImmersiveMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (rightSlot != null) ...[
                const SizedBox(width: AppSpacing.md),
                rightSlot!,
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(AppSizes.appBarHeight + AppSpacing.lg);
}
