import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/molecules/navigation/app_floating_action_bar.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';
import 'package:flutter_mvvm_riverpod/design_system/atoms/buttons/fg_button.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: AppFloatingActionBar,
  path: 'Design System/Molecules/Navigation',
)
Widget buildAppFloatingActionBarPlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Stack(
      children: [
        const Center(
            child: Text('Content', style: TextStyle(color: Colors.white))),
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: AppFloatingActionBar(
            children: [
              FgButton(
                text: 'Action 1',
                onPressed: () {},
                variant: FgButtonVariant.primary,
                size: FgButtonSize.sm,
              ),
              FgButton(
                text: 'Action 2',
                onPressed: () {},
                variant: FgButtonVariant.secondary,
                size: FgButtonSize.sm,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Showcase',
  type: AppFloatingActionBar,
  path: 'Design System/Molecules/Navigation',
)
Widget buildAppFloatingActionBarShowcase(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: AppFloatingActionBar(
          children: [
            FgButton(
              text: 'Save',
              onPressed: () {},
              variant: FgButtonVariant.primary,
              size: FgButtonSize.sm,
            ),
            FgButton(
              text: 'Discard',
              onPressed: () {},
              variant: FgButtonVariant.ghost,
              size: FgButtonSize.sm,
            ),
            FgButton(
              icon: const Icon(Icons.share, size: 16),
              onPressed: () {},
              variant: FgButtonVariant.secondary,
              size: FgButtonSize.sm,
            ),
          ],
        ),
      ),
    ),
  );
}
