import 'package:flutter/material.dart';

import '../../../../design_system/tokens/app_colors.dart';
import '../../../../design_system/tokens/app_spacing.dart';
import '../../../../design_system/tokens/app_typography.dart';

/// Text input atom - Standard text field with icon, label, and error state
class TextInputAtom extends StatelessWidget {
  final String? label;
  final String? hint;
  final IconData? icon;
  final TextEditingController? controller;
  final String? errorText;
  final bool isEnabled;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const TextInputAtom({
    super.key,
    this.label,
    this.hint,
    this.icon,
    this.controller,
    this.errorText,
    this.isEnabled = true,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 16,
                    color: hasError ? AppColors.passionRed : AppColors.gray400,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                ],
                Text(
                  label!,
                  style: AppTheme.bodySmall.copyWith(
                    color: hasError ? AppColors.passionRed : AppColors.gray400,
                  ),
                ),
              ],
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.gray800,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasError
                  ? AppColors.passionRed
                  : AppColors.gray700,
              width: 1,
            ),
          ),
          child: TextField(
            controller: controller,
            enabled: isEnabled,
            keyboardType: keyboardType,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            style: AppTheme.body.copyWith(
              color: AppColors.crystalWhite,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTheme.body.copyWith(
                color: AppColors.gray500,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              border: InputBorder.none,
              suffixIcon: hasError
                  ? const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.passionRed,
                      size: 20,
                    )
                  : null,
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(
              errorText!,
              style: AppTheme.caption.copyWith(
                color: AppColors.passionRed,
              ),
            ),
          ),
      ],
    );
  }
}
