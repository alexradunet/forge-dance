import 'dart:ui' show SemanticsValidationResult;

import 'package:flutter/material.dart';

import '../../theme/forge_theme_extensions.dart';
import '../../tokens/app_sizes.dart';
import '../../tokens/app_spacing.dart';
import '../typography/fg_label.dart';

enum FgInputVariant { standard, password, search, multiline }

/// Forge text-entry primitive backed by [TextFormField].
///
/// Feature code owns validation and localized copy. This module owns semantic
/// state, Material interaction behavior, target sizing, and theme integration.
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
    this.isEnabled = true,
    this.isRequired = false,
    this.autofocus = false,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.textCapitalization = TextCapitalization.none,
    this.readOnly = false,
    this.onTap,
    this.isLoading = false,
    this.loadingSemanticsLabel,
  }) : variant = FgInputVariant.standard,
       showPasswordSemanticsLabel = null,
       hidePasswordSemanticsLabel = null,
       _onClear = null,
       _clearSemanticsLabel = null,
       _showFilter = false,
       _onFilterPressed = null,
       _filterSemanticsLabel = null,
       assert(
         !isLoading || loadingSemanticsLabel != null,
         'Loading FgInput requires a loadingSemanticsLabel.',
       );

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
    bool autofocus = false,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
    Iterable<String>? autofillHints,
    TextCapitalization textCapitalization = TextCapitalization.none,
    bool readOnly = false,
    VoidCallback? onTap,
    bool isLoading = false,
    String? loadingSemanticsLabel,
    required String showPasswordSemanticsLabel,
    required String hidePasswordSemanticsLabel,
  }) {
    return FgInput._internal(
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
      autofocus: autofocus,
      focusNode: focusNode,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      textCapitalization: textCapitalization,
      readOnly: readOnly,
      onTap: onTap,
      isLoading: isLoading,
      loadingSemanticsLabel: loadingSemanticsLabel,
      prefixIcon: Icons.lock_outline_rounded,
      variant: FgInputVariant.password,
      showPasswordSemanticsLabel: showPasswordSemanticsLabel,
      hidePasswordSemanticsLabel: hidePasswordSemanticsLabel,
    );
  }

  factory FgInput.search({
    Key? key,
    String? label,
    String? placeholder,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    VoidCallback? onClear,
    String? clearSemanticsLabel,
    bool isEnabled = true,
    bool autofocus = false,
    FocusNode? focusNode,
    bool readOnly = false,
    VoidCallback? onTap,
    bool isLoading = false,
    String? loadingSemanticsLabel,
    bool showFilter = false,
    VoidCallback? onFilterPressed,
    String? filterSemanticsLabel,
  }) {
    assert(
      onClear == null || clearSemanticsLabel != null,
      'Search clear actions require a clearSemanticsLabel.',
    );
    assert(
      !showFilter || onFilterPressed == null || filterSemanticsLabel != null,
      'Search filter actions require a filterSemanticsLabel.',
    );

    return FgInput._internal(
      key: key,
      label: label,
      placeholder: placeholder,
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      isEnabled: isEnabled,
      autofocus: autofocus,
      focusNode: focusNode,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      readOnly: readOnly,
      onTap: onTap,
      isLoading: isLoading,
      loadingSemanticsLabel: loadingSemanticsLabel,
      prefixIcon: Icons.search_rounded,
      variant: FgInputVariant.search,
      onClear: onClear,
      clearSemanticsLabel: clearSemanticsLabel,
      showFilter: showFilter,
      onFilterPressed: onFilterPressed,
      filterSemanticsLabel: filterSemanticsLabel,
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
    ValueChanged<String>? onSubmitted,
    bool isEnabled = true,
    bool isRequired = false,
    bool autofocus = false,
    FocusNode? focusNode,
    Iterable<String>? autofillHints,
    TextCapitalization textCapitalization = TextCapitalization.sentences,
    bool readOnly = false,
    VoidCallback? onTap,
    bool isLoading = false,
    String? loadingSemanticsLabel,
  }) {
    return FgInput._internal(
      key: key,
      label: label,
      placeholder: placeholder,
      errorText: errorText,
      helperText: helperText,
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      isEnabled: isEnabled,
      isRequired: isRequired,
      autofocus: autofocus,
      focusNode: focusNode,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      autofillHints: autofillHints,
      textCapitalization: textCapitalization,
      readOnly: readOnly,
      onTap: onTap,
      isLoading: isLoading,
      loadingSemanticsLabel: loadingSemanticsLabel,
      variant: FgInputVariant.multiline,
    );
  }

  const FgInput._internal({
    super.key,
    this.label,
    this.placeholder,
    this.errorText,
    this.helperText,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.prefixIcon,
    this.isEnabled = true,
    this.isRequired = false,
    this.autofocus = false,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.textCapitalization = TextCapitalization.none,
    this.readOnly = false,
    this.onTap,
    this.isLoading = false,
    this.loadingSemanticsLabel,
    required this.variant,
    this.showPasswordSemanticsLabel,
    this.hidePasswordSemanticsLabel,
    this._onClear,
    this._clearSemanticsLabel,
    this._showFilter = false,
    this._onFilterPressed,
    this._filterSemanticsLabel,
  }) : assert(
         variant != FgInputVariant.password ||
             (showPasswordSemanticsLabel != null &&
                 hidePasswordSemanticsLabel != null),
         'Password inputs require show and hide semantic labels.',
       ),
       assert(
         !isLoading || loadingSemanticsLabel != null,
         'Loading FgInput requires a loadingSemanticsLabel.',
       );

  final String? label;
  final String? placeholder;
  final String? errorText;
  final String? helperText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final IconData? prefixIcon;
  final bool isEnabled;
  final bool isRequired;
  final bool autofocus;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final TextCapitalization textCapitalization;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool isLoading;
  final String? loadingSemanticsLabel;
  final FgInputVariant variant;
  final String? showPasswordSemanticsLabel;
  final String? hidePasswordSemanticsLabel;
  final VoidCallback? _onClear;
  final String? _clearSemanticsLabel;
  final bool _showFilter;
  final VoidCallback? _onFilterPressed;
  final String? _filterSemanticsLabel;

  @override
  State<FgInput> createState() => _FgInputState();
}

