import 'package:flutter/material.dart';

import '../../tokens/app_animation.dart';
import '../../tokens/app_border_radius.dart';
import '../../tokens/app_sizes.dart';
import '../../tokens/app_spacing.dart';
import '../../tokens/app_typography.dart';
import '../typography/fg_label.dart';

enum FgInputVariant { standard, password, search, multiline }

/// Forge Dance text-entry primitive with semantic focus, error, and disabled
/// states. Feature code owns validation and passes [errorText] when needed.
class FgInput extends StatefulWidget {
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
    this.isRequired = false,
    this.autofocus = false,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.textCapitalization = TextCapitalization.none,
    this.variant = FgInputVariant.standard,
    this.showPasswordSemanticsLabel,
    this.hidePasswordSemanticsLabel,
  });

  factory FgInput.password({
    Key? key,
    String? label,
    String? placeholder,
    TextEditingController? controller,
    String? errorText,
    String? helperText,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    bool isEnabled = true,
    bool isRequired = false,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
    Iterable<String>? autofillHints,
    String? showPasswordSemanticsLabel,
    String? hidePasswordSemanticsLabel,
  }) {
    return FgInput(
      key: key,
      label: label,
      placeholder: placeholder,
      controller: controller,
      errorText: errorText,
      helperText: helperText,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      isEnabled: isEnabled,
      isRequired: isRequired,
      focusNode: focusNode,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      prefixIcon: Icons.lock_outline_rounded,
      variant: FgInputVariant.password,
      showPasswordSemanticsLabel: showPasswordSemanticsLabel,
      hidePasswordSemanticsLabel: hidePasswordSemanticsLabel,
    );
  }

  factory FgInput.search({
    Key? key,
    String? placeholder,
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
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      prefixIcon: Icons.search_rounded,
      variant: FgInputVariant.search,
      suffixWidget: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (controller != null && onClear != null)
            _ClearButton(controller: controller, onClear: onClear),
          if (showFilter && onFilterPressed != null)
            _FilterButton(onPressed: onFilterPressed),
        ],
      ),
    );
  }

  factory FgInput.multiline({
    Key? key,
    String? label,
    String? placeholder,
    String? errorText,
    String? helperText,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    bool isEnabled = true,
    bool isRequired = false,
    TextCapitalization textCapitalization = TextCapitalization.sentences,
  }) {
    return FgInput(
      key: key,
      label: label,
      placeholder: placeholder,
      errorText: errorText,
      helperText: helperText,
      controller: controller,
      onChanged: onChanged,
      isEnabled: isEnabled,
      isRequired: isRequired,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      textCapitalization: textCapitalization,
      variant: FgInputVariant.multiline,
    );
  }

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
  final bool isRequired;
  final bool autofocus;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final TextCapitalization textCapitalization;
  final FgInputVariant variant;
  final String? showPasswordSemanticsLabel;
  final String? hidePasswordSemanticsLabel;

  @override
  State<FgInput> createState() => _FgInputState();
}

