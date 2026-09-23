import 'package:flutter/material.dart';
import 'package:forge_dance/design_system/design_system.dart';
import 'package:widgetbook/widgetbook.dart';

part 'fg_program_card.stories.g.dart';

const meta = Meta(FgProgramCard.new);

final $Preview = _Story(
  name: 'Module and programme previews',
  args: _Args(
    title: StringArg('Ready Body'),
    label: StringArg('Start here'),
    details: StringArg('0 of 3 lessons'),
    actionLabel: StringArg('View learning path'),
    imageUrl: StringArg(
      'https://images.unsplash.com/photo-1547153760-18fc86324498?w=600',
    ),
    progress: Arg.fixed(0),
    onTap: Arg.fixed(() {}),
  ),
  scenarios: [
    _Scenario(
      name: 'Locked module',
      args: _Args.fixed(
        onTap: () {},
        title: 'Time and Weight',
        label: 'Common foundation • Locked',
        details: 'Requires Bases & Breath',
        locked: true,
      ),
    ),
    _Scenario(
      name: 'Enrolled route without photography',
      args: _Args.fixed(
        onTap: () {},
        title: 'Find the Beat',
        label: 'ROUTE 01 • Enrolled',
        imageUrl: null,
        summary:
            'Build a safe base and locate a steady pulse. Sound is optional.',
        details: '2 of 6 lessons studied',
        progress: 1 / 3,
        isSelected: true,
        actionLabel: 'Continue programme',
      ),
    ),
    _Scenario(
      name: 'Long copy',
      args: _Args.fixed(
        onTap: () {},
        title: 'Movement Foundations',
        label: 'ROUTE 04 • Ready',
        imageUrl: null,
        summary: 'Follow the complete common foundation from a usable practice space to timing, spatial choice, phrase recall, composition and relationship.',
        details: '0 of 18 lessons studied',
        actionLabel: 'View programme',
      ),
    ),
  ],
);
