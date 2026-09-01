import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:forge_dance/design_system/tokens/app_animation.dart';

/// Semantic colors that do not map to Material's [ColorScheme] roles.
@immutable
class ForgeColors extends ThemeExtension<ForgeColors> {
  const ForgeColors({
    required this.immersiveBackground,
    required this.immersiveSurface,
    required this.onImmersive,
    required this.onImmersiveMuted,
    required this.success,
    required this.onSuccess,
    required this.warning,
    required this.onWarning,
    required this.reward,
    required this.onReward,
    required this.focusRing,
  });

  final Color immersiveBackground;
  final Color immersiveSurface;
  final Color onImmersive;
  final Color onImmersiveMuted;
  final Color success;
  final Color onSuccess;
  final Color warning;
  final Color onWarning;
  final Color reward;
  final Color onReward;
  final Color focusRing;

  @override
  ForgeColors copyWith({
    Color? immersiveBackground,
    Color? immersiveSurface,
    Color? onImmersive,
    Color? onImmersiveMuted,
    Color? success,
    Color? onSuccess,
    Color? warning,
    Color? onWarning,
    Color? reward,
    Color? onReward,
    Color? focusRing,
  }) {
    return ForgeColors(
      immersiveBackground: immersiveBackground ?? this.immersiveBackground,
      immersiveSurface: immersiveSurface ?? this.immersiveSurface,
      onImmersive: onImmersive ?? this.onImmersive,
      onImmersiveMuted: onImmersiveMuted ?? this.onImmersiveMuted,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      reward: reward ?? this.reward,
      onReward: onReward ?? this.onReward,
      focusRing: focusRing ?? this.focusRing,
    );
  }

  @override
  ForgeColors lerp(ForgeColors? other, double t) {
    if (other is! ForgeColors) return this;

    return ForgeColors(
      immersiveBackground: Color.lerp(
        immersiveBackground,
        other.immersiveBackground,
        t,
      )!,
      immersiveSurface: Color.lerp(
        immersiveSurface,
        other.immersiveSurface,
        t,
      )!,
      onImmersive: Color.lerp(onImmersive, other.onImmersive, t)!,
      onImmersiveMuted: Color.lerp(
        onImmersiveMuted,
        other.onImmersiveMuted,
        t,
      )!,
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      reward: Color.lerp(reward, other.reward, t)!,
      onReward: Color.lerp(onReward, other.onReward, t)!,
      focusRing: Color.lerp(focusRing, other.focusRing, t)!,
    );
  }
}

/// Tonal elevation and high-emphasis rendering beyond Material elevation.
@immutable
class ForgeEmphasis extends ThemeExtension<ForgeEmphasis> {
  const ForgeEmphasis({
    required this.raised,
    required this.floating,
    required this.primaryAction,
    required this.glassFill,
    required this.glassBorder,
    required this.glassBlurSigma,
  });

  final List<BoxShadow> raised;
  final List<BoxShadow> floating;
  final List<BoxShadow> primaryAction;
  final Color glassFill;
  final Color glassBorder;
  final double glassBlurSigma;

  @override
  ForgeEmphasis copyWith({
    List<BoxShadow>? raised,
    List<BoxShadow>? floating,
    List<BoxShadow>? primaryAction,
    Color? glassFill,
    Color? glassBorder,
    double? glassBlurSigma,
  }) {
    return ForgeEmphasis(
      raised: raised ?? this.raised,
      floating: floating ?? this.floating,
      primaryAction: primaryAction ?? this.primaryAction,
      glassFill: glassFill ?? this.glassFill,
      glassBorder: glassBorder ?? this.glassBorder,
      glassBlurSigma: glassBlurSigma ?? this.glassBlurSigma,
    );
  }

  @override
  ForgeEmphasis lerp(ForgeEmphasis? other, double t) {
    if (other is! ForgeEmphasis) return this;

    return ForgeEmphasis(
      raised: BoxShadow.lerpList(raised, other.raised, t) ?? const [],
      floating: BoxShadow.lerpList(floating, other.floating, t) ?? const [],
      primaryAction:
          BoxShadow.lerpList(primaryAction, other.primaryAction, t) ?? const [],
      glassFill: Color.lerp(glassFill, other.glassFill, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
      glassBlurSigma:
          lerpDouble(glassBlurSigma, other.glassBlurSigma, t) ?? glassBlurSigma,
    );
  }
}

/// Runtime-resolved motion policy honoring platform accessibility settings.
@immutable
class ForgeMotion {
  const ForgeMotion._({required this.disableAnimations});

  factory ForgeMotion.of(BuildContext context) {
    return ForgeMotion._(
      disableAnimations:
          MediaQuery.maybeOf(context)?.disableAnimations ?? false,
    );
  }

  final bool disableAnimations;

  Duration get fast => disableAnimations ? Duration.zero : AppAnimation.fast;
  Duration get standard =>
      disableAnimations ? Duration.zero : AppAnimation.standard;
  Duration get slow => disableAnimations ? Duration.zero : AppAnimation.slow;

  Curve get enterCurve =>
      disableAnimations ? Curves.linear : AppAnimation.easeOutCubic;
  Curve get exitCurve =>
      disableAnimations ? Curves.linear : AppAnimation.easeInOutCubic;
}

/// The semantic surface surrounding a Forge component.
///
/// Components on an immersive background must use the matching Forge
/// foreground roles rather than Material's ordinary surface roles.
enum ForgeSurface { standard, immersive }

class ForgeSurfaceScope extends InheritedWidget {
  const ForgeSurfaceScope({
    super.key,
    required this.surface,
    required super.child,
  });

  final ForgeSurface surface;

  static ForgeSurface? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ForgeSurfaceScope>()
        ?.surface;
  }

  @override
  bool updateShouldNotify(ForgeSurfaceScope oldWidget) {
    return surface != oldWidget.surface;
  }
}

extension ForgeThemeDataExtension on ThemeData {
  ForgeColors get forgeColors => extension<ForgeColors>()!;
  ForgeEmphasis get forgeEmphasis => extension<ForgeEmphasis>()!;
}

extension ForgeBuildContextExtension on BuildContext {
  ForgeMotion get forgeMotion => ForgeMotion.of(this);

  ForgeSurface get forgeSurface =>
      ForgeSurfaceScope.maybeOf(this) ?? ForgeSurface.standard;

  Color get forgeForeground => switch (forgeSurface) {
    ForgeSurface.standard => Theme.of(this).colorScheme.onSurface,
    ForgeSurface.immersive => Theme.of(this).forgeColors.onImmersive,
  };

  Color get forgeMutedForeground => switch (forgeSurface) {
    ForgeSurface.standard => Theme.of(this).colorScheme.onSurfaceVariant,
    ForgeSurface.immersive => Theme.of(this).forgeColors.onImmersiveMuted,
  };

  Color get forgeSurfaceColor => switch (forgeSurface) {
    ForgeSurface.standard => Theme.of(this).colorScheme.surfaceContainer,
    ForgeSurface.immersive => Theme.of(this).forgeColors.immersiveSurface,
  };
}
