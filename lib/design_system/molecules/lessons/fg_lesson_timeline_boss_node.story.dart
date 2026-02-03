import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/molecules/lessons/fg_lesson_timeline_boss_node.dart';
import 'package:flutter_mvvm_riverpod/design_system/organisms/lessons/lesson_node_models.dart';
import 'package:flutter_mvvm_riverpod/design_system/atoms/visuals/fg_background.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: FgLessonTimelineBossNode,
  path: 'Design System/Molecules/Lessons',
)
Widget buildFgLessonTimelineBossNodePlayground(BuildContext context) {
  return FgBackground(
    child: Center(
      child: FgLessonTimelineBossNode(
        node: LessonNode(
          title: context.knobs
              .string(label: 'Title', initialValue: 'Final Challenge'),
          type: LessonNodeType.boss,
          state: context.knobs.list(
            label: 'State',
            options: LessonNodeState.values,
            labelBuilder: (value) => value.name,
            initialOption: LessonNodeState.locked,
          ),
          duration:
              context.knobs.string(label: 'Duration', initialValue: '10 min'),
          difficulty:
              context.knobs.string(label: 'Difficulty', initialValue: 'Expert'),
          progress: context.knobs.double
              .slider(label: 'Progress', initialValue: 0, min: 0, max: 1),
        ),
      ),
    ),
  );
}
