import 'package:flutter/material.dart';

import '../../tokens/app_colors.dart';
import '../../tokens/app_spacing.dart';
import '../../tokens/app_typography.dart';
import '../../atoms/buttons/fg_button.dart';

/// Empty state atom - With icon, title, description, and optional CTA
class FgEmpty extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;

  const FgEmpty({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onAction,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final icnColor = iconColor ?? AppColors.forgeFire;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: AppColors.gray800,
              shape: BoxShape.circle,
              border: Border.all(
                color: icnColor.withOpacity(0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: icnColor.withOpacity(0.1),
                  blurRadius: 80,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 48,
              color: icnColor,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            title,
            style: AppTheme.h3.copyWith(
              color: AppColors.crystalWhite,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            description,
            style: AppTheme.bodySmall.copyWith(
              color: AppColors.gray400,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: AppSpacing.xxl),
            SizedBox(
              width: 200,
              child: FgButton(
                text: actionLabel!,
                onPressed: onAction,
                variant: FgButtonVariant.primary,
                icon: const Icon(
                  Icons.local_fire_department,
                  size: 20,
                  color: AppColors.crystalWhite,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
