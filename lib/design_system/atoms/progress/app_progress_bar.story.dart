import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/atoms/progress/app_progress_bar.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

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
          segments: context.knobs.int
              .slider(label: 'Segments', initialValue: 0, min: 0, max: 10),
          isCumulative:
              context.knobs.boolean(label: 'Is Cumulative', initialValue: true),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Segmented',
  type: AppProgressBar,
  path: 'Design System/Atoms/AppProgressBar',
)
Widget buildAppProgressBarSegmented(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Splitted (Not Cumulative)',
                style: TextStyle(color: Colors.white)),
            const SizedBox(height: 8),
            AppProgressBar.segmented(
              total: 5,
              current: 2,
              isCumulative: false,
            ),
            const SizedBox(height: 32),
            const Text('Segmented (Cumulative)',
                style: TextStyle(color: Colors.white)),
            const SizedBox(height: 8),
            AppProgressBar.segmented(
              total: 5,
              current: 2,
              isCumulative: true,
            ),
          ],
        ),
      ),
    ),
  );
}
