import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_theme.dart';
import '../../../../features/common/ui/widgets/material_ink_well.dart';

/// Ghost button atom - Text-only button with no background or border
class GhostButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? textColor;
  final bool underline;
  final bool isEnabled;

  const GhostButton({
    super.key,
    required this.text,
    this.onPressed,
    this.textColor,
    this.underline = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final txtColor = textColor ?? AppColors.electricBlue;

    return MaterialInkWell(
      onTap: isEnabled ? onPressed : null,
      radius: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Text(
          text,
          style: AppTheme.bodySmall.copyWith(
            fontWeight: FontWeight.w500,
            color: isEnabled ? txtColor : AppColors.gray600,
            decoration: underline ? TextDecoration.underline : null,
            decorationColor: txtColor.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}
