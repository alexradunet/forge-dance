import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../features/common/ui/widgets/custom_snack_bar.dart';
import '../design_system/tokens/app_colors.dart';

extension ThemeModeExtension on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  // ═══════════════════════════════════════════════════════════
  // FORGE DESIGN SYSTEM COLORS
  // ═══════════════════════════════════════════════════════════

  Color get primaryBackgroundColor =>
      isDarkMode ? AppColors.gray950 : AppColors.gray50;

  Color get secondaryBackgroundColor =>
      isDarkMode ? AppColors.gray900 : AppColors.gray100;

  Color get secondaryWidgetColor =>
      isDarkMode ? AppColors.gray800 : AppColors.gray50;

  Color get primaryTextColor =>
      isDarkMode ? AppColors.crystalWhite : AppColors.gray950;

  Color get secondaryTextColor =>
      isDarkMode ? AppColors.gray400 : AppColors.gray600;

  Color get dividerColor => isDarkMode ? AppColors.gray700 : AppColors.gray200;

  void showSuccessSnackBar(String text, {SnackBarAction? action}) {
    ScaffoldMessenger.of(this).showSnackBar(
      CustomSnackBar.success(text: text, action: action),
    );
  }

  void showInfoSnackBar(String text, {SnackBarAction? action}) {
    ScaffoldMessenger.of(this).showSnackBar(
      CustomSnackBar.info(text: text, action: action),
    );
  }

  void showWarningSnackBar(String text, {SnackBarAction? action}) {
    ScaffoldMessenger.of(this).showSnackBar(
      CustomSnackBar.warning(text: text, action: action),
    );
  }

  void showErrorSnackBar(String text, {SnackBarAction? action}) {
    ScaffoldMessenger.of(this).showSnackBar(
      CustomSnackBar.error(text: text, action: action),
    );
  }

  void hideKeyboard() {
    FocusScope.of(this).unfocus();
  }

  void tryLaunchUrl(String url) async {
    try {
      await launchUrl(Uri.parse(url));
    } catch (e) {
      if (mounted) {
        showErrorSnackBar('Can not open url: $url');
      }
    }
  }
}
