import 'package:flutter/material.dart';

import '../../tokens/app_colors.dart';
import '../../tokens/app_animation.dart';
import '../../tokens/app_sizes.dart';

/// Toggle switch atom - Binary on/off control with glow effect
/// Based on HTML mockup: forge.dance_home_dashboard_7 (01. Toggles)
class FgToggle extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool isEnabled;

  const FgToggle({
    super.key,
    required this.value,
    this.onChanged,
    this.isEnabled = true,
  });

  @override
  State<FgToggle> createState() => _FgToggleState();
}

class _FgToggleState extends State<FgToggle> {
  @override
  Widget build(BuildContext context) {
    final isActive = widget.value;
    final isEnabled = widget.isEnabled;

    return GestureDetector(
      onTap: isEnabled
          ? () {
              widget.onChanged?.call(!widget.value);
            }
          : null,
      child: AnimatedContainer(
        duration: AppAnimation.fast,
        curve: AppAnimation.easeOut,
        width: AppSizes.toggleWidth,
        height: AppSizes.toggleHeight,
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.forgeFire
              : isEnabled
                  ? AppColors.neutral700
                  : AppColors.neutral800,
          borderRadius: BorderRadius.circular(AppSizes.toggleHeight / 2),
          border: !isActive && isEnabled
              ? Border.all(color: AppColors.borderSubtle, width: 1)
              : null,
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.forgeFire.withOpacity(0.4),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: AnimatedAlign(
          duration: AppAnimation.fast,
          curve: AppAnimation.easeOut,
          alignment: isActive ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.all(2),
            width: AppSizes.toggleThumbSize,
            height: AppSizes.toggleThumbSize,
            decoration: BoxDecoration(
              color: isEnabled ? AppColors.crystalWhite : AppColors.textMuted,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x26000000),
                  blurRadius: 4,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Toggle list item - Toggle with label and description
class ToggleListItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool isEnabled;

  const ToggleListItem({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    this.onChanged,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isEnabled ? AppColors.textMain : AppColors.textMuted,
                  ),
                ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          FgToggle(
            value: value,
            onChanged: onChanged,
            isEnabled: isEnabled,
          ),
        ],
      ),
    );
  }
}
