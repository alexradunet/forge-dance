import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/molecules/lessons/fg_lesson_timeline_standard_node.dart';
import 'package:flutter_mvvm_riverpod/design_system/organisms/lessons/lesson_node_models.dart';
import 'package:flutter_mvvm_riverpod/design_system/atoms/visuals/fg_background.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: FgLessonTimelineStandardNode,
  path: 'Design System/Molecules/Lessons',
)
Widget buildFgLessonTimelineStandardNodePlayground(BuildContext context) {
  return FgBackground(
    child: Center(
      child: FgLessonTimelineStandardNode(
        isTextLeft:
            context.knobs.boolean(label: 'Is Text Left', initialValue: true),
        node: LessonNode(
          title: context.knobs
              .string(label: 'Title', initialValue: 'Lesson Title'),
          type: context.knobs.list(
            label: 'Type',
            options: LessonNodeType.values,
            labelBuilder: (value) => value.name,
            initialOption: LessonNodeType.theory,
          ),
          state: context.knobs.list(
            label: 'State',
            options: LessonNodeState.values,
            labelBuilder: (value) => value.name,
            initialOption: LessonNodeState.current,
          ),
          duration:
              context.knobs.string(label: 'Duration', initialValue: '5 min'),
          difficulty: context.knobs
              .string(label: 'Difficulty', initialValue: 'Intermediate'),
          progress: context.knobs.double
              .slider(label: 'Progress', initialValue: 0.5, min: 0, max: 1),
        ),
      ),
    ),
  );
}
