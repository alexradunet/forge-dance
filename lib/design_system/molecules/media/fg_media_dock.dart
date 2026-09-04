import 'package:flutter/material.dart';

import '../../atoms/buttons/fg_icon_button.dart';
import '../../theme/forge_theme_extensions.dart';
import '../../tokens/app_spacing.dart';

/// A compact, persistent representation of media that has been moved out of
/// the primary reading surface.
class FgMediaDock extends StatelessWidget {
  const FgMediaDock({
    required this.thumbnail,
    required this.title,
    required this.subtitle,
    required this.onExpand,
    required this.expandSemanticLabel,
    super.key,
    this.action,
  });

  final Widget thumbnail;
  final String title;
  final String subtitle;
  final VoidCallback onExpand;
  final String expandSemanticLabel;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 76,
      child: Row(
        children: [
          SizedBox(width: 84, height: double.infinity, child: thumbnail),
          Expanded(
            child: Semantics(
              button: true,
              label: expandSemanticLabel,
              onTap: onExpand,
              child: ExcludeSemantics(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onExpand,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(color: context.forgeForeground),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(color: context.forgeMutedForeground),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (action != null) ...[
            action!,
            const SizedBox(width: AppSpacing.xs),
          ],
          FgIconButton(
            icon: Icons.expand_less_rounded,
            semanticLabel: expandSemanticLabel,
            variant: FgIconButtonVariant.ghost,
            size: FgIconButtonSize.sm,
            onPressed: onExpand,
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
    );
  }
}
