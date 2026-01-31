import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Default',
  type: FgStepper,
  path: 'Design System/Atoms/Inputs',
)
Widget buildFgStepperDefault(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: FgStepper(
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
  type: FgStepper,
  path: 'Design System/Atoms/Inputs',
)
Widget buildFgStepperUnit(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: FgStepper(
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
