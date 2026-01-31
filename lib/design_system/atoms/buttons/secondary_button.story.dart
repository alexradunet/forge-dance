import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Default',
  type: SecondaryButton,
  path: 'Design System/Atoms/Buttons',
)
Widget buildSecondaryButtonDefault(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: SizedBox(
        width: 240,
        child: SecondaryButton(
          text: 'VIEW DETAILS',
          onPressed: () {},
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Disabled',
  type: SecondaryButton,
  path: 'Design System/Atoms/Buttons',
)
Widget buildSecondaryButtonDisabled(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: SizedBox(
        width: 240,
        child: SecondaryButton(
          text: 'DISABLED',
          onPressed: () {},
          isEnabled: false,
        ),
      ),
    ),
  );
}
