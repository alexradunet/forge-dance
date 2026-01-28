import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../../../design_system/design_system.dart';
import '../../../../theme/app_colors.dart';

@widgetbook.UseCase(
  name: 'Default',
  type: EmptyState,
  path: 'Design System/Atoms/Empty States',
)
Widget buildEmptyStateDefault(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: EmptyState(
        icon: Icons.inbox,
        title: 'No Workouts Yet',
        description: 'Start your first workout to see it here',
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Action',
  type: EmptyState,
  path: 'Design System/Atoms/Empty States',
)
Widget buildEmptyStateWithAction(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: EmptyState(
        icon: Icons.search_off,
        title: 'No Results',
        description: 'Try adjusting your search',
        actionLabel: 'Clear Filters',
        onAction: () {},
      ),
    ),
  );
}
