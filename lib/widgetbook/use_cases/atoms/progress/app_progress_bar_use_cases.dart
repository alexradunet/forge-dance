import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../../../design_system/atoms/progress/app_progress_bar.dart';
import '../../../../design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Default',
  type: AppProgressBar,
  path: 'Design System/Atoms/AppProgressBar',
)
Widget buildAppProgressBarDefault(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: AppProgressBar(
          value: context.knobs.double
              .slider(label: 'Value', initialValue: 0.5, min: 0.0, max: 1.0),
          height: context.knobs.double
              .slider(label: 'Height', initialValue: 8, min: 2, max: 20),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Variants',
  type: AppProgressBar,
  path: 'Design System/Atoms/AppProgressBar',
)
Widget buildAppProgressBarVariants(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppProgressBar(value: 0.3, color: AppColors.forgeFire),
          const SizedBox(height: 16),
          const AppProgressBar(value: 0.6, color: AppColors.electricBlue),
          const SizedBox(height: 16),
          const AppProgressBar(value: 0.8, color: AppColors.growthGreen),
        ],
      ),
    ),
  );
}
