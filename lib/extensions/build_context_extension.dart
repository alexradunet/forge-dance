import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../design_system/design_system.dart';

extension BuildContextExtension on BuildContext {
  void showSuccessSnackBar(
    String text, {
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      FgSnackBar.build(
        this,
        text: text,
        tone: FgSnackBarTone.success,
        actionLabel: actionLabel,
        onAction: onAction,
      ),
    );
  }

  void showInfoSnackBar(
    String text, {
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      FgSnackBar.build(
        this,
        text: text,
        tone: FgSnackBarTone.info,
        actionLabel: actionLabel,
        onAction: onAction,
      ),
    );
  }

  void showWarningSnackBar(
    String text, {
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      FgSnackBar.build(
        this,
        text: text,
        tone: FgSnackBarTone.warning,
        actionLabel: actionLabel,
        onAction: onAction,
      ),
    );
  }

  void showErrorSnackBar(
    String text, {
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      FgSnackBar.build(
        this,
        text: text,
        tone: FgSnackBarTone.error,
        actionLabel: actionLabel,
        onAction: onAction,
      ),
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
