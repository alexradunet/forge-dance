import 'package:flutter/material.dart';

import '../../atoms/buttons/fg_button.dart';
import '../../theme/forge_theme_extensions.dart';
import '../../tokens/app_sizes.dart';
import '../../tokens/app_spacing.dart';

enum ForgeAlertTone { primary, destructive, success, reward }

/// Forge-styled alert built on Flutter's semantic Material dialog.
class ForgeAlertDialog extends StatelessWidget {
  const ForgeAlertDialog({
    super.key,
    required this.title,
    required this.primaryActionLabel,
    this.message,
    this.icon,
    this.tone = ForgeAlertTone.primary,
    this.onPrimaryAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
    this.isPrimaryDestructive = false,
  });

  final String title;
  final String? message;
  final IconData? icon;
  final ForgeAlertTone tone;
  final String primaryActionLabel;
  final VoidCallback? onPrimaryAction;
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;
  final bool isPrimaryDestructive;

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String primaryActionLabel,
    String? message,
    IconData? icon,
    ForgeAlertTone tone = ForgeAlertTone.primary,
    VoidCallback? onPrimaryAction,
    String? secondaryActionLabel,
    VoidCallback? onSecondaryAction,
    bool isPrimaryDestructive = false,
    bool barrierDismissible = true,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => ForgeAlertDialog(
        title: title,
        message: message,
        icon: icon,
        tone: tone,
        primaryActionLabel: primaryActionLabel,
        onPrimaryAction: onPrimaryAction,
        secondaryActionLabel: secondaryActionLabel,
        onSecondaryAction: onSecondaryAction,
        isPrimaryDestructive: isPrimaryDestructive,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final forgeColors = theme.forgeColors;
    final accent = switch (tone) {
      ForgeAlertTone.primary => scheme.primary,
      ForgeAlertTone.destructive => scheme.error,
      ForgeAlertTone.success => forgeColors.success,
      ForgeAlertTone.reward => forgeColors.reward,
    };

    return AlertDialog(
      semanticLabel: title,
      icon: icon == null
          ? null
          : ExcludeSemantics(
              child: Container(
                width: AppSizes.buttonXl,
                height: AppSizes.buttonXl,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(color: accent.withValues(alpha: 0.24)),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: accent, size: AppSizes.iconLg),
              ),
            ),
      title: Text(title, textAlign: TextAlign.center),
      content: message == null
          ? null
          : Text(
              message!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FgButton(
                text: primaryActionLabel,
                variant: isPrimaryDestructive
                    ? FgButtonVariant.destructive
                    : FgButtonVariant.primary,
                expand: true,
                onPressed: () {
                  Navigator.of(context).pop(true);
                  onPrimaryAction?.call();
                },
              ),
              if (secondaryActionLabel != null) ...[
                const SizedBox(height: AppSpacing.sm),
                FgButton(
                  text: secondaryActionLabel!,
                  variant: FgButtonVariant.ghost,
                  expand: true,
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    onSecondaryAction?.call();
                  },
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
