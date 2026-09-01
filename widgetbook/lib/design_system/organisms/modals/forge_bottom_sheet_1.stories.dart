import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:forge_dance/design_system/organisms/modals/forge_bottom_sheet.dart';

part 'forge_bottom_sheet_1.stories.g.dart';

const meta = Meta(ForgeBottomSheet.new);

final $Playground = _Story(
  name: 'Playground',
  args: _Args(
    title: StringArg('Training options'),
    child: Arg.fixed(const Text('Choose how to continue your session.')),
    resetLabel: NullableStringArg('Reset'),
    actionLabel: NullableStringArg('Apply'),
    onReset: Arg.fixed(() {}),
    onAction: Arg.fixed(() {}),
  ),
);
