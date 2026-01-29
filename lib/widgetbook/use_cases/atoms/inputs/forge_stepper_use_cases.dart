import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../../../design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Default',
  type: ForgeStepper,
  path: 'Design System/Atoms/Inputs',
)
Widget buildForgeStepperDefault(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: ForgeStepper(
        value: 5,
        min: 0,
        max: 10,
        label: 'Quantity',
        onChanged: (_) {},
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Unit',
  type: ForgeStepper,
  path: 'Design System/Atoms/Inputs',
)
Widget buildForgeStepperUnit(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: ForgeStepper(
        value: 30,
        min: 5,
        max: 60,
        step: 5,
        label: 'Duration',
        unit: 'min',
        showBounds: true,
        onChanged: (_) {},
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Inline',
  type: InlineForgeStepper,
  path: 'Design System/Atoms/Inputs',
)
Widget buildInlineForgeStepper(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: InlineForgeStepper(
        value: 3,
        min: 1,
        max: 10,
        onChanged: (_) {},
      ),
    ),
  );
}
