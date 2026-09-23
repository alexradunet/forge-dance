import 'package:flutter/material.dart';
import 'package:forge_dance/design_system/design_system.dart';
import 'package:widgetbook/widgetbook.dart';

part 'fg_round_panel.stories.g.dart';

const meta = Meta(FgRoundPanel.new);

final $Rounds = _Story(
  name: 'Practice rounds',
  args: _Args(
    label: StringArg('ROUND 01 / 04'),
    active: Arg.fixed(true),
    child: Arg.fixed(
      const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FgSectionHeading(
            title: 'Find the pocket',
            subtitle: 'Comfortable range. Your own tempo.',
          ),
          SizedBox(height: AppSpacing.lg),
          Text('Stop if you feel pain, dizziness or unusual breathlessness.'),
        ],
      ),
    ),
  ),
  scenarios: [
    _Scenario(
      name: 'Next round',
      args: _Args.fixed(
        active: false,
        label: 'ROUND 02 / 04',
        child: Text('Explore the next round at your own pace.'),
      ),
    ),
    _Scenario(
      name: 'Active floor',
      args: _Args.fixed(
        active: true,
        label: 'ON THE FLOOR',
        child: Text('Keep your current movement cue visible.'),
      ),
    ),
  ],
);
