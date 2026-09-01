import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:forge_dance/design_system/organisms/modals/fg_filter_sheet.dart';

part 'fg_filter_sheet.stories.g.dart';

const meta = Meta(FgFilterSheet.new);

final $Playground = _Story(
  name: 'Playground',
  args: _Args(
    title: StringArg('Filters'),
    resetLabel: StringArg('Reset'),
    applyLabel: StringArg('Apply'),
    sections: Arg.fixed(const {
      'Style': ['Hip hop', 'House', 'Breaking'],
      'Level': ['Beginner', 'Intermediate', 'Advanced'],
    }),
    selectedFilters: Arg.fixed(const {'Style': 'Hip hop'}),
    onFilterSelected: Arg.fixed((_, _) {}),
    onReset: Arg.fixed(() {}),
    onApply: Arg.fixed(() {}),
  ),
);
