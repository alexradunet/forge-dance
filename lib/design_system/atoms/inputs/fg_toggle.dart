import 'package:flutter/material.dart';

/// Semantic binary control backed by Flutter's platform-adaptive switch.
///
/// The caller owns [semanticLabel] so assistive text remains localized and
/// specific to the setting being changed.
class FgToggle extends StatelessWidget {
  const FgToggle({
    super.key,
    required this.value,
    required this.semanticLabel,
    this.onChanged,
    this.isEnabled = true,
    this.focusNode,
    this.autofocus = false,
  });

  final bool value;
  final String semanticLabel;
  final ValueChanged<bool>? onChanged;
  final bool isEnabled;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final effectiveOnChanged = isEnabled ? onChanged : null;
    final isInteractive = effectiveOnChanged != null;

    return Semantics(
      label: semanticLabel,
      enabled: isInteractive,
      toggled: value,
      onTap: isInteractive ? () => effectiveOnChanged(!value) : null,
      child: ExcludeSemantics(
        child: Switch.adaptive(
          value: value,
          onChanged: effectiveOnChanged,
          focusNode: focusNode,
          autofocus: autofocus,
          materialTapTargetSize: MaterialTapTargetSize.padded,
        ),
      ),
    );
  }
}
