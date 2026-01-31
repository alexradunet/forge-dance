import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Checked',
  type: FgCheckboxItem,
  path: 'Design System/Atoms/Inputs',
)
Widget buildCheckboxChecked(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: FgCheckboxItem(
        state: CheckboxState.checked,
        onTap: () {},
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Unchecked',
  type: FgCheckboxItem,
  path: 'Design System/Atoms/Inputs',
)
Widget buildCheckboxUnchecked(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: FgCheckboxItem(
        state: CheckboxState.unchecked,
        onTap: () {},
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Indeterminate',
  type: FgCheckboxItem,
  path: 'Design System/Atoms/Inputs',
)
Widget buildCheckboxIndeterminate(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: FgCheckboxItem(
        state: CheckboxState.indeterminate,
        onTap: () {},
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With List Item',
  type: CheckboxListItem,
  path: 'Design System/Atoms/Inputs',
)
Widget buildCheckboxListItem(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListItem(
              title: 'Accept Terms',
              subtitle: 'I agree to the terms and conditions',
              state: CheckboxState.checked,
              onTap: () {},
            ),
            const SizedBox(height: 8),
            CheckboxListItem(
              title: 'Subscribe',
              subtitle: 'Receive newsletters and updates',
              state: CheckboxState.unchecked,
              onTap: () {},
            ),
          ],
        ),
      ),
    ),
  );
}
