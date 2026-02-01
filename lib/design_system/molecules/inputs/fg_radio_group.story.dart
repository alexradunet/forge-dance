import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/molecules/inputs/fg_radio_group.dart'
    as atom;
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: atom.RadioGroup,
  path: 'Design System/Molecules/Inputs',
)
Widget buildRadioGroupPlayground(BuildContext context) {
  final items = [
    atom.FgRadioGroupItem(label: 'Option 1', value: '1'),
    atom.FgRadioGroupItem(label: 'Option 2', value: '2'),
    atom.FgRadioGroupItem(label: 'Option 3', value: '3'),
  ];
  String? selected = '1';

  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StatefulBuilder(builder: (context, setState) {
          return atom.RadioGroup<String>(
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

@widgetbook.UseCase(
  name: 'Showcase',
  type: atom.RadioGroup,
  path: 'Design System/Molecules/Inputs',
)
Widget buildRadioGroupShowcase(BuildContext context) {
  final items1 = [
    atom.FgRadioGroupItem(label: 'Daily', value: 'daily'),
    atom.FgRadioGroupItem(label: 'Weekly', value: 'weekly'),
  ];
  final items2 = [
    atom.FgRadioGroupItem(label: 'Small', value: 's'),
    atom.FgRadioGroupItem(label: 'Medium', value: 'm'),
    atom.FgRadioGroupItem(label: 'Large', value: 'l'),
  ];

  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            atom.RadioGroup<String>(
              items: items1,
              selectedValue: 'daily',
              onChanged: (_) {},
            ),
            const SizedBox(height: 32),
            atom.RadioGroup<String>(
              items: items2,
              selectedValue: 'm',
              onChanged: (_) {},
            ),
          ],
        ),
      ),
    ),
  );
}
