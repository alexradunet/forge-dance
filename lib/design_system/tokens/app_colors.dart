import 'package:flutter/material.dart';

/// Forge.dance Design System Colors
/// Based on the Forge Design System specification and HTML mockups
class AppColors {
  AppColors._();

  // ═══════════════════════════════════════════════════════════
  // PRIMARY PALETTE - Forge Brand Colors
  // ═══════════════════════════════════════════════════════════

  /// 🔥 FORGE FIRE - Primary brand color, CTAs, highlights
  /// #FF4500
  static const forgeFire = Color(0xFFFF4500);

  /// Legacy variations (kept for compatibility)
  static const forgeFireDark = Color(0xFFDC3A00);
  static const forgeFireLight = Color(0xFFFF6B33);

  /// ⚡ ELECTRIC BLUE - Secondary actions, progress, energy
  /// #00BFFF
  static const electricBlue = Color(0xFF00BFFF);

  /// Legacy variations
  static const electricBlueDark = Color(0xFF0099CC);
  static const electricBlueLight = Color(0xFF33CCFF);

  /// 👑 LEGEND GOLD - Achievements, premium features
  /// #FFD700
  static const legendGold = Color(0xFFFFD700);

  /// ✨ MYSTIC PURPLE - Magic moments, special features
  /// #A855F7
  static const mysticPurple = Color(0xFFA855F7);

  // ═══════════════════════════════════════════════════════════
  // SURFACE & BACKGROUND COLORS
  // ═══════════════════════════════════════════════════════════

  /// Background Deep - App background
  /// #0A0A0A
  static const bgDeep = Color(0xFF0A0A0A);

  /// Surface Dark
  /// #121212
  static const surfaceDark = Color(0xFF121212);

  /// Surface Card
  /// #1E1E1E
  static const surfaceCard = Color(0xFF1E1E1E);

  /// Surface Light
  /// #2C2C2C
  static const surfaceLight = Color(0xFF2C2C2C);

  // ═══════════════════════════════════════════════════════════
  // TEXT COLORS
  // ═══════════════════════════════════════════════════════════

  /// Text Main
  /// #FFFFFF
  static const textMain = Color(0xFFFFFFFF);

  /// Text Muted
  /// #A1A1AA
  static const textMuted = Color(0xFFA1A1AA);

  /// Text Dark
  /// #71717A
  static const textDark = Color(0xFF71717A);

  /// Legacy Crystal White (often used as Text Main or Highlight)
  /// #F0F8FF
  static const crystalWhite = Color(0xFFF0F8FF);

  // ═══════════════════════════════════════════════════════════
  // ACCENT & UTILITY COLORS (Legacy & Functional)
  // ═══════════════════════════════════════════════════════════

  /// 🌿 GROWTH GREEN - Success states, progress indicators
  static const growthGreen = Color(0xFF10B981);

  /// ❤️ PASSION RED - High intensity, warnings
  static const passionRed = Color(0xFFDC143C);

  /// ☀️ WARNING AMBER - Alerts, attention needed
  static const warningAmber = Color(0xFFF59E0B);

  static const borderSubtle = Color(0x14FFFFFF);

  // ═══════════════════════════════════════════════════════════
  // DANCE STYLE COLORS
  // ═══════════════════════════════════════════════════════════

  /// 🎤 Hip Hop
  static const styleHipHop = Color(0xFF8B00FF);
  static const hipHopPurple = Color(0xFFA855F7); // Alias/Variation
  static const hipHopGlow = Color(0xFFD946EF);

  /// 💃 Contemporary
  static const styleContemporary = Color(0xFF00BFFF);

  /// 🩰 Ballet
  static const styleBallet = Color(0xFFEC4899);

  /// 🎺 Jazz
  static const styleJazz = Color(0xFFF59E0B);

  /// 🔥 Latin
  static const styleLatin = Color(0xFFEF4444);
  static const latinRose = Color(0xFFEC4899);

  /// 🌪️ Breaking
  static const styleBreaking = Color(0xFF10B981);
  static const breakingBlue = Color(0xFF3B82F6);

  // ═══════════════════════════════════════════════════════════
  // NEUTRAL SCALE
  // ═══════════════════════════════════════════════════════════

  static const neutral950 = Color(0xFF0A0A0A);
  static const neutral900 = Color(0xFF171717);
  static const neutral800 = Color(0xFF262626);
  static const neutral700 = Color(0xFF404040);
  static const neutral600 = Color(0xFF525252);
  static const neutral500 = Color(0xFF737373);
  static const neutral400 = Color(0xFFA3A3A3);
  static const neutral300 = Color(0xFFD4D4D4);
  static const neutral200 = Color(0xFFE5E5E5);
  static const neutral100 = Color(0xFFF5F5F5);
  static const neutral50 = Color(0xFFF9FAFB);

  // ═══════════════════════════════════════════════════════════
  // LEGACY GRAY SCALE (Mapped to Neutral)
  // ═══════════════════════════════════════════════════════════

  static const gray950 = neutral950;
  static const gray900 = neutral900;
  static const gray800 = neutral800;
  static const gray700 = neutral700;
  static const gray600 = neutral600;
  static const gray500 = neutral500;
  static const gray400 = neutral400;
  static const gray300 = neutral300;
  static const gray200 = neutral200;
  static const gray100 = neutral100;
  static const gray50 = neutral50;
}
