import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/molecules/inputs/radio_group.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Radio Group',
  type: RadioGroup,
  path: 'Design System/Molecules/Inputs',
)
Widget buildRadioGroup(BuildContext context) {
  final items = [
    RadioGroupItem(label: 'Option 1', value: '1'),
    RadioGroupItem(label: 'Option 2', value: '2'),
    RadioGroupItem(label: 'Option 3', value: '3'),
  ];
  String? selected = '1';

  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StatefulBuilder(builder: (context, setState) {
          return RadioGroup<String>(
            items: items,
            selectedValue: selected,
            onChanged: (value) {
              setState(() => selected = value);
            },
          );
        }),
      ),
    ),
  );
}
