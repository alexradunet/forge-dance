
import 'package:flutter/material.dart';

/// Forge Dance typography backed by bundled, deterministic font assets.
///
/// Common Material roles are exposed through [textTheme]. The named styles
/// remain the component-level Forge roles while the existing catalog migrates
/// to theme-owned typography.
abstract final class AppTypography {
  static const displayFamily = 'Bebas Neue';
  static const bodyFamily = 'Inter';

  static const h1 = TextStyle(
    fontFamily: displayFamily,
    fontSize: 48,
    fontWeight: FontWeight.w400,
    height: 1,
  );

  static const h2 = TextStyle(
    fontFamily: displayFamily,
    fontSize: 36,
    fontWeight: FontWeight.w400,
    height: 1,
  );

  static const h3 = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 30,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static const h4 = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const h5 = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const h6 = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const bodyLarge = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const body = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const bodySmall = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.45,
  );

  static const caption = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static const overline = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: 1.2,
  );

  static const label = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const mono = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.5,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const monoLarge = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const monoSmall = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.4,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const textTheme = TextTheme(
    displayLarge: h1,
    displayMedium: h2,
    headlineLarge: h3,
    headlineMedium: h4,
    titleLarge: h5,
    titleMedium: h6,
    bodyLarge: bodyLarge,
    bodyMedium: body,
    bodySmall: bodySmall,
    labelLarge: bodySmall,
    labelMedium: label,
    labelSmall: caption,
  );
}
