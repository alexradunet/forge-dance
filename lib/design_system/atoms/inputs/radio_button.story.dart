import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Selected',
  type: RadioButton,
  path: 'Design System/Atoms/Inputs',
)
Widget buildRadioButtonSelected(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: RadioButton(
        isSelected: true,
        onTap: () {},
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Unselected',
  type: RadioButton,
  path: 'Design System/Atoms/Inputs',
)
Widget buildRadioButtonUnselected(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: RadioButton(
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
