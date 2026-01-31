import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: FgStepper,
  path: 'Design System/Atoms/Inputs',
)
Widget buildStepperPlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: FgStepper(
        value: context.knobs.int
            .slider(label: 'Value', initialValue: 5, min: 0, max: 20),
        min: context.knobs.int
            .slider(label: 'Min', initialValue: 0, min: 0, max: 10),
        max: context.knobs.int
            .slider(label: 'Max', initialValue: 10, min: 11, max: 50),
        label: context.knobs.string(label: 'Label', initialValue: 'Quantity'),
        unit: context.knobs.stringOrNull(label: 'Unit'),
        showBounds:
            context.knobs.boolean(label: 'Show Bounds', initialValue: false),
        onChanged: (_) {},
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Showcase',
  type: FgStepper,
  path: 'Design System/Atoms/Inputs',
)
Widget buildStepperShowcase(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const FgStepper(
            value: 5,
            min: 0,
            max: 10,
            label: 'Quantity',
          ),
          const SizedBox(height: 48),
          const FgStepper(
            value: 30,
            min: 5,
            max: 60,
            step: 5,
            label: 'Duration',
            unit: 'min',
            showBounds: true,
          ),
        ],
      ),
    ),
  );
}
