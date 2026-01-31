import 'package:flutter/material.dart';
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
