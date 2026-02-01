import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/molecules/cards/app_mini_workout_card.dart';
import 'package:flutter_mvvm_riverpod/design_system/atoms/visuals/fg_background.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: AppMiniWorkoutCard,
  path: 'Design System/Molecules/Cards',
)
Widget buildAppMiniWorkoutCardPlayground(BuildContext context) {
  return FgBackground(
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SizedBox(
          height: 180,
          width: 150,
          child: AppMiniWorkoutCard(
            title: context.knobs
                .string(label: 'Title', initialValue: 'Morning Burn'),
            duration:
                context.knobs.string(label: 'Duration', initialValue: '15 min'),
            intensity:
                context.knobs.string(label: 'Intensity', initialValue: 'High'),
            onTap: () {},
          ),
        ),
      ),
    ),
  );
}
