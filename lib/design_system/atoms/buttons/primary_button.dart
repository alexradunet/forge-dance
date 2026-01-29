import 'package:flutter/material.dart';

import '../../../../design_system/tokens/app_colors.dart';
import '../../../../design_system/tokens/app_spacing.dart';
import '../../../../design_system/tokens/app_typography.dart';
import '../../../../features/common/ui/widgets/material_ink_well.dart';

/// Primary button atom - Forge Fire filled button for main CTAs
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final Color? textColor;
  final Color? backgroundColor;
  final double? height;
  final bool isEnabled;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.textColor,
    this.backgroundColor,
    this.height,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final txtColor = textColor ?? AppColors.crystalWhite;
    final bgColor = backgroundColor ?? AppColors.forgeFire;
    final buttonHeight = height ?? 48.0;

    return Container(
      height: buttonHeight,
      decoration: BoxDecoration(
        color: isEnabled ? bgColor : AppColors.gray400,
        borderRadius: BorderRadius.circular(24),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: bgColor.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: MaterialInkWell(
        onTap: isEnabled ? onPressed : null,
        radius: 24,
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: (buttonHeight - 20) / 2,
          ),
          child: icon != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    icon!,
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      text,
                      style: AppTheme.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isEnabled ? txtColor : AppColors.gray600,
                      ),
                    ),
                  ],
                )
              : Text(
                  text,
                  style: AppTheme.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isEnabled ? txtColor : AppColors.gray600,
                  ),
                ),
        ),
      ),
    );
  }
}
