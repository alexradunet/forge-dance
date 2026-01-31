import 'package:flutter/material.dart';

import '../../tokens/app_colors.dart';
import '../../tokens/app_animation.dart';
import '../../tokens/app_sizes.dart';

/// Checkbox state enum for tri-state checkboxes
enum CheckboxState {
  unchecked,
  checked,
  indeterminate,
}

/// Checkbox atom - Multi-selection control with check icon and glow effect
/// Based on HTML mockup: forge.dance_home_dashboard_7 (03. Checkboxes)
class FgCheckboxItem extends StatelessWidget {
  final CheckboxState state;
  final VoidCallback? onTap;
  final bool isEnabled;

  const FgCheckboxItem({
    super.key,
    required this.state,
    this.onTap,
    this.isEnabled = true,
  });

  /// Convenience constructor for simple boolean checked state
  factory FgCheckboxItem.simple({
    Key? key,
    required bool isChecked,
    VoidCallback? onTap,
    bool isEnabled = true,
  }) {
    return FgCheckboxItem(
      key: key,
      state: isChecked ? CheckboxState.checked : CheckboxState.unchecked,
      onTap: onTap,
      isEnabled: isEnabled,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCheckedOrIndeterminate = state != CheckboxState.unchecked;

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: AnimatedContainer(
        duration: AppAnimation.fast,
        curve: AppAnimation.easeOut,
        width: AppSizes.checkboxSize,
        height: AppSizes.checkboxSize,
        decoration: BoxDecoration(
          color: isCheckedOrIndeterminate
              ? (state == CheckboxState.indeterminate
                  ? AppColors.forgeFire.withOpacity(0.8)
                  : AppColors.forgeFire)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: !isCheckedOrIndeterminate
              ? Border.all(
                  color: isEnabled ? AppColors.neutral600 : AppColors.neutral700,
                  width: 2,
                )
              : null,
          boxShadow: isCheckedOrIndeterminate
              ? [
                  BoxShadow(
                    color: AppColors.forgeFire.withOpacity(0.4),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: AppAnimation.fast,
            child: isCheckedOrIndeterminate
                ? Icon(
                    state == CheckboxState.indeterminate
                        ? Icons.remove
                        : Icons.check,
                    size: 14,
                    color: AppColors.crystalWhite,
                    key: ValueKey(state),
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}

/// Checkbox list item - Checkbox with label, description, and card styling
class CheckboxListItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final CheckboxState state;
  final VoidCallback? onTap;
  final bool isEnabled;
  final String? trailingLabel;

  const CheckboxListItem({
    super.key,
    required this.title,
    this.subtitle,
    required this.state,
    this.onTap,
    this.isEnabled = true,
    this.trailingLabel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            FgCheckboxItem(
              state: state,
              isEnabled: isEnabled,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: state == CheckboxState.checked
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: state == CheckboxState.checked
                          ? AppColors.textMain
                          : isEnabled
                              ? AppColors.textMuted
                              : AppColors.neutral600,
                    ),
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        subtitle!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (trailingLabel != null)
              Text(
                trailingLabel!,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
