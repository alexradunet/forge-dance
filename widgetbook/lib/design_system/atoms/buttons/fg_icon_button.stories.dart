import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:forge_dance/design_system/atoms/buttons/fg_icon_button.dart';

part 'fg_icon_button.stories.g.dart';

const meta = Meta(FgIconButton.new);

final $Playground = _Story(
  name: 'Playground',
  args: _Args(
    icon: Arg.fixed(Icons.play_arrow_rounded),
    semanticLabel: StringArg('Play movement'),
    onPressed: Arg.fixed(() {}),
  ),
);
