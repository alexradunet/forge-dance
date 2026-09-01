import 'package:flutter/widgets.dart';
import 'package:forge_dance/design_system/atoms/surfaces/fg_card.dart';
import 'package:forge_dance/design_system/tokens/app_spacing.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_workspace/story_setup.dart';

part 'fg_card.stories.g.dart';

const meta = Meta(FgCard.new);

final $Playground = _Story(
  name: 'Playground',
  setup: scenarioSemanticsBoundary,
  args: _Args(
    child: Arg.fixed(const Text('Card content')),
    onTap: Arg.fixed(_noop),
    semanticLabel: NullableStringArg('Training card'),
  ),
  scenarios: [
    _Scenario(
      name: 'Opaque',
      args: _Args.fixed(
        child: const Text('Training card'),
        onTap: _noop,
        semanticLabel: 'Training card',
      ),
    ),
    _Scenario(
      name: 'Outlined selected',
      excludeFromTests: true,
      args: _Args.fixed(
        child: const Text('Selected training card'),
        variant: FgCardVariant.outlined,
        isSelected: true,
        onTap: _noop,
        semanticLabel: 'Selected training card',
      ),
    ),
    _Scenario(
      name: 'Disabled',
      excludeFromTests: true,
      args: _Args.fixed(
        child: const Text('Unavailable training card'),
        isEnabled: false,
        onTap: _noop,
        semanticLabel: 'Unavailable training card',
      ),
    ),
  ],
);

void _noop() {}
