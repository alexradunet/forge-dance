import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:forge_dance/design_system/organisms/lessons/lesson_path_timeline.dart';

part 'lesson_path_timeline.stories.g.dart';

const meta = Meta(LessonPathTimeline.new);

final $Playground = _Story(
  name: 'Playground',
  args: _Args(
    nodes: Arg.fixed(const [
      LessonNode(
        title: 'Foundation',
        type: LessonNodeType.theory,
        state: LessonNodeState.completed,
        duration: '5 min',
        progress: 1,
      ),
      LessonNode(
        title: 'Groove drill',
        type: LessonNodeType.drill,
        state: LessonNodeState.current,
        duration: '10 min',
        progress: 0.4,
      ),
      LessonNode(
        title: 'Final challenge',
        type: LessonNodeType.boss,
        state: LessonNodeState.locked,
        duration: '15 min',
      ),
    ]),
    onNavigate: Arg.fixed((_) {}),
  ),
);
