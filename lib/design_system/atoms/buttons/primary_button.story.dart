import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Default',
  type: PrimaryButton,
  path: 'Design System/Atoms/Buttons',
)
Widget buildPrimaryButtonDefault(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: SizedBox(
        width: 240,
        child: PrimaryButton(
          text: 'START WORKOUT',
          onPressed: () {},
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Icon',
  type: PrimaryButton,
  path: 'Design System/Atoms/Buttons',
)
Widget buildPrimaryButtonWithIcon(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: SizedBox(
        width: 240,
        child: PrimaryButton(
          text: 'IGNITE',
          onPressed: () {},
          icon: const Icon(
            Icons.local_fire_department,
            size: 20,
            color: AppColors.crystalWhite,
          ),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Disabled',
  type: PrimaryButton,
  path: 'Design System/Atoms/Buttons',
)
Widget buildPrimaryButtonDisabled(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: SizedBox(
        width: 240,
        child: PrimaryButton(
          text: 'DISABLED',
          onPressed: () {},
          isEnabled: false,
        ),
      ),
    ),
  );
}
