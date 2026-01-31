import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Horizontal',
  type: FgDivider,
  path: 'Design System/Atoms',
)
Widget buildFgDividerHorizontal(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: FgDivider(),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Vertical',
  type: FgDivider,
  path: 'Design System/Atoms',
)
Widget buildFgDividerVertical(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          height: 100,
          child: FgDivider.vertical(),
        ),
      ),
    ),
  );
}
