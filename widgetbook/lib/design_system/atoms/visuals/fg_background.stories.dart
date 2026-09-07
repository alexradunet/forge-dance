import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:forge_dance/design_system/atoms/visuals/fg_background.dart';
import 'package:forge_dance/design_system/theme/forge_theme_extensions.dart';
import 'package:forge_dance/design_system/atoms/typography/fg_label.dart';

part 'fg_background.stories.g.dart';

const meta = Meta(FgBackground.new);

final $Playground = _Story(
  name: 'Playground',
  args: _Args(
    child: Arg.fixed(const Center(child: FgLabel(text: 'Surface content'))),
  ),
  scenarios: [
    _Scenario(
      name: 'Immersive',
      args: _Args.fixed(
        surface: ForgeSurface.immersive,
        child: const Center(child: FgLabel(text: 'Immersive content')),
      ),
    ),
    _Scenario(
      name: 'Standard form surface',
      args: _Args.fixed(
        surface: ForgeSurface.standard,
        child: const Center(child: Text('Readable form content')),
      ),
    ),
  ],
);
