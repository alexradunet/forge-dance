import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';

/// Canonical Material themes for Forge Dance surfaces.
abstract final class AppThemes {
  static final ThemeData light = _build(Brightness.light);
  static final ThemeData dark = _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final base =
        brightness == Brightness.light ? ThemeData.light() : ThemeData.dark();
    final isDark = brightness == Brightness.dark;

    return base.copyWith(
      scaffoldBackgroundColor: isDark ? AppColors.gray950 : AppColors.gray50,
      colorScheme: base.colorScheme.copyWith(
        brightness: brightness,
        primary: AppColors.forgeFire,
        secondary: AppColors.electricBlue,
        error: AppColors.passionRed,
        surface: isDark ? AppColors.gray900 : AppColors.gray100,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: isDark ? AppColors.crystalWhite : AppColors.gray950,
        displayColor: isDark ? AppColors.crystalWhite : AppColors.gray950,
      ),
    );
  }
}
