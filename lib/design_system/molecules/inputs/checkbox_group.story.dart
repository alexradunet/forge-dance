import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/molecules/inputs/checkbox_group.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Checkbox Group',
  type: CheckboxGroup,
  path: 'Design System/Molecules/Inputs',
)
Widget buildCheckboxGroup(BuildContext context) {
  final items = [
    CheckboxGroupItem(label: 'Option 1', value: false, id: '1'),
    CheckboxGroupItem(label: 'Option 2', value: true, id: '2'),
    CheckboxGroupItem(label: 'Option 3', value: false, id: '3'),
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
