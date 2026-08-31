import 'package:flutter/material.dart';

import '../../theme/forge_theme_extensions.dart';
import '../../tokens/app_border_radius.dart';
import '../../tokens/app_sizes.dart';
import '../../tokens/app_spacing.dart';
import '../../tokens/app_typography.dart';

enum FgButtonVariant { primary, secondary, tertiary, ghost, destructive }

enum FgButtonSize { sm, md, lg, xl }

enum FgButtonShape { rounded, pill, circle }

/// Forge action primitive backed by Material button behavior.
///
/// Visual decisions are expressed through semantic variants and sizes.
/// Keyboard, focus, hover, pointer, and disabled behavior stay inside the
/// standard Material button implementation.
class FgButton extends StatelessWidget {
  const FgButton({
    super.key,
    this.text,
    this.onPressed,
    this.icon,
    this.variant = FgButtonVariant.primary,
    this.size = FgButtonSize.md,
    this.shape,
    this.isLoading = false,
    this.isEnabled = true,
    this.expand = false,
    this.semanticLabel,
    this.focusNode,
    this.autofocus = false,
  }) : assert(
         text != null || icon != null,
         'FgButton requires text or an icon.',
       ),
       assert(
         text != null || semanticLabel != null,
         'Icon-only FgButton requires a semanticLabel.',
       );

  final String? text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final FgButtonVariant variant;
  final FgButtonSize size;
  final FgButtonShape? shape;
  final bool isLoading;
  final bool isEnabled;
  final bool expand;
  final String? semanticLabel;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final motion = context.forgeMotion;
    final emphasis = theme.forgeEmphasis;
    final isInteractive = isEnabled && onPressed != null && !isLoading;
    final effectiveShape =
        shape ?? (text == null ? FgButtonShape.circle : _defaultShape);
    final buttonShape = _shapeFor(effectiveShape);
    final foreground = _foregroundColor(scheme);

