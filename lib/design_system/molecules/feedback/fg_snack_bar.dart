import 'package:flutter/material.dart';

import '../../theme/forge_theme_extensions.dart';
import '../../tokens/app_border_radius.dart';
import '../../tokens/app_sizes.dart';
import '../../tokens/app_spacing.dart';

enum FgSnackBarTone { success, info, warning, error }

/// Builds a floating snackbar from semantic theme roles.
abstract final class FgSnackBar {
  static SnackBar build(
    BuildContext context, {
    required String text,
    required FgSnackBarTone tone,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final forgeColors = theme.forgeColors;
    final (background, foreground, icon) = switch (tone) {
      FgSnackBarTone.success => (
          forgeColors.success,
          forgeColors.onSuccess,
          Icons.check_rounded,
        ),
      FgSnackBarTone.info => (
          scheme.secondary,
          scheme.onSecondary,
          Icons.info_outline_rounded,
        ),
      FgSnackBarTone.warning => (
          forgeColors.warning,
          forgeColors.onWarning,
          Icons.warning_amber_rounded,
        ),
      FgSnackBarTone.error => (
          scheme.error,
          scheme.onError,
          Icons.close_rounded,
        ),
    };

    return SnackBar(
      content: Row(
        children: [
          ExcludeSemantics(
            child: Icon(icon, size: AppSizes.iconLg, color: foreground),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(color: foreground),
            ),
          ),
        ],
      ),
      action: actionLabel == null || onAction == null
          ? null
          : SnackBarAction(
              label: actionLabel,
              textColor: foreground,
              onPressed: onAction,
            ),
      backgroundColor: background,
      margin: const EdgeInsets.only(
        left: AppSpacing.xl,
        right: AppSpacing.xl,
        bottom: AppSpacing.xxxl,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
        horizontal: AppSpacing.lg,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: AppBorderRadius.medium,
      ),
      behavior: SnackBarBehavior.floating,
    );
  }
}
