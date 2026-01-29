import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/organisms/lessons/lesson_path_timeline.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Default',
  type: LessonPathTimeline,
  path: '[Organisms]/Lessons',
)
Widget buildLessonPathTimelineDefault(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: LessonPathTimeline(
        nodes: const [
          LessonNode(
            title: 'Introduction',
            type: LessonNodeType.theory,
            state: LessonNodeState.completed,
            duration: '3 min',
          ),
          LessonNode(
            title: 'Top Rock Basics',
            type: LessonNodeType.drill,
            state: LessonNodeState.completed,
            duration: '5 min',
          ),
          LessonNode(
            title: 'Indian Step',
            type: LessonNodeType.movement,
            state: LessonNodeState.current,
            duration: '8 min',
          ),
          LessonNode(
            title: 'Footwork Flow',
            type: LessonNodeType.experiment,
            state: LessonNodeState.locked,
            duration: '10 min',
          ),
          LessonNode(
            title: 'Challenge',
            type: LessonNodeType.challenge,
            state: LessonNodeState.locked,
            duration: '5 min',
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'All Completed',
  type: LessonPathTimeline,
  path: '[Organisms]/Lessons',
)
Widget buildLessonPathTimelineCompleted(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: LessonPathTimeline(
        nodes: const [
          LessonNode(
            title: 'Theory',
            type: LessonNodeType.theory,
            state: LessonNodeState.completed,
            duration: '3 min',
          ),
          LessonNode(
            title: 'Drill',
            type: LessonNodeType.drill,
            state: LessonNodeState.completed,
            duration: '5 min',
          ),
          LessonNode(
            title: 'Movement',
            type: LessonNodeType.movement,
            state: LessonNodeState.completed,
            duration: '8 min',
          ),
        ],
      ),
    ),
  );
}
