import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:forge_dance/design_system/atoms/visuals/fg_icon_label.dart';

part 'fg_icon_label.stories.g.dart';

const meta = Meta(FgIconLabel.new);

final $Playground = _Story(
  name: 'Playground',
  args: _Args(
    icon: Arg.fixed(Icons.local_fire_department_rounded),
    label: StringArg('Streak'),
    value: StringArg('12 days'),
  ),
);
