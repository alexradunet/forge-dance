import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:forge_dance/design_system/molecules/navigation/fg_app_nav_button.dart';

part 'fg_app_nav_button.stories.g.dart';

const meta = Meta(FgNavButton.new);

final $Playground = _Story(
  name: 'Playground',
  args: _Args(
    icon: Arg.fixed(Icons.home_rounded),
    label: StringArg('Home'),
    onTap: Arg.fixed(() {}),
  ),
);
