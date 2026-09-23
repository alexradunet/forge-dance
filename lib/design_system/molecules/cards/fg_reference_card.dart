import 'package:flutter/material.dart';

import '../../design_system.dart';

/// A scannable editorial index entry with one native destination action.
/// The full definition stays readable; the number is an index, not progress.
class FgReferenceCard extends StatelessWidget {
  const FgReferenceCard({
    super.key,
    required this.indexLabel,
    required this.title,
    required this.label,
    required this.definition,
    required this.status,
    required this.onTap,
    this.focusNode,
    this.autofocus = false,
  });

  final String indexLabel;
  final String title;
  final String label;
  final String definition;
  final String status;
  final VoidCallback onTap;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  Widget build(BuildContext context) => FgCard(
    immersive: true,
    shape: FgCardShape.editorial,
    onTap: onTap,
    focusNode: focusNode,
    autofocus: autofocus,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcludeSemantics(
              child: Text(
                indexLabel,
                style: AppTypography.monoLarge.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label.toUpperCase(),
                style: AppTypography.overline.copyWith(
                  color: Theme.of(context).forgeColors.onImmersiveMuted,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            ExcludeSemantics(
              child: Icon(
                Icons.north_east,
                color: Theme.of(context).forgeColors.onImmersive,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          title,
          style: AppTypography.h2.copyWith(
            color: Theme.of(context).forgeColors.onImmersive,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          definition,
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: Theme.of(context).forgeColors.onImmersiveMuted),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          status,
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: Theme.of(context).forgeColors.onImmersive),
        ),
      ],
    ),
  );
}
