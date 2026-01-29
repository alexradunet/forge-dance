import 'package:flutter/material.dart';


/// Forge.dance Design System Shadows
/// Box shadows and glow effects from HTML mockups
class AppShadows {
  AppShadows._();

  // ═══════════════════════════════════════════════════════════
  // GLOW EFFECTS - Colored glow shadows for emphasis
  // ═══════════════════════════════════════════════════════════

  /// Primary glow - Forge Fire orange glow
  /// 0 0 20px rgba(255, 69, 0, 0.25)
  static const glowPrimary = BoxShadow(
    color: Color(0x40FF4500), // 25% opacity
    blurRadius: 20,
    spreadRadius: 0,
  );

  /// Intense primary glow - For elevated actions
  /// 0 0 35px rgba(255, 69, 0, 0.6)
  static const glowIntense = BoxShadow(
    color: Color(0x99FF4500), // 60% opacity
    blurRadius: 35,
    spreadRadius: 0,
  );

  /// Blue glow - Electric Blue accents
  /// 0 0 20px rgba(0, 191, 255, 0.25)
  static const glowBlue = BoxShadow(
    color: Color(0x4000BFFF), // 25% opacity
    blurRadius: 20,
    spreadRadius: 0,
  );

  /// Gold glow - Legend Gold achievements
  /// 0 0 20px rgba(255, 215, 0, 0.25)
  static const glowGold = BoxShadow(
    color: Color(0x40FFD700), // 25% opacity
    blurRadius: 20,
    spreadRadius: 0,
  );

  /// Purple glow - Mystic Purple special states
  /// 0 0 20px rgba(139, 0, 255, 0.25)
  static const glowPurple = BoxShadow(
    color: Color(0x408B00FF), // 25% opacity
    blurRadius: 20,
    spreadRadius: 0,
  );

  // ═══════════════════════════════════════════════════════════
  // ELEVATION SHADOWS - Standard material-style elevations
  // ═══════════════════════════════════════════════════════════

  /// Small shadow - Subtle elevation
  static const shadowSm = BoxShadow(
    color: Color(0x26000000), // 15% black
    blurRadius: 4,
    offset: Offset(0, 1),
  );

  /// Medium shadow - Cards, buttons
  static const shadowMd = BoxShadow(
    color: Color(0x33000000), // 20% black
    blurRadius: 10,
    offset: Offset(0, 4),
  );

  /// Large shadow - Elevated modals, dropdowns
  static const shadowLg = BoxShadow(
    color: Color(0x40000000), // 25% black
    blurRadius: 25,
    offset: Offset(0, 10),
  );

  /// Extra large shadow - Floating elements
  static const shadowXl = BoxShadow(
    color: Color(0x4D000000), // 30% black
    blurRadius: 50,
    offset: Offset(0, 20),
  );

  // ═══════════════════════════════════════════════════════════
  // COMPOSITE SHADOW LISTS - Ready to use
  // ═══════════════════════════════════════════════════════════

  /// Card shadow with subtle glow
  static List<BoxShadow> cardShadow(Color glowColor) => [
        BoxShadow(
          color: glowColor.withOpacity(0.15),
          blurRadius: 15,
          offset: const Offset(0, 4),
        ),
      ];

  /// Button shadow with primary glow
  static const buttonPrimary = [
    BoxShadow(
      color: Color(0x4DFF4500), // 30% Forge Fire
      blurRadius: 15,
      offset: Offset(0, 4),
    ),
  ];

  /// FAB shadow with intense glow
  static const fabShadow = [
    BoxShadow(
      color: Color(0x99FF4500), // 60% Forge Fire
      blurRadius: 35,
      spreadRadius: 0,
    ),
  ];
}
