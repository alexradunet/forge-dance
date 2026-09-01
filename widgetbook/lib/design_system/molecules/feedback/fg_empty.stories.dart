import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:forge_dance/design_system/molecules/feedback/fg_empty.dart';

part 'fg_empty.stories.g.dart';

const meta = Meta(FgEmpty.new);

final $Playground = _Story(
  name: 'Playground',
  args: _Args(
    icon: Arg.fixed(Icons.search_off_rounded),
    title: StringArg('No movements found'),
    description: NullableStringArg('Try changing the active filters.'),
    actionLabel: NullableStringArg('Reset filters'),
    onAction: Arg.fixed(() {}),
  ),
);
