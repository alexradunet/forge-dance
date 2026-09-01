import 'package:flutter/widgets.dart';
import 'package:forge_dance/design_system/molecules/lessons/fg_lesson_timeline_boss_node.dart';
import 'package:forge_dance/design_system/organisms/lessons/lesson_node_models.dart';
import 'package:widgetbook/widgetbook.dart';

part 'fg_lesson_timeline_boss_node.stories.g.dart';

const meta = Meta(FgLessonTimelineBossNode.new);

final $Playground = _Story(
  name: 'Playground',
  args: _Args(
    node: Arg.fixed(
      const LessonNode(
        title: 'Final challenge',
        type: LessonNodeType.boss,
        state: LessonNodeState.current,
        duration: '15 min',
      ),
    ),
  ),
);
