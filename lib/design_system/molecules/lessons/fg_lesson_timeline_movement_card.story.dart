import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/molecules/lessons/fg_lesson_timeline_movement_card.dart';
import 'package:flutter_mvvm_riverpod/design_system/organisms/lessons/lesson_node_models.dart';
import 'package:flutter_mvvm_riverpod/design_system/atoms/visuals/fg_background.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: FgLessonTimelineMovementCard,
  path: 'Design System/Molecules/Lessons',
)
Widget buildFgLessonTimelineMovementCardPlayground(BuildContext context) {
  return FgBackground(
    child: Center(
      child: FgLessonTimelineMovementCard(
        node: LessonNode(
          title: context.knobs
              .string(label: 'Title', initialValue: 'Movement Lesson'),
          type: LessonNodeType.movement,
          state: context.knobs.list(
            label: 'State',
            options: LessonNodeState.values,
            labelBuilder: (value) => value.name,
            initialOption: LessonNodeState.current,
          ),
          duration:
              context.knobs.string(label: 'Duration', initialValue: '15 min'),
          difficulty: context.knobs
              .string(label: 'Difficulty', initialValue: 'Advanced'),
          progress: context.knobs.double
              .slider(label: 'Progress', initialValue: 0.7, min: 0, max: 1),
        ),
        onNavigate: (_) {},
      ),
    ),
  );
}
