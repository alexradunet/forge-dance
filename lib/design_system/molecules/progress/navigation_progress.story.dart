import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../../../design_system/atoms/progress/app_progress_bar.dart';
import '../../../../design_system/molecules/navigation/app_floating_action_bar.dart';
import '../../../../design_system/atoms/buttons/app_button.dart';
import '../../../../design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Progress Segments',
  type: AppProgressBar,
  path: 'Design System/Molecules/Feedback',
)
Widget buildAppProgressSegments(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: AppProgressBar.segmented(
        total: 5,
        current: context.knobs.int
            .slider(label: 'Current Step', initialValue: 2, min: 0, max: 4),
        isCumulative:
            context.knobs.boolean(label: 'Is Cumulative', initialValue: false),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Floating Action Bar',
  type: AppFloatingActionBar,
  path: 'Design System/Molecules/Navigation',
)
Widget buildAppFloatingActionBar(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: AppFloatingActionBar(
          children: [
            AppButton(
              text: 'CANCEL',
              variant: AppButtonVariant.ghost,
              onPressed: () {},
            ),
            AppButton(
              text: 'CONTINUE',
              variant: AppButtonVariant.primary,
              onPressed: () {},
            ),
          ],
        ),
      ),
    ),
  );
}
