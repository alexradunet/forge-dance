import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/organisms/progress/progress_section.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: ProgressSection,
  path: 'Design System/Organisms/Progress',
)
Widget buildProgressSectionPlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ProgressSection(
          title: context.knobs
              .string(label: 'Title', initialValue: 'Your Progress'),
          actionLabel: context.knobs
              .string(label: 'Action Label', initialValue: 'View All'),
          onAction: () {},
          stats: [],
          levelProgress: ProgressData(
            label: context.knobs
                .string(label: 'Level Label', initialValue: 'Level 5'),
            current: context.knobs.int.slider(
                label: 'Current XP', initialValue: 750, min: 0, max: 1000),
            target: 1000,
            message: context.knobs
                .string(label: 'Message', initialValue: '250 XP to next level'),
          ),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Showcase',
  type: ProgressSection,
  path: 'Design System/Organisms/Progress',
)
Widget buildProgressSectionShowcase(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ProgressSection(
              title: 'Overview',
              stats: [
                StatCardData(
                    label: 'Workouts', value: '12', icon: 'fitness_center'),
                StatCardData(label: 'Minutes', value: '340', icon: 'timer'),
              ],
            ),
            const SizedBox(height: 32),
            ProgressSection(
              title: 'Level Progress',
              levelProgress: ProgressData(
                label: 'Beginner II',
                current: 300,
                target: 500,
                message: 'Keep going!',
              ),
              stats: [],
            ),
          ],
        ),
      ),
    ),
  );
}
