import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook/widgetbook.dart';

import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: AppBadge,
  path: 'Design System/Atoms/Badges',
)
Widget buildAppBadgePlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: AppBadge(
        text: context.knobs.string(label: 'Text', initialValue: 'Badge'),
        variant: context.knobs.list(
          label: 'Variant',
          options: AppBadgeVariant.values,
          initialOption: AppBadgeVariant.solid,
        ),
        color: context.knobs.list(
          label: 'Color',
          options: AppBadgeColor.values,
          initialOption: AppBadgeColor.brand,
        ),
        shape: context.knobs.list(
          label: 'Shape',
          options: AppBadgeShape.values,
          initialOption: AppBadgeShape.standard,
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Showcase',
  type: AppBadge,
  path: 'Design System/Atoms/Badges',
)
Widget buildAppBadgeShowcase(BuildContext context) {
  return const Scaffold(
    backgroundColor: AppColors.gray950,
    body: SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Center(
        child: Column(
          children: [
            _BadgeSection(title: 'Solid', variant: AppBadgeVariant.solid),
            SizedBox(height: 32),
            _BadgeSection(title: 'Outline', variant: AppBadgeVariant.outline),
            SizedBox(height: 32),
            _BadgeSection(title: 'Subtle', variant: AppBadgeVariant.subtle),
          ],
        ),
      ),
    ),
  );
}

class _BadgeSection extends StatelessWidget {
  final String title;
  final AppBadgeVariant variant;

  const _BadgeSection({required this.title, required this.variant});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title,
            style: AppTypography.h5.copyWith(color: AppColors.crystalWhite)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: AppBadgeColor.values
              .map(
                (color) => AppBadge(
                  text: color.name,
                  variant: variant,
                  color: color,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
