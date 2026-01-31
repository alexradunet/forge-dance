import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Default',
  type: FgEmpty,
  path: 'Design System/Atoms',
)
Widget buildFgEmptyDefault(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: FgEmpty(
        icon: Icons.inbox,
        title: 'No Workouts Yet',
        description: 'Start your first workout to see it here',
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Action',
  type: FgEmpty,
  path: 'Design System/Atoms',
)
Widget buildFgEmptyWithAction(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: FgEmpty(
        icon: Icons.search_off,
        title: 'No Results',
        description: 'Try adjusting your search',
        actionLabel: 'Clear Filters',
        onAction: () {},
      ),
    ),
  );
}
