import 'package:flutter/material.dart';
import 'package:forge_dance/design_system/design_system.dart';
import 'package:widgetbook/widgetbook.dart';

part 'fg_details.stories.g.dart';

const meta = Meta(FgDetails.new);

final $Playground = _Story(
  name: 'Progressive disclosure',
  args: _Args(
    title: StringArg('Adaptations & guidance'),
    child: Arg.fixed(
      const Text(
        'All instructional detail remains available. Choose a supported or seated base, reduce the range, and practise at your own pace.',
      ),
    ),
  ),
  scenarios: [
    _Scenario(
      name: 'Collapsed explanation',
      args: _Args.fixed(
        title: 'How practice works',
        child: const Text(
          'An explanation that does not compete with the primary action.',
        ),
      ),
    ),
    _Scenario(
      name: 'Expanded explanation',
      args: _Args.fixed(
        title: 'Technique & context',
        initiallyExpanded: true,
        child: const Text(
          'Complete technique and cultural context stay readable, without truncation or a separate condensed source of truth.',
        ),
      ),
    ),
    _Scenario(
      name: 'Long label',
      args: _Args.fixed(
        title: 'Adaptations for comfortable and supported movement',
        child: const Text(
          'Labels and detail text wrap at large accessibility text sizes.',
        ),
      ),
    ),
  ],
);
