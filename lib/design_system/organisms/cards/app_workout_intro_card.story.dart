import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/organisms/cards/app_workout_intro_card.dart';
import 'package:flutter_mvvm_riverpod/design_system/atoms/visuals/fg_background.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: AppWorkoutIntroCard,
  path: 'Design System/Organisms/Cards',
)
Widget buildAppWorkoutIntroCardPlayground(BuildContext context) {
  return FgBackground(
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SizedBox(
          height: 600,
          width: 350,
          child: AppWorkoutIntroCard(
            title: context.knobs
                .string(label: 'Title', initialValue: 'HIIT BLAST'),
            duration:
                context.knobs.string(label: 'Duration', initialValue: '25 Min'),
            intensity:
                context.knobs.string(label: 'Intensity', initialValue: 'High'),
            description: context.knobs.string(
              label: 'Description',
              initialValue:
                  'Push your limits with high-intensity interval training designed to burn fat and build endurance.',
            ),
          ),
        ),
      ),
    ),
  );
}
