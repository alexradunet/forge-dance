import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../../../design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Default',
  type: FabButton,
  path: 'Design System/Atoms/Buttons',
)
Widget buildFabButtonDefault(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: FabButton(
        icon: Icons.add,
        onPressed: () {},
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Custom Size',
  type: FabButton,
  path: 'Design System/Atoms/Buttons',
)
Widget buildFabButtonCustomSize(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: FabButton(
        icon: Icons.bolt,
        onPressed: () {},
        size: 64,
      ),
    ),
  );
}
