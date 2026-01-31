import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../../../design_system/molecules/navigation/app_floating_action_bar.dart';
import '../../../../design_system/atoms/buttons/fg_button.dart';
import '../../../../design_system/tokens/app_colors.dart';

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
            FgButton(
              text: 'CANCEL',
              variant: FgButtonVariant.ghost,
              onPressed: () {},
            ),
            FgButton(
              text: 'CONTINUE',
              variant: FgButtonVariant.primary,
              onPressed: () {},
            ),
          ],
        ),
      ),
    ),
  );
}
