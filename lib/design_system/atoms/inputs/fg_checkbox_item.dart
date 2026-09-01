import 'package:flutter/material.dart';

/// Visual and semantic states supported by [FgCheckboxItem].
enum FgCheckboxState { unchecked, checked, indeterminate }

/// Semantic tri-state checkbox backed by Flutter's adaptive checkbox.
///
/// The caller owns [semanticLabel] so assistive text remains localized and
/// describes the selected option rather than the generic control type.
class FgCheckboxItem extends StatelessWidget {
  const FgCheckboxItem({
    super.key,
    required this.state,
    required this.semanticLabel,
    this.onTap,
    this.isEnabled = true,
    this.focusNode,
    this.autofocus = false,
  });

  factory FgCheckboxItem.simple({
    Key? key,
    required bool isChecked,
    required String semanticLabel,
    VoidCallback? onTap,
    bool isEnabled = true,
    FocusNode? focusNode,
    bool autofocus = false,
  }) {
    return FgCheckboxItem(
      key: key,
      state: isChecked ? FgCheckboxState.checked : FgCheckboxState.unchecked,
      semanticLabel: semanticLabel,
      onTap: onTap,
      isEnabled: isEnabled,
      focusNode: focusNode,
      autofocus: autofocus,
    );
  }

  final FgCheckboxState state;
  final String semanticLabel;
  final VoidCallback? onTap;
  final bool isEnabled;
  final FocusNode? focusNode;
  final bool autofocus;

  bool? get _value => switch (state) {
        FgCheckboxState.unchecked => false,
        FgCheckboxState.checked => true,
        FgCheckboxState.indeterminate => null,
      };

  @override
  Widget build(BuildContext context) {
    final effectiveOnChanged = isEnabled && onTap != null
        ? (bool? _) => onTap!()
        : null;

    return MergeSemantics(
      child: Semantics(
        label: semanticLabel,
        child: Checkbox.adaptive(
          value: _value,
          tristate: true,
          onChanged: effectiveOnChanged,
          focusNode: focusNode,
          autofocus: autofocus,
          materialTapTargetSize: MaterialTapTargetSize.padded,
        ),
      ),
    );
  }
}
