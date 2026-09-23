import 'package:flutter/material.dart';
import 'package:forge_dance/design_system/design_system.dart';
import 'package:widgetbook/widgetbook.dart';

part 'fg_section_heading.stories.g.dart';

const meta = Meta(FgSectionHeading.new);

final $Editorial = _Story(
  name: 'Editorial hierarchy',
  args: _Args(
    eyebrow: StringArg('YOUR DAILY PRACTICE'),
    title: StringArg('Find your groove'),
    subtitle: StringArg('20 minutes · foundations'),
  ),
  scenarios: [
    _Scenario(
      name: 'Title only',
      args: _Args.fixed(eyebrow: null, subtitle: null),
    ),
    _Scenario(
      name: 'Long title',
      args: _Args.fixed(title: 'Find a comfortable rhythm at your own pace'),
    ),
  ],
);
