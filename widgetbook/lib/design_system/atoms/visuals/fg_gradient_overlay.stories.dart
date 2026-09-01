import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:forge_dance/design_system/atoms/visuals/fg_gradient_overlay.dart';

part 'fg_gradient_overlay.stories.g.dart';

const meta = Meta(FgGradientOverlay.new);

final $Playground = _Story(
  name: 'Playground',
  args: _Args(
    colors: Arg.fixed(const [Color(0xFF1D4ED8), Color(0x001D4ED8)]),
    child: Arg.fixed(const SizedBox(width: 240, height: 160)),
  ),
);
