import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:forge_dance/design_system/molecules/inputs/fg_checkbox_group.dart';

part 'fg_checkbox_group.stories.g.dart';

const meta = Meta(FgCheckboxGroup.new);

final $Playground = _Story(
  name: 'Playground',
  args: _Args(
    items: Arg.fixed(const [
      FgCheckboxGroupItem(label: 'Hip hop', value: true),
      FgCheckboxGroupItem(label: 'House', value: false),
      FgCheckboxGroupItem(label: 'Breaking', value: false),
    ]),
    onChanged: Arg.fixed((_) {}),
    semanticLabel: NullableStringArg('Dance styles'),
  ),
);
