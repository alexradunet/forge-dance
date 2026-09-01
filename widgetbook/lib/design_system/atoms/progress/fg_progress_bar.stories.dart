import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:forge_dance/design_system/atoms/progress/fg_progress_bar.dart';
import 'package:widgetbook_workspace/story_setup.dart';

part 'fg_progress_bar.stories.g.dart';

const meta = Meta(FgProgressBar.new);

final $Playground = _Story(
  name: 'Playground',
  setup: scenarioSemanticsBoundary,
  args: _Args(
    value: DoubleArg(0.72),
    semanticLabel: NullableStringArg('Training progress'),
  ),
  scenarios: [
    _Scenario(
      name: 'Empty',
      args: _Args.fixed(value: 0, semanticLabel: 'No progress'),
    ),
    _Scenario(
      name: 'In progress',
      excludeFromTests: true,
      args: _Args.fixed(value: 0.48, semanticLabel: '48 percent complete'),
    ),
    _Scenario(
      name: 'Complete',
      excludeFromTests: true,
      args: _Args.fixed(
        value: 1,
        tone: FgProgressBarTone.success,
        semanticLabel: 'Complete',
      ),
    ),
  ],
);
