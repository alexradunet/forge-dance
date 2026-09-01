import 'package:flutter/widgets.dart';
import 'package:forge_dance/design_system/molecules/lessons/fg_lesson_timeline_standard_node.dart';
import 'package:forge_dance/design_system/organisms/lessons/lesson_node_models.dart';
import 'package:widgetbook/widgetbook.dart';

part 'fg_lesson_timeline_standard_node.stories.g.dart';

const meta = Meta(FgLessonTimelineStandardNode.new);

final $Playground = _Story(
  name: 'Playground',
  args: _Args(
    node: Arg.fixed(
      const LessonNode(
        title: 'Rhythm theory',
        type: LessonNodeType.theory,
        state: LessonNodeState.completed,
        duration: '5 min',
        progress: 1,
      ),
    ),
  ),
);
