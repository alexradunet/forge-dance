import 'package:flutter/material.dart';

/// Forge.dance Design System Colors
/// Based on the Forge Design System specification and HTML mockups
class AppColors {
  AppColors._();

  // ═══════════════════════════════════════════════════════════
  // PRIMARY PALETTE - Forge Brand Colors
  // ═══════════════════════════════════════════════════════════

  /// 🔥 FORGE FIRE - Primary brand color, CTAs, highlights
  /// #FF4500 - rgb(255, 69, 0)
  static const forgeFire = Color(0xFFFF4500);
  static const forgeFireDark = Color(0xFFDC3A00);
  static const forgeFireLight = Color(0xFFFF6B33);

  /// ⚡ ELECTRIC BLUE - Secondary actions, progress, energy
  /// #00BFFF - rgb(0, 191, 255)
  static const electricBlue = Color(0xFF00BFFF);
  static const electricBlueDark = Color(0xFF0099CC);
  static const electricBlueLight = Color(0xFF33CCFF);

  /// 💎 CRYSTAL WHITE - Text on dark backgrounds, highlights
  /// #F0F8FF - rgb(240, 248, 255)
  static const crystalWhite = Color(0xFFF0F8FF);

  /// 🌑 STEEL GRAY - Primary background, surfaces
  /// #2C2C2C - rgb(44, 44, 44)
  static const steelGray = Color(0xFF2C2C2C);
  static const steelGrayLight = Color(0xFF3A3A3A);

  /// 👑 LEGEND GOLD - Achievements, premium features
  /// #FFD700 - rgb(255, 215, 0)
  static const legendGold = Color(0xFFFFD700);

  // ═══════════════════════════════════════════════════════════
  // ACCENT & UTILITY COLORS
  // ═══════════════════════════════════════════════════════════

  /// ✨ MYSTIC PURPLE - Magic moments, special features
  /// #8B00FF - rgb(139, 0, 255)
  static const mysticPurple = Color(0xFF8B00FF);

  /// 🌿 GROWTH GREEN - Success states, progress indicators
  /// #10B981 - rgb(16, 185, 129)
  static const growthGreen = Color(0xFF10B981);

  /// ❤️ PASSION RED - High intensity, warnings
  /// #DC143C - rgb(220, 20, 60)
  static const passionRed = Color(0xFFDC143C);

  /// ☀️ WARNING AMBER - Alerts, attention needed
  /// #F59E0B - rgb(245, 158, 11)
  static const warningAmber = Color(0xFFF59E0B);

  // ═══════════════════════════════════════════════════════════
  // SURFACE & BACKGROUND COLORS (from HTML mockups)
  // ═══════════════════════════════════════════════════════════

  /// Surface Dark - Card backgrounds
  /// #1E1E1E
  static const surfaceDark = Color(0xFF1E1E1E);

  /// Surface Light - Elevated surfaces
  /// #2C2C2C
  static const surfaceLight = Color(0xFF2C2C2C);

  /// Background Deep - App background
  /// #0A0A0A
  static const bgDeep = Color(0xFF0A0A0A);

  /// Text Main - Primary text
  /// #FFFFFF
  static const textMain = Color(0xFFFFFFFF);

  /// Text Muted - Secondary text
  /// #A1A1AA
  static const textMuted = Color(0xFFA1A1AA);

  /// Border Subtle - Subtle borders
  /// rgba(255,255,255,0.08)
  static const borderSubtle = Color(0x14FFFFFF);

  // ═══════════════════════════════════════════════════════════
  // DANCE STYLE COLORS
  // ═══════════════════════════════════════════════════════════

  /// 🎤 Hip Hop
  static const styleHipHop = Color(0xFF8B00FF);

  /// Hip Hop Purple (alias for category tags)
  static const hipHopPurple = Color(0xFFA855F7);

  /// 🎇 Hip Hop Glow
  static const hipHopGlow = Color(0xFFD946EF);

  /// 💃 Contemporary
  static const styleContemporary = Color(0xFF00BFFF);

  /// 🩰 Ballet
  static const styleBallet = Color(0xFFEC4899);

  /// 🎺 Jazz
  static const styleJazz = Color(0xFFF59E0B);

  /// 🔥 Latin
  static const styleLatin = Color(0xFFEF4444);

  /// 💗 Latin Rose
  static const latinRose = Color(0xFFEC4899);

  /// 🌪️ Breaking
  static const styleBreaking = Color(0xFF10B981);

  /// 💙 Breaking Blue
  static const breakingBlue = Color(0xFF3B82F6);

  // ═══════════════════════════════════════════════════════════
  // NEUTRAL SCALE (from HTML mockups)
  // ═══════════════════════════════════════════════════════════

  static const neutral950 = Color(0xFF0A0A0A); // App background
  static const neutral900 = Color(0xFF171717); // Dark surfaces
  static const neutral800 = Color(0xFF262626); // Card surfaces
  static const neutral700 = Color(0xFF404040); // Elevated borders
  static const neutral600 = Color(0xFF525252); // Disabled elements
  static const neutral500 = Color(0xFF737373); // Muted text
  static const neutral400 = Color(0xFFA3A3A3); // Placeholder text
  static const neutral300 = Color(0xFFD4D4D4); // Light borders
  static const neutral200 = Color(0xFFE5E5E5); // Dividers
  static const neutral100 = Color(0xFFF5F5F5); // Light surfaces
  static const neutral50 = Color(0xFFF9FAFB); // High contrast text

  // ═══════════════════════════════════════════════════════════
  // LEGACY GRAY SCALE (for backwards compatibility mapping)
  // ═══════════════════════════════════════════════════════════

  static const gray950 = neutral950;
  static const gray900 = Color(0xFF111827);
  static const gray800 = Color(0xFF1F2937);
  static const gray700 = Color(0xFF374151);
  static const gray600 = Color(0xFF4B5563);
  static const gray500 = Color(0xFF6B7280);
  static const gray400 = Color(0xFF9CA3AF);
  static const gray300 = Color(0xFFD1D5DB);
  static const gray200 = Color(0xFFE5E7EB);
  static const gray100 = Color(0xFFF3F4F6);
  static const gray50 = Color(0xFFF9FAFB);
}
