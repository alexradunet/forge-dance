import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../features/common/ui/widgets/material_ink_well.dart';

/// FAB (Floating Action Button) atom - Circular, floating primary action
class FabButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final bool isEnabled;

  const FabButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = 56,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? AppColors.forgeFire;
    final icnColor = iconColor ?? AppColors.crystalWhite;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isEnabled ? bgColor : AppColors.gray400,
        shape: BoxShape.circle,
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: bgColor.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: MaterialInkWell(
        onTap: isEnabled ? onPressed : null,
        radius: size / 2,
        child: Icon(
          icon,
          color: isEnabled ? icnColor : AppColors.gray600,
          size: size * 0.4,
        ),
      ),
    );
  }
}
