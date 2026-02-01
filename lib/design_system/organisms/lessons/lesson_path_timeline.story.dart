import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/organisms/lessons/lesson_path_timeline.dart';
import 'package:flutter_mvvm_riverpod/design_system/atoms/visuals/fg_background.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: LessonPathTimeline,
  path: 'Design System/Organisms/Lessons',
)
Widget buildLessonPathTimelinePlayground(BuildContext context) {
  return FgBackground(
    child: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: LessonPathTimeline(
        onNavigate: (_) {},
        nodes: [
          LessonNode(
            title: context.knobs
                .string(label: 'Node 1 Title', initialValue: 'Rhythm Basics'),
            type: LessonNodeType.theory,
            state: LessonNodeState.completed,
            duration: '5 min',
          ),
          LessonNode(
            title: context.knobs
                .string(label: 'Node 2 Title', initialValue: 'Foundation Step'),
            type: LessonNodeType.movement,
            state: LessonNodeState.current,
            duration: '10 min',
            progress: context.knobs.double
                .slider(label: 'Current Node Progress', initialValue: 0.3),
          ),
          const LessonNode(
            title: 'Drill: Timing',
            type: LessonNodeType.drill,
            state: LessonNodeState.locked,
            duration: '15 min',
            difficulty: 'Intermediate',
          ),
          const LessonNode(
            title: 'Experiment: Freestyle',
            type: LessonNodeType.experiment,
            state: LessonNodeState.locked,
            duration: '20 min',
          ),
          const LessonNode(
            title: 'Final Showcase',
            type: LessonNodeType.boss,
            state: LessonNodeState.locked,
            duration: '25 min',
            difficulty: 'Advanced',
          ),
        ],
      ),
    ),
  );
}
