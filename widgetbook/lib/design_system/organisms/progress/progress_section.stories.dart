import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:forge_dance/design_system/organisms/progress/progress_section.dart';

part 'progress_section.stories.g.dart';

const meta = Meta(FgProgressSection.new);

final $Playground = _Story(
  name: 'Playground',
  args: _Args(
    title: StringArg('Weekly progress'),
    stats: Arg.fixed(const [
      FgStatData(label: 'Sessions', value: '4', icon: Icons.fitness_center),
      FgStatData(label: 'Minutes', value: '128', unit: 'min'),
      FgStatData(label: 'Streak', value: '12', unit: 'days'),
    ]),
    actionLabel: NullableStringArg('View details'),
    onAction: Arg.fixed(() {}),
    levelProgress: Arg.fixed(
      const FgProgressData(
        label: 'Level 8',
        current: 720,
        target: 1000,
        valueLabel: '720 / 1000 XP',
      ),
    ),
  ),
);
