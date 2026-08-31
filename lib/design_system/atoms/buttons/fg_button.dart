import 'package:flutter/material.dart';

import '../../tokens/app_border_radius.dart';
import '../../tokens/app_shadows.dart';
import '../../tokens/app_sizes.dart';
import '../../tokens/app_spacing.dart';
import '../../tokens/app_typography.dart';

enum FgButtonVariant { primary, secondary, tertiary, ghost, destructive }

enum FgButtonSize { sm, md, lg, xl }

enum FgButtonShape { rounded, pill, circle }

/// Forge Dance action primitive.
///
/// Visual decisions are expressed through semantic variants and sizes. Raw
/// color and dimension overrides intentionally live outside this contract.
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
  }) : assert(
          text != null || icon != null,
          'FgButton requires text or an icon.',
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isInteractive = isEnabled && onPressed != null && !isLoading;
    final buttonHeight = _height;
    final effectiveShape = shape ??
        (text == null ? FgButtonShape.circle : _defaultShapeFor(variant));
    final isCircle = effectiveShape == FgButtonShape.circle;
    final foreground = _foregroundColor(colorScheme, isInteractive);
    final background = _backgroundColor(colorScheme, isInteractive);
    final border = _borderColor(colorScheme, isInteractive);

    final button = AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOutCubic,
      width: expand ? double.infinity : (isCircle ? buttonHeight : null),
      height: buttonHeight,
      decoration: BoxDecoration(
        color: background,
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle ? null : _borderRadius(effectiveShape),
        border: border == null ? null : Border.all(color: border),
        boxShadow: isInteractive && variant == FgButtonVariant.primary
            ? AppShadows.buttonPrimary
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        shape: isCircle
            ? const CircleBorder()
            : RoundedRectangleBorder(
                borderRadius: _borderRadius(effectiveShape),
              ),
        child: InkWell(
          onTap: isInteractive ? onPressed : null,
          customBorder: isCircle ? const CircleBorder() : null,
          borderRadius: isCircle ? null : _borderRadius(effectiveShape),
          child: Padding(
            padding: text == null ? EdgeInsets.zero : _padding,
            child: Center(child: _content(foreground)),
          ),
        ),
      ),
    );

    return Semantics(
      button: true,
      enabled: isInteractive,
      label: semanticLabel ?? text,
      liveRegion: isLoading,
      child: ExcludeSemantics(
        child: MouseRegion(
          cursor: isInteractive
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          child: button,
        ),
      ),
    );
  }

  Widget _content(Color color) {
    if (isLoading) {
      return SizedBox.square(
        dimension: _iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(color),
        ),
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

  FgButtonShape _defaultShapeFor(FgButtonVariant value) {
    return value == FgButtonVariant.primary
        ? FgButtonShape.pill
        : FgButtonShape.rounded;
  }

  Color _backgroundColor(ColorScheme colors, bool isInteractive) {
    if (!isInteractive && !isLoading) {
      return colors.onSurface.withAlpha(18);
    }

    return switch (variant) {
      FgButtonVariant.primary => colors.primary,
      FgButtonVariant.secondary => Colors.transparent,
      FgButtonVariant.tertiary => colors.surfaceContainerHighest,
      FgButtonVariant.ghost => Colors.transparent,
      FgButtonVariant.destructive => colors.error,
    };
  }

  Color _foregroundColor(ColorScheme colors, bool isInteractive) {
    if (!isInteractive && !isLoading) {
      return colors.onSurface.withAlpha(97);
    }

    return switch (variant) {
      FgButtonVariant.primary => colors.onPrimary,
      FgButtonVariant.secondary => colors.secondary,
      FgButtonVariant.tertiary => colors.onSurface,
      FgButtonVariant.ghost => colors.primary,
      FgButtonVariant.destructive => colors.onError,
    };
  }

  Color? _borderColor(ColorScheme colors, bool isInteractive) {
    if (variant != FgButtonVariant.secondary) return null;
    return isInteractive ? colors.secondary : colors.onSurface.withAlpha(31);
  }

  double get _height => switch (size) {
        FgButtonSize.sm => AppSizes.buttonSm,
        FgButtonSize.md => AppSizes.buttonMd,
        FgButtonSize.lg => AppSizes.buttonLg,
        FgButtonSize.xl => AppSizes.buttonXl,
      };

  double get _iconSize => switch (size) {
        FgButtonSize.sm => AppSizes.iconSm,
        FgButtonSize.md => AppSizes.iconMd,
        FgButtonSize.lg => AppSizes.iconMd,
        FgButtonSize.xl => AppSizes.iconLg,
      };

  TextStyle get _textStyle => switch (size) {
        FgButtonSize.sm => AppTypography.caption.copyWith(
            fontWeight: FontWeight.w700,
          ),
        FgButtonSize.md => AppTypography.bodySmall.copyWith(
            fontWeight: FontWeight.w700,
          ),
        FgButtonSize.lg => AppTypography.body.copyWith(
            fontWeight: FontWeight.w700,
          ),
        FgButtonSize.xl => AppTypography.bodyLarge.copyWith(
            fontWeight: FontWeight.w700,
          ),
      };

  EdgeInsets get _padding => switch (size) {
        FgButtonSize.sm => const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
          ),
        FgButtonSize.md || FgButtonSize.lg => const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
          ),
        FgButtonSize.xl => const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
          ),
      };

  BorderRadius _borderRadius(FgButtonShape value) {
    return switch (value) {
      FgButtonShape.rounded => AppBorderRadius.large,
      FgButtonShape.pill || FgButtonShape.circle => AppBorderRadius.pill,
    };
  }
}
