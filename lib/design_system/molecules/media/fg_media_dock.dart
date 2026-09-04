import 'package:flutter/material.dart';

import '../../atoms/buttons/fg_icon_button.dart';
import '../../theme/forge_theme_extensions.dart';
import '../../tokens/app_border_radius.dart';
import '../../tokens/app_shadows.dart';
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
    final scheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppBorderRadius.xl),
        boxShadow: const [AppShadows.shadowMd],
      ),
      child: Material(
        color: scheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.xl),
          side: BorderSide(color: scheme.outlineVariant),
        ),
        clipBehavior: Clip.antiAlias,
        child: ForgeSurfaceScope(
          surface: ForgeSurface.standard,
          child: SizedBox(
            height: 76,
            child: Row(
              children: [
                SizedBox(width: 84, height: double.infinity, child: thumbnail),
                Expanded(
                  child: InkWell(
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
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                        ],
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
          ),
        ),
      ),
    );
  }
}
