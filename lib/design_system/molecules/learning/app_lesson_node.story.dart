import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/molecules/learning/app_lesson_node.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Circular States',
  type: AppLessonNode,
  path: 'Design System/Molecules/Learning',
)
Widget buildAppLessonNodeCircular(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppLessonNode(
            title: 'Body Control',
            type: AppLessonNodeType.theory,
            status: AppLessonNodeStatus.completed,
            duration: '5 min',
            onTap: () {},
          ),
          const SizedBox(width: 40),
          AppLessonNode(
            title: 'Isolations',
            type: AppLessonNodeType.movement,
            status: AppLessonNodeStatus.active,
            duration: '10 min',
            onTap: () {},
          ),
          const SizedBox(width: 40),
          AppLessonNode(
            title: 'Floor Work',
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

@widgetbook.UseCase(
  name: 'Box States',
  type: AppLessonNode,
  path: 'Design System/Molecules/Learning',
)
Widget buildAppLessonNodeBox(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          AppLessonNode(
            title: 'Technique Masterclass',
            subtitle: 'Master the fundamentals of breaking',
            status: AppLessonNodeStatus.completed,
            variant: AppLessonNodeVariant.box,
            duration: '45 min',
            onTap: () {},
          ),
          const SizedBox(height: 16),
          AppLessonNode(
            title: 'Advanced Grooves',
            subtitle: 'Rhythm and flow isolation patterns',
            status: AppLessonNodeStatus.active,
            variant: AppLessonNodeVariant.box,
            duration: '30 min',
            progress: 0.65,
            onTap: () {},
          ),
          const SizedBox(height: 16),
          AppLessonNode(
            title: 'Power Moves 101',
            status: AppLessonNodeStatus.locked,
            variant: AppLessonNodeVariant.box,
            duration: '60 min',
            onTap: () {},
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Checkpoint & Branch',
  type: AppLessonNode,
  path: 'Design System/Molecules/Learning',
)
Widget buildAppLessonNodeSpecial(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppLessonNode(
              title: 'Checkpoint: Foundation Module Complete',
              status: AppLessonNodeStatus.completed,
              variant: AppLessonNodeVariant.checkpoint,
            ),
            const SizedBox(height: 32),
            const AppLessonNode(
              title: 'Choose Your Style: Breaking or Popping',
              status: AppLessonNodeStatus.active,
              variant: AppLessonNodeVariant.branch,
            ),
          ],
        ),
      ),
    ),
  );
}
