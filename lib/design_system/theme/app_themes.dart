import 'package:flutter/material.dart';
import 'package:forge_dance/design_system/theme/forge_theme_extensions.dart';
import 'package:forge_dance/design_system/tokens/app_border_radius.dart';
import 'package:forge_dance/design_system/tokens/app_colors.dart';
import 'package:forge_dance/design_system/tokens/app_spacing.dart';
import 'package:forge_dance/design_system/tokens/app_sizes.dart';
import 'package:forge_dance/design_system/tokens/app_typography.dart';

/// Material 3 themes and Forge-specific semantic roles.
abstract final class AppThemes {
  static final ThemeData light = _build(Brightness.light);
  static final ThemeData dark = _build(Brightness.dark);
  static final ThemeData highContrastLight = _build(
    Brightness.light,
    highContrast: true,
  );
  static final ThemeData highContrastDark = _build(
    Brightness.dark,
    highContrast: true,
  );

  static ThemeData _build(Brightness brightness, {bool highContrast = false}) {
    final scheme = _colorScheme(brightness, highContrast: highContrast);
    final forgeColors = _forgeColors(brightness, highContrast: highContrast);
    final forgeEmphasis = _forgeEmphasis(scheme, highContrast: highContrast);
    final textTheme = AppTypography.textTheme.apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    );
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: AppTypography.bodyFamily,
      textTheme: textTheme,
    );
    final controlShape = RoundedRectangleBorder(
      borderRadius: AppBorderRadius.large,
    );

    return base.copyWith(
      scaffoldBackgroundColor: scheme.surface,
      canvasColor: scheme.surface,
      focusColor: forgeColors.focusRing.withValues(alpha: 0.18),
      hoverColor: scheme.primary.withValues(alpha: 0.08),
      highlightColor: scheme.primary.withValues(alpha: 0.12),
      extensions: [forgeColors, forgeEmphasis],
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppBorderRadius.extraLarge,
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          disabledBackgroundColor: scheme.onSurface.withValues(alpha: 0.12),
          disabledForegroundColor: scheme.onSurface.withValues(alpha: 0.38),
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          shape: controlShape,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.onSurface,
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          side: BorderSide(color: scheme.outline),
          shape: controlShape,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          shape: controlShape,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: scheme.onSurfaceVariant,
          minimumSize: const Size(48, 48),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLow,
        contentPadding: AppSpacing.allLG,
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
        floatingLabelStyle: textTheme.labelMedium?.copyWith(
          color: forgeColors.focusRing,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
        helperStyle: textTheme.bodySmall?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
        errorStyle: textTheme.bodySmall?.copyWith(color: scheme.error),
        border: OutlineInputBorder(
          borderRadius: AppBorderRadius.large,
          borderSide: BorderSide(color: scheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.large,
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.large,
          borderSide: BorderSide(
            color: scheme.onSurface.withValues(alpha: 0.12),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.large,
          borderSide: BorderSide(color: forgeColors.focusRing, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.large,
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.large,
          borderSide: BorderSide(color: scheme.error, width: 2),
        ),
        constraints: const BoxConstraints(
          minHeight: AppSizes.comfortableTouchTarget,
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: AppSizes.comfortableTouchTarget,
          minHeight: AppSizes.comfortableTouchTarget,
        ),
        suffixIconConstraints: const BoxConstraints(
          minWidth: AppSizes.comfortableTouchTarget,
          minHeight: AppSizes.comfortableTouchTarget,
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: scheme.surfaceContainerHigh,
        selectedColor: scheme.secondaryContainer,
        disabledColor: scheme.onSurface.withValues(alpha: 0.12),
        labelStyle: textTheme.labelMedium,
        secondaryLabelStyle: textTheme.labelMedium?.copyWith(
          color: scheme.onSecondaryContainer,
        ),
        side: BorderSide(color: scheme.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.pill),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return scheme.primary;
          return Colors.transparent;
        }),
        checkColor: WidgetStatePropertyAll(scheme.onPrimary),
        side: BorderSide(color: scheme.outline, width: 2),
        shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.small),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? scheme.primary
              : scheme.onSurfaceVariant;
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? scheme.onPrimary
              : scheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? scheme.primary
              : scheme.surfaceContainerHighest;
        }),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        indicatorColor: scheme.secondaryContainer,
        elevation: 0,
        labelTextStyle: WidgetStatePropertyAll(textTheme.labelMedium),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          return IconThemeData(
            color: states.contains(WidgetState.selected)
                ? scheme.onSecondaryContainer
                : scheme.onSurfaceVariant,
          );
        }),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: scheme.surfaceContainer,
        indicatorColor: scheme.secondaryContainer,
        selectedIconTheme: IconThemeData(color: scheme.onSecondaryContainer),
        unselectedIconTheme: IconThemeData(color: scheme.onSurfaceVariant),
        selectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          color: scheme.onSurface,
        ),
        unselectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppBorderRadius.xxLarge,
          side: BorderSide(color: scheme.outlineVariant),
        ),
        titleTextStyle: textTheme.headlineMedium,
        contentTextStyle: textTheme.bodyMedium,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceContainer,
        modalBackgroundColor: scheme.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        modalElevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: AppBorderRadius.topXxl,
        ),
        showDragHandle: true,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onInverseSurface,
        ),
        actionTextColor: scheme.inversePrimary,
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.large),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: scheme.inverseSurface,
          borderRadius: AppBorderRadius.medium,
        ),
        textStyle: textTheme.bodySmall?.copyWith(
          color: scheme.onInverseSurface,
        ),
        waitDuration: const Duration(milliseconds: 500),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: scheme.surfaceContainerHighest,
        circularTrackColor: scheme.surfaceContainerHighest,
      ),
    );
  }

  static ColorScheme _colorScheme(
    Brightness brightness, {
    required bool highContrast,
  }) {
    final isDark = brightness == Brightness.dark;
    final generated = ColorScheme.fromSeed(
      seedColor: AppColors.forgeFire,
      brightness: brightness,
      contrastLevel: highContrast ? 1 : 0,
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    );

    return generated.copyWith(
      brightness: brightness,
      primary: AppColors.forgeFire,
      onPrimary: AppColors.gray950,
      primaryContainer: isDark
          ? const Color(0xFF8F2500)
          : const Color(0xFFFFDCCF),
      onPrimaryContainer: isDark
          ? const Color(0xFFFFEEE8)
          : const Color(0xFF3B0B00),
      secondary: AppColors.electricBlue,
      onSecondary: AppColors.gray950,
      secondaryContainer: isDark
          ? const Color(0xFF004D66)
          : const Color(0xFFC7F0FF),
      onSecondaryContainer: isDark
          ? const Color(0xFFD5F3FF)
          : const Color(0xFF002634),
      tertiary: AppColors.mysticPurple,
      onTertiary: AppColors.gray950,
      tertiaryContainer: isDark
          ? const Color(0xFF57217D)
          : const Color(0xFFF0DBFF),
      onTertiaryContainer: isDark
          ? const Color(0xFFF6E8FF)
          : const Color(0xFF31005A),
      error: AppColors.passionRed,
      onError: AppColors.crystalWhite,
      errorContainer: isDark
          ? const Color(0xFF930020)
          : const Color(0xFFFFDAD9),
      onErrorContainer: isDark
          ? const Color(0xFFFFDAD9)
          : const Color(0xFF410006),
      surface: isDark ? AppColors.surfaceDark : AppColors.gray50,
      onSurface: isDark ? AppColors.crystalWhite : AppColors.gray950,
      surfaceContainerLowest: isDark
          ? AppColors.gray950
          : AppColors.crystalWhite,
      surfaceContainerLow: isDark ? AppColors.gray900 : AppColors.gray100,
      surfaceContainer: isDark ? AppColors.surfaceCard : AppColors.gray200,
      surfaceContainerHigh: isDark ? AppColors.gray800 : AppColors.gray300,
      surfaceContainerHighest: isDark
          ? const Color(0xFF333333)
          : AppColors.gray300,
      onSurfaceVariant: isDark ? AppColors.gray300 : AppColors.gray700,
      outline: isDark ? AppColors.gray400 : AppColors.gray600,
      outlineVariant: isDark ? AppColors.gray700 : AppColors.gray300,
      surfaceTint: AppColors.forgeFire,
      inverseSurface: isDark ? AppColors.gray100 : AppColors.gray900,
      onInverseSurface: isDark ? AppColors.gray900 : AppColors.gray100,
      inversePrimary: isDark
          ? const Color(0xFFC93400)
          : const Color(0xFFFF8A65),
    );
  }

  static ForgeColors _forgeColors(
    Brightness brightness, {
    required bool highContrast,
  }) {
    final isDark = brightness == Brightness.dark;

    return ForgeColors(
      immersiveBackground: AppColors.bgDeep,
      immersiveSurface: AppColors.surfaceDark,
      onImmersive: AppColors.crystalWhite,
      onImmersiveMuted: highContrast
          ? AppColors.crystalWhite
          : AppColors.gray300,
      success: isDark ? AppColors.growthGreen : const Color(0xFF0B6B35),
      onSuccess: isDark ? AppColors.gray950 : AppColors.crystalWhite,
      warning: AppColors.warningAmber,
      onWarning: AppColors.gray950,
      reward: AppColors.legendGold,
      onReward: AppColors.gray950,
      focusRing: highContrast ? AppColors.electricBlue : AppColors.forgeFire,
    );
  }

  static ForgeEmphasis _forgeEmphasis(
    ColorScheme scheme, {
    required bool highContrast,
  }) {
    return ForgeEmphasis(
      raised: highContrast
          ? const []
          : [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
      floating: highContrast
          ? const []
          : [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.28),
                blurRadius: 28,
                offset: const Offset(0, 12),
              ),
            ],
      primaryAction: highContrast
          ? const []
          : [
              BoxShadow(
                color: scheme.primary.withValues(alpha: 0.28),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
      glassFill: highContrast
          ? scheme.surfaceContainerHigh
          : scheme.surfaceContainer.withValues(alpha: 0.82),
      glassBorder: highContrast
          ? scheme.outline
          : scheme.outlineVariant.withValues(alpha: 0.7),
      glassBlurSigma: highContrast ? 0 : 10,
    );
  }
}
