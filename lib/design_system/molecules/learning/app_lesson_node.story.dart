import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/molecules/learning/app_lesson_node.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: AppLessonNode,
  path: 'Design System/Molecules',
)
Widget buildAppLessonNodePlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: AppLessonNode(
        title:
            context.knobs.string(label: 'Title', initialValue: 'Lesson Title'),
        type: context.knobs.list(
          label: 'Type',
          options: AppLessonNodeType.values,
          initialOption: AppLessonNodeType.theory,
        ),
        status: context.knobs.list(
          label: 'Status',
          options: AppLessonNodeStatus.values,
          initialOption: AppLessonNodeStatus.active,
        ),
        duration:
            context.knobs.string(label: 'Duration', initialValue: '5 min'),
        onTap: () {},
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Showcase',
  type: AppLessonNode,
  path: 'Design System/Molecules',
)
Widget buildAppLessonNodeShowcase(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppLessonNode(
            title: 'Theory',
            type: AppLessonNodeType.theory,
            status: AppLessonNodeStatus.completed,
            duration: '5 min',
            onTap: () {},
          ),
          const SizedBox(width: 32),
          AppLessonNode(
            title: 'Movement',
            type: AppLessonNodeType.movement,
            status: AppLessonNodeStatus.active,
            duration: '10 min',
            onTap: () {},
          ),
          const SizedBox(width: 32),
          AppLessonNode(
            title: 'Drill',
            type: AppLessonNodeType.drill,
            status: AppLessonNodeStatus.locked,
            duration: '15 min',
            onTap: () {},
          ),
        ],
      ),
    ),
  );
}
