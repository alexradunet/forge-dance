import 'package:flutter/widgets.dart';
import 'package:forge_dance/design_system/molecules/lessons/fg_lesson_timeline_movement_card.dart';
import 'package:forge_dance/design_system/organisms/lessons/lesson_node_models.dart';
import 'package:widgetbook/widgetbook.dart';

part 'fg_lesson_timeline_movement_card.stories.g.dart';

const meta = Meta(FgLessonTimelineMovementCard.new);

final $Playground = _Story(
  name: 'Playground',
  args: _Args(
    node: Arg.fixed(
      const LessonNode(
        title: 'Groove foundations',
        type: LessonNodeType.movement,
        state: LessonNodeState.current,
        duration: '10 min',
        progress: 0.45,
      ),
    ),
    onNavigate: Arg.fixed((_) {}),
  ),
);
