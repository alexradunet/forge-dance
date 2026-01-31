import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: FgEmpty,
  path: 'Design System/Molecules',
)
Widget buildFgEmptyPlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: FgEmpty(
        icon: context.knobs.list(
          label: 'Icon',
          options: [
            Icons.inbox,
            Icons.search_off,
            Icons.notifications_off,
            Icons.cloud_off
          ],
          initialOption: Icons.inbox,
        ),
        title:
            context.knobs.string(label: 'Title', initialValue: 'No Data Found'),
        description: context.knobs.string(
            label: 'Description',
            initialValue: 'Try adjusting your filters or search terms.'),
        actionLabel: context.knobs.stringOrNull(label: 'Action Label'),
        onAction: () {},
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Showcase',
  type: FgEmpty,
  path: 'Design System/Molecules',
)
Widget buildFgEmptyShowcase(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const FgEmpty(
            icon: Icons.inbox,
            title: 'No Workouts Yet',
            description: 'Start your first workout to see it here',
          ),
          const SizedBox(height: 48),
          FgEmpty(
            icon: Icons.search_off,
            title: 'No Results',
            description: 'Try adjusting your search',
            actionLabel: 'Clear Filters',
            onAction: () {},
          ),
        ],
      ),
    ),
  );
}
