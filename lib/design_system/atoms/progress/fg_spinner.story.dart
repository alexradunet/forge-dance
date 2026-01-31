import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';
import 'package:flutter_mvvm_riverpod/design_system/atoms/progress/fg_spinner.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: FgSpinner,
  path: 'Design System/Atoms/Progress',
)
Widget buildFgSpinnerPlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: FgSpinner(
        size: context.knobs.double
            .slider(label: 'Size', initialValue: 32, min: 16, max: 100),
        color: context.knobs
            .color(label: 'Color', initialValue: AppColors.forgeFire),
        strokeWidth: context.knobs.double
            .slider(label: 'Stroke Width', initialValue: 3, min: 1, max: 10),
        trackColor: context.knobs
            .color(label: 'Track Color', initialValue: Colors.white10),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Showcase',
  type: FgSpinner,
  path: 'Design System/Atoms/Progress',
)
Widget buildFgSpinnerShowcase(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const FgSpinner(size: 20),
          FgSpinner(
            size: 40,
            color: AppColors.electricBlue,
            trackColor: Colors.white.withOpacity(0.1),
          ),
          const FgSpinner(
              size: 60, strokeWidth: 6, color: AppColors.growthGreen),
        ],
      ),
    ),
  );
}
