import 'package:flutter/material.dart';

import '../../../design_system/tokens/app_colors.dart';
import '../../../design_system/tokens/app_spacing.dart';
import '../../../design_system/tokens/app_typography.dart';

/// Toast notification molecule - Success, error, info variants with icons
class ToastNotification extends StatelessWidget {
  final String title;
  final String? message;
  final ToastType type;
  final IconData? icon;

  const ToastNotification({
    super.key,
    required this.title,
    this.message,
    this.type = ToastType.success,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color borderColor;
    Color iconColor;
    IconData defaultIcon;

    switch (type) {
      case ToastType.success:
        backgroundColor = AppColors.gray800;
        borderColor = AppColors.growthGreen;
        iconColor = AppColors.growthGreen;
        defaultIcon = Icons.check_circle;
        break;
      case ToastType.error:
        backgroundColor = AppColors.gray800;
        borderColor = AppColors.passionRed;
        iconColor = AppColors.passionRed;
        defaultIcon = Icons.error;
        break;
      case ToastType.info:
        backgroundColor = AppColors.gray800;
        borderColor = AppColors.electricBlue;
        iconColor = AppColors.electricBlue;
        defaultIcon = Icons.info;
        break;
      case ToastType.warning:
        backgroundColor = AppColors.gray800;
        borderColor = AppColors.warningAmber;
        iconColor = AppColors.warningAmber;
        defaultIcon = Icons.warning;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(color: borderColor, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: borderColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon ?? defaultIcon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.h6.copyWith(
                    color: AppColors.crystalWhite,
                  ),
                ),
                if (message != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    message!,
                    style: AppTheme.bodySmall.copyWith(
                      color: AppColors.gray400,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum ToastType {
  success,
  error,
  info,
  warning,
}
