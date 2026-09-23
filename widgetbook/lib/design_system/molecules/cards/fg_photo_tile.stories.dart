import 'package:flutter/material.dart';
import 'package:forge_dance/design_system/design_system.dart';
import 'package:widgetbook/widgetbook.dart';

part 'fg_photo_tile.stories.g.dart';

const meta = Meta(FgPhotoTile.new);

final $Destination = _Story(
  name: 'Photo destination',
  args: _Args(
    image: Arg.fixed(
      const AssetImage(
        'packages/forge_dance/assets/images/dance-floor-preview.webp',
      ),
    ),
    label: StringArg('Programmes'),
    title: StringArg('Build a routine'),
    onTap: Arg.fixed(() {}),
  ),
  scenarios: [
    _Scenario(
      name: 'Missing photo',
      args: _Args(
        image: Arg.fixed(const AssetImage('intentionally-unavailable.webp')),
        onTap: Arg.fixed(() {}),
      ),
    ),
  ],
);
