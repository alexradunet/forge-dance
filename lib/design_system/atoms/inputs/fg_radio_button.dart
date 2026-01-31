import 'package:flutter/material.dart';

import '../../tokens/app_colors.dart';
import '../../tokens/app_animation.dart';
import '../../tokens/app_sizes.dart';

/// Radio button atom - Single selection control with glow effect
/// Based on HTML mockup: forge.dance_home_dashboard_7 (02. Radio Buttons)
class FgFgRadioButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback? onTap;
  final bool isEnabled;

  const FgFgRadioButton({
    super.key,
    required this.isSelected,
    this.onTap,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: AnimatedContainer(
        duration: AppAnimation.fast,
        curve: AppAnimation.easeOut,
        width: AppSizes.radioSize,
        height: AppSizes.radioSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected
                ? AppColors.forgeFire
                : isEnabled
                    ? AppColors.neutral600
                    : AppColors.neutral700,
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.forgeFire.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: AnimatedContainer(
            duration: AppAnimation.fast,
            curve: AppAnimation.easeOut,
            width: isSelected ? 10 : 0,
            height: isSelected ? 10 : 0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? AppColors.forgeFire : Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}

/// Radio list item - Radio with label and card styling
class RadioListItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool isEnabled;

  const RadioListItem({
    super.key,
    required this.label,
    required this.isSelected,
    this.onTap,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: AnimatedContainer(
        duration: AppAnimation.fast,
        curve: AppAnimation.easeOut,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppColors.forgeFire.withOpacity(0.5)
                : AppColors.borderSubtle,
            width: 1,
          ),
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    AppColors.forgeFire.withOpacity(0.05),
                    Colors.transparent,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? AppColors.textMain
                    : isEnabled
                        ? AppColors.textMuted
                        : AppColors.neutral600,
              ),
            ),
            FgFgRadioButton(
              isSelected: isSelected,
              isEnabled: isEnabled,
            ),
          ],
        ),
      ),
    );
  }
}
