import 'package:flutter/material.dart';

import '../../design_system.dart';

/// Editorial hierarchy for discovery and practice. All copy can wrap, including
/// at accessibility text scales. No fixed-height title or trailing action slot.
class FgSectionHeading extends StatelessWidget {
  const FgSectionHeading({
    super.key,
    required this.title,
    this.eyebrow,
    this.subtitle,
  });

  final String title;
  final String? eyebrow;
  final String? subtitle;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (eyebrow != null) ...[
        Text(
          eyebrow!,
          style: AppTypography.overline.copyWith(
            color: context.forgeMutedForeground,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
      Semantics(
        container: true,
        header: true,
        child: Text(
          title,
          style: AppTypography.h2.copyWith(color: context.forgeForeground),
        ),
      ),
      if (subtitle != null) ...[
        const SizedBox(height: AppSpacing.sm),
        Text(
          subtitle!,
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: context.forgeMutedForeground),
        ),
      ],
    ],
  );
}
