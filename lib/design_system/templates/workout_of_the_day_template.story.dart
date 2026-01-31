import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';
import 'package:flutter_mvvm_riverpod/design_system/templates/workout_of_the_day_template.dart';

@widgetbook.UseCase(
  name: 'Standard WOD',
  type: WorkoutOfTheDayTemplate,
  path: 'Design System/Templates',
)
Widget buildWorkoutOfTheDayTemplate(BuildContext context) {
  return WorkoutOfTheDayTemplate(
    title: context.knobs.string(label: 'Title', initialValue: 'DAILY DROP'),
    subtitle: context.knobs
        .string(label: 'Subtitle', initialValue: 'Fresh Challenges'),
    startButtonText: context.knobs
        .string(label: 'Button Text', initialValue: 'Start Session'),
    onBack: () {},
    onMenu: () {},
    onStartWorkout: () {},
    content: Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer_outlined,
              size: 48, color: AppColors.forgeFire),
          const SizedBox(height: 16),
          Text(
            'HIIT THE BEAT',
            style: AppTypography.h2.copyWith(color: AppColors.crystalWhite),
          ),
          const SizedBox(height: 8),
          Text(
            'High intensity interval training syncopated to the rhythm.',
            textAlign: TextAlign.center,
            style: AppTypography.body.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    ),
  );
}