    final button = FilledButton(
      focusNode: focusNode,
      autofocus: autofocus,
      onPressed: isInteractive ? onPressed : null,
      style: ButtonStyle(
        minimumSize: WidgetStatePropertyAll(
          Size(
            effectiveShape == FgButtonShape.circle
                ? _targetHeight
                : AppSizes.comfortableTouchTarget,
            _targetHeight,
          ),
        ),
        fixedSize: effectiveShape == FgButtonShape.circle
            ? WidgetStatePropertyAll(Size.square(_targetHeight))
            : null,
        padding: WidgetStatePropertyAll(
          text == null ? EdgeInsets.zero : _padding,
        ),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled) && !isLoading) {
            return scheme.onSurface.withValues(alpha: 0.12);
          }
          return _backgroundColor(scheme);
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled) && !isLoading) {
            return scheme.onSurface.withValues(alpha: 0.38);
          }
          return foreground;
        }),
        overlayColor: WidgetStatePropertyAll(
          foreground.withValues(alpha: 0.10),
        ),
        side: WidgetStateProperty.resolveWith((states) {
          if (variant != FgButtonVariant.secondary) return BorderSide.none;
          if (states.contains(WidgetState.disabled) && !isLoading) {
            return BorderSide(color: scheme.onSurface.withValues(alpha: 0.12));
          }
          return BorderSide(color: scheme.outline);
        }),
        shape: WidgetStatePropertyAll(buttonShape),
        textStyle: WidgetStatePropertyAll(_textStyle),
        elevation: const WidgetStatePropertyAll(0),
        animationDuration: motion.fast,
        tapTargetSize: MaterialTapTargetSize.padded,
        visualDensity: VisualDensity.standard,
      ),
      child: _content(foreground),
    );

    final decoratedButton = DecoratedBox(
      decoration: BoxDecoration(
        shape: effectiveShape == FgButtonShape.circle
            ? BoxShape.circle
            : BoxShape.rectangle,
        borderRadius: effectiveShape == FgButtonShape.circle
            ? null
            : _borderRadius(effectiveShape),
        boxShadow: isInteractive && variant == FgButtonVariant.primary
            ? emphasis.primaryAction
            : const [],
      ),
      child: button,
    );

    return Semantics(
      button: true,
      enabled: isInteractive,
      label: semanticLabel ?? text,
      liveRegion: isLoading,
      onTap: isInteractive ? onPressed : null,
      child: ExcludeSemantics(
        child: expand
            ? SizedBox(width: double.infinity, child: decoratedButton)
            : decoratedButton,
      ),
    );
  }

  Widget _content(Color color) {
    if (isLoading) {
      return SizedBox.square(
        dimension: _iconSize,
        child: CircularProgressIndicator(strokeWidth: 2, color: color),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null)
          IconTheme(
            data: IconThemeData(color: color, size: _iconSize),
            child: icon!,
          ),
        if (icon != null && text != null) const SizedBox(width: AppSpacing.sm),
        if (text != null)
          Flexible(
            child: Text(
              text!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _textStyle.copyWith(color: color),
            ),
          ),
      ],
    );
  }

  FgButtonShape get _defaultShape => variant == FgButtonVariant.primary
      ? FgButtonShape.pill
      : FgButtonShape.rounded;

  Color _backgroundColor(ColorScheme scheme) {
    return switch (variant) {
      FgButtonVariant.primary => scheme.primary,
      FgButtonVariant.secondary => Colors.transparent,
      FgButtonVariant.tertiary => scheme.surfaceContainerHighest,
      FgButtonVariant.ghost => Colors.transparent,
      FgButtonVariant.destructive => scheme.error,
    };
  }

  Color _foregroundColor(ColorScheme scheme) {
    return switch (variant) {
      FgButtonVariant.primary => scheme.onPrimary,
      FgButtonVariant.secondary => scheme.onSurface,
      FgButtonVariant.tertiary => scheme.onSurface,
      FgButtonVariant.ghost => scheme.onSurfaceVariant,
      FgButtonVariant.destructive => scheme.onError,
    };
  }

  double get _targetHeight => switch (size) {
    FgButtonSize.sm ||
    FgButtonSize.md ||
    FgButtonSize.lg => AppSizes.comfortableTouchTarget,
    FgButtonSize.xl => AppSizes.buttonXl,
  };

  double get _iconSize => switch (size) {
    FgButtonSize.sm => AppSizes.iconSm,
    FgButtonSize.md || FgButtonSize.lg => AppSizes.iconMd,
    FgButtonSize.xl => AppSizes.iconLg,
  };

  TextStyle get _textStyle => switch (size) {
    FgButtonSize.sm => AppTypography.caption.copyWith(
      fontWeight: FontWeight.w700,
    ),
    FgButtonSize.md => AppTypography.bodySmall.copyWith(
      fontWeight: FontWeight.w700,
    ),
    FgButtonSize.lg => AppTypography.body.copyWith(fontWeight: FontWeight.w700),
    FgButtonSize.xl => AppTypography.bodyLarge.copyWith(
      fontWeight: FontWeight.w700,
    ),
  };

  EdgeInsets get _padding => switch (size) {
    FgButtonSize.sm => const EdgeInsets.symmetric(horizontal: AppSpacing.md),
    FgButtonSize.md ||
    FgButtonSize.lg => const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
    FgButtonSize.xl => const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
  };

  OutlinedBorder _shapeFor(FgButtonShape value) {
    return switch (value) {
      FgButtonShape.circle => const CircleBorder(),
      FgButtonShape.rounded || FgButtonShape.pill => RoundedRectangleBorder(
        borderRadius: _borderRadius(value),
      ),
    };
  }

  BorderRadius _borderRadius(FgButtonShape value) {
    return switch (value) {
      FgButtonShape.rounded => AppBorderRadius.large,
      FgButtonShape.pill || FgButtonShape.circle => AppBorderRadius.pill,
    };
  }
}
