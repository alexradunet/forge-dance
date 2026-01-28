import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_theme.dart';

/// Search input atom - Text input with search icon
class SearchInputAtom extends StatelessWidget {
  final String? hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;

  const SearchInputAtom({
    super.key,
    this.hint,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.gray800,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.gray700,
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        style: AppTheme.body.copyWith(
          color: AppColors.crystalWhite,
        ),
        decoration: InputDecoration(
          hintText: hint ?? 'Search exercises...',
          hintStyle: AppTheme.body.copyWith(
            color: AppColors.gray500,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.gray400,
            size: 20,
          ),
          suffixIcon: controller != null &&
                  controller!.text.isNotEmpty &&
                  onClear != null
              ? IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: AppColors.gray400,
                    size: 20,
                  ),
                  onPressed: onClear,
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
