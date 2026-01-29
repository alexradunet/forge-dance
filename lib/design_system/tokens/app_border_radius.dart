import 'package:flutter/material.dart';

/// Forge.dance Design System Border Radius
/// Based on HTML mockup specifications
class AppBorderRadius {
  AppBorderRadius._();

  // ═══════════════════════════════════════════════════════════
  // RADIUS VALUES
  // ═══════════════════════════════════════════════════════════

  static const double none = 0.0;
  static const double sm = 4.0; // 0.25rem - subtle rounding
  static const double md = 8.0; // 0.5rem - inputs, small buttons
  static const double lg = 12.0; // 0.75rem - cards, containers
  static const double xl = 16.0; // 1rem - large cards
  static const double xxl = 24.0; // 1.5rem - hero cards, modals
  static const double xxxl = 32.0; // 2rem - extra large elements
  static const double full = 9999.0; // Pills, circles

  // ═══════════════════════════════════════════════════════════
  // BORDER RADIUS PRESETS
  // ═══════════════════════════════════════════════════════════

  /// Small rounded corners
  static const BorderRadius small = BorderRadius.all(Radius.circular(sm));

  /// Medium rounded corners (inputs, small buttons)
  static const BorderRadius medium = BorderRadius.all(Radius.circular(md));

  /// Large rounded corners (cards)
  static const BorderRadius large = BorderRadius.all(Radius.circular(lg));

  /// Extra large rounded corners (hero cards)
  static const BorderRadius extraLarge = BorderRadius.all(Radius.circular(xl));

  /// 2XL rounded corners (modals, large cards)
  static const BorderRadius xxLarge = BorderRadius.all(Radius.circular(xxl));

  /// 3XL rounded corners
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
