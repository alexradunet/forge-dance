import 'package:flutter/material.dart';

import '../../design_system.dart';

class FgNavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const FgNavButton({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return MergeSemantics(
      child: Semantics(
        selected: isActive,
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: isActive
                ? scheme.onPrimaryContainer
                : scheme.onSurfaceVariant,
            backgroundColor: isActive ? scheme.primaryContainer : null,
            minimumSize: const Size(
              AppSizes.comfortableTouchTarget,
              AppSizes.comfortableTouchTarget,
            ),
            padding: AppSpacing.allSM,
            shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.small),
          ),
          onPressed: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: AppSizes.iconLg),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isActive
                      ? scheme.onPrimaryContainer
                      : scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
