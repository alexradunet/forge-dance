import 'package:flutter/material.dart';

import '../../tokens/app_colors.dart';
import '../../tokens/app_typography.dart';
import '../../tokens/app_border_radius.dart';
import '../../tokens/app_spacing.dart';

class AppInput extends StatelessWidget {
  final String? label;
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final bool isEnabled;
  final bool autofocus;

  const AppInput({
    super.key,
    this.label,
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.onChanged,
    this.keyboardType,
    this.isEnabled = true,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTypography.label.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        TextField(
          controller: controller,
          onChanged: onChanged,
          obscureText: obscureText,
          keyboardType: keyboardType,
          enabled: isEnabled,
          autofocus: autofocus,
          style: AppTypography.body.copyWith(
            color: AppColors.textMain,
          ),
          cursorColor: AppColors.forgeFire,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTypography.body.copyWith(
              color: AppColors.textDark,
            ),
            errorText: errorText,
            errorStyle: AppTypography.caption.copyWith(
              color: AppColors.passionRed,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            filled: true,
            fillColor: AppColors.surfaceDark.withOpacity(0.5),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            enabledBorder: OutlineInputBorder(
              borderRadius: AppBorderRadius.medium,
              borderSide: const BorderSide(
                color: AppColors.neutral700,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppBorderRadius.medium,
              borderSide: const BorderSide(
                color: AppColors.forgeFire,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppBorderRadius.medium,
              borderSide: const BorderSide(
                color: AppColors.passionRed,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: AppBorderRadius.medium,
              borderSide: const BorderSide(
                color: AppColors.passionRed,
                width: 1.5,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: AppBorderRadius.medium,
              borderSide: BorderSide(
                color: AppColors.neutral700.withOpacity(0.5),
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
