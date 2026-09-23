import 'package:flutter/material.dart';

import '../../theme/forge_theme_extensions.dart';
import '../../tokens/app_border_radius.dart';
import '../../tokens/app_sizes.dart';
import '../../tokens/app_spacing.dart';

/// Secondary explanations stay available without competing with the next action.
/// Use a stable key in repeated lists. Keep essential instructions, safety,
/// errors and confirmation consequences outside this disclosure.
class FgDetails extends StatelessWidget {
  const FgDetails({
    super.key,
    required this.title,
    required this.child,
    this.initiallyExpanded = false,
    this.maintainState = false,
  });

  final String title;
  final Widget child;
  final bool initiallyExpanded;
  final bool maintainState;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final motion = context.forgeMotion;
    final shape = RoundedRectangleBorder(borderRadius: AppBorderRadius.large);
    return Material(
      type: MaterialType.transparency,
      child: DefaultTextStyle.merge(
        style: theme.textTheme.bodyMedium?.copyWith(
          color: context.forgeForeground,
        ),
        child: ExpansionTile(
          title: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              color: context.forgeForeground,
            ),
          ),
          initiallyExpanded: initiallyExpanded,
          maintainState: maintainState,
          minTileHeight: AppSizes.comfortableTouchTarget,
          tilePadding: EdgeInsets.zero,
          childrenPadding: const EdgeInsets.only(bottom: AppSpacing.lg),
          expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
          textColor: context.forgeForeground,
          collapsedTextColor: context.forgeForeground,
          iconColor: context.forgeMutedForeground,
          collapsedIconColor: context.forgeMutedForeground,
          shape: shape,
          collapsedShape: shape,
          expansionAnimationStyle: AnimationStyle(
            duration: motion.standard,
            reverseDuration: motion.fast,
            curve: motion.enterCurve,
            reverseCurve: motion.exitCurve,
          ),
          children: [child],
        ),
      ),
    );
  }
}
