import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Forge.dance Design System Typography
/// Based on the Forge Design System specification and HTML mockups
class AppTypography {
  AppTypography._();

  // ═══════════════════════════════════════════════════════════
  // DISPLAY FONT - Bebas Neue (Headers, titles, hero text)
  // ═══════════════════════════════════════════════════════════

  /// H1 - 48px - Page titles, major headings (Bebas Neue)
  static final h1 = GoogleFonts.bebasNeue(
    fontSize: 48,
    fontWeight: FontWeight.w400,
    height: 1.0, // line-height: 1.0 from HTML
    letterSpacing: 0,
  );

  /// H2 - 36px - Section titles, feature headers (Bebas Neue)
  static final h2 = GoogleFonts.bebasNeue(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    height: 1.0, // line-height: 1.0 from HTML
    letterSpacing: 0,
  );

  // ═══════════════════════════════════════════════════════════
  // BODY FONT - Inter (All body text, UI elements)
  // ═══════════════════════════════════════════════════════════

  /// H3 - 30px - Card titles, prominent labels (Inter Semibold)
  static final h3 = GoogleFonts.inter(
    fontSize: 30,
    fontWeight: FontWeight.w600,
    height: 1.2, // line-height: 1.2 from HTML
  );

  /// H4 - 24px - Component labels (Inter Semibold)
  static final h4 = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.4, // line-height: 1.4 from HTML
  );

  /// H5 - 20px - Modal titles (Inter Medium)
  static final h5 = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 1.4, // line-height: 1.4 from HTML
  );

  /// H6 - 18px - Small labels (Inter Medium)
  static final h6 = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.5, // line-height: 1.5 from HTML
  );

  /// Body Large - 18px - Primary body text for emphasis
  static final bodyLarge = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// Body - 16px - Standard body text (Inter Regular)
  static final body = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6, // line-height: 1.6 from HTML (relaxed)
  );

  /// Body Small - 14px - Secondary text, metadata (Inter Regular)
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

  /// Overline - 10px - Labels, status text (uppercase tracking-widest)
  static final overline = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: 1.5, // tracking-widest
  );

  /// Label - 11px - Small labels (like card badges)
  static final label = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  // ═══════════════════════════════════════════════════════════
  // MONOSPACE FONT - JetBrains Mono (Stats, timers, numbers)
  // ═══════════════════════════════════════════════════════════

  /// Mono - Stats, timers, numbers, technical text (13px)
  static final mono = GoogleFonts.jetBrainsMono(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// Mono Large - Larger technical displays (16px)
  static final monoLarge = GoogleFonts.jetBrainsMono(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// Mono Small - Smaller code/tech text (10px)
  static final monoSmall = GoogleFonts.jetBrainsMono(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );
}

/// For backwards compatibility - maps to AppTypography
typedef AppTheme = AppTypography;
