import 'package:flutter/material.dart';
import 'package:forge_dance/design_system/atoms/visuals/fg_aspect_ratio.dart';
import 'package:widgetbook/widgetbook.dart';

part 'fg_aspect_ratio.stories.g.dart';

const meta = Meta(FgAspectRatio.new);

final $Playground = _Story(
  name: 'Playground',
  args: _Args(
    ratio: DoubleArg(16 / 9),
    child: Arg.fixed(
      const ColoredBox(
        color: Color(0xFF1D4ED8),
        child: Center(child: Text('16:9 content')),
      ),
    ),
  ),
);
