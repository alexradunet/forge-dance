import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Active',
  type: FgToggle,
  path: 'Design System/Atoms/Inputs',
)
Widget buildFgToggleActive(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: FgToggle(
        value: true,
        onChanged: (_) {},
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Inactive',
  type: FgToggle,
  path: 'Design System/Atoms/Inputs',
)
Widget buildFgToggleInactive(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: FgToggle(
        value: false,
        onChanged: (_) {},
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With List Item',
  type: ToggleListItem,
  path: 'Design System/Atoms/Inputs',
)
Widget buildToggleListItem(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ToggleListItem(
          title: 'Enable Notifications',
          subtitle: 'Receive push notifications for updates',
          value: true,
          onChanged: (_) {},
        ),
      ),
    ),
  );
}
