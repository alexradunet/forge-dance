import 'package:flutter/material.dart';

import '../../theme/forge_theme_extensions.dart';
import '../../tokens/app_border_radius.dart';
import '../../tokens/app_sizes.dart';
import '../../tokens/app_spacing.dart';

enum FgCardVariant { opaque, outlined, elevated }

/// Semantic content surface with optional native pointer and keyboard action.
class FgCard extends StatelessWidget {
  const FgCard({
    super.key,
    required this.child,
    this.variant = FgCardVariant.opaque,
    this.padding = AppSpacing.card,
    this.onTap,
    this.isSelected = false,
    this.isEnabled = true,
    this.semanticLabel,
    this.focusNode,
    this.autofocus = false,
  });

  final Widget child;
  final FgCardVariant variant;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool isEnabled;
  final String? semanticLabel;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final emphasis = theme.forgeEmphasis;
    final effectiveOnTap = isEnabled ? onTap : null;
    final shape = RoundedRectangleBorder(
      borderRadius: AppBorderRadius.defaultRadius,
      side: BorderSide(
        color: isSelected
            ? scheme.primary
            : variant == FgCardVariant.outlined
                ? scheme.outlineVariant
                : Colors.transparent,
        width: isSelected ? 2 : 1,
      ),
    );
    final color = switch (variant) {
      FgCardVariant.opaque => scheme.surfaceContainer,
      FgCardVariant.outlined => scheme.surface,
      FgCardVariant.elevated => scheme.surfaceContainerHigh,
    };

    Widget card = Material(
      color: color,
      shape: shape,
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: InkWell(
        onTap: effectiveOnTap,
        focusNode: focusNode,
        autofocus: autofocus,
        child: Padding(padding: padding, child: child),
      ),
    );

    if (variant == FgCardVariant.elevated && emphasis.raised.isNotEmpty) {
      card = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: AppBorderRadius.defaultRadius,
          boxShadow: emphasis.raised,
        ),
        child: card,
      );
    }

    if (effectiveOnTap != null) {
      card = ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: AppSizes.comfortableTouchTarget,
        ),
        child: card,
      );
    }

    return Semantics(
      label: semanticLabel,
      button: onTap == null ? null : true,
      enabled: onTap == null ? null : effectiveOnTap != null,
      selected: isSelected ? true : null,
      child: card,
    );
  }
}
