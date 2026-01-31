import 'package:flutter/material.dart';

/// Forge.dance Design System Border Radius
/// Based on HTML mockup specifications
class AppBorderRadius {
  AppBorderRadius._();

  // ═══════════════════════════════════════════════════════════
  // RADIUS VALUES
  // ═══════════════════════════════════════════════════════════

  static const double none = 0.0;
  static const double sm = 4.0; // 0.25rem
  static const double defaultValue = 8.0; // 0.5rem - DEFAULT in Tailwind
  static const double lg = 12.0; // 0.75rem
  static const double xl = 16.0; // 1rem
  static const double xxl = 24.0; // 1.5rem - 2xl in Tailwind
  static const double xxxl = 32.0; // 2rem - 3xl in Tailwind
  static const double full = 9999.0;

  // ═══════════════════════════════════════════════════════════
  // BORDER RADIUS PRESETS
  // ═══════════════════════════════════════════════════════════

  /// Small rounded corners (4px)
  static const BorderRadius small = BorderRadius.all(Radius.circular(sm));

  /// Medium / Default rounded corners (8px)
  static const BorderRadius medium =
      BorderRadius.all(Radius.circular(defaultValue));
  static const BorderRadius defaultRadius = medium;

  /// Large rounded corners (12px)
  static const BorderRadius large = BorderRadius.all(Radius.circular(lg));

  /// Extra large rounded corners (16px)
  static const BorderRadius extraLarge = BorderRadius.all(Radius.circular(xl));

  /// 2XL rounded corners (24px)
  static const BorderRadius xxLarge = BorderRadius.all(Radius.circular(xxl));

  /// 3XL rounded corners (32px)
  static const BorderRadius xxxLarge = BorderRadius.all(Radius.circular(xxxl));

  /// Pill shape (buttons, badges)
  static const BorderRadius pill = BorderRadius.all(Radius.circular(full));

  /// Circle (avatars, FAB)
  static const BorderRadius circle = BorderRadius.all(Radius.circular(full));

  // ═══════════════════════════════════════════════════════════
  // PARTIAL RADIUS PRESETS
  // ═══════════════════════════════════════════════════════════

  /// Top corners only (bottom sheets, modals)
  static const BorderRadius topLarge = BorderRadius.only(
    topLeft: Radius.circular(lg),
    topRight: Radius.circular(lg),
  );

  /// Top corners XXL (large bottom sheets)
  static const BorderRadius topXxl = BorderRadius.only(
    topLeft: Radius.circular(xxl),
    topRight: Radius.circular(xxl),
  );

  /// Bottom corners only
  static const BorderRadius bottomLarge = BorderRadius.only(
    bottomLeft: Radius.circular(lg),
    bottomRight: Radius.circular(lg),
  );
}
