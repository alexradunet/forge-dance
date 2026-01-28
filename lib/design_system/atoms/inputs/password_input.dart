import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_theme.dart';
import '../../../../features/common/ui/widgets/material_ink_well.dart';

/// Password input atom - Text input with visibility toggle
class PasswordInputAtom extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? errorText;
  final bool isEnabled;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const PasswordInputAtom({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.errorText,
    this.isEnabled = true,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  State<PasswordInputAtom> createState() => _PasswordInputAtomState();
}

class _PasswordInputAtomState extends State<PasswordInputAtom> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              children: [
                const Icon(
                  Icons.lock,
                  size: 16,
                  color: AppColors.gray400,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  widget.label!,
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
            controller: widget.controller,
            enabled: widget.isEnabled,
            obscureText: _obscureText,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
            style: AppTheme.body.copyWith(
              color: AppColors.crystalWhite,
            ),
            decoration: InputDecoration(
              hintText: widget.hint ?? 'Password',
              hintStyle: AppTheme.body.copyWith(
                color: AppColors.gray500,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              border: InputBorder.none,
              suffixIcon: MaterialInkWell(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                radius: 20,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.gray400,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(
              widget.errorText!,
              style: AppTheme.caption.copyWith(
                color: AppColors.passionRed,
              ),
            ),
          ),
      ],
    );
  }
}
