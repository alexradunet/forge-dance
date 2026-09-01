import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:forge_dance/design_system/organisms/navigation/app_bottom_nav.dart';

part 'app_bottom_nav.stories.g.dart';

const meta = Meta(AppBottomNav.new);

final $Playground = _Story(
  name: 'Playground',
  args: _Args(onTabChange: Arg.fixed((_) {})),
);
