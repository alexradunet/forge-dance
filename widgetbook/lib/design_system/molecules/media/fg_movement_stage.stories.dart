import 'package:flutter/material.dart';
import 'package:forge_dance/design_system/design_system.dart';
import 'package:widgetbook/widgetbook.dart';

part 'fg_movement_stage.stories.g.dart';

const meta = Meta(FgMovementStage.new);

final $Stage = _Story(
  name: 'Instructional viewport',
  args: _Args(
    semanticLabel: StringArg('Movement preview placeholder'),
    child: Arg.fixed(
      const Center(
        child: Icon(Icons.accessibility_new, size: AppSizes.iconHuge),
      ),
    ),
  ),
  scenarios: [
    _Scenario(
      name: 'Loading',
      args: _Args.fixed(
        semanticLabel: 'Loading movement preview',
        child: Center(child: FgSpinner()),
      ),
    ),
    _Scenario(
      name: 'Unavailable',
      args: _Args.fixed(
        semanticLabel: 'Movement preview unavailable',
        child: Center(child: Icon(Icons.videocam_off_outlined)),
      ),
    ),
  ],
);
