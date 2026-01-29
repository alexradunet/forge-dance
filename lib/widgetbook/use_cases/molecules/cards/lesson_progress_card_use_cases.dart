import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../../../design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'With Progress',
  type: LessonProgressCard,
  path: 'Design System/Molecules/Cards',
)
Widget buildLessonProgressCardProgress(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: LessonProgressCard(
        title: 'Body Control I',
        categoryLabel: 'Rhythm',
        categoryColor: AppColors.forgeFire,
        completedLessons: 2,
        totalLessons: 8,
        onTap: () {},
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Not Started',
  type: LessonProgressCard,
  path: 'Design System/Molecules/Cards',
)
Widget buildLessonProgressCardEmpty(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: LessonProgressCard(
        title: 'Isolations Master',
        categoryLabel: 'Tech',
        categoryColor: AppColors.breakingBlue,
        completedLessons: 0,
        totalLessons: 5,
        onTap: () {},
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Vertical Lesson Card',
  type: VerticalLessonCard,
  path: 'Design System/Molecules/Cards',
)
Widget buildVerticalLessonCard(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          VerticalLessonCard(
            title: 'Hip Opener Flow',
            categoryLabel: 'Mobility',
            categoryColor: AppColors.forgeFire,
            duration: '20m',
            isBookmarked: true,
            onTap: () {},
          ),
          const SizedBox(width: 16),
          VerticalLessonCard(
            title: 'Core Crusher',
            categoryLabel: 'Strength',
            categoryColor: AppColors.breakingBlue,
            duration: '15m',
            onTap: () {},
          ),
        ],
      ),
    ),
  );
}
