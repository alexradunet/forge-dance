import 'package:flutter/material.dart';

import '../../tokens/app_colors.dart';
import '../../tokens/app_typography.dart';
import '../../tokens/app_border_radius.dart';
import '../../tokens/app_shadows.dart';

/// Bottom Sheet modal with filters and toggles
/// Based on HTML mockup: forge.dance_home_dashboard_15 (01. Standard Bottom Sheet)
class ForgeBottomSheet extends StatelessWidget {
  final String title;
  final Widget child;
  final String? resetLabel;
  final VoidCallback? onReset;
  final String? actionLabel;
  final VoidCallback? onAction;

  const ForgeBottomSheet({
    super.key,
    required this.title,
    required this.child,
    this.resetLabel,
    this.onReset,
    this.actionLabel,
    this.onAction,
  });

  /// Show the bottom sheet as a modal
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget child,
    String? resetLabel,
    VoidCallback? onReset,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ForgeBottomSheet(
        title: title,
        resetLabel: resetLabel,
        onReset: onReset,
        actionLabel: actionLabel,
        onAction: onAction,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border(
          top: BorderSide(
            color: AppColors.crystalWhite.withOpacity(0.1),
            width: 1,
          ),
        ),
        boxShadow: const [AppShadows.shadowXl],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.crystalWhite.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: AppTypography.h3.copyWith(
                    color: AppColors.crystalWhite,
                  ),
                ),
                if (resetLabel != null)
                  GestureDetector(
                    onTap: onReset,
                    child: Text(
                      resetLabel!.toUpperCase(),
                      style: AppTypography.overline.copyWith(
                        color: AppColors.forgeFire,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: child,
          ),

          // Action button
          if (actionLabel != null)
            Padding(
              padding: const EdgeInsets.all(24),
              child: GestureDetector(
                onTap: onAction ?? () => Navigator.of(context).pop(),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.crystalWhite,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    actionLabel!,
                    textAlign: TextAlign.center,
                    style: AppTypography.body.copyWith(
                      color: AppColors.bgDeep,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),

          // Safe area padding
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

/// Action Sheet with list of actions
/// Based on HTML mockup: forge.dance_home_dashboard_15 (02. Action Sheet)
class ForgeActionSheet extends StatelessWidget {
  final String? title;
  final List<ForgeActionSheetItem> actions;
  final String cancelLabel;

  const ForgeActionSheet({
    super.key,
    this.title,
    required this.actions,
    this.cancelLabel = 'Cancel',
  });

  /// Show the action sheet
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required List<ForgeActionSheetItem> actions,
    String cancelLabel = 'Cancel',
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ForgeActionSheet(
        title: title,
        actions: actions,
        cancelLabel: cancelLabel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 16 + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Action list
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E).withOpacity(0.8),
              borderRadius: AppBorderRadius.large,
              border: Border.all(
                color: AppColors.crystalWhite.withOpacity(0.05),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // Title
                if (title != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.crystalWhite.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      title!,
                      textAlign: TextAlign.center,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                // Actions
                ...actions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final action = entry.value;
                  final isLast = index == actions.length - 1;

                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      action.onTap?.call();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: isLast
                            ? null
                            : Border(
                                bottom: BorderSide(
                                  color:
                                      AppColors.crystalWhite.withOpacity(0.1),
                                  width: 1,
                                ),
                              ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (action.icon != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Icon(
                                action.icon,
                                color: action.isDestructive
                                    ? AppColors.passionRed
                                    : action.color ?? AppColors.forgeFire,
                                size: 20,
                              ),
                            ),
                          Text(
                            action.label,
                            style: AppTypography.body.copyWith(
                              color: action.isDestructive
                                  ? AppColors.passionRed
                                  : action.color ?? AppColors.forgeFire,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Cancel button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: AppBorderRadius.large,
                border: Border.all(
                  color: AppColors.crystalWhite.withOpacity(0.05),
                  width: 1,
                ),
              ),
              child: Text(
                cancelLabel,
                textAlign: TextAlign.center,
                style: AppTypography.body.copyWith(
                  color: AppColors.crystalWhite,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Action sheet item model
class ForgeActionSheetItem {
  final String label;
  final IconData? icon;
  final Color? color;
  final bool isDestructive;
  final VoidCallback? onTap;

  const ForgeActionSheetItem({
    required this.label,
    this.icon,
    this.color,
    this.isDestructive = false,
    this.onTap,
  });
}
