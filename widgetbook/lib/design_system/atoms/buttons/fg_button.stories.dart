import 'package:flutter/widgets.dart';
import 'package:forge_dance/design_system/atoms/buttons/fg_button.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_workspace/story_setup.dart';

part 'fg_button.stories.g.dart';

const meta = Meta(FgButton.new);

final $Playground = _Story(
  name: 'Playground',
  setup: scenarioSemanticsBoundary,
  args: _Args(text: StringArg('Start training'), onPressed: Arg.fixed(_noop)),
  scenarios: [
    _Scenario(
      name: 'Default',
      args: _Args.fixed(text: 'Start training', onPressed: _noop),
    ),
    _Scenario(
      name: 'Disabled',
      excludeFromTests: true,
      args: _Args.fixed(
        text: 'Start training',
        onPressed: _noop,
        isEnabled: false,
      ),
    ),
    _Scenario(
      name: 'Loading',
      excludeFromTests: true,
      args: _Args.fixed(
        text: 'Start training',
        onPressed: _noop,
        isLoading: true,
      ),
    ),
    _Scenario(
      name: 'Long label',
      excludeFromTests: true,
      args: _Args.fixed(
        text: 'Continue to the next training movement',
        onPressed: _noop,
        expand: true,
      ),
    ),
  ],
);

void _noop() {}
