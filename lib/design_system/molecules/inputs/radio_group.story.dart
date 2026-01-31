import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/molecules/inputs/radio_group.dart'
    as atom;
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: atom.RadioGroup,
  path: 'Design System/Molecules/Inputs',
)
Widget buildRadioGroupPlayground(BuildContext context) {
  final items = [
    atom.RadioGroupItem(label: 'Option 1', value: '1'),
    atom.RadioGroupItem(label: 'Option 2', value: '2'),
    atom.RadioGroupItem(label: 'Option 3', value: '3'),
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
    atom.RadioGroupItem(label: 'Daily', value: 'daily'),
    atom.RadioGroupItem(label: 'Weekly', value: 'weekly'),
  ];
  final items2 = [
    atom.RadioGroupItem(label: 'Small', value: 's'),
    atom.RadioGroupItem(label: 'Medium', value: 'm'),
    atom.RadioGroupItem(label: 'Large', value: 'l'),
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
