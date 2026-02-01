import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/templates/swipeable_card_screen_template.dart';
import 'package:flutter_mvvm_riverpod/design_system/atoms/surfaces/fg_card.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_typography.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: SwipeableCardScreenTemplate,
  path: 'Design System/Templates',
)
Widget buildSwipeableCardScreenTemplatePlayground(BuildContext context) {
  return SwipeableCardScreenTemplate(
    title: context.knobs.string(label: 'Title', initialValue: 'WORKOUT'),
    subtitle:
        context.knobs.string(label: 'Subtitle', initialValue: 'Session 1'),
    progressSteps: context.knobs.int.slider(
      label: 'Progress Steps',
      initialValue: 5,
      min: 0,
      max: 10,
    ),
    currentStep: context.knobs.int.slider(
      label: 'Current Step',
      initialValue: 2,
      min: 0,
      max: 9,
    ),
    useFullWidth:
        context.knobs.boolean(label: 'Use Full Width', initialValue: false),
    onBack: () {},
    actionZone: context.knobs
            .boolean(label: 'Show Action Zone', initialValue: true)
        ? FgCard(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'Action Zone (e.g. Controls)',
                  style: AppTypography.body.copyWith(color: AppColors.textMain),
                ),
              ),
            ),
          )
        : null,
    children: FgCard(
      child: SizedBox(
        height: 400,
        child: Center(
          child: Text(
            'Main Content Area',
            style: AppTypography.h3.copyWith(color: AppColors.textMain),
          ),
        ),
      ),
    ),
  );
}
