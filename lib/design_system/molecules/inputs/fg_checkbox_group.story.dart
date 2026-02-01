import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/molecules/inputs/fg_checkbox_group.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: CheckboxGroup,
  path: 'Design System/Molecules/Inputs',
)
Widget buildCheckboxGroupPlayground(BuildContext context) {
  final items = [
    FgCheckboxGroupItem(label: 'Option 1', value: false, id: '1'),
    FgCheckboxGroupItem(label: 'Option 2', value: true, id: '2'),
    FgCheckboxGroupItem(label: 'Option 3', value: false, id: '3'),
  ];

  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StatefulBuilder(builder: (context, setState) {
          return CheckboxGroup(
            items: items,
            onChanged: (values) {
              // Widgetbook is stateless in this context mostly, but highlighting updates
            },
          );
        }),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Showcase',
  type: CheckboxGroup,
  path: 'Design System/Molecules/Inputs',
)
Widget buildCheckboxGroupShowcase(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CheckboxGroup(
              items: [
                FgCheckboxGroupItem(label: 'Unchecked', value: false, id: '1'),
                FgCheckboxGroupItem(label: 'Checked', value: true, id: '2'),
              ],
              onChanged: (_) {},
            ),
            const SizedBox(height: 32),
            CheckboxGroup(
              items: [
                FgCheckboxGroupItem(label: 'Item A', value: true, id: 'A'),
                FgCheckboxGroupItem(
                    label: 'Item B (Long Label Text Example)',
                    value: false,
                    id: 'B'),
                FgCheckboxGroupItem(label: 'Item C', value: true, id: 'C'),
              ],
              onChanged: (_) {},
            ),
          ],
        ),
      ),
    ),
  );
}
