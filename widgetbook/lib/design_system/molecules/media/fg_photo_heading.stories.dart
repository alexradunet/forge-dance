import 'package:flutter/material.dart';
import 'package:forge_dance/design_system/design_system.dart';
import 'package:widgetbook/widgetbook.dart';

part 'fg_photo_heading.stories.g.dart';

const meta = Meta(FgPhotoHeading.new);

final $Preview = _Story(
  name: 'Offline round thumbnail',
  args: _Args(
    image: Arg.fixed(
      const AssetImage(
        'packages/forge_dance/assets/images/studio-dancer-preview.webp',
      ),
    ),
    imageLabel: StringArg('Preview photo'),
    title: StringArg('Warm up · Clear Initiations'),
    subtitle: StringArg('2 min · White progression · 50 BPM'),
  ),
  scenarios: [
    _Scenario(
      name: 'Vocabulary editorial heading',
      args: _Args(
        image: Arg.fixed(
          const AssetImage(
            'packages/forge_dance/assets/images/dance-floor-preview.webp',
          ),
        ),
        editorial: BoolArg(true),
        title: StringArg('MOVE WITH MEANING.'),
        subtitle: StringArg('Moves, foundations & concepts'),
      ),
    ),
    _Scenario(
      name: 'Long round name',
      args: _Args(
        image: Arg.fixed(
          const AssetImage(
            'packages/forge_dance/assets/images/dance-floor-preview.webp',
          ),
        ),
        title: StringArg(
          'Explore a comfortable beginning and a controlled return',
        ),
      ),
    ),
  ],
);
