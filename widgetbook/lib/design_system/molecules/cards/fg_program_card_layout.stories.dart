import 'package:flutter/material.dart';
import 'package:forge_dance/design_system/design_system.dart';
import 'package:widgetbook/widgetbook.dart';

part 'fg_program_card_layout.stories.g.dart';

const meta = Meta(FgProgramCardLayout.new);

final $Columns = _Story(
  name: 'Content-sized history columns',
  args: _Args(
    maxColumns: IntArg(
      2,
      style: const SliderIntArgStyle(min: 1, max: 4, divisions: 3),
    ),
    children: Arg.fixed([
      for (var index = 1; index <= 4; index++)
        FgProgramCard(
          title: 'Lesson $index — find a comfortable rhythm',
          label: 'In progress',
          summary:
              'Full history text stays readable without a fixed card height.',
          actionLabel: 'View lesson',
          onTap: () {},
        ),
    ]),
  ),
);
