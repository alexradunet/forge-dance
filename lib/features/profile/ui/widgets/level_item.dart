import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../../model/level_model.dart';

class LevelItem extends StatelessWidget {
  const LevelItem({
    super.key,
    required this.level,
    required this.onTap,
  });

  final DanceLevel level;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final forgeColors = theme.forgeColors;

    return FgCard(
      onTap: onTap,
      isSelected: level.isCurrent,
      semanticLabel: level.name,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: FgIcon(
                icon: level.isLocked
                    ? Icons.lock_outline_rounded
                    : level.isCompleted
                        ? Icons.check_circle_outline_rounded
                        : Icons.directions_run_rounded,
                color: level.isLocked
                    ? scheme.onSurfaceVariant
                    : level.isCompleted
                        ? forgeColors.success
                        : scheme.primary,
                size: AppSizes.iconLg,
              ),
            ),
          ),
          Text(
            level.name.toUpperCase(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelMedium?.copyWith(
              color: level.isLocked
                  ? scheme.onSurfaceVariant
                  : scheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            height: AppSpacing.sm,
            decoration: BoxDecoration(
              color: level.color,
              borderRadius: AppBorderRadius.pill,
            ),
          ),
        ],
      ),
    );
  }
}
