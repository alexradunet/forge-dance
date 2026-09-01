import 'package:flutter/material.dart';
import 'package:forge_dance/design_system/templates/swipeable_card_screen_template.dart';
import 'package:widgetbook/widgetbook.dart';

part 'swipeable_card_screen_template.stories.g.dart';

const meta = Meta(SwipeableCardScreenTemplate.new);

final $Playground = _Story(
  name: 'Playground',
  args: _Args(
    title: StringArg('Groove foundations'),
    subtitle: NullableStringArg('Lesson 2 of 5'),
    progressSteps: IntArg(5),
    currentStep: IntArg(2),
    onStepClick: Arg.fixed((_) {}),
    children: Arg.fixed(
      const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text('Swipeable lesson content'),
          ),
        ),
      ),
    ),
    onBack: Arg.fixed(() {}),
  ),
);
