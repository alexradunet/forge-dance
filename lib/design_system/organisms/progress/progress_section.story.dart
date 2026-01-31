import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/organisms/progress/progress_section.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Progress Section',
  type: ProgressSection,
  path: 'Design System/Organisms/Progress',
)
Widget buildProgressSection(BuildContext context) {
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
          stats: [], // Can populate with dummy data if needed, but structure is complex for knobs
          levelProgress: ProgressData(
            label: 'Level 5',
            current: 750,
            target: 1000,
            message: '250 XP to next level',
          ),
        ),
      ),
    ),
  );
}
