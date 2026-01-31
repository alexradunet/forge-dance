import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Selected',
  type: FgRadioButton,
  path: 'Design System/Atoms/Inputs',
)
Widget buildFgRadioButtonSelected(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: FgRadioButton(
        isSelected: true,
        onTap: () {},
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Unselected',
  type: FgRadioButton,
  path: 'Design System/Atoms/Inputs',
)
Widget buildFgRadioButtonUnselected(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: FgRadioButton(
        isSelected: false,
        onTap: () {},
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With List Item',
  type: RadioListItem,
  path: 'Design System/Atoms/Inputs',
)
Widget buildRadioListItem(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListItem(
              label: 'Option 1 - Selected',
              isSelected: true,
              onTap: () {},
            ),
            const SizedBox(height: 8),
            RadioListItem(
              label: 'Option 2 - Unselected',
              isSelected: false,
              onTap: () {},
            ),
          ],
        ),
      ),
    ),
  );
}