class _FgInputState extends State<FgInput> {
  late FocusNode _focusNode;
  late bool _ownsFocusNode;
  bool _isFocused = false;
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _attachFocusNode(widget.focusNode);
    _obscureText = widget.variant == FgInputVariant.password;
  }

  @override
  void didUpdateWidget(covariant FgInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      _focusNode.removeListener(_handleFocusChange);
      if (_ownsFocusNode) _focusNode.dispose();
      _attachFocusNode(widget.focusNode);
    }
    if (oldWidget.variant != widget.variant) {
      _obscureText = widget.variant == FgInputVariant.password;
    }
  }

  void _attachFocusNode(FocusNode? node) {
    _ownsFocusNode = node == null;
    _focusNode = node ?? FocusNode();
    _isFocused = _focusNode.hasFocus;
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (_ownsFocusNode) _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (mounted) setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final hasError = widget.errorText?.isNotEmpty ?? false;
    final isMultiline = widget.variant == FgInputVariant.multiline;
    final labelTone = hasError
        ? FgLabelTone.error
        : !widget.isEnabled
            ? FgLabelTone.disabled
            : _isFocused
                ? FgLabelTone.accent
                : FgLabelTone.neutral;
    final borderColor = hasError
        ? colors.error
        : _isFocused
            ? colors.primary
            : colors.onSurface.withAlpha(31);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          FgLabel(
            text: widget.label!,
            isRequired: widget.isRequired,
            tone: labelTone,
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        AnimatedContainer(
          duration: AppAnimation.fast,
          curve: AppAnimation.easeOut,
          constraints: isMultiline
              ? const BoxConstraints()
              : const BoxConstraints(minHeight: AppSizes.inputLg),
          decoration: BoxDecoration(
            color: widget.isEnabled
                ? colors.surfaceContainerHighest
                : colors.onSurface.withAlpha(13),
            borderRadius: AppBorderRadius.extraLarge,
            border: Border.all(
              color: borderColor,
              width: _isFocused || hasError ? 1.5 : 1,
            ),
            boxShadow: _isFocused && !hasError
                ? [
                    BoxShadow(
                      color: colors.primary.withAlpha(38),
                      blurRadius: AppSpacing.md,
                    ),
                  ]
                : null,
          ),
          child: Row(
            crossAxisAlignment: isMultiline
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              if (widget.prefixIcon != null)
                Padding(
                  padding: EdgeInsets.only(
                    left: AppSpacing.lg,
                    top: isMultiline ? AppSpacing.lg : 0,
                  ),
                  child: Icon(
                    widget.prefixIcon,
                    color:
                        _isFocused ? colors.primary : colors.onSurfaceVariant,
                    size: AppSizes.iconMd,
                  ),
                ),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  obscureText: _obscureText,
                  keyboardType: widget.keyboardType ??
                      (isMultiline
                          ? TextInputType.multiline
                          : TextInputType.text),
                  textInputAction: widget.textInputAction,
                  autofillHints: widget.autofillHints,
                  textCapitalization: widget.textCapitalization,
                  autocorrect: widget.variant != FgInputVariant.password,
                  enableSuggestions: widget.variant != FgInputVariant.password,
                  enabled: widget.isEnabled,
                  autofocus: widget.autofocus,
                  maxLines: isMultiline ? 5 : 1,
                  minLines: isMultiline ? 3 : 1,
                  style: AppTypography.bodySmall.copyWith(
                    color: widget.isEnabled
                        ? colors.onSurface
                        : colors.onSurface.withAlpha(97),
                    fontWeight: FontWeight.w500,
                  ),
                  cursorColor: colors.primary,
                  decoration: InputDecoration(
                    hintText: widget.placeholder,
                    hintStyle: AppTypography.bodySmall.copyWith(
                      color: colors.onSurfaceVariant.withAlpha(153),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: widget.prefixIcon == null
                          ? AppSpacing.lg
                          : AppSpacing.md,
                      vertical: AppSpacing.lg,
                    ),
                    isDense: true,
                  ),
                ),
              ),
              if (widget.variant == FgInputVariant.password)
                _PasswordVisibilityButton(
                  isObscured: _obscureText,
                  showLabel: widget.showPasswordSemanticsLabel,
                  hideLabel: widget.hidePasswordSemanticsLabel,
                  onPressed: () {
                    setState(() => _obscureText = !_obscureText);
                  },
                )
              else if (widget.suffixWidget != null)
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: widget.suffixWidget,
                ),
            ],
          ),
        ),
        if (hasError || widget.helperText != null)
          Padding(
            padding: const EdgeInsets.only(
              top: AppSpacing.sm,
              left: AppSpacing.xs,
            ),
            child: Semantics(
              liveRegion: hasError,
              child: Text(
                widget.errorText ?? widget.helperText!,
                style: AppTypography.caption.copyWith(
                  color: hasError ? colors.error : colors.onSurfaceVariant,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _PasswordVisibilityButton extends StatelessWidget {
  const _PasswordVisibilityButton({
    required this.isObscured,
    required this.onPressed,
    this.showLabel,
    this.hideLabel,
  });

  final bool isObscured;
  final VoidCallback onPressed;
  final String? showLabel;
  final String? hideLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: isObscured ? showLabel : hideLabel,
      child: IconButton(
        icon: Icon(
          isObscured
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          size: AppSizes.iconMd,
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class _ClearButton extends StatelessWidget {
  const _ClearButton({required this.controller, required this.onClear});

  final TextEditingController controller;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, child) {
        if (value.text.isEmpty) return const SizedBox.shrink();

        return IconButton(
          icon: Icon(
            Icons.close_rounded,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            size: AppSizes.iconSm,
          ),
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
  const _FilterButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.tune_rounded,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        size: AppSizes.iconSm,
      ),
      onPressed: onPressed,
    );
  }
}
