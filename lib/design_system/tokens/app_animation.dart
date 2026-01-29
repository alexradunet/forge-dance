import 'package:flutter/material.dart';

/// Forge.dance Design System Animation
/// Animation tokens for consistent motion design
class AppAnimation {
  AppAnimation._();

  // ═══════════════════════════════════════════════════════════
  // DURATIONS
  // ═══════════════════════════════════════════════════════════

  /// Instant - Micro interactions (50ms)
  static const Duration instant = Duration(milliseconds: 50);

  /// Fast - Quick feedback, hover states (150ms)
  static const Duration fast = Duration(milliseconds: 150);

  /// Standard - Most transitions (300ms)
  static const Duration standard = Duration(milliseconds: 300);

  /// Slow - Complex animations (500ms)
  static const Duration slow = Duration(milliseconds: 500);

  /// Slower - Page transitions (700ms)
  static const Duration slower = Duration(milliseconds: 700);

  /// Slowest - Complex sequences (1000ms)
  static const Duration slowest = Duration(milliseconds: 1000);

  // ═══════════════════════════════════════════════════════════
  // CURVES - Easing functions
  // ═══════════════════════════════════════════════════════════

  /// Default easing - Most animations
  static const Curve defaultCurve = Curves.easeInOut;

  /// Ease out - Elements entering (decelerate)
  static const Curve easeOut = Curves.easeOut;

  /// Ease in - Elements exiting (accelerate)
  static const Curve easeIn = Curves.easeIn;

  /// Ease out cubic - Smooth deceleration
  static const Curve easeOutCubic = Curves.easeOutCubic;

  /// Ease in out cubic - Smooth both ways
  static const Curve easeInOutCubic = Curves.easeInOutCubic;

  /// Spring - Bouncy, playful animations
  static const Curve spring = Curves.elasticOut;

  /// Bounce - Impact animations
  static const Curve bounce = Curves.bounceOut;

  /// Sharp - Quick decisive animations
  static const Curve sharp = Curves.easeOutExpo;

  // ═══════════════════════════════════════════════════════════
  // PRESET ANIMATION CONFIGS
  // ═══════════════════════════════════════════════════════════

  /// Button press animation
  static const Duration buttonPress = fast;
  static const Curve buttonCurve = easeOut;

  /// Card hover/tap animation
  static const Duration cardHover = standard;
  static const Curve cardCurve = easeOutCubic;

  /// Page transition
  static const Duration pageTransition = slow;
  static const Curve pageCurve = easeInOutCubic;

  /// Modal animation
  static const Duration modal = standard;
  static const Curve modalCurve = easeOutCubic;

  /// Toast/Snackbar animation
  static const Duration toast = standard;
  static const Curve toastEnter = easeOut;
  static const Curve toastExit = easeIn;

  /// Skeleton shimmer animation
  static const Duration shimmer = Duration(milliseconds: 1500);

  /// Pulse animation (for glowing elements)
  static const Duration pulse = Duration(milliseconds: 2000);

  /// Fade in animation
  static const Duration fadeIn = fast;
  static const Curve fadeInCurve = easeOut;
}
