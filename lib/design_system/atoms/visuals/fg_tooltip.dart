import 'package:flutter/material.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_typography.dart';
import '../../tokens/app_border_radius.dart';
import '../../tokens/app_shadows.dart';

/// A customized tooltip atom.
///
/// Displays an informative message on long press (mobile) or hover (desktop).
class FgTooltip extends StatelessWidget {
  final String message;
  final Widget child;
  final Duration? waitDuration;

  const FgTooltip({
    super.key,
    required this.message,
    required this.child,
    this.waitDuration,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      waitDuration: waitDuration,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.gray800,
        borderRadius: AppBorderRadius.small,
        boxShadow: [AppShadows.shadowMd],
        border: Border.all(color: AppColors.gray700),
      ),
      textStyle: AppTheme.label.copyWith(
        color: AppColors.textMain,
        fontSize: 12,
      ),
      child: child,
    );
  }
}
