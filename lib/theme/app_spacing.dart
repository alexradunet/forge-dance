import 'package:flutter/material.dart';

/// Forge.dance Design System Spacing
/// Based on 4px base unit system
class AppSpacing {
  AppSpacing._();

  // ═══════════════════════════════════════════════════════════
  // SPACING SCALE (4px base unit)
  // ═══════════════════════════════════════════════════════════

  static const double xs = 4.0; // 1 unit
  static const double sm = 8.0; // 2 units
  static const double md = 12.0; // 3 units
  static const double lg = 16.0; // 4 units
  static const double xl = 20.0; // 5 units
  static const double xxl = 24.0; // 6 units
  static const double xxxl = 32.0; // 8 units
  static const double huge = 40.0; // 10 units
  static const double huge2 = 48.0; // 12 units
  static const double huge3 = 64.0; // 16 units
  static const double huge4 = 80.0; // 20 units

  // ═══════════════════════════════════════════════════════════
  // EDGE INSETS (Common padding/margin patterns)
  // ═══════════════════════════════════════════════════════════

  /// 4px all sides
  static const EdgeInsets allXS = EdgeInsets.all(xs);

  /// 8px all sides
  static const EdgeInsets allSM = EdgeInsets.all(sm);

  /// 12px all sides
  static const EdgeInsets allMD = EdgeInsets.all(md);

  /// 16px all sides (most common)
  static const EdgeInsets allLG = EdgeInsets.all(lg);

  /// 24px all sides
  static const EdgeInsets allXXL = EdgeInsets.all(xxl);

  /// 32px all sides
  static const EdgeInsets allXXXL = EdgeInsets.all(xxxl);

  /// Horizontal padding (16px)
  static const EdgeInsets horizontal = EdgeInsets.symmetric(horizontal: lg);

  /// Vertical padding (16px)
  static const EdgeInsets vertical = EdgeInsets.symmetric(vertical: lg);

  /// Horizontal padding (24px)
  static const EdgeInsets horizontalXXL = EdgeInsets.symmetric(horizontal: xxl);

  /// Vertical padding (24px)
  static const EdgeInsets verticalXXL = EdgeInsets.symmetric(vertical: xxl);

  /// Card padding (16px)
  static const EdgeInsets card = EdgeInsets.all(lg);

  /// Screen padding (24px)
  static const EdgeInsets screen = EdgeInsets.all(xxl);

  /// Section spacing (vertical 16px)
  static const EdgeInsets section = EdgeInsets.symmetric(vertical: lg);

  /// Component spacing (vertical 8px)
  static const EdgeInsets component = EdgeInsets.symmetric(vertical: sm);
}
