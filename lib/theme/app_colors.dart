import 'package:flutter/material.dart';

/// Forge.dance Design System Colors
/// Based on the Forge Design System specification
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
  // DANCE STYLE COLORS
  // ═══════════════════════════════════════════════════════════

  /// 🎤 Hip Hop
  static const styleHipHop = Color(0xFF8B00FF);

  /// 💃 Contemporary
  static const styleContemporary = Color(0xFF00BFFF);

  /// 🩰 Ballet
  static const styleBallet = Color(0xFFEC4899);

  /// 🎺 Jazz
  static const styleJazz = Color(0xFFF59E0B);

  /// 🔥 Latin
  static const styleLatin = Color(0xFFEF4444);

  /// 🌪️ Breaking
  static const styleBreaking = Color(0xFF10B981);

  // ═══════════════════════════════════════════════════════════
  // NEUTRAL GRAY SCALE (Dark Mode Primary)
  // ═══════════════════════════════════════════════════════════

  static const gray950 = Color(0xFF0A0A0A); // Almost black
  static const gray900 = Color(0xFF111827); // Dark bg
  static const gray800 = Color(0xFF1F2937); // Card bg
  static const gray700 = Color(0xFF374151); // Borders
  static const gray600 = Color(0xFF4B5563); // Disabled
  static const gray500 = Color(0xFF6B7280); // Muted text
  static const gray400 = Color(0xFF9CA3AF); // Placeholder
  static const gray300 = Color(0xFFD1D5DB); // Borders light
  static const gray200 = Color(0xFFE5E7EB); // Dividers
  static const gray100 = Color(0xFFF3F4F6); // Light bg
  static const gray50 = Color(0xFFF9FAFB); // Subtle bg

}
