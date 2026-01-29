import 'package:flutter/material.dart';

import '../../tokens/app_colors.dart';
import '../../tokens/app_typography.dart';
import '../../tokens/app_shadows.dart';

/// Centered Alert Modal with icon and actions
/// Based on HTML mockup: forge.dance_home_dashboard_15 (03. Centered Alert Modal)
class ForgeAlertDialog extends StatelessWidget {
  final String title;
  final String? message;
  final IconData? icon;
  final Color? iconColor;
  final String primaryActionLabel;
  final VoidCallback? onPrimaryAction;
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;
  final bool isPrimaryDestructive;

  const ForgeAlertDialog({
    super.key,
    required this.title,
    this.message,
    this.icon,
    this.iconColor,
    required this.primaryActionLabel,
    this.onPrimaryAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
    this.isPrimaryDestructive = false,
  });

  /// Show the alert dialog
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    String? message,
    IconData? icon,
    Color? iconColor,
    required String primaryActionLabel,
    VoidCallback? onPrimaryAction,
    String? secondaryActionLabel,
    VoidCallback? onSecondaryAction,
    bool isPrimaryDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (context) => Center(
        child: ForgeAlertDialog(
          title: title,
          message: message,
          icon: icon,
          iconColor: iconColor,
          primaryActionLabel: primaryActionLabel,
          onPrimaryAction: onPrimaryAction,
          secondaryActionLabel: secondaryActionLabel,
          onSecondaryAction: onSecondaryAction,
          isPrimaryDestructive: isPrimaryDestructive,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? AppColors.forgeFire;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: 288,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF161616),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.crystalWhite.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: const [AppShadows.shadowXl],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            if (icon != null)
              Container(
                width: 56,
                height: 56,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: effectiveIconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: effectiveIconColor.withOpacity(0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: effectiveIconColor.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: effectiveIconColor,
                  size: 28,
                ),
              ),

            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.h3.copyWith(
                color: AppColors.crystalWhite,
              ),
            ),

            // Message
            if (message != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                    height: 1.5,
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // Primary action
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop(true);
                onPrimaryAction?.call();
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isPrimaryDestructive
                      ? AppColors.forgeFire
                      : AppColors.forgeFire,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.forgeFire.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Text(
                  primaryActionLabel,
                  textAlign: TextAlign.center,
                  style: AppTypography.body.copyWith(
                    color: AppColors.crystalWhite,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            // Secondary action
            if (secondaryActionLabel != null)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(false);
                  onSecondaryAction?.call();
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  margin: const EdgeInsets.only(top: 12),
                  child: Text(
                    secondaryActionLabel!,
                    textAlign: TextAlign.center,
                    style: AppTypography.body.copyWith(
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
