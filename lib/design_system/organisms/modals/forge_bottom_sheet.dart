import 'package:flutter/material.dart';

import '../../atoms/buttons/fg_button.dart';
import '../../atoms/surfaces/fg_card.dart';
import '../../tokens/app_spacing.dart';

/// Material 3 modal bottom sheet with Forge actions and responsive content.
class ForgeBottomSheet extends StatelessWidget {
  const ForgeBottomSheet({
    super.key,
    required this.title,
    required this.child,
    this.resetLabel,
    this.onReset,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final Widget child;
  final String? resetLabel;
  final VoidCallback? onReset;
  final String? actionLabel;
  final VoidCallback? onAction;

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
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
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

  /// Presents a full-height feature surface without exposing modal styling.
  static Future<T?> showPage<T>({
    required BuildContext context,
    required Widget child,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: false,
      builder: (context) =>
          SizedBox(height: MediaQuery.sizeOf(context).height, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: title,
      container: true,
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.xxl,
            right: AppSpacing.xxl,
            bottom: AppSpacing.xxl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(title, style: theme.textTheme.titleLarge),
                  ),
                  if (resetLabel != null)
                    FgButton(
                      text: resetLabel!,
                      variant: FgButtonVariant.ghost,
                      size: FgButtonSize.sm,
                      onPressed: onReset,
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Flexible(child: SingleChildScrollView(child: child)),
              if (actionLabel != null) ...[
                const SizedBox(height: AppSpacing.xxl),
                FgButton(
                  text: actionLabel!,
                  expand: true,
                  onPressed: onAction ?? () => Navigator.of(context).pop(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class ForgeActionSheet extends StatelessWidget {
  const ForgeActionSheet({
    super.key,
    required this.actions,
    required this.cancelLabel,
    this.title,
  });

  final String? title;
  final List<ForgeActionSheetItem> actions;
  final String cancelLabel;

  static Future<T?> show<T>({
    required BuildContext context,
    required List<ForgeActionSheetItem> actions,
    required String cancelLabel,
    String? title,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) => ForgeActionSheet(
        title: title,
        actions: actions,
        cancelLabel: cancelLabel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          bottom: AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FgCard(
              variant: FgCardVariant.outlined,
              padding: EdgeInsets.zero,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null) ...[
                    Padding(
                      padding: AppSpacing.allMD,
                      child: Text(
                        title!,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                  ],
                  for (var index = 0; index < actions.length; index++) ...[
                    ListTile(
                      onTap: () {
                        Navigator.of(context).pop();
                        actions[index].onTap?.call();
                      },
                      leading: actions[index].icon == null
                          ? null
                          : Icon(
                              actions[index].icon,
                              color: actions[index].isDestructive
                                  ? scheme.error
                                  : scheme.primary,
                            ),
                      title: Text(
                        actions[index].label,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: actions[index].isDestructive
                              ? scheme.error
                              : scheme.onSurface,
                        ),
                      ),
                    ),
                    if (index < actions.length - 1) const Divider(height: 1),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            FgButton(
              text: cancelLabel,
              variant: FgButtonVariant.secondary,
              expand: true,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

@immutable
class ForgeActionSheetItem {
  const ForgeActionSheetItem({
    required this.label,
    this.icon,
    this.isDestructive = false,
    this.onTap,
  });

  final String label;
  final IconData? icon;
  final bool isDestructive;
  final VoidCallback? onTap;
}
