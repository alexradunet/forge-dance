import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Default',
  type: GhostButton,
  path: 'Design System/Atoms/Buttons',
)
Widget buildGhostButtonDefault(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: GhostButton(
        text: 'Skip',
        onPressed: () {},
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Underline',
  type: GhostButton,
  path: 'Design System/Atoms/Buttons',
)
Widget buildGhostButtonWithUnderline(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: GhostButton(
        text: 'Learn More',
        onPressed: () {},
        underline: true,
      ),
    ),
  );
}
