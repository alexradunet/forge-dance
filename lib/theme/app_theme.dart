import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Forge.dance Design System Typography
/// Based on the Forge Design System specification
class AppTheme {
  AppTheme._();

  // ═══════════════════════════════════════════════════════════
  // DISPLAY FONT - Bebas Neue (Headers, titles, hero text)
  // ═══════════════════════════════════════════════════════════

  /// H1 - 48px - Page titles, major headings
  static final h1 = GoogleFonts.bebasNeue(
    fontSize: 48,
    fontWeight: FontWeight.w400, // Bebas Neue only has one weight
    height: 1.1,
    letterSpacing: 0,
  );

  /// H2 - 36px - Section titles, feature headers
  static final h2 = GoogleFonts.bebasNeue(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    height: 1.1,
    letterSpacing: 0,
  );

  // ═══════════════════════════════════════════════════════════
  // BODY FONT - Inter (All body text, UI elements)
  // ═══════════════════════════════════════════════════════════

  /// H3 - 30px - Card titles, prominent labels
  static final h3 = GoogleFonts.inter(
    fontSize: 30,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  /// H4 - 24px - Subsection headings
  static final h4 = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  /// H5 - 20px - Component titles
  static final h5 = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  /// H6 - 18px - Small headings
  static final h6 = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  /// Body Large - 18px - Primary body text for emphasis
  static final bodyLarge = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// Body - 16px - Standard body text, descriptions
  static final body = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// Body Small - 14px - Secondary text, metadata
  static final bodySmall = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// Caption - 12px - Captions, timestamps, hints
  static final caption = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  // ═══════════════════════════════════════════════════════════
  // MONOSPACE FONT - JetBrains Mono (Stats, timers, numbers)
  // ═══════════════════════════════════════════════════════════

  /// Mono - Stats, timers, numbers
  static final mono = GoogleFonts.jetBrainsMono(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );
}
