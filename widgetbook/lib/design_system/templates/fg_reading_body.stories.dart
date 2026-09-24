import 'package:flutter/material.dart';
import 'package:forge_dance/design_system/design_system.dart';
import 'package:widgetbook/widgetbook.dart';

part 'fg_reading_body.stories.g.dart';

const meta = Meta(FgReadingBody.new);

final $Playground = _Story(
  name: 'Constrained utility reading surface',
  args: _Args(child: Arg.fixed(_content)),
);

final Widget _content = ListView(
  padding: AppSpacing.allXXL,
  children: [
    const FgSectionHeading(
      eyebrow: 'On this device',
      title: 'YOUR SPACE',
      subtitle: 'A bounded reading surface with caller-owned scrolling.',
    ),
    const SizedBox(height: AppSpacing.xxl),
    FgCard(
      shape: FgCardShape.editorial,
      child: FgButton(text: 'Continue', onPressed: () {}),
    ),
  ],
);
