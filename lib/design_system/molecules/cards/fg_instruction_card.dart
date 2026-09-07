import 'package:flutter/material.dart';

import '../../design_system.dart';

/// A focused coaching surface shared by lesson and workout players.
class FgInstructionCard extends StatelessWidget {
  const FgInstructionCard({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.icon,
    this.details,
  });

  final String eyebrow;
  final String title;
  final String description;
  final IconData icon;
  final Widget? details;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).forgeColors;
    final accent = Theme.of(context).colorScheme.primary;
    return FgCard(
      immersive: true,
      padding: AppSpacing.allXXL,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: AppSpacing.allSM,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: AppBorderRadius.large,
                ),
                child: Icon(icon, color: accent, size: AppSizes.iconLg),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: FgLabel(text: eyebrow, tone: FgLabelTone.accent),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            title,
            style: AppTypography.h2.copyWith(color: colors.onImmersive),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            description,
            style: AppTypography.bodyLarge.copyWith(
              color: colors.onImmersiveMuted,
            ),
          ),
          if (details != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: Divider(
                height: 1,
                color: colors.onImmersiveMuted.withValues(alpha: 0.18),
              ),
            ),
            details!,
          ],
        ],
      ),
    );
  }
}

/// An icon-led detail row that separates individual coaching cues visually.
class FgCoachingCue extends StatelessWidget {
  const FgCoachingCue({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).forgeColors;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: Container(
        padding: AppSpacing.allLG,
        decoration: BoxDecoration(
          color: colors.immersiveBackground.withValues(alpha: 0.5),
          borderRadius: AppBorderRadius.large,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: AppSizes.iconMd,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FgLabel(text: label, tone: FgLabelTone.accent),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    value,
                    style: AppTypography.body.copyWith(
                      color: colors.onImmersive,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
