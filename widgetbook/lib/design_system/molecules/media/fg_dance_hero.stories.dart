import 'package:flutter/material.dart';
import 'package:forge_dance/design_system/design_system.dart';
import 'package:widgetbook/widgetbook.dart';

part 'fg_dance_hero.stories.g.dart';

const meta = Meta(FgDanceHero.new);

final $Poster = _Story(
  name: 'Cypher invitation',
  args: _Args(
    image: Arg.fixed(
      const AssetImage('packages/forge_dance/assets/images/cypher-dancer.webp'),
    ),
    imageLabel: StringArg('Preview photo'),
    eyebrow: StringArg('YOUR FLOOR. YOUR PACE.'),
    title: StringArg('FIND YOUR\nFLOW.'),
    subtitle: StringArg(
      'Build your foundations. Find your groove. Bring your own style.',
    ),
    action: Arg.fixed(
      FgButton(text: 'Today’s practice', expand: true, onPressed: () {}),
    ),
  ),
  scenarios: [
    _Scenario(
      name: 'Workout poster',
      args: _Args(
        image: Arg.fixed(
          const AssetImage(
            'packages/forge_dance/assets/images/studio-dancer-preview.webp',
          ),
        ),
        compact: Arg.fixed(true),
        eyebrow: StringArg('Today’s workout'),
        title: StringArg('Clear Initiations'),
        subtitle: StringArg('White FORGE · 20 min'),
        action: Arg.fixed(
          FgButton(text: 'Start first round', onPressed: () {}),
        ),
      ),
    ),
    _Scenario(
      name: 'Unavailable image',
      args: _Args(
        image: Arg.fixed(const AssetImage('intentionally-unavailable.webp')),
        action: Arg.fixed(FgButton(text: 'Practice', onPressed: () {})),
      ),
    ),
    _Scenario(
      name: 'Long translated copy',
      args: _Args(
        image: Arg.fixed(
          const AssetImage(
            'packages/forge_dance/assets/images/cypher-dancer.webp',
          ),
        ),
        action: Arg.fixed(FgButton(text: 'Practice', onPressed: () {})),
        title: StringArg('Make room for your next movement'),
        subtitle: StringArg(
          'Find a comfortable space and explore movement at a pace that feels right for you.',
        ),
      ),
    ),
    _Scenario(
      name: 'Loading action',
      args: _Args(
        image: Arg.fixed(
          const AssetImage(
            'packages/forge_dance/assets/images/cypher-dancer.webp',
          ),
        ),
        action: Arg.fixed(
          const FgButton(
            text: 'Preparing practice',
            isLoading: true,
            expand: true,
          ),
        ),
      ),
    ),
  ],
);
