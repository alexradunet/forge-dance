import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../features/common/ui/widgets/material_ink_well.dart';

/// Icon button atom - Square or circular icon buttons with variants
class IconButtonAtom extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final bool isCircular;
  final bool isEnabled;

  const IconButtonAtom({
    super.key,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = 48,
    this.isCircular = false,
    this.isEnabled = true,
  });

  const IconButtonAtom.filled({
    super.key,
    required this.icon,
    this.onPressed,
    Color? backgroundColor,
    Color? iconColor,
    this.size = 48,
    this.isEnabled = true,
  })  : backgroundColor = backgroundColor ?? AppColors.forgeFire,
        iconColor = iconColor ?? AppColors.crystalWhite,
        isCircular = false;

  const IconButtonAtom.outlined({
    super.key,
    required this.icon,
    this.onPressed,
    Color? borderColor,
    Color? iconColor,
    this.size = 48,
    this.isEnabled = true,
  })  : backgroundColor = Colors.transparent,
        iconColor = iconColor ?? AppColors.electricBlue,
        isCircular = false;

  const IconButtonAtom.ghost({
    super.key,
    required this.icon,
    this.onPressed,
    Color? iconColor,
    this.size = 48,
    this.isEnabled = true,
  })  : backgroundColor = AppColors.gray800,
        iconColor = iconColor ?? AppColors.crystalWhite,
        isCircular = false;

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? AppColors.gray800;
    final icnColor = iconColor ?? AppColors.crystalWhite;
    final borderRadius = isCircular ? size / 2 : 12.0;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isEnabled ? bgColor : AppColors.gray800,
        borderRadius: BorderRadius.circular(borderRadius),
        border: backgroundColor == Colors.transparent
            ? Border.all(
                color: isEnabled ? AppColors.electricBlue : AppColors.gray600,
                width: 1,
              )
            : null,
        boxShadow: backgroundColor == AppColors.forgeFire && isEnabled
            ? [
                BoxShadow(
                  color: AppColors.forgeFire.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: MaterialInkWell(
        onTap: isEnabled ? onPressed : null,
        radius: borderRadius,
        child: Icon(
          icon,
          color: isEnabled ? icnColor : AppColors.gray600,
          size: size * 0.5,
        ),
      ),
    );
  }
}
