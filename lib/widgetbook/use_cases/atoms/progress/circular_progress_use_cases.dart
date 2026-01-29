import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../../../design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Default',
  type: CircularProgress,
  path: 'Design System/Atoms/Progress',
)
Widget buildCircularProgressDefault(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: CircularProgress(
        outerProgress: 0.75,
        innerProgress: 0.5,
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Child',
  type: CircularProgress,
  path: 'Design System/Atoms/Progress',
)
Widget buildCircularProgressWithChild(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: CircularProgress(
        outerProgress: 0.75,
        innerProgress: 0.5,
        child: const Text(
          '75%',
          style: TextStyle(
            color: AppColors.crystalWhite,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}
