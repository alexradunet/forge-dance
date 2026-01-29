import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../../../design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Horizontal',
  type: GradientDivider,
  path: 'Design System/Atoms/Dividers',
)
Widget buildGradientDividerHorizontal(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: GradientDivider(),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Vertical',
  type: GradientDivider,
  path: 'Design System/Atoms/Dividers',
)
Widget buildGradientDividerVertical(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          height: 100,
          child: GradientDivider.vertical(),
        ),
      ),
    ),
  );
}
