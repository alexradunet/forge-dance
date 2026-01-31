import 'package:flutter/material.dart';

import '../../tokens/app_colors.dart';
import '../../tokens/app_typography.dart';
import '../../tokens/app_animation.dart';
import '../../tokens/app_border_radius.dart';

enum FgInputVariant {
  standard,
  password,
  search,
  multiline,
}

class FgInput extends StatefulWidget {
  final String? label;
  final String? placeholder;
  final String? errorText;
  final String? helperText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final IconData? prefixIcon;
  final Widget? suffixWidget;
  final bool isEnabled;
  final bool autofocus;
  final FocusNode? focusNode;
  final FgInputVariant variant;

  const FgInput({
    super.key,
    this.label,
    this.placeholder,
    this.errorText,
    this.helperText,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.prefixIcon,
    this.suffixWidget,
    this.isEnabled = true,
    this.autofocus = false,
    this.focusNode,
    this.variant = FgInputVariant.standard,
  });

  factory FgInput.password({
    Key? key,
    String? label = 'Password',
    String? placeholder = 'Enter password',
    TextEditingController? controller,
    String? errorText,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    bool isEnabled = true,
  }) {
    return FgInput(
      key: key,
      label: label,
      placeholder: placeholder,
      controller: controller,
      errorText: errorText,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      isEnabled: isEnabled,
      prefixIcon: Icons.lock_outline,
      variant: FgInputVariant.password,
    );
  }

  factory FgInput.search({
    Key? key,
    String? placeholder = 'Search...',
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    VoidCallback? onClear,
    bool isEnabled = true,
    bool showFilter = false,
    VoidCallback? onFilterPressed,
  }) {
    return FgInput(
      key: key,
      placeholder: placeholder,
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      isEnabled: isEnabled,
      prefixIcon: Icons.search,
      variant: FgInputVariant.search,
      suffixWidget: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (controller != null && onClear != null)
            _ClearButton(controller: controller, onClear: onClear),
          if (showFilter && onFilterPressed != null) ...[
            const SizedBox(width: 8),
            _FilterButton(onPressed: onFilterPressed),
          ],
        ],
      ),
    );
  }

  factory FgInput.multiline({
    Key? key,
    String? label,
    String? placeholder,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    bool isEnabled = true,
  }) {
    return FgInput(
      key: key,
      label: label,
      placeholder: placeholder,
      controller: controller,
      onChanged: onChanged,
      isEnabled: isEnabled,
      variant: FgInputVariant.multiline,
    );
  }

  @override
  State<FgInput> createState() => _FgInputState();
}

class _FgInputState extends State<FgInput> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);

    if (widget.variant == FgInputVariant.password) {
      _obscureText = true;
    }
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
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    final isMultimedia = widget.variant == FgInputVariant.multiline;

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
                      ? AppColors.forgeFire.withAlpha(128)
                      : AppColors.crystalWhite.withAlpha(26),
              width: _isFocused ? 1.5 : 1,
            ),
            boxShadow: _isFocused && !hasError
                ? [
                    BoxShadow(
                      color: AppColors.forgeFire.withAlpha(51),
                      blurRadius: 12,
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: Row(
            crossAxisAlignment: isMultimedia
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              // Prefix icon
              if (widget.prefixIcon != null)
                Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    top: isMultimedia ? 14 : 0,
                  ),
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
                  obscureText: _obscureText,
                  keyboardType: isMultimedia
                      ? TextInputType.multiline
                      : TextInputType.text,
                  enabled: widget.isEnabled,
                  autofocus: widget.autofocus,
                  maxLines: isMultimedia ? 5 : 1,
                  minLines: isMultimedia ? 3 : 1,
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
                      color: AppColors.textMuted.withAlpha(153),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: widget.prefixIcon != null ? 12 : 16,
                      vertical: 14,
                    ),
                    isDense: true,
                  ),
                ),
              ),

              // Suffix widget
              if (widget.variant == FgInputVariant.password)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.textMuted,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                )
              else if (widget.suffixWidget != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: widget.suffixWidget,
                ),
            ],
          ),
        ),

        // Error or helper text
        if (hasError || widget.helperText != null)
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

class _ClearButton extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onClear;

  const _ClearButton({required this.controller, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, child) {
        if (value.text.isEmpty) return const SizedBox.shrink();

        return IconButton(
          icon: const Icon(Icons.close, color: AppColors.textMuted, size: 18),
          onPressed: () {
            controller.clear();
            onClear();
          },
        );
      },
    );
  }
}

class _FilterButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _FilterButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.crystalWhite.withAlpha(13),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.tune,
          color: AppColors.textMuted,
          size: 18,
        ),
      ),
    );
  }
}
