import 'dart:ui';

import 'package:flutter/material.dart';

import '../../theme/forge_theme_extensions.dart';
import '../../tokens/app_sizes.dart';

enum FgIconButtonVariant { primary, secondary, glass, ghost }

enum FgIconButtonSize { sm, md, lg, xl }

/// Icon-only action with a semantic label and a minimum 48px target.
///
/// [size] controls the visual circle. The interactive target remains at least
/// [AppSizes.comfortableTouchTarget] for pointer, keyboard, and assistive input.
class FgIconButton extends StatelessWidget {
  const FgIconButton({
    super.key,
    required this.icon,
    required this.semanticLabel,
    this.onPressed,
    this.variant = FgIconButtonVariant.glass,
    this.size = FgIconButtonSize.md,
    this.isSelected = false,
    this.isLoading = false,
    this.isEnabled = true,
    this.focusNode,
    this.autofocus = false,
  });

  final IconData icon;
  final String semanticLabel;
  final VoidCallback? onPressed;
  final FgIconButtonVariant variant;
  final FgIconButtonSize size;
  final bool isSelected;
  final bool isLoading;
  final bool isEnabled;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final emphasis = Theme.of(context).forgeEmphasis;
    final motion = context.forgeMotion;
    final isInteractive = isEnabled && !isLoading && onPressed != null;
    final targetDimension = _targetDimension;
    final visualDimension = _visualDimension;
    final foreground = _foregroundColor(context, scheme, isInteractive);

    Widget visual = AnimatedContainer(
      duration: motion.fast,
      curve: motion.enterCurve,
      width: visualDimension,
      height: visualDimension,
      decoration: _decoration(
        context,
        scheme,
        emphasis,
        isInteractive: isInteractive,
      ),
      alignment: Alignment.center,
      child: isLoading
          ? SizedBox.square(
              dimension: _iconSize,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: foreground,
              ),
            )
          : Icon(icon, size: _iconSize, color: foreground),
    );

    if (variant == FgIconButtonVariant.glass && emphasis.glassBlurSigma > 0) {
      visual = ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: emphasis.glassBlurSigma,
            sigmaY: emphasis.glassBlurSigma,
          ),
          child: visual,
        ),
      );
    }

    return Semantics(
      button: true,
      enabled: isInteractive,
      selected: isSelected,
      label: semanticLabel,
      liveRegion: isLoading,
      onTap: isInteractive ? onPressed : null,
      child: ExcludeSemantics(
        child: Tooltip(
          message: semanticLabel,
          child: SizedBox.square(
            dimension: targetDimension,
            child: IconButton(
              focusNode: focusNode,
              autofocus: autofocus,
              onPressed: isInteractive ? onPressed : null,
              padding: EdgeInsets.all((targetDimension - visualDimension) / 2),
              constraints: BoxConstraints.tightFor(
                width: targetDimension,
                height: targetDimension,
              ),
              style: IconButton.styleFrom(
                minimumSize: Size.square(targetDimension),
                tapTargetSize: MaterialTapTargetSize.padded,
                shape: const CircleBorder(),
              ),
              icon: visual,
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _decoration(
    BuildContext context,
    ColorScheme scheme,
    ForgeEmphasis emphasis, {
    required bool isInteractive,
  }) {
    if (!isInteractive && !isLoading) {
      return BoxDecoration(
        shape: BoxShape.circle,
        color: context.forgeForeground.withValues(alpha: 0.12),
      );
    }

    return switch (variant) {
      FgIconButtonVariant.primary => BoxDecoration(
        shape: BoxShape.circle,
        color: scheme.primary,
        boxShadow: emphasis.primaryAction,
      ),
      FgIconButtonVariant.secondary => BoxDecoration(
        shape: BoxShape.circle,
        color: scheme.secondary,
        boxShadow: emphasis.raised,
      ),
      FgIconButtonVariant.glass => BoxDecoration(
        shape: BoxShape.circle,
        color: emphasis.glassFill,
        border: Border.all(color: emphasis.glassBorder),
        boxShadow: emphasis.raised,
      ),
      FgIconButtonVariant.ghost => const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
      ),
    };
  }

  Color _foregroundColor(
    BuildContext context,
    ColorScheme scheme,
    bool isInteractive,
  ) {
    if (!isInteractive && !isLoading) {
      return context.forgeForeground.withValues(alpha: 0.38);
    }
    if (isSelected &&
        (variant == FgIconButtonVariant.glass ||
            variant == FgIconButtonVariant.ghost)) {
      return scheme.primary;
    }

    return switch (variant) {
      FgIconButtonVariant.primary => scheme.onPrimary,
      FgIconButtonVariant.secondary => scheme.onSecondary,
      FgIconButtonVariant.glass => context.forgeForeground,
      FgIconButtonVariant.ghost => context.forgeMutedForeground,
    };
  }

  double get _targetDimension =>
      _visualDimension < AppSizes.comfortableTouchTarget
      ? AppSizes.comfortableTouchTarget
      : _visualDimension;

  double get _visualDimension => switch (size) {
    FgIconButtonSize.sm => AppSizes.iconXl,
    FgIconButtonSize.md => AppSizes.avatarMd,
    FgIconButtonSize.lg => AppSizes.comfortableTouchTarget,
    FgIconButtonSize.xl => AppSizes.fabSizeSm,
  };

  double get _iconSize => switch (size) {
    FgIconButtonSize.sm => AppSizes.iconSm,
    FgIconButtonSize.md => AppSizes.iconMd,
    FgIconButtonSize.lg => AppSizes.iconLg,
    FgIconButtonSize.xl => AppSizes.iconXl,
  };
}
