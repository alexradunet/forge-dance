import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';

enum ProfileMenuTone { neutral, destructive }

/// Feature composition for profile and settings menu actions.
class ProfileMenuItem extends StatelessWidget {
  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.tone = ProfileMenuTone.neutral,
    this.showArrow = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final ProfileMenuTone tone;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final foreground = switch (tone) {
      ProfileMenuTone.neutral => scheme.onSurface,
      ProfileMenuTone.destructive => scheme.error,
    };

    return FgCard(
      variant: FgCardVariant.outlined,
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: ListTile(
        contentPadding: AppSpacing.horizontal,
        minVerticalPadding: AppSpacing.md,
        leading: Icon(icon, size: AppSizes.iconLg, color: foreground),
        title: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: foreground,
                fontWeight: FontWeight.w500,
              ),
        ),
        trailing: showArrow
            ? Icon(
                Icons.chevron_right,
                size: AppSizes.iconMd,
                color: scheme.onSurfaceVariant,
              )
            : null,
      ),
    );
  }
}

class ProfileMenuSection extends StatelessWidget {
  const ProfileMenuSection({
    super.key,
    required this.title,
    required this.items,
  });

  final String title;
  final List<ProfileMenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: FgLabel(text: title),
        ),
        const SizedBox(height: AppSpacing.md),
        for (var index = 0; index < items.length; index++) ...[
          items[index],
          if (index < items.length - 1)
            const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}