class _FgInputState extends State<FgInput> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.variant == FgInputVariant.password;
  }

  @override
  void didUpdateWidget(covariant FgInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.variant != widget.variant) {
      _obscureText = widget.variant == FgInputVariant.password;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final motion = context.forgeMotion;
    final isMultiline = widget.variant == FgInputVariant.multiline;
    final effectiveEnabled = widget.isEnabled && !widget.isLoading;
    final suffix = _buildSuffix();

    final field = TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      onTap: widget.onTap,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      textInputAction: widget.textInputAction,
      autofillHints: widget.autofillHints,
      textCapitalization: widget.textCapitalization,
      autocorrect: widget.variant != FgInputVariant.password,
      enableSuggestions: widget.variant != FgInputVariant.password,
      enabled: effectiveEnabled,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      maxLines: isMultiline ? 5 : 1,
      minLines: isMultiline ? 3 : 1,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: effectiveEnabled
            ? scheme.onSurface
            : scheme.onSurface.withValues(alpha: 0.38),
      ),
      decoration: InputDecoration(
        labelText: null,
        hintText: widget.placeholder,
        helperText: widget.errorText == null ? widget.helperText : null,
        errorText: widget.errorText,
        errorMaxLines: 6,
        helperMaxLines: 6,
        alignLabelWithHint: isMultiline,
        prefixIcon: widget.prefixIcon == null ? null : Icon(widget.prefixIcon),
        suffixIcon: suffix == null
            ? null
            : AnimatedSwitcher(
                duration: motion.fast,
                switchInCurve: motion.enterCurve,
                switchOutCurve: motion.exitCurve,
                child: suffix,
              ),
        fillColor: !widget.isEnabled
            ? scheme.onSurface.withValues(alpha: 0.06)
            : widget.readOnly
            ? scheme.surfaceContainerHigh
            : null,
      ),
    );

    final semanticField = Semantics(
      label: widget.label,
      isRequired: widget.isRequired,
      validationResult: widget.errorText == null
          ? SemanticsValidationResult.none
          : SemanticsValidationResult.invalid,
      child: field,
    );

    if (widget.label == null) return semanticField;

    final labelTone = widget.errorText != null
        ? FgLabelTone.error
        : !effectiveEnabled
        ? FgLabelTone.disabled
        : FgLabelTone.neutral;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExcludeSemantics(
          child: FgLabel(
            text: widget.label!,
            isRequired: widget.isRequired,
            tone: labelTone,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        semanticField,
      ],
    );
  }

  Widget? _buildSuffix() {
    if (widget.isLoading) {
      return _InputLoadingIndicator(
        key: const ValueKey('loading'),
        semanticLabel: widget.loadingSemanticsLabel!,
      );
    }

    return switch (widget.variant) {
      FgInputVariant.password => _InputActionButton(
        key: ValueKey(_obscureText),
        icon: _obscureText
            ? Icons.visibility_outlined
            : Icons.visibility_off_outlined,
        semanticLabel: _obscureText
            ? widget.showPasswordSemanticsLabel!
            : widget.hidePasswordSemanticsLabel!,
        toggled: !_obscureText,
        onPressed: () => setState(() => _obscureText = !_obscureText),
      ),
      FgInputVariant.search => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.controller != null && widget._onClear != null)
            _ClearInputAction(
              controller: widget.controller!,
              semanticLabel: widget._clearSemanticsLabel!,
              onPressed: widget._onClear!,
            ),
          if (widget._showFilter && widget._onFilterPressed != null)
            _InputActionButton(
              icon: Icons.tune_rounded,
              semanticLabel: widget._filterSemanticsLabel!,
              onPressed: widget._onFilterPressed!,
            ),
        ],
      ),
      FgInputVariant.standard || FgInputVariant.multiline => null,
    };
  }
}

class _InputActionButton extends StatelessWidget {
  const _InputActionButton({
    super.key,
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
    this.toggled,
  });

  final IconData icon;
  final String semanticLabel;
  final VoidCallback onPressed;
  final bool? toggled;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      toggled: toggled,
      onTap: onPressed,
      child: ExcludeSemantics(
        child: IconButton(
          tooltip: semanticLabel,
          icon: Icon(icon, size: AppSizes.iconMd),
          onPressed: onPressed,
        ),
      ),
    );
  }
}

class _ClearInputAction extends StatelessWidget {
  const _ClearInputAction({
    required this.controller,
    required this.semanticLabel,
    required this.onPressed,
  });

  final TextEditingController controller;
  final String semanticLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        if (value.text.isEmpty) return const SizedBox.shrink();

        return _InputActionButton(
          icon: Icons.close_rounded,
          semanticLabel: semanticLabel,
          onPressed: () {
            controller.clear();
            onPressed();
          },
        );
      },
    );
  }
}

class _InputLoadingIndicator extends StatelessWidget {
  const _InputLoadingIndicator({super.key, required this.semanticLabel});

  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      liveRegion: true,
      child: ExcludeSemantics(
        child: Center(
          child: SizedBox.square(
            dimension: AppSizes.iconMd,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
