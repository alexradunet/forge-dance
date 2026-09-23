import 'package:flutter/material.dart';
import 'package:forge_dance/design_system/design_system.dart';
import 'package:widgetbook/widgetbook.dart';

part 'fg_photo.stories.g.dart';

const meta = Meta(FgPhoto.new);

Widget _frame(BuildContext context, Widget child, StoryArgs args) => SizedBox(
  width: AppSizes.cardStandardWidth,
  height: AppSizes.squareTileLg,
  child: child,
);

final $Photo = _Story(
  name: 'Decorative offline photograph',
  setup: _frame,
  args: _Args(
    image: Arg.fixed(
      const AssetImage(
        'packages/forge_dance/assets/images/studio-dancer-preview.webp',
      ),
    ),
  ),
  scenarios: [
    _Scenario(
      name: 'Unavailable',
      args: _Args(
        image: Arg.fixed(const AssetImage('intentionally-unavailable.webp')),
      ),
    ),
  ],
);
