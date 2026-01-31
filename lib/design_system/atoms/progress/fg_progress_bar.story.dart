import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/atoms/progress/fg_progress_bar.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: FgProgressBar,
  path: 'Design System/Atoms',
)
Widget buildFgProgressBarPlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: FgProgressBar(
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
  name: 'Showcase',
  type: FgProgressBar,
  path: 'Design System/Atoms',
)
Widget buildFgProgressBarShowcase(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Continuous',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const FgProgressBar(value: 0.3),
          const SizedBox(height: 8),
          const FgProgressBar(value: 0.7, color: AppColors.growthGreen),
          const SizedBox(height: 32),
          const Text('Segmented (Cumulative)',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          FgProgressBar.segmented(total: 5, current: 3, isCumulative: true),
          const SizedBox(height: 8),
          FgProgressBar.segmented(
              total: 8,
              current: 2,
              isCumulative: true,
              color: AppColors.passionRed),
          const SizedBox(height: 32),
          const Text('Segmented (Splitted)',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          FgProgressBar.segmented(total: 5, current: 3, isCumulative: false),
          const SizedBox(height: 8),
          FgProgressBar.segmented(
              total: 6,
              current: 5,
              isCumulative: false,
              color: AppColors.mysticPurple),
        ],
      ),
    ),
  );
}
