import 'package:flutter/material.dart';

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

extension ForgeThemeDataExtension on ThemeData {
  ForgeColors get forgeColors => extension<ForgeColors>()!;
}
