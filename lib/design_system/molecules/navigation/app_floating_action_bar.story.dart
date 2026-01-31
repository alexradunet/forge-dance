import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/molecules/navigation/app_floating_action_bar.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';
import 'package:flutter_mvvm_riverpod/design_system/atoms/buttons/app_button.dart';

@widgetbook.UseCase(
  name: 'App Floating Action Bar',
  type: AppFloatingActionBar,
  path: 'Design System/Molecules/Navigation',
)
Widget buildAppFloatingActionBar(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Stack(
      children: [
        Center(child: Text('Content', style: TextStyle(color: Colors.white))),
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: AppFloatingActionBar(
            children: [
              AppButton(
                text: 'Action 1',
                onPressed: () {},
                variant: AppButtonVariant.primary,
                size: AppButtonSize.sm,
              ),
              AppButton(
                text: 'Action 2',
                onPressed: () {},
                variant: AppButtonVariant.secondary,
                size: AppButtonSize.sm,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
