import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../../../design_system/atoms/badges/app_badge.dart';
import '../../../../design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: AppBadge,
  path: 'Design System/Atoms/AppBadge',
)
Widget buildAppBadgePlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: AppBadge(
        text: context.knobs.string(label: 'Label', initialValue: 'Badge'),
        variant: context.knobs.list(
          label: 'Variant',
          options: AppBadgeVariant.values,
          initialOption: AppBadgeVariant.defaultVariant,
        ),
        icon: context.knobs.boolean(label: 'Show Icon', initialValue: false)
            ? Icons.star
            : null,
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'All Variants',
  type: AppBadge,
  path: 'Design System/Atoms/AppBadge',
)
Widget buildAppBadgeAllVariants(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: AppBadgeVariant.values.map((variant) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AppBadge(
              text: variant.name.toUpperCase(),
              variant: variant,
            ),
          );
        }).toList(),
      ),
    ),
  );
}
