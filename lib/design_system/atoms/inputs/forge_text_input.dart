import 'package:flutter/material.dart';

import '../../tokens/app_colors.dart';
import '../../tokens/app_typography.dart';
import '../../tokens/app_animation.dart';
import '../../tokens/app_border_radius.dart';

/// Text input atom - Styled text field with focus states, icon support, and glow
/// Based on HTML mockup: forge.dance_home_dashboard_5 (search input styling)
class ForgeTextInput extends StatefulWidget {
  final String? placeholder;
  final String? label;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final IconData? prefixIcon;
  final Widget? suffixWidget;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool isEnabled;
  final bool autofocus;
  final FocusNode? focusNode;
  final int? maxLines;
  final int? maxLength;
  final String? errorText;
  final String? helperText;

  const ForgeTextInput({
    super.key,
    this.placeholder,
    this.label,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.prefixIcon,
    this.suffixWidget,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.isEnabled = true,
    this.autofocus = false,
    this.focusNode,
    this.maxLines = 1,
    this.maxLength,
    this.errorText,
    this.helperText,
  });

  @override
  State<ForgeTextInput> createState() => _ForgeTextInputState();
}

class _ForgeTextInputState extends State<ForgeTextInput> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              widget.label!.toUpperCase(),
              style: AppTypography.overline.copyWith(
                color: hasError
                    ? AppColors.passionRed
                    : _isFocused
                        ? AppColors.forgeFire
                        : AppColors.textMuted,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

        // Input container with glow effect
        AnimatedContainer(
          duration: AppAnimation.fast,
          curve: AppAnimation.easeOut,
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: AppBorderRadius.extraLarge,
            border: Border.all(
              color: hasError
                  ? AppColors.passionRed
                  : _isFocused
                      ? AppColors.forgeFire.withAlpha((0.5 * 255).round())
                      : AppColors.crystalWhite.withAlpha((0.1 * 255).round()),
              width: _isFocused ? 1.5 : 1,
            ),
            boxShadow: _isFocused && !hasError
                ? [
                    BoxShadow(
                      color: AppColors.forgeFire.withAlpha((0.2 * 255).round()),
                      blurRadius: 12,
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              // Prefix icon
              if (widget.prefixIcon != null)
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Icon(
                    widget.prefixIcon,
                    color: _isFocused
                        ? AppColors.crystalWhite
                        : AppColors.textMuted,
                    size: 20,
                  ),
                ),

              // Text field
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  obscureText: widget.obscureText,
                  keyboardType: widget.keyboardType,
                  enabled: widget.isEnabled,
                  autofocus: widget.autofocus,
                  maxLines: widget.maxLines,
                  maxLength: widget.maxLength,
                  style: AppTypography.bodySmall.copyWith(
                    color: widget.isEnabled
                        ? AppColors.crystalWhite
                        : AppColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                  cursorColor: AppColors.forgeFire,
                  decoration: InputDecoration(
                    hintText: widget.placeholder,
                    hintStyle: AppTypography.bodySmall.copyWith(
                      color: AppColors.textMuted.withAlpha((0.6 * 255).round()),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: widget.prefixIcon != null ? 12 : 16,
                      vertical: 14,
                    ),
                    counterText: '', // Hide character counter
                  ),
                ),
              ),

              // Suffix widget
              if (widget.suffixWidget != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: widget.suffixWidget,
                ),
            ],
          ),
        ),

        // Error or helper text
        if (widget.errorText != null || widget.helperText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              widget.errorText ?? widget.helperText ?? '',
              style: AppTypography.caption.copyWith(
                color: hasError ? AppColors.passionRed : AppColors.textMuted,
                fontSize: 11,
              ),
            ),
          ),
      ],
    );
  }
}

/// Search input variant with filter button
class ForgeSearchInput extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onFilterPressed;
  final String placeholder;
  final bool showFilterButton;

  const ForgeSearchInput({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onFilterPressed,
    this.placeholder = 'Search...',
    this.showFilterButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return ForgeTextInput(
      controller: controller,
      placeholder: placeholder,
      prefixIcon: Icons.search,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      suffixWidget: showFilterButton
          ? GestureDetector(
              onTap: onFilterPressed,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.crystalWhite.withAlpha((0.05 * 255).round()),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.tune,
                  color: AppColors.textMuted,
                  size: 18,
                ),
              ),
            )
          : null,
    );
  }
}
