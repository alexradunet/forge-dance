import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:forge_dance/design_system/organisms/modals/forge_bottom_sheet.dart';

part 'forge_bottom_sheet_2.stories.g.dart';

const meta = Meta(ForgeActionSheet.new);

final $Playground = _Story(
  name: 'Playground',
  args: _Args(
    title: NullableStringArg('Workout actions'),
    cancelLabel: StringArg('Cancel'),
    actions: Arg.fixed(const [
      ForgeActionSheetItem(label: 'Save workout', icon: Icons.save_rounded),
      ForgeActionSheetItem(
        label: 'Delete workout',
        icon: Icons.delete_outline_rounded,
        isDestructive: true,
      ),
    ]),
  ),
);
