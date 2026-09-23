import 'package:flutter/material.dart';
import 'package:forge_dance/design_system/design_system.dart';
import 'package:widgetbook/widgetbook.dart';

part 'fg_reference_card.stories.g.dart';

const meta = Meta(FgReferenceCard.new);

final $Reference = _Story(
  name: 'Movement index',
  args: _Args(
    indexLabel: StringArg('01'),
    title: StringArg('Bounce'),
    label: StringArg('Moves · Hip hop'),
    definition: StringArg(
      'A repeated, relaxed bending and releasing action that lets the body ride the beat.',
    ),
    status: StringArg('Not explored in lessons yet'),
    onTap: Arg.fixed(() {}),
  ),
  scenarios: [
    _Scenario(
      name: 'Introduced concept',
      args: _Args(
        onTap: Arg.fixed(() {}),
        indexLabel: StringArg('06'),
        title: StringArg('Weight transfer'),
        label: StringArg('Concepts · Foundations'),
        definition: StringArg(
          'A change in which support carries your weight, making another contact point available to move.',
        ),
        status: StringArg('Introduced in lessons'),
      ),
    ),
  ],
);
