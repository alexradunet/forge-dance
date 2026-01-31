import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: '25%',
  type: LinearProgress,
  path: 'Design System/Atoms/Progress',
)
Widget buildLinearProgress25(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: LinearProgress(progress: 0.25),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: '50%',
  type: LinearProgress,
  path: 'Design System/Atoms/Progress',
)
Widget buildLinearProgress50(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: LinearProgress(progress: 0.5),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: '100%',
  type: LinearProgress,
  path: 'Design System/Atoms/Progress',
)
Widget buildLinearProgress100(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: LinearProgress(progress: 1.0),
      ),
    ),
  );
}
