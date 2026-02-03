import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/atoms/status/fg_lesson_timeline_indicator.dart';
import 'package:flutter_mvvm_riverpod/design_system/organisms/lessons/lesson_node_models.dart';
import 'package:flutter_mvvm_riverpod/design_system/atoms/visuals/fg_background.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: FgLessonTimelineIndicator,
  path: 'Design System/Atoms/Status',
)
Widget buildFgLessonTimelineIndicatorPlayground(BuildContext context) {
  return FgBackground(
    child: Center(
      child: FgLessonTimelineIndicator(
        state: context.knobs.list(
          label: 'State',
          options: LessonNodeState.values,
          labelBuilder: (value) => value.name,
          initialOption: LessonNodeState.current,
        ),
        size: context.knobs.double
            .slider(label: 'Size', initialValue: 40, min: 20, max: 80),
      ),
    ),
  );
}
