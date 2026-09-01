import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:forge_dance/design_system/atoms/visuals/fg_tooltip.dart';

part 'fg_tooltip.stories.g.dart';

const meta = Meta(FgTooltip.new);

final $Playground = _Story(
  name: 'Playground',
  args: _Args(
    message: StringArg('Movement details'),
    child: Arg.fixed(
      const Icon(Icons.info_outline_rounded, semanticLabel: 'Movement details'),
    ),
  ),
);
