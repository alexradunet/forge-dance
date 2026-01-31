import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import '../../../../design_system/molecules/learning/app_lesson_node.dart';

@widgetbook.UseCase(
  name: 'States',
  type: AppLessonNode,
)
Widget buildAppLessonNodeStates(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFF0A0A0A),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
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
          const SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppLessonNode(
                title: 'Experiment 1',
                type: AppLessonNodeType.experiment,
                status: AppLessonNodeStatus.completed,
                onTap: () {},
              ),
              const SizedBox(width: 40),
              AppLessonNode(
                title: 'Drill Master',
                type: AppLessonNodeType.drill,
                status: AppLessonNodeStatus.active,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
