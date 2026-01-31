import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/molecules/controls/stepper_control.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Stepper Control',
  type: StepperControl,
  path: 'Design System/Molecules/Controls',
)
Widget buildStepperControl(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: 350,
          child: StepperControl(
            label: context.knobs.string(label: 'Label', initialValue: 'Sets'),
            unit: context.knobs.string(label: 'Unit', initialValue: ''),
            initialValue: context.knobs.int
                .input(label: 'Initial Value', initialValue: 3),
            min: context.knobs.int.input(label: 'Min', initialValue: 1),
            max: context.knobs.int.input(label: 'Max', initialValue: 10),
            onValueChanged: (value) {},
          ),
        ),
      ),
    ),
  );
}
