import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:forge_dance/design_system/atoms/avatars/fg_avatar.dart';
import 'package:widgetbook_workspace/story_setup.dart';

part 'fg_avatar.stories.g.dart';

const meta = Meta(FgAvatar.new);

final $Playground = _Story(
  name: 'Playground',
  setup: scenarioSemanticsBoundary,
  args: _Args(
    initials: NullableStringArg('FD'),
    semanticLabel: NullableStringArg('Forge dancer'),
  ),
  scenarios: [
    _Scenario(
      name: 'Initials',
      args: _Args.fixed(initials: 'FD', semanticLabel: 'Forge dancer'),
    ),
    _Scenario(
      name: 'Online with level',
      excludeFromTests: true,
      args: _Args.fixed(
        initials: 'FD',
        level: 8,
        isOnline: true,
        semanticLabel: 'Forge dancer, online, level 8',
      ),
    ),
    _Scenario(
      name: 'Notifications',
      excludeFromTests: true,
      args: _Args.fixed(
        initials: 'FD',
        notificationCount: 3,
        semanticLabel: 'Forge dancer, 3 notifications',
      ),
    ),
    _Scenario(
      name: 'Loading',
      excludeFromTests: true,
      args: _Args.fixed(isLoading: true, semanticLabel: 'Loading avatar'),
    ),
  ],
);
