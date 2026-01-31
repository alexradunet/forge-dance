import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/templates/interactive_card_template.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Interactive Card Template',
  type: InteractiveCardTemplate,
  path: 'Design System/Templates',
)
Widget buildInteractiveCardTemplate(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Padding(
      padding: const EdgeInsets.all(32.0),
      child: InteractiveCardTemplate(
        accentColor: context.knobs
            .color(label: 'Accent Color', initialValue: AppColors.forgeFire),
        frontContent: Container(
          color: AppColors.surfaceDark,
          child: const Center(
            child: Text(
              'FRONT',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        backContent: Container(
          color: AppColors.gray900,
          child: const Center(
            child: Text(
              'BACK',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    ),
  );
}
