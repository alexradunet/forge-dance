import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../../../design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Active',
  type: ToggleSwitch,
  path: 'Design System/Atoms/Inputs',
)
Widget buildToggleSwitchActive(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: ToggleSwitch(
        value: true,
        onChanged: (_) {},
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Inactive',
  type: ToggleSwitch,
  path: 'Design System/Atoms/Inputs',
)
Widget buildToggleSwitchInactive(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: ToggleSwitch(
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
