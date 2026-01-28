import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_theme.dart';
import '../../../../features/common/ui/widgets/material_ink_well.dart';

/// Secondary button atom - Outlined button with Electric Blue border
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final Color? borderColor;
  final Color? textColor;
  final double? height;
  final bool isEnabled;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.borderColor,
    this.textColor,
    this.height,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final border = borderColor ?? AppColors.electricBlue;
    final txtColor = textColor ?? AppColors.electricBlue;
    final buttonHeight = height ?? 40.0;

    return Container(
      height: buttonHeight,
      decoration: BoxDecoration(
        color: isEnabled ? Colors.transparent : AppColors.gray800,
        border: Border.all(
          color: isEnabled ? border : AppColors.gray600,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: MaterialInkWell(
        onTap: isEnabled ? onPressed : null,
        radius: 12,
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
